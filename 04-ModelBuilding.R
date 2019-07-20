# ---
# script: 04-ModelBuilding
# subject: Model training, exploring and saving to later deployment
# date: 2019-07-20
# author: Marcus Di Paula
# github: github.com/marcusdipaula/
# linkedin: linkedin.com/in/marcusdipaula/
# ---


# 4. Building and validating models (orientated to the 5th phase)
#     - Train and test a ML model
#     - Which performance metrics should I relly on?
#     - Iteration


# variable to control exploration of models results
want_to_explore_models_results <- FALSE


# Loading caret package (and installint it before, if not installed)
if(!require(caret)) {install.packages("caret"); library(caret)}


# Spliting the dataset
# More at:http://topepo.github.io/caret/data-splitting.html

# creating and index to do it
index <- createDataPartition(credit$Credit_Rating, p = 0.8, list = F)

# Spliting the dataset into train and test
train <- credit[index,]
test <- credit[-index,]; rm(index)

# Looking at the distribution of the target variable
table(train$Credit_Rating) # unbalanced, so we should take care of it before or while fiting the model 
                           # I'll do it through the training control bellow

# proportion of the imbalance
prop.table(table(train$Credit_Rating))

#_______________________________________Train_Control______________________________________# 

# Setting up control parameters to training models
# More at: http://topepo.github.io/caret/model-training-and-tuning.html#basic-parameter-tuning

train_control <- trainControl(method = "repeatedcv", # the resampling method, repeated k-fold cross-validation.
                              # Repeated k-fold cross validation is preferred when you can afford the computational
                              # expense and require a less biased estimate.
                              
                              number = 5, # the number of folds in K-fold cross-validation, so we have 5-fold 
                              # cross-validations
                              
                              repeats = 3, # repetitions of the previous k-fold cross-validation, so we have
                              # 3 repetitions of 5-fold cross-validations
                              # An illustration: https://www.evernote.com/l/AGKmXIbis1dHSbR_j9dblVk-t3klmWsL_i0/
                              
                              search = "random", # a random sample of possible tuning parameter combinations
                              # More at: http://topepo.github.io/caret/random-hyperparameter-search.html
                              
                              classProbs = TRUE, # an alternative to get probabilities, if any method used in train
                              # doesn't support this parameter, would be to use the extractProb(), the same way 
                              # as we use predict(). See more on ?extractProb
                              
                              sampling = "smote" # the type of additional sampling that is conducted after 
                              # resampling due to the target variable class imbalance
                              # More at: https://topepo.github.io/caret/subsampling-for-class-imbalances.html
                              
                              )

# trainControl function has an "allowParallel" parameter, you can see more at:
# http://topepo.github.io/caret/parallel-processing.html
#
# To know more about parallel processing (on Windows and Unix like systems):
# http://dept.stat.lsa.umich.edu/~jerrick/courses/stat701/notes/parallel.html


#_______________________________________Algorithm_01______________________________________# 

# Random Forest algorithm
# 
# Caret method: 'rf'
# 
# Type: Classification, Regression
# 
# Tags (types or relevant characteristics according to the caret package guide):
# Bagging, Ensemble Model, Implicit Feature Selection, Random Forest, Supports Class Probabilities
# 
# Tuning parameters: mtry (#Randomly Selected Predictors)
# 
# Required packages: randomForest
# 
# More info: A model-specific variable importance metric is available.
#
# Link to know more: http://topepo.github.io/caret/

model_rf <- train(Credit_Rating ~ ., # formula: "TARGET ~ PREDICTORS" (the dot mean all variables, except the target)
                  
                  data = train, # the dataset to fit the model
                  
                  method = "rf", # the caret method for this algorithm
                  
                  trControl = train_control, # the control parameters setted above
                  
                  tuneLength = 5, # the total number of random unique combinations to tune parameters
                                  # more at: http://topepo.github.io/caret/random-hyperparameter-search.html
                  
                  metric = "Kappa" # in problems where there are a low percentage of samples in one 
                  # class, using metric = "Kappa" can improve quality of the final model
                  )

