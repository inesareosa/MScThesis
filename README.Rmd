---
output: html_document
editor_options: 
  chunk_output_type: inline
---

# MSc Thesis: **Visual Tools for Understanding Regression Black-Box Models**
## *Inês Areosa*
## *Supervisors: Luís Torgo and Luís Custódio*

This page contains the code, data and resulting plots of the experiments in the MSc Thesis *Visual Tools for Understanding Regression Black-Box Models* (November, 2019).

First, it is provided an explanation on how the full experiments can be reproduced, followed with an example of the proposed tools. 

Then, it is provided a zip file with the plots and code corresponding to all 18 data sets, not included in the paper due to space limitation.

Lastly, the plots for the case study of the Fishing Effort are also made available for all Large Scale Marine Protected Areas in study.


## Requirements
[R](www.r-project.org) is required for reproducing the experiments. The following R extra packages, available on [CRAN](https://cran.r-project.org/web/packages/), are also needed:

* dplyr
* GGally
* plyr
* gridExtra
* reshape2


## Usage

Tested on R 3.5.2

The benchamark data sets can be downloaded [here](Datasets.zip). The full code and resultant plots can be downloaded [here](Performance.zip). The full plots of the LSMPAs can be downloaded [here](FishingEffort.zip)


### Load Functions and Dataset

```{r, warning=FALSE}
## Loading functions required (as well as required packages)
source("Performance/performance_functions.R")

## Loading Dataset
load("Datasets/dataSetsWithPreds.Rdata")
names(DSsPreds) <- c('a1','a2','a3','a4','a6','a7','Abalone','acceleration','availPwr','bank8FM','cpuSm','fuelCons','boston','maxTorque','machineCpu','servo','airfoild','concreteStrength')
nmod <- 4

```

### Run the Experiments for the Full Benchmark Dataset

```Rscript DataSet_Performance.R```

### An Example on How to Employ the Single Model Functionalities

Choose what type of error the end user wants to analyse: "Absolute", Logarithmic ("Log") or "Residual"
```{r}
err <- "Absolute"
```

Choose a particular data set from the full benchmark
```{r}
y_observed <- "servo"
dataset <- DSsPreds[[y_observed]][complete.cases(DSsPreds[[y_observed]]),]
#Show part of dataset
head(dataset, n=10)
```

Choose which model is to be analysed and prepare the data
```{r}
mod <- "svm"
single_error_ds <- single_model_data(data=dataset[1:(length(dataset) - nmod)], model=dataset[[mod]], feature_y=names(dataset)[1], type=err)
head(single_error_ds, n=10)
```

* **EDP**

Choose a predictor and calculate the EDP. Here is the example with a numeric ("vgain") and a categorical ("screw"), as well as the bivariate EDP for both features:

```{r, echo=FALSE, results='hide', fig.keep='all'}
edp(single_error_ds, "vgain", type=err, jitter=FALSE)
edp(single_error_ds, "screw", type=err, jitter=FALSE)

# Bivariate EDP: Option "All" for the comparative facet to show theoverall error distribution
plot(multiple_edp(single_error_ds, c("vgain", "screw"), type=err, option='All', ncols=3, mode="wrap"))
```

* **PEP**

Plot for all predictors:

```{r, echo=FALSE, results='hide', fig.keep='all'}
pep(single_error_ds, type=err, option="A")
pep(single_error_ds, type=err, option="B")
```


### An Example on How to Employ the Multiple Model Functionality

```{r}
multiple_error_ds <- all_model_data(data=dataset, model=c("svm", "randomForest", "nnet","gbm"), feature_y=names(dataset)[1], type=err)
head(multiple_error_ds, n=10)

```

* **MEDP**

Choose a predictor and calculate the MEDP. Here is the example with feature "vgain", as well as the bivariate MEDP for the same feature:

```{r, echo=FALSE, results='hide', fig.keep='all'}
medp(multiple_error_ds, "vgain", mod_names=c("svm", "randomForest", "nnet","gbm"), type=err)

# Bivariate MEDP: Option 3 for the comparative facet to show the overall error distribution
plot(biv_medp(multiple_error_ds, c("vgain", "screw"), mod_names=c("svm", "randomForest", "nnet","gbm"), type=err, option=3))
```





