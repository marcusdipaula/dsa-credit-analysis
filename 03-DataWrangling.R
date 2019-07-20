# ---
# script: 03-DataWrangling
# subject: Data exploring and wrangling
# date: 2019-06-28
# author: Marcus Di Paula
# github: github.com/marcusdipaula/
# linkedin: linkedin.com/in/marcusdipaula/
# ---


# 3. Data preparation and Exploration (Feature Engineering orientated to the 4th and 5th phase)
#     - Is my dataset tidy?
#     - Is my dataset clean?
#     - Which correlations exists between all variables and to the target?
#     - There is any NA in my dataset? If so, how should I treat them? Which effects would it have?
#     - Should I narrowing in on observations of interest? Which effects would it have?
#     - Should I reduce my variables? Which effects would it have?
#     - Should I create new variables that are functions of existing ones? Which effects would it have?
#     - Should I binning variables? Which effects would it have?
#     - should I convert variables (categorical = numerical / vv)? Which effects would it have?
#     - Should I dummy coding categorical variables? Which effects would it have?
#     - Should I standardize numerical variables? Which effects would it have?
#     - Can I test my hypotheses?


# variables to control exploration and the binding of some variables
want_to_explore <- FALSE # There is an exploration before and after the creation of groups




if(want_to_explore){
          
          # loading the plotly package (and installing it first, if not installed)
          if(!require(plotly)) {install.packages("plotly"); library(plotly)}
          
          # Exploring the distribution of the target variable
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
                  
          # Grouping some numerical variables
          # so it will be easy to plot them by Credit_Rating
          
            # Viewing summary of Duration_Month, Credit_Amount and Age variables
            # to have notion of its distribution (I'd like to group them into just a few groups)
          summary(credit$Age)
          summary(credit$Duration_Month)
          summary(credit$Credit_Amount)
          quantile(credit$Credit_Amount)
          }



            # Creating groups for each variable desired (Age, Duration_Month and Credit_Amount)
              # Age groups
          Age_groups <- c(paste(seq(15, 75, by = 15), seq(30-1, 90, by = 15), sep = "-"))
          
              # Month duration groups
          Duration_Month_groups <- c("0-12","13-24","25-36","37-48","49-60","61-72")
              # Duration_Month_Group <- c(paste(seq(4, 72, by = 14), seq(18-1, 75, by = 14), sep = "-"))
              # the above is an alternative, but the groups don't make sense in terms of real accounting periods
          
              # Requested amount of credit groups
          Credit_Amount_groups <- c("250-1364", "1365-2318", "2319-3971", "3972-18424")
              # split according to quantile function result
          
          
            # Adding the groups to dataset
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
          


if(want_to_explore) {
  
          # Looking the number of Credit_Rating by age groups
          credit %>%
            select(Age_groups, Credit_Rating) %>%
            table()
          
          
          credit %>%
            select(Credit_Rating) %>%
            table()
          
          # There is any NA?
          sapply(credit, function(x){ sum(is.na(x)) })
          
          
          # Ploting (before balancing)
          
          # loading the GGally package (and installing it first, if not installed)
          if(!require(GGally)) {install.packages("GGally"); library(GGally)}
          
          # correlation heat map
          sapply(credit, as.integer) %>% 
            as_tibble() %>% 
            select(-ends_with("_groups")) %>% 
            ggcorr()
          
          # a matrix of plots
          sapply(credit, as.integer) %>% 
            as_tibble() %>% 
            select(-ends_with("_groups")) %>% 
            ggpairs()
          
          
          # test
          # credit %>%
          #   select(Job_Skill, Credit_Rating, Age_groups) %>%
          #   ggplot(aes(Job_Skill, fill = Job_Skill)) +
          #   geom_bar() +
          #   facet_grid(Age_groups ~ Credit_Rating) +
          #   labs(fill = "Color legend")
          
          
            # Variables to plot bars
          variables_2bars <- c(colnames(credit[, sapply(credit, is.factor)] ))
          
          
            # bar plot
          lapply(variables_2bars, function(x){
                                    ggplot(subset_balanced, aes_string(x, fill = x)) +
                                    geom_bar() +
                                    geom_text(stat='count', aes(label=..count..), vjust=-1) +
                                    facet_grid(. ~ Credit_Rating) +
                                    theme(axis.text.x = element_text(angle = 45,
                                                                     hjust = 1),
                                          axis.title.x = ) +
                                    ggtitle(paste("Good/Bad credit count by", x)) +
                                    labs(fill = "Color legend") +
                                    theme(plot.title = element_text(hjust = 0.5)) }); rm(variables_2bars) # ggsave()
          
          
          
          
          
            # Variables to plot boxes
          variables_2boxes <- c("Age_groups", 
                                "Purpose", 
                                "Job_Skill", 
                                "Credit_History")
          
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
          } 


