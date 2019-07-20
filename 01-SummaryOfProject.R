# ---
# script: 01-SummaryOfProject
# subject: Project Summary
# date: 2019-06-28
# author: Marcus Di Paula
# github: github.com/marcusdipaula/
# linkedin: linkedin.com/in/marcusdipaula/
# ---


#### Personal framework for a systematic approach ####


#___________ FUNDAMENTALS ___________#
#
# 1. Problem statement and comprehension of the context
#     - What am I trying to solve?
#     - Who will benefit of/is asking for this solution?
#     - What would be the ideal scenario for them?
#     - How could I use the available data to help them achieve this scenario?
#     - Why solve this problem? (purpose)
#
# 2. Looking for data:
#     - Identify entities (and its attributes) of the problem
#     - Collect data that represents entities
#     - Which hypotheses could I suppose?
#     - Explore the data (superficially) to understand it
#     - Could I use an algorithm to address the issue or solve it? Which one?



#___________ DATA WRANGLING ___________#
#
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
#
# 4. Building and validating models (orientated to the 5th phase)
#     - Train and test a ML model
#     - Which performance metrics should I rely on?
#     - Iteration



#___________ DEPLOYING ___________#
#
# 5. Deploy
#     - Data StoryTelling
#     - How can I deploy the model to production?
#     - Which strategies should I consider?
#     - An overview of what should be considered:
# https://christophergs.github.io/machine%20learning/2019/03/17/how-to-deploy-machine-learning-models/



#### End of framework ####


# 1. Problem statement and comprehension of the context
#
# How to predict a good or bad credit concession based on client's profile?
# This is a classification task. More information about classification tasks can be
# found here: https://towardsdatascience.com/machine-learning-classifiers-a5cc4e1b0623
#
#
# The approach to this question should consider that it will be presented
# to the bank decision makers.
#
# We want them to know which entities have the highest correlation to the variable
# we want to predict.
#
# We need to create a generalized model with which they can predict a good or bad credit
# concession based on historical client's profile
