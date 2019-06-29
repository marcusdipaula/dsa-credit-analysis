# 03-DataWrangling
#mod
# ---
# title: Data wrangling
# date: 2019-06-28
# author: Marcus Di Paula
# github: github.com/marcusdipaula/
# linkedin: linkedin.com/in/marcusdipaula/
# ---

# install.packages("plotly")
library(plotly)

# 1. Exploring the distribution of the target variable
credit %>% 
  select(Credit_Rating) %>% 
    table() %>% 
     as_tibble() %>% 
      `colnames<-`(c("Rating","Count")) %>% 
        ggplot(aes(Rating, Count, fill = Rating)) + 
          geom_bar(stat = "identity") +
          labs(title = "Target variable distribution") +
          theme( plot.title = element_text(hjust = 0.5))
        ggplotly()

# 2. Grouping some numerical variables
# so it will be easy to plot them by Credit_Rating

  # 2.1 Viewing summary of Duration_Month, Credit_Amount and Age variables
  # to have notion of its distribution (I'd like to group them into just a few groups)
summary(credit$Age)
summary(credit$Duration_Month)
summary(credit$Credit_Amount)
quantile(credit$Credit_Amount)

  # 2.2 Creating groups for each variable desired (Age, Duration_Month and Credit_Amount)
    # Age groups
Age_groups <- c(paste(seq(15, 75, by = 15), seq(30-1, 90, by = 15), sep = "-"))

    # Month duration groups
Duration_Month_groups <- c("0-12","13-24","25-36","37-48","49-60","61-72")
    # Duration_Month_Group <- c(paste(seq(4, 72, by = 14), seq(18-1, 75, by = 14), sep = "-")) 
    # the above is an alternative, but the groups don't make sense in terms of real accounting periods

    # Requested amount of credit groups
Credit_Amount_groups <- c("250-1364", "1365-2318", "2319-3971", "3972-18424") 
    # split according to quantile function result


  # 2.3 Adding the groups to dataset
credit$Age_groups <- cut(credit$Age, 
                        breaks = c(seq(15, 75, by = 15), Inf), 
                        labels = Age_groups, 
                        right = FALSE); rm(Age_groups)


credit$Duration_Month_groups <- cut(credit$Duration_Month, 
                                    breaks = c(c(0, 13, 25, 37, 49, 61), Inf), 
                                    labels = Duration_Month_groups, 
                                    right = FALSE); rm(Duration_Month_groups)


credit$Credit_Amount_groups <- cut(credit$Credit_Amount, 
                                   breaks = c(250, 1365, 2319, 3972, Inf), 
                                   labels = Credit_Amount_groups, 
                                   right = FALSE); rm(Credit_Amount_groups)

# 3. Looking the number of Credit_Rating by age groups
credit %>% 
  select(Age_groups, Credit_Rating) %>% 
  table()


# 4. Ploting

# test
# credit %>% 
#   select(Job_Skill, Credit_Rating, Age_groups) %>% 
#   ggplot(aes(Job_Skill, fill = Job_Skill)) +
#   geom_bar() + 
#   facet_grid(Age_groups ~ Credit_Rating) +
#   labs(fill = "Color legend")

  # Variables to plot bars
variables_2bars <- c("Duration_Month_groups", "Credit_Amount_groups", "Age_groups", "Purpose", "Job_Skill")


  # bar plot
lapply(variables_2bars, function(x){
                          ggplot(credit, aes_string(x, fill = x)) +
                          geom_bar() + 
                          facet_grid(. ~ Credit_Rating) + 
                          theme(axis.text.x = element_text(angle = 45, 
                                                           hjust = 1)) +
                          ggtitle(paste("Good/Bad credit count by", x)) +
                          labs(fill = "Color legend") +
                          theme(plot.title = element_text(hjust = 0.5)) }); rm(variables_2bars) # ggsave()





  # Variables to plot boxes
variables_2boxes <- c("Age_groups", "Purpose", "Job_Skill", "Credit_History")

  # boxplot
lapply(variables_2boxes, function(x){
                        ggplot(credit, aes_string(x = x, y = "Credit_Amount", fill = x)) +
                          geom_boxplot() + 
                          facet_grid(. ~ Credit_Rating) + 
                          theme(axis.text.x = element_text(angle = 45, 
                                                           hjust = 1)) +
                          ggtitle(paste("Good/Bad credit distribution by", x)) +
                          labs(fill = "Color legend") +
                          theme(plot.title = element_text(hjust = 0.5)) 
                          ggplotly()  }); rm(variables_2boxes) # ggsave()


  # correlation plot
