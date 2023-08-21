---
title: logistic far from machine learning
author: Bongani Ncube
date: '2023-08-17'
slug: logistic-far-from-machine-learning
categories: []
tags: []
subtitle: ''
summary: ''
authors: []
lastmod: '2023-08-17T19:38:55+02:00'
featured: no
image:
  caption: ''
  focal_point: ''
  preview_only: no
projects: []

---


# Generalized linear models

**Exponential Family**
The theory of GLMs is developed for data with distribution given y the **exponential family**.
The form of the data distribution that is useful for GLMs is

$$
f(y;\theta, \phi) = \exp(\frac{\theta y - b(\theta)}{a(\phi)} + c(y, \phi))
$$

# where

-   `\(\theta\)` is called the natural parameter
-   `\(\phi\)` is called the dispersion parameter

**Note**:

This family includes the [Gamma], [Normal], [Poisson], and other. For all parameterization of the exponential family, check this 

# **Example**

if we have `\(Y \sim N(\mu, \sigma^2)\)`

$$
`\begin{aligned}
f(y; \mu, \sigma^2) &= \frac{1}{(2\pi \sigma^2)^{1/2}}\exp(-\frac{1}{2\sigma^2}(y- \mu)^2) \\
&= \exp(-\frac{1}{2\sigma^2}(y^2 - 2y \mu +\mu^2)- \frac{1}{2}\log(2\pi \sigma^2)) \\
&= \exp(\frac{y \mu - \mu^2/2}{\sigma^2} - \frac{y^2}{2\sigma^2} - \frac{1}{2}\log(2\pi \sigma^2)) \\
&= \exp(\frac{\theta y - b(\theta)}{a(\phi)} + c(y , \phi))
\end{aligned}`
$$

# where

-   `\(\theta = \mu\)`
-   `\(b(\theta) = \frac{\mu^2}{2}\)`
-   `\(a(\phi) = \sigma^2 = \phi\)`
-   `\(c(y , \phi) = - \frac{1}{2}(\frac{y^2}{\phi}+\log(2\pi \sigma^2))\)`

# Logistic Regression

Logistic regression estimates the probability of a particular level of a categorical response variable given a set of predictors. The response levels can be binary, nominal (multiple categories), or ordinal (multiple levels).  

The **binary** logistic regression model is

##

`$$y = logit(\pi) = \ln \left( \frac{\pi}{1 - \pi} \right) = X \beta$$`

where `\(\pi\)` is the event probability. The model predicts the *log odds* of the response variable.  The maximum likelihood estimator maximizes the likelihood function

##

`$$L(\beta; y, X) = \prod_{i=1}^n \pi_i^{y_i}(1 - \pi_i)^{(1-y_i)} = \prod_{i=1}^n\frac{\exp(y_i X_i \beta)}{1 + \exp(X_i \beta)}.$$`

# goal

> the goal of this article is to use logistic regression from a statistical stead point i.e learn how to build parsimonious models using statistical criteria

> we also seek to use the R's sophisticated tools to help in deriving insights from the data

## Dataset

We will use a dataset named `stroke.dta` which in STATA\index{STATA} format. These data come from a study of hospitalized stroke patients. our main variables of interest are:

##

- status : Status of patient during hospitalization (alive or dead)
- gcs : Glasgow Coma Scale on admission (range from 3 to 15)
- stroke_type : IS (Ischaemic Stroke) or HS (Haemorrhagic Stroke)
- sex : female or male
- dm : History of Diabetes (yes or no)
- sbp : Systolic Blood Pressure (mmHg)
- age : age of patient on admission

# setup

```r
# load in packages
library(tidyverse)
```

```
## Warning: package 'ggplot2' was built under R version 4.2.3
```

```
## Warning: package 'tibble' was built under R version 4.2.3
```

```
## Warning: package 'dplyr' was built under R version 4.2.3
```

```
## -- Attaching core tidyverse packages ------------------------ tidyverse 2.0.0 --
## v dplyr     1.1.2     v readr     2.1.4
## v forcats   1.0.0     v stringr   1.5.0
## v ggplot2   3.4.2     v tibble    3.2.1
## v lubridate 1.9.2     v tidyr     1.3.0
## v purrr     1.0.1     
## -- Conflicts ------------------------------------------ tidyverse_conflicts() --
## x dplyr::filter() masks stats::filter()
## x dplyr::lag()    masks stats::lag()
## i Use the ]8;;http://conflicted.r-lib.org/conflicted package]8;; to force all conflicts to become errors
```

```r
library(haven)
library(rms)
```