if(want_to_explore_models_results) {
  
              # Printing the model
              print(model_rf)
              
              # Looking at the final model
              print(model_rf$finalModel)
              
              # Ploting the tuning parameters (the randomly selected predictors by the metric used)
              plot(model_rf)
              
              # Getting probabilities and raw predictions together
              prob_pred_rf <- bind_cols(
                                
                                      predict.train(model_rf,
                                                    newdata = test,
                                                    type = "prob"
                                                    ),
                                      
                                      tibble(historical = test$Credit_Rating,
                                             predicted = predict.train(model_rf,
                                                                       newdata = test)
                                             )
                                      
                                         ) %>% as_tibble
              
              
              # Confusion matrix of predictions
              confusionMatrix(data = prob_pred_rf$predicted,
                              reference = prob_pred_rf$historical)
              
              
              # Ploting the AUROC
              
              # Loading plotROC package (and installint it before, if not installed)
              if(!require(plotROC)) {install.packages("plotROC"); library(plotROC)}
              # More info about this package at:
              # https://cran.r-project.org/web/packages/plotROC/vignettes/examples.html
              
              # Basic ROC plot
              basic_ROC_plot <- ggplot(prob_pred_rf,
                                       aes(d = historical,
                                           m = Good)) +
                                      geom_roc() + 
                                      style_roc(theme = theme_grey)
              
              # ROC plot with the AUC calculated
              basic_ROC_plot +
                annotate("text", x = .75, y = .25,
                         label = paste("AUC =", round(calc_auc(basic_ROC_plot)$AUC, 4))
                         ); rm(basic_ROC_plot)
              }

#Saving the model to deploy to production
saveRDS(object = model_rf, 
        file = "./models/model_rf.RDS")



#_______________________________________Algorithm_02______________________________________# 

# Generalized Linear Model with Stepwise Feature Selection algorithm
# 
# Caret method: 'glmStepAIC'
# 
# Type: Regression, Classification
# 
# Tags (types or relevant characteristics according to the caret package guide):
# Accepts Case Weights, Feature Selection Wrapper, Generalized Linear Model, Implicit Feature Selection
# Linear Classifier, Supports Class Probabilities, Two Class Only
# 
# Tuning parameters: No tuning parameters for this model
# 
# Required packages: MASS
#
# Link to know more: http://topepo.github.io/caret/

model_glmStepAIC <-  train(Credit_Rating ~ ., # formula: "TARGET ~ PREDICTORS" (the dot mean all variables, except the target)
                         
                           data = train, # the dataset to fit the model
                           
                           method = "glmStepAIC", # the caret method for this algorithm
                           
                           trControl = train_control, # the control parameters setted above
                           
                           # tuneLength = 5, # since this model has no tuning parameters, this line is suppressed of the train
                           # more at: http://topepo.github.io/caret/random-hyperparameter-search.html
                           # about the lack of tuning parameters: http://topepo.github.io/caret/train-models-by-tag.html
                           
                           metric = "Kappa", # in problems where there are a low percentage of samples in one 
                           # class, using metric = "Kappa" can improve quality of the final model
                          )

if(want_to_explore_models_results) {
  
              # Printing the model
              print(model_glmStepAIC)
              
              # Getting probabilities and raw predictions together
              prob_pred_glmStepAIC <- bind_cols(
                
                                            predict.train(model_glmStepAIC,
                                                          newdata = test,
                                                          type = "prob"
                                                          ),
                                            
                                            tibble(historical = test$Credit_Rating,
                                                   predicted = predict.train(model_glmStepAIC,
                                                                             newdata = test)
                                                   )
                                                
                                                ) %>% as_tibble
              
              
              # Confusion matrix of predictions
              confusionMatrix(data = prob_pred_glmStepAIC$predicted,
                              reference = prob_pred_glmStepAIC$historical)
              
              
              # Ploting the AUROC
              
              # Loading plotROC package (and installint it before, if not installed)
              if(!require(plotROC)) {install.packages("plotROC"); library(plotROC)}
              # More info about this package at:
              # https://cran.r-project.org/web/packages/plotROC/vignettes/examples.html
              
              # Basic ROC plot
              basic_ROC_plot <- ggplot(prob_pred_glmStepAIC,
                                       aes(d = historical,
                                           m = Good)) +
                                geom_roc() + 
                                style_roc(theme = theme_grey)
              
              # ROC plot with the AUC calculated
              basic_ROC_plot +
                    annotate("text", x = .75, y = .25,
                             label = paste("AUC =", round(calc_auc(basic_ROC_plot)$AUC, 4))
                            ); rm(basic_ROC_plot)
            }

