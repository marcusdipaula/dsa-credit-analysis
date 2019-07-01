# 01-SummaryOfProject

# ---
# title: Project Summary
# date: 2019-06-28
# author: Marcus Di Paula
# github: github.com/marcusdipaula/
# linkedin: linkedin.com/in/marcusdipaula/
# ---


#### Framework of reference ####

### Fundaments ###
#
# 1. Problem definition and comprehension of context
#
# 2. Identification of entities and its features
#
# 3. Collect data that represents entities


### Data Mining/Wrangling ###
#
# 1. Understand & Tidy the dataset
#
# 2. Understand & Analyse: hypothesis generation
#
# 3. Understand & Transform (Feature Engineering)
#
# 4. Data Exploration: hypothesis confirmation
#
# 5. Create, train, test, improve a Machine Learning model
#
# 6. Iteration


### Data StoryTelling ###
#
# 1. Choose appropriate visual
#
# 2. Decluter it
#
# 3. Focus attention
#
# 4. Think like a designer (UX/UI)
#
# 5. Tell the story of data


#### Definitions ####
#
# _________________________________Fundaments_____________________________________ 
#
# 1.Problem: How to predict a good or bad credit concession based on client's profile? 
# This is a classification task. More information about classification models can be 
# found here: https://towardsdatascience.com/machine-learning-classifiers-a5cc4e1b0623
#
#
# Context: The approach to this question should consider that it will be presented 
# to the bank decision makers.
#
# We want them to know which entities have the highest correlation to the variable 
# we want to predict.
#
# We need to create a generalized model with which they can predict a good or bad credit 
# concession based on historical client's profile
# 
#
# 2.Entities: Attributes (variables) that could help to predict good or bad credit
# concession, such as Job, Housing, Age, Sex, Savings Account, Purpose, Duration, etc
#
# The features of each attribute (or variable) are its kind/type/characteristic, example: 
# - Sex: male or female
#
#
# 3.Data: Will be used the German credit dataset*, with an addition of a 21th** column 
# (attribute/variable) that represents the historical definition for each concession (row).
#
# * Original dataset: https://archive.ics.uci.edu/ml/datasets/Statlog+%28German+Credit+Data%29
# ** Dataset with addition: https://github.com/marcusdipaula/dsa-credit-analysis/blob/master/credit.csv