```
## Loading required package: Hmisc
## 
## Attaching package: 'Hmisc'
## 
## The following objects are masked from 'package:dplyr':
## 
##     src, summarize
## 
## The following objects are masked from 'package:base':
## 
##     format.pval, units
## 
## Loading required package: survival
## Loading required package: lattice
## Loading required package: SparseM
## 
## Attaching package: 'SparseM'
## 
## The following object is masked from 'package:base':
## 
##     backsolve
```

```r
library(broom)

fatal <- read_dta('stroke.dta')
write.csv(fatal,"stroke_dat.csv")
```

Take a peek at data to check for 

- variable names
- variable types 

#
##

```r
> glimpse(fatal)

Rows: 226
Columns: 7
$ sex         <dbl+lbl> 1, 1, 1, 2, 1, 2, 2, 1, 2, 2, 1, 2, 2, 2, 2, 1, 2, 1~
$ status      <dbl+lbl> 1, 1, 1, 1, 1, 1, 2, 1, 1, 2, 1, 1, 1, 1, 1, 1, 1, 1~
$ gcs         <dbl> 13, 15, 15, 15, 15, 15, 13, 15, 15, 10, 15, 15, 15, 15, ~
$ sbp         <dbl> 143, 150, 152, 215, 162, 169, 178, 180, 186, 185, 122, 2~
$ dm          <dbl+lbl> 0, 0, 0, 1, 1, 1, 1, 0, 1, 1, 0, 1, 1, 1, 0, 1, 1, 1~
$ age         <dbl> 50, 58, 64, 50, 65, 78, 66, 72, 61, 64, 63, 59, 64, 62, ~
$ stroke_type <dbl+lbl> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0~
```


# Explore data

Variables sex, status, dm and stroke type are labelled variables though they are coded as numbers. The numbers represent the groups or categories or levels of the variables. They are categorical variables and not real numbers.

##

```r
fatal <- 
  fatal %>%
  mutate_if(is.labelled, as.factor)
```

# model building

+ model building is very important in the world of statistics
+ it enables us to come up with more precise and optimal models to describe different phenomena

# lets start model building
## first things first 

+ lets build a multivariate model with all the predictors
+ we use `glm(formula=y_var~x_vars,data,family=binomial)`



```r
fatal_mv2 <- 
  glm(status ~ gcs + stroke_type + sex + dm + sbp + age, 
      data = fatal, 
      family = binomial(link = 'logit'))
```

#

```r
> summary(fatal_mv2)

glm(formula = status ~ gcs + stroke_type + sex + dm + sbp + age, 
    family = binomial(link = "logit"), data = fatal)

Deviance Residuals: 
    Min       1Q   Median       3Q      Max  
-2.3715  -0.4687  -0.3280  -0.1921   2.5150  

Coefficients:
                          Estimate Std. Error z value Pr(>|z|)    
(Intercept)             -0.1588269  1.6174965  -0.098  0.92178    
gcs                     -0.3284640  0.0557574  -5.891 3.84e-09 ***
stroke_typeHaemorrhagic  1.2662764  0.4365882   2.900  0.00373 ** 
sexfemale                0.4302901  0.4362742   0.986  0.32399    
dmyes                    0.4736670  0.4362309   1.086  0.27756    
sbp                      0.0008612  0.0060619   0.142  0.88703    
age                      0.0242321  0.0154010   1.573  0.11562    
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

(Dispersion parameter for binomial family taken to be 1)

    Null deviance: 250.83  on 225  degrees of freedom
Residual deviance: 159.34  on 219  degrees of freedom
AIC: 173.34
```

```r
library(reticulate)
use_condaenv("base")
```



```python
import pandas as pd
import statsmodels.api as sm
import statsmodels.formula.api as smf

# obtain stroke_datadata
url = "stroke_dat.csv"
stroke_data= pd.read_csv(url)
# define model
model1 = smf.glm(formula = "status ~ gcs + stroke_type + sex + dm + sbp + age", 
                data = stroke_data, 
                family = sm.families.Binomial())


# fit model
promotion_model1 = model1.fit()


# see results summary
print(promotion_model1.summary())
```
#
##

+ we wont really explain the output but can comment on the p-values that gcs and stroke type Haemorrhagic are the most significant predictors of death
+ Haemorrhagic increases the odds of dying since it has a positive coefficient 

> a unit increase in gcs reduces the `log odds of dying` by `-0.3284640` which is 
 equivalent to `odds=exp(-0.3284640)=0.7200288` which implies that if the value increases the odds of dying are reduced by approximately `1-0.720028=37%` which makes sense coz had to research more about thus and saw that
 