#Saving the model to deploy to production
saveRDS(object = model_glmStepAIC, 
        file = "./models/model_glmStepAIC.RDS")





#_______________________________________Algorithm_03______________________________________# 

# AdaBoost Classification Trees algorithm
# 
# Caret method: 'adaboost'
# 
# Type: Classification
# 
# Tags (types or relevant characteristics according to the caret package guide):
# Boosting, Ensemble Model, Implicit Feature Selection, Supports Class Probabilities
# Tree-Based Model, Two Class Only
# 
# Tuning parameters: nIter (#Trees), method (Method)
# 
# Required packages: fastAdaboost
#
# Link to know more: http://topepo.github.io/caret/


model_adaboost <- train(Credit_Rating ~ ., # formula: "TARGET ~ PREDICTORS" (the dot mean all variables, except the target)
                        
                        data = train, # the dataset to fit the model
                        
                        method = "adaboost", # the caret method for this algorithm
                        
                        trControl = train_control, # the control parameters setted above
                        
                        tuneLength = 5, # the total number of random unique combinations to tune parameters
                        # more at: http://topepo.github.io/caret/random-hyperparameter-search.html
                        
                        metric = "Kappa" # in problems where there are a low percentage of samples in one 
                        # class, using metric = "Kappa" can improve quality of the final model
                        )

if(want_to_explore_models_results) {
  
              # Printing the model
              print(model_adaboost)
              
              # Looking at the final model
              print(model_adaboost$finalModel)
              
              # Ploting the tuning parameters (the randomly selected predictors by the metric used)
              plot(model_adaboost)
              
              # Getting probabilities and raw predictions together
              prob_pred_adaboost <- bind_cols(
                
                                          predict.train(model_adaboost,
                                                        newdata = test,
                                                        type = "prob"
                                                        ),
                                          
                                          tibble(historical = test$Credit_Rating,
                                                 predicted = predict.train(model_adaboost,
                                                                           newdata = test
                                                                           )
                                                 )
                                          
                                              ) %>% as_tibble
              
              
              # Confusion matrix of predictions
              confusionMatrix(data = prob_pred_adaboost$predicted,
                              reference = prob_pred_adaboost$historical)
              
              
              # Ploting the AUROC
              
              # Loading plotROC package (and installint it before, if not installed)
              if(!require(plotROC)) {install.packages("plotROC"); library(plotROC)}
              # More info about this package at:
              # https://cran.r-project.org/web/packages/plotROC/vignettes/examples.html
              
              # Basic ROC plot
              basic_ROC_plot <- ggplot(prob_pred_adaboost,
                                       aes(d = historical,
                                           m = Good)) +
                                      geom_roc() + 
                                      style_roc(theme = theme_grey)
              
              # ROC plot with the AUC calculated
              basic_ROC_plot +
                annotate("text", x = .75, y = .25,
                         label = paste("AUC =", round(calc_auc(basic_ROC_plot)$AUC, 4))
                        ); rm(basic_ROC_plot)
            
              }; rm(want_to_explore_models_results)

#Saving the model to deploy to production
saveRDS(object = model_adaboost, 
        file = "./models/model_adaboost.RDS")





#_______________________________________Selecting_Model______________________________________# 