# library(psych)
# 
# png("Correlations.png", width = 1720, height = 1080)
# psych::pairs.panels(credit[,c(1:21)])
# dev.off()


# 5. Feature Selection
# The importance of this procedure is, among others, to reduce the possibility of
# getting your model overfitted, so to try to get a generalized model.
# More information at: 
# https://www.analyticsvidhya.com/blog/2016/12/introduction-to-feature-selection-methods-with-an-example-or-how-to-select-the-right-variables/

# install.packages("caret")
library(caret)

  # Using randomForest to identify which variables are better as predictors
model_rf.p <- randomForest::randomForest(Credit_Rating ~ .,
                                         data = credit, 
                                         ntree = 100, 
                                         nodesize = 10, 
                                         importance = T)

randomForest::varImpPlot(model_rf.p)

  # The variables I choose from the Mean Decrease Accuracy plot are:
# Checking_Account 
# Duration_Month 
# Credit_History 
# Credit_Amount 
# Savings_Account 
# Property
# Employment

  # Getting the number of each column
# sort(match(c("Credit_Rating",
#         "Checking_Account" ,
#         "Duration_Month" ,
#         "Credit_History" ,
#         "Credit_Amount" ,
#         "Savings_Account" ,
#         "Property",
#         "Employment"), 
#         names(credit)))
# 
# str(credit[,c(1,  2 , 3 , 5 , 6 , 7, 12, 21)])

  # Ploting the histogram and correlation of each variable
psych::pairs.panels(credit[,c(1,  2 , 3 , 5 , 6 , 7, 12, 21)])

  # Testing training a model with these variables
model_rf.t <- train(Credit_Rating ~ Checking_Account +
                                    Duration_Month +
                                    Credit_History +
                                    Credit_Amount +
                                    Savings_Account +
                                    Property +
                                    Employment,
                     data = credit, 
                     method = "rf",
                     ntree = 100, 
                     nodesize = 10)


model_rf.t$results
model_rf.t$finalModel 

  # Some results of this model_rf.t model
#
# Accuracy 0.7545142
# OOB estimate of  error rate: 24.2%
#
# Confusion matrix:
#       Good  Bad  class.error
# Good  622    78   0.1114286
# Bad   164   136   0.5466667
#
# But this model cannot be used for real, since we have an unbalanced target variable
# as we can see at the following function result:
#
#   credit %>% 
#   select(Credit_Rating) %>% 
#   table() %>% 
#   as_tibble() %>% 
#   `colnames<-`(c("Credit_Rating","Count"))
#
# A tibble: 2 x 2
# Credit_Rating   Count
#   <chr>         <int>
# 1 Good            700
# 2 Bad             300
#
# This made our model to be good at predicting Good credit rating, but not so good 
# at predicting Bad credit rating.


# 6. Going serious: Subseting (let's split the data into train and test subsets)

# Subseting all Credit_Rating "Bad", since it has the small portion of both options(Good/Bad)
subset_bad <- credit %>% 
                filter(Credit_Rating %in% "Bad")

# Subseting a random sample of Credit_Rating "Good" of the same size of Credit_Rating "Bad"
subset_good <- credit %>% 
                filter(Credit_Rating %in% "Good") %>% 
                  sample_n(size = 300)

# Binding rows and removing unecessary objects
subset_balanced <- bind_rows(subset_bad, subset_good); rm(subset_bad, subset_good)

# Creating an index to split the dataset into training and testing
index <- createDataPartition(subset_balanced$Credit_Rating, times = 1, p = 0.7, list = F)

# spliting dataset and removing unecessary objects
train_subset <- subset_balanced[index,]
test_subset <- subset_balanced[-index,]; rm(index)

# Verifying proportions
train_subset %>% 
  select(Credit_Rating) %>% 
  table()

test_subset %>% 
  select(Credit_Rating) %>% 
  table()

# 7. training a Random Forest model with the variables choosen before
model_rf <- train(Credit_Rating ~ Checking_Account +
                                  Duration_Month +
                                  Credit_Amount +
                                  Credit_History +
                                  Savings_Account +
                                  Property +
                                  Employment,
                  data = train_subset, 
                  method = "rf",
                  ntree = 100, 
                  nodesize = 10)


# looking into results
model_rf$results
model_rf$finalModel 

# print(model_rf)
# Random Forest 
# 
# 420 samples
# 7 predictor
# 2 classes: 'Good', 'Bad' 
# 
# No pre-processing
# Resampling: Bootstrapped (25 reps) 
# Summary of sample sizes: 420, 420, 420, 420, 420, 420, ... 
# Resampling results across tuning parameters:
#   
# mtry  Accuracy   Kappa    
# 2     0.6572401  0.3179620
# 11    0.6566626  0.3161356
# 20    0.6444198  0.2910512
# 
# Accuracy was used to select the optimal model using the largest value.
# The final value used for the model was mtry = 2.