* 3- 8 means severe
* 9-13 means moderate
* 14-15 means mild

#
##

- patients with HS have `\(1.266\)` times the log odds\index{Log odds} for death as compared to patients with IS, adjusting for other covariates.
- female patients have `\(0.430\)` times the log odds\index{Log odds} for death as compared to male patients, adjusting for other covariates.
- patients with diabetes mellitus have `\(0.474\)` times the log odds\index{Log odds} for deaths as compared to patients with no diabetes mellitus.
- With one mmHg increase in systolic blood pressure, the log odds\index{Log odds} for deaths change by a factor of `\(0.00086\)`, when adjusting for other variables.  
- with an increase in one year of age, the log odds\index{Log odds} for deaths change by a factor of `\(0.024\)`, when adjusting for other variables.

- thats not all folks

# using rms package


```r
> fatal_mv1 <- lrm(status ~ gcs + stroke_type + sex + dm + sbp + age,
                 data = fatal)

Logistic Regression Model

lrm(formula = status ~ gcs + stroke_type + sex + dm + sbp + age, 
    data = fatal)

                       Model Likelihood      Discrimination    Rank Discrim.    
                             Ratio Test             Indexes          Indexes    
Obs           226    LR chi2      91.49      R2       0.497    C       0.892    
 alive        171    d.f.             6      R2(6,226)0.315    Dxy     0.784    
 dead          55    Pr(> chi2) <0.0001    R2(6,124.8)0.496    gamma   0.784    
max |deriv| 4e-07                            Brier    0.110    tau-a   0.290    
```

#
##

```r
                         Coef    S.E.   Wald Z Pr(>|Z|)
Intercept                -0.1588 1.6175 -0.10  0.9218  
gcs                      -0.3285 0.0558 -5.89  <0.0001 
stroke_type=Haemorrhagic  1.2663 0.4366  2.90  0.0037  
sex=female                0.4303 0.4363  0.99  0.3240  
dm=yes                    0.4737 0.4362  1.09  0.2776  
sbp                       0.0009 0.0061  0.14  0.8870  
age                       0.0242 0.0154  1.57  0.1156 
```
# variable importance



```r
plot(anova(fatal_mv1),margin=c("chisq","d.f","P"))
```

<img src="{{< blogdown/postref >}}index.en_files/figure-html/unnamed-chunk-11-1.png" width="672" />
+ gcs and stroke type seem to be the most important variables that predict death

# model building 

+ we want to find the optimal set of variables that predict death 
+ first up we will use the univariate approach,thus we build univariate models based on variables available then we choose the variable with the the least p-value or least AIC value then build from there

# create univariate models and look at p-values




```r
# define function to run stroke model and glance at results
stroke_model_pvals <- function(form, df) {
  model <- glm(formula = form, data = df)
  broom::tidy(model)
}
# create model formula column
formula <- c(
  "status ~ gcs", 
  "status ~ stroke_type",
  "status ~ sex",
  "status ~ dm",
  "status ~ sbp",
  "status ~ age"
)
# create dataframe
models <- data.frame(formula)
```

# view p-values

```r
# run models and glance at results
mods<-models |>
  dplyr::group_by(formula) |>
  dplyr::summarise(stroke_model_pvals(formula, fatal)) |> 
  select(formula,p.value,term) |> 
  filter(term!="(Intercept)") |> 
  arrange(p.value)
```

```
## Warning: Returning more (or less) than 1 row per `summarise()` group was deprecated in
## dplyr 1.1.0.
## i Please use `reframe()` instead.
## i When switching from `summarise()` to `reframe()`, remember that `reframe()`
##   always returns an ungrouped data frame and adjust accordingly.
## Call `lifecycle::last_lifecycle_warnings()` to see where this warning was
## generated.
```

```
## `summarise()` has grouped output by 'formula'. You can override using the
## `.groups` argument.
```

```r
mods
```

```
## # A tibble: 6 x 3
## # Groups:   formula [6]
##   formula               p.value term       
##   <chr>                   <dbl> <chr>      
## 1 status ~ gcs         1.66e-24 gcs        
## 2 status ~ stroke_type 5.04e-11 stroke_type
## 3 status ~ sex         1.71e- 2 sex        
## 4 status ~ dm          1.62e- 1 dm         
## 5 status ~ age         4.54e- 1 age        
## 6 status ~ sbp         9.21e- 1 sbp
```

# explanation