if(want_to_explore) {
            # Manualy balancing
            
            # Subseting all Credit_Rating "Bad", since it has the small portion of both options(Good/Bad)
            subset_bad <- credit %>%
                            filter(Credit_Rating %in% "Bad")
            
            # Subseting a random sample of Credit_Rating "Good" of the same size of Credit_Rating "Bad"
            subset_good <- credit %>%
                            filter(Credit_Rating %in% "Good") %>%
                              sample_n(size = 300)
            
            # Binding rows and removing unecessary objects
            subset_balanced <- bind_rows(subset_bad, subset_good); rm(subset_bad, subset_good)
            
            # Verifying proportions
            train_subset %>%
              select(Credit_Rating) %>%
              table()
            
            test_subset %>%
              select(Credit_Rating) %>%
              table()
            
            
            
            # Ploting after balancing
            
            # Variables to plot bars
            variables_2bars <- c(colnames(credit[, 
                                                 sapply(credit, 
                                                        is.factor
                                                        )
                                                 ]
                                          )
                                 )
            
            
            # bar plot
            lapply(variables_2bars, function(x){
                    ggplot(subset_balanced, aes_string(x, fill = x)) +
                      geom_bar() +
                      geom_text(stat='count', aes(label=..count..), vjust=-1) +
                      facet_grid(. ~ Credit_Rating) +
                      theme(axis.text.x = element_text(angle = 45,
                                                       hjust = 1) ) +
                      ggtitle(paste("Good/Bad credit count by", x)) +
                      labs(fill = "Color legend") +
                      theme(plot.title = element_text(hjust = 0.5)) }); rm(variables_2bars) # ggsave()
            
            
            # Variables to plot boxes
            variables_2boxes <- c("Age_groups", 
                                  "Purpose", 
                                  "Job_Skill", 
                                  "Credit_History")
            
            # boxplot
            lapply(variables_2boxes, function(x){
                    ggplot(subset_balanced, aes_string(x = x, y = "Credit_Amount", fill = x)) +
                      geom_boxplot() +
                      facet_grid(. ~ Credit_Rating) +
                      theme(axis.text.x = element_text(angle = 45,
                                                       hjust = 1)) +
                      ggtitle(paste("Good/Bad credit distribution by", x)) +
                      labs(fill = "Color legend") +
                      theme(plot.title = element_text(hjust = 0.5)) }); rm(variables_2boxes) # ggsave()
            
            } ; rm(want_to_explore)



# # Test with c50 algorithm, with costs associated with the possible errors
# # install.packages("C50")
# library(C50)
# 
# Cost_func <- matrix(c(0, 1.5, 0.5, 0), # 0, 1.5, 0, 0
#                     nrow = 2,
#                     dimnames = list(c("Good", "Bad"), c("Good", "Bad")))
# 
# model_c50  <- C5.0(Credit_Rating ~ Checking_Account +
#                                      Duration_Month +
#                                      Credit_History +
#                                      Credit_Amount +
#                                      Savings_Account +
#                                      Property +
#                                      Employment,
#                      data = train_subset,
#                      trials = 100,
#                      costs = Cost_func); rm(Cost_func)