# Using the model to predict the test_subset
prediction <- tibble(observed = test_subset$Credit_Rating,
                     predicted = predict(model_rf, newdata = test_subset))

# Looking the results of predictions (similar to a confusion matrix)
table(prediction) %>% 
  as_tibble()

# Viewing the confusion matrix with the caret package
confusionMatrix(prediction$predicted, prediction$observed) # This order must be followed. See more at help of this function
# Result of accuracy on this confutionMatrix
# Accuracy : 0.6944

# 8. Ploting a ROC Curve of this model

# install.packages("plotROC")
library(plotROC)
# More info about this package at:
# https://cran.r-project.org/web/packages/plotROC/vignettes/examples.html

# creating an object with the join of probabilities used on prediction and the results of prediction
prob_pred <- bind_cols(predict(model_rf, 
                               newdata = test_subset, 
                               type = "prob"), 
                       prediction) %>% 
             as_tibble()

#
# prob_pred %>% 
#   filter(predicted %in% "Good", observed %in% "Good") # True Positive
# 
# 
# prob_pred %>% 
#   filter(predicted %in% "Good", observed %in% "Bad") # False Positive
#   
# 
# prob_pred %>% 
#   filter(Good >= 0.51, Bad <=0.49) # False Positive + True Positive
#   

# ploting the ROC Curve
basicROC <- ggplot(prob_pred, 
                   aes(d = observed, 
                       m = Good)) + 
            geom_roc() 


basicROC + 
  style_roc(theme = theme_grey) +
  theme(axis.text = element_text(colour = "blue")) +
  ggtitle("ROC and AUC") + 
  annotate("text", x = .75, y = .25, 
           label = paste("AUC =", round(calc_auc(basicROC)$AUC, 2))) +
  scale_x_continuous("1 - Specificity", breaks = seq(0, 1, by = .1))


# Interactive ROC
plot_interactive_roc(basicROC + 
                       style_roc())


# 9. Trying to optimize the model

# Training a new version of the model, with costs associated with the possible errors
# install.packages("C50")
library(C50)

Cost_func <- matrix(c(0, 1.5, 0.5, 0), # 0, 1.5, 0, 0
                    nrow = 2, 
                    dimnames = list(c("Good", "Bad"), c("Good", "Bad")))

model_rf_v2  <- C5.0(Credit_Rating ~ Checking_Account +
                                     Duration_Month +
                                     Credit_History +
                                     Credit_Amount +
                                     Savings_Account +
                                     Property +
                                     Employment,
                     data = train_subset,  
                     trials = 100,
                     costs = Cost_func); rm(Cost_func)

# print(model_rf_v2)
print(model_rf_v2)

# sort(match(c("Credit_Rating", 
#         "Checking_Account" , 
#         "Duration_Month" ,
#         "Credit_History" ,
#         "Credit_Amount" ,
#         "Savings_Account" ,
#         "Other_Guarantors"), names(credit)))
# 
# str(train_subset[,c(1,  2 , 3 , 5 , 6 ,10 ,21)])


# Using the new model to predict the test_subset
prediction_v2 <- tibble(observed = test_subset$Credit_Rating,
                        predicted = predict(model_rf_v2, newdata = test_subset))

# Looking the results of predictions (similar to a confusion matrix)
table(prediction_v2) %>% 
      as_tibble()

# Viewing the confusion matrix of caret package
confusionMatrix(prediction_v2$predicted, prediction_v2$observed) # This order must be followed. See more at help of this function
# Result of accuracy of this confutionMatrix
# Accuracy : 0.7278 


# Loss plots
# 
# credit_subset <- bind_cols(test_subset, prediction_v2[ ,2] ) 
# 
# credit_subset <- credit_subset %>% 
#                  filter(Credit_Rating != predicted)
# 
# 
# variables_2bars <- c("Duration_Month_groups", "Credit_Amount_groups", "Age_groups", "Purpose", "Job_Skill")
# 
# lapply(variables_2bars, function(x) {
#     ggplot(credit_subset, aes_string(x, fill = x)) +
#     geom_bar() + 
#     facet_grid(. ~ Credit_Rating) + 
#     theme(axis.text.x = element_text(angle = 45, 
#                                      hjust = 1)) +
#     ggtitle(paste("Loss frequency count by", x)) +
#     labs(fill = "Color legend") +
#     theme(plot.title = element_text(hjust = 0.5)) }); rm(variables_2bars, credit_subset)