- the output shows p-values for the univariate models arranged from smallest to largest
- gcs has the least p-value followed by stroke type

# Based on AIC
##

```r
stroke_model_information <- function(form, df) {
  model <- glm(formula = form, data = df)
  broom::glance(model)
}
```

#
##

```r
# run models and glance at results
  models |>
  dplyr::group_by(formula) |>
  dplyr::summarise(stroke_model_information(formula, fatal)) |> 
  select(formula,AIC,BIC,deviance,logLik) |> 
  arrange(AIC)
```

```
## # A tibble: 6 x 5
##   formula                AIC   BIC deviance logLik
##   <chr>                <dbl> <dbl>    <dbl>  <dbl>
## 1 status ~ gcs          159.  170.     26.1  -76.7
## 2 status ~ stroke_type  221.  232.     34.3 -108. 
## 3 status ~ sex          259.  269.     40.6 -127. 
## 4 status ~ dm           263.  273.     41.3 -128. 
## 5 status ~ age          264.  275.     41.5 -129. 
## 6 status ~ sbp          265.  275.     41.6 -129.
```
+ we get the same results (gcs and stroke_type have the least  AIC)

# Lets build from there
##


```r
> model0<-glm(status~gcs,data=fatal,family = binomial)
> model1<-glm(status~gcs+stroke_type,data=fatal,family = binomial)
> summary(model1)

glm(formula = status ~ gcs + stroke_type, family = binomial, 
    data = fatal)

Deviance Residuals: 
    Min       1Q   Median       3Q      Max  
-2.1921  -0.5629  -0.3380  -0.3380   2.4045  

Coefficients:
                        Estimate Std. Error z value Pr(>|z|)    
(Intercept)              2.22960    0.71414   3.122  0.00180 ** 
gcs                     -0.33755    0.05477  -6.164 7.11e-10 ***
stroke_typeHaemorrhagic  1.09094    0.41452   2.632  0.00849 ** 
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
```
# is adding stroke_type to gcs worth it?
##
+ we use likelihood ratio test
+ call `Anova(model1,model2,test="LRT")`




```r
anova(model0,model1,test="LRT")
```

```
## Analysis of Deviance Table
## 
## Model 1: status ~ gcs
## Model 2: status ~ gcs + stroke_type
##   Resid. Df Resid. Dev Df Deviance Pr(>Chi)   
## 1       224     170.92                        
## 2       223     164.17  1   6.7477 0.009387 **
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```
+ the value of `Pr(>Chi)` is less than 0.05 implying that stroketype can make the model much better so we include it and add another variable

# lets add sex


```r
model2<-glm(status~gcs+stroke_type+sex,data=fatal,family = binomial)
anova(model1,model2,test="LRT")
```

```
## Analysis of Deviance Table
## 
## Model 1: status ~ gcs + stroke_type
## Model 2: status ~ gcs + stroke_type + sex
##   Resid. Df Resid. Dev Df Deviance Pr(>Chi)
## 1       223     164.17                     
## 2       222     162.72  1   1.4567   0.2275
```
+ We get a p-value greater than 0.05 hence we drop the variable

# lets try `dm`

##

```r
model3<-glm(status~gcs+stroke_type+dm,data=fatal,family = binomial)
anova(model1,model3,test="LRT")
```

```
## Analysis of Deviance Table
## 
## Model 1: status ~ gcs + stroke_type
## Model 2: status ~ gcs + stroke_type + dm
##   Resid. Df Resid. Dev Df Deviance Pr(>Chi)
## 1       223     164.17                     
## 2       222     163.51  1  0.65891   0.4169
```

+ our p-value is also greater than 0.05 so we drop it

# lets try `age`

##

```r
model4<-glm(status ~ gcs + stroke_type + age, data=fatal,family = binomial)
anova(model1,model4,test="LRT")
```

```
## Analysis of Deviance Table
## 
## Model 1: status ~ gcs + stroke_type
## Model 2: status ~ gcs + stroke_type + age
##   Resid. Df Resid. Dev Df Deviance Pr(>Chi)
## 1       223     164.17                     
## 2       222     161.51  1   2.6602   0.1029
```

+ still not satisfying

# lets add sbp


```r
model5<-glm(status~gcs+stroke_type+sbp,data=fatal,family = binomial)
anova(model1,model5,test="LRT")
```

```
## Analysis of Deviance Table
## 
## Model 1: status ~ gcs + stroke_type
## Model 2: status ~ gcs + stroke_type + sbp
##   Resid. Df Resid. Dev Df Deviance Pr(>Chi)
## 1       223     164.17                     
## 2       222     164.07  1 0.098017   0.7542
```
+ still not satisfying
> addition of other variables to gcs and stroke_type did not yield signifant p-values hence we can drop them 

