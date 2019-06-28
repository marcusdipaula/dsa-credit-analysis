# Credit Risk Analysis (mini project)

Mini project proposed by the [Data Science Academy](https://www.datascienceacademy.com.br/), regarding credit analysis using R language.

How to predict clients as good or bad for credit concession?
This is a classification task. More information about it can be found here: https://towardsdatascience.com/machine-learning-classifiers-a5cc4e1b0623

1. <b>Context:</b> The approach to this question should consider that it will be presented to the bank decision makers.
We want them to know which entities have the highest correlation to the variable we want predict. We need to create a generalized model with which they can predict clients as good or bad for credit concession

2. <b>Entities:</b> Attributes (variables) that could help to predict good or bad credit concession, such as Job, Housing, Age, Sex, Savings Account, Purpose, Duration, etc.
The features of each attribute (or variable) are its kind/type/characteristic, example, Sex: male or female

3. <b>Data:</b> Will be used the German credit dataset*, with an addition of a 21th** column (attribute/variable) that represents the historical definition for each concession (row).

\* Original dataset: https://archive.ics.uci.edu/ml/datasets/Statlog+%28German+Credit+Data%29

\** Dataset with addition: https://github.com/marcusdipaula/dsa-credit-analysis/blob/master/credit.csv



## Here are some results of this short analysis:

### Target variable distribution
<img src="Plots/BarPlot_Target_variable_distribution.png" />

### Good or Bad credit count by some categorical variables

<img src="Plots/BarPlot_01.png" />

<img src="Plots/BarPlot_02.png" />

<img src="Plots/BarPlot_03.png" />

<img src="Plots/BarPlot_04.png" />

<img src="Plots/BarPlot_05.png" />

### Good or Bad credit distribution by some categorical variables

<img src="Plots/BoxPlot_01.png" />

<img src="Plots/BoxPlot_02.png" />

<img src="Plots/BoxPlot_03.png" />

<img src="Plots/BoxPlot_04.png" />

## Some analysis on feature selection, correlations and ROC curve of the first model

<img src="Plots/Predictors_ranking.png" />

<img src="Plots/Choosen_Variables_Correlations.png" />

<img src="Plots/ROC_first_model.png" />