# 
## final model

+ we can choose gcs and stroke_type to be the most significant and optimal set of variables to predict death


```r
> final_model<-glm(status~gcs+stroke_type,data=fatal,family = binomial)
> summary(final_model)

glm(formula = status ~ gcs + stroke_type, family = binomial, 
    data = fatal)

Deviance Residuals: 
    Min       1Q   Median       3Q      Max  
-2.1921  -0.5629  -0.3380  -0.3380   2.4045  

Coefficients:
                        Estimate Std. Error z value Pr(>|z|)    
(Intercept)              2.22960    0.71414   3.122  0.00180 ** 
gcs                     -0.33755    0.05477  -6.164 7.11e-10 ***
stroke_typeHaemorrhagic  1.09094    0.41452   2.632  0.00849 ** 
```
# lets confirm this using backward elimination

+ we start of with a full model


```r
fatal_mv1 <- 
  lrm(status ~ gcs + stroke_type + sex + dm + sbp + age, 
      data = fatal)
```
 
# 
## 

```r
> fastbw(fatal_mv1)

 Deleted Chi-Sq d.f. P      Residual d.f. P      AIC  
 sbp     0.02   1    0.8870 0.02     1    0.8870 -1.98
 sex     0.97   1    0.3246 0.99     2    0.6094 -3.01
 dm      1.11   1    0.2911 2.11     3    0.5509 -3.89
 age     2.38   1    0.1228 4.49     4    0.3441 -3.51

Approximate Estimates after Deleting Factors

                            Coef    S.E. Wald Z         P
Intercept                 2.1811 0.71458  3.052 2.272e-03
gcs                      -0.3283 0.05525 -5.942 2.824e-09
stroke_type=Haemorrhagic  1.0436 0.41883  2.492 1.272e-02

Factors in Final Model

[1] gcs         stroke_type
```

#
##

+ we get similar results
+ lets try a step-wise regression from both sides


```r
>full_model <-glm(status ~ gcs + stroke_type + sex + dm + sbp + age, 
                data = fatal,family=binomial())

>step<-stepAIC(full_model, direction = "both")
>summary(step)

Start:  AIC=173.34
status ~ gcs + stroke_type + sex + dm + sbp + age

              Df Deviance    AIC
- sbp          1   159.36 171.36
- sex          1   160.32 172.32
- dm           1   160.54 172.54
<none>             159.34 173.34
- age          1   161.92 173.92
- stroke_type  1   167.69 179.69
- gcs          1   202.73 214.73
```

# second iteration 
##


```r
Step:  AIC=171.36
status ~ gcs + stroke_type + sex + dm + age

              Df Deviance    AIC
- sex          1   160.34 170.34
- dm           1   160.55 170.55
<none>             159.36 171.36
- age          1   162.04 172.04
+ sbp          1   159.34 173.34
- stroke_type  1   167.73 177.73
- gcs          1   202.82 212.82
```

# third iteration
##

```r
Step:  AIC=170.34
status ~ gcs + stroke_type + dm + age

              Df Deviance    AIC
- dm           1   161.51 169.51
<none>             160.34 170.34
+ sex          1   159.36 171.36
- age          1   163.51 171.51
+ sbp          1   160.32 172.32
- stroke_type  1   168.52 176.52
- gcs          1   206.86 214.86
```

#
## final iteration

```r
Step:  AIC=169.51
status ~ gcs + stroke_type + age

              Df Deviance    AIC
<none>             161.51 169.51
- age          1   164.17 170.17
+ dm           1   160.34 170.34
+ sex          1   160.55 170.55
+ sbp          1   161.51 171.51
- stroke_type  1   169.53 175.53
- gcs          1   208.96 214.96
```

# model from final iteration              

```r
Call:
glm(formula = status ~ gcs + stroke_type + age, family = binomial(), 
    data = fatal)

Deviance Residuals: 
    Min       1Q   Median       3Q      Max  
-2.2588  -0.4481  -0.3337  -0.2228   2.4807  

Coefficients:
                        Estimate Std. Error z value Pr(>|z|)    
(Intercept)              0.73401    1.16319   0.631  0.52802    
gcs                     -0.33864    0.05546  -6.106 1.02e-09 ***
stroke_typeHaemorrhagic  1.22428    0.42959   2.850  0.00437 ** 
age                      0.02350    0.01467   1.602  0.10918    
---
```
