---
# Documentation: https://wowchemy.com/docs/managing-content/

title: "Generalised Linear Models 1"
subtitle: ""
summary: ""
authors: []
tags: []
categories: []
date: 2023-09-09T12:48:21+02:00
lastmod: 2023-09-09T12:48:21+02:00
featured: false
draft: false

# Featured image
# To use, add an image named `featured.jpg/png` to your page's folder.
# Focal points: Smart, Center, TopLeft, Top, TopRight, Left, Right, BottomLeft, Bottom, BottomRight.
image:
  caption: ""
  focal_point: ""
  preview_only: false

# Projects (optional).
#   Associate this post with one or more of your projects.
#   Simply enter your project's folder or file name without extension.
#   E.g. `projects = ["internal-project"]` references `content/project/deep-learning/index.md`.
#   Otherwise, set `projects = []`.
projects: []
---

<script src="//yihui.org/js/math-code.js" defer></script>
<!-- Just one possible MathJax CDN below. You may use others. -->
<script defer
  src="//mathjax.rstudio.com/latest/MathJax.js?config=TeX-MML-AM_CHTML">
</script>



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

# **Properties of GLM exponential families**

1.  `\(E(Y) = b' (\theta)\)` where `\(b'(\theta) = \frac{\partial b(\theta)}{\partial \theta}\)` (here `'` is "prime", not transpose)

2.  `\(var(Y) = a(\phi)b''(\theta)= a(\phi)V(\mu)\)`.

    -   `\(V(\mu)\)` is the *variance function*; however, it is only the variance in the case that `\(a(\phi) =1\)`

3.  If `\(a(), b(), c()\)` are identifiable, we will derive expected value and variance of Y.

# Example

Normal distribution

$$
b'(\theta) = \frac{\partial b(\mu^2/2)}{\partial \mu} = \mu$$`
`$$V(\mu) = \frac{\partial^2 (\mu^2/2)}{\partial \mu^2} = 1$$`
`$$\to var(Y) = a(\phi) = \sigma^2
$$

# Poisson distribution

$$
`\begin{aligned}
f(y, \theta, \phi) &= \frac{\mu^y \exp(-\mu)}{y!}
&= \exp(y\log(\mu) - \mu - \log(y!)) 
&= \exp(y\theta - \exp(\theta) - \log(y!))
\end{aligned}`
$$

# where

-   `\(\theta = \log(\mu)\)`
-   `\(a(\phi) = 1\)`
-   `\(b(\theta) = \exp(\theta)\)`
-   `\(c(y, \phi) = \log(y!)\)`

Hence,

$$
E(Y) = \frac{\partial b(\theta)}{\partial \theta} = \exp(\theta) = \mu$$`
`$$var(Y) = \frac{\partial^2 b(\theta)}{\partial \theta^2} = \mu
$$

Since `\(\mu = E(Y) = b'(\theta)\)`

In GLM, we take some monotone function (typically nonlinear) of `\(\mu\)` to be linear in the set of covariates

$$
g(\mu) = g(b'(\theta)) = \mathbf{x'\beta}
$$

# Equivalently,

$$
\mu = g^{-1}(\mathbf{x'\beta})
$$

where `\(g(.)\)` is the **link function** since it links mean response ($\mu = E(Y)$) and a linear expression of the covariates

Some people use `\(\eta = \mathbf{x'\beta}\)` where `\(\eta\)` = the "linear predictor"

# **GLM is composed of 2 components**

The **random component**:

-   is the distribution chosen to model the response variables `\(Y_1,...,Y_n\)`

-   is specified by the choice fo `\(a(), b(), c()\)` in the exponential form

-   Notation:

Assume that there are n **independent** response variables `\(Y_1,...,Y_n\)` with densities
        $$
        f(y_i ; \theta_i, \phi) = \exp(\frac{\theta_i y_i - b(\theta_i)}{a(\phi)}+ c(y_i, \phi))
        $$ notice each observation might have different densities
    -   Assume that `\(\phi\)` is constant for all `\(i = 1,...,n\)`, but `\(\theta_i\)` will vary. `\(\mu_i = E(Y_i)\)` for all i.

# The **systematic component**

-   is the portion of the model that gives the relation between `\(\mu\)` and the covariates `\(\mathbf{x}\)`

-   consists of 2 parts:

    -   the *link* function, `\(g(.)\)`
    -   the *linear predictor*, `\(\eta = \mathbf{x'\beta}\)`

-   Notation:

assume `\(g(\mu_i) = \mathbf{x'\beta} = \eta_i\)` where `\(\mathbf{\beta} = (\beta_1,..., \beta_p)'\)`
    -   The parameters to be estimated are `\(\beta_1,...\beta_p , \phi\)`

# **The Canonical Link**

To choose `\(g(.)\)`, we can use **canonical link function** (Remember: Canonical link is just a special case of the link function)

If the link function `\(g(.)\)` is such `\(g(\mu_i) = \eta_i = \theta_i\)`, the natural parameter, then `\(g(.)\)` is the canonical link.

# Logistic Regression

$$
p_i = f(\mathbf{x}_i ; \beta) = \frac{exp(\mathbf{x_i'\beta})}{1 + exp(\mathbf{x_i'\beta})}
$$

Equivalently,

$$
logit(p_i) = log(\frac{p_i}{1-p_i}) = \mathbf{x_i'\beta}
$$

where `\(\frac{p_i}{1+p_i}\)`is the **odds**.

In this form, the model is specified such that **a function of the mean response is linear**. Hence, **Generalized Linear Models**


# **Logistic Regression: Interpretation of** betas

For single regressor, the model is

$$
logit\{\hat{p}_{x_i}\} \equiv logit (\hat{p}_i) = \log(\frac{\hat{p}_i}{1 - \hat{p}_i}) = \hat{\beta}_0 + \hat{\beta}_1 x_i
$$

When `\(x= x_i + 1\)`

$$
logit\{\hat{{p}_{x_i +1}\}} = \hat{\beta_0} + \hat{\beta}(x_i + 1)$$`

which is equal to 
`$$logit\{\hat{p}_{x_i}\} + \hat{\beta}_1$$`

Then,

$$
logit{\hat{p_{x_i +1}}} - logit{\hat{p_{x_i}}}$$ 

is equal to

`$$log\{odds[\hat{p}_{x_i +1}]\} - log\{odds[\hat{p}_{x_i}]\}$$`


# the estimated **odds ratio**

the estimated odds ratio, when there is a difference of c units in the regressor x, is `\(exp(c\hat{\beta}_1)\)`. When there are multiple covariates, `\(exp(\hat{\beta}_k)\)` is the estimated odds ratio for the variable `\(x_k\)`, assuming that all of the other variables are held constant.

*Inference on the Mean Response**

Let `\(x_h = (1, x_{h1}, ...,x_{h,p-1})'\)`. Then

$$
\hat{p}_h = \frac{exp(\mathbf{x'_h \hat{\beta}})}{1 + exp(\mathbf{x'_h \hat{\beta}})}
$$

and `\(s^2(\hat{p}_h) = \mathbf{x'_h[I(\hat{\beta})]^{-1}x_h}\)`

For new observation, we can have a cutoff point to decide whether y = 0 or 1.

# setup

```r
library(tidyverse)

df<-readxl::read_xlsx("logistic.xlsx") |> 
  mutate_if(is.character,as.factor) |> 
  rename(SEX="SEX JAN",
         STATUS="Default Status")
df
#> # A tibble: 6,824 x 7
#>    `RTGS EXPOSURE` STATUS SEX    `Marital Status` Profession   `Gross Income`
#>              <dbl>  <dbl> <fct>  <fct>            <fct>                 <dbl>
#>  1          1057.       1 MALE   Single           Blue Collar             652
#>  2           207.       1 MALE   Married          Blue Collar             460
#>  3          2162.       1 FEMALE Single           White Collar            468
#>  4            41.9      1 FEMALE Married          White Collar            733
#>  5            10.8      1 FEMALE Married          White Collar            465
#>  6           181.       1 FEMALE Married          White Collar            460
#>  7         14583.       0 MALE   Single           White Collar           8000
#>  8         53471.       0 FEMALE Other            Blue Collar            2600
#>  9          2156.       0 FEMALE Single           White Collar            773
#> 10          1114.       0 MALE   Married          Blue Collar             575
#> # i 6,814 more rows
#> # i 1 more variable: `Age Group` <fct>
```

#
+ CBZ is considering to develop a model that predicts the default experience of their loan books.A statistician was assigned to develop of prob of default,default and non-default,The factors that will be considered to influence.  

EXPOSURE,SEX,MARIT,PROFFESSION,GROSSINCOME,AGEGROUP As predictor variables explaining all the terms

#

```r
options(scipen = 999)
library(equatiomatic)
mod1<-glm(STATUS~.,data=df,family=binomial)
summary(mod1)
#> 
#> Call:
#> glm(formula = STATUS ~ ., family = binomial, data = df)
#> 
#> Deviance Residuals: 
#>     Min       1Q   Median       3Q      Max  
#> -0.4612  -0.1916  -0.1331  -0.0539   4.1543  
#> 
#> Coefficients:
#>                              Estimate    Std. Error z value Pr(>|z|)    
#> (Intercept)               -2.13712297    1.23427306  -1.731   0.0834 .  
#> `RTGS EXPOSURE`           -0.00036209    0.00009165  -3.951 0.000078 ***
#> SEXMALE                   -0.01617771    0.27574625  -0.059   0.9532    
#> `Marital Status`Engaged  -12.87415038  514.79170656  -0.025   0.9800    
#> `Marital Status`Married   -0.91052261    1.04309052  -0.873   0.3827    
#> `Marital Status`Other     -2.28288908    1.44346105  -1.582   0.1138    
#> `Marital Status`Single    -1.05896113    1.06289344  -0.996   0.3191    
#> ProfessionWhite Collar    -0.32313990    0.26883397  -1.202   0.2294    
#> `Gross Income`            -0.00072287    0.00045865  -1.576   0.1150    
#> `Age Group`30-39           0.33735455    0.61753220   0.546   0.5849    
#> `Age Group`40-49           0.82290874    0.62040499   1.326   0.1847    
#> `Age Group`50-59           0.57181832    0.66677092   0.858   0.3911    
#> `Age Group`60-69           1.02085330    0.78462020   1.301   0.1932    
#> `Age Group`70+           -11.67550397 1624.62863041  -0.007   0.9943    
#> ---
#> Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
#> 
#> (Dispersion parameter for binomial family taken to be 1)
#> 
#>     Null deviance: 879.30  on 6823  degrees of freedom
#> Residual deviance: 799.53  on 6810  degrees of freedom
#> AIC: 827.53
#> 
#> Number of Fisher Scoring iterations: 15
```

#

```r
extract_eq(mod1,greek_colors = "blue",wrap=TRUE,terms_per_line = 2,use_coefs = TRUE) 
```

# null model

- model with no dependent variables

```r
model1<-glm(STATUS~1,data=df,family=binomial)
summary(model1)
#> 
#> Call:
#> glm(formula = STATUS ~ 1, family = binomial, data = df)
#> 
#> Deviance Residuals: 
#>     Min       1Q   Median       3Q      Max  
#> -0.1545  -0.1545  -0.1545  -0.1545   2.9778  
#> 
#> Coefficients:
#>             Estimate Std. Error z value            Pr(>|z|)    
#> (Intercept)  -4.4218     0.1118  -39.56 <0.0000000000000002 ***
#> ---
#> Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
#> 
#> (Dispersion parameter for binomial family taken to be 1)
#> 
#>     Null deviance: 879.3  on 6823  degrees of freedom
#> Residual deviance: 879.3  on 6823  degrees of freedom
#> AIC: 881.3
#> 
#> Number of Fisher Scoring iterations: 7
```

# model with sex

```r
model2<-glm(STATUS ~ SEX,data=df,family=binomial)
summary(model2)
#> 
#> Call:
#> glm(formula = STATUS ~ SEX, family = binomial, data = df)
#> 
#> Deviance Residuals: 
#>     Min       1Q   Median       3Q      Max  
#> -0.1553  -0.1553  -0.1553  -0.1522   2.9882  
#> 
#> Coefficients:
#>             Estimate Std. Error z value            Pr(>|z|)    
#> (Intercept) -4.45312    0.23075 -19.299 <0.0000000000000002 ***
#> SEXMALE      0.04111    0.26376   0.156               0.876    
#> ---
#> Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
#> 
#> (Dispersion parameter for binomial family taken to be 1)
#> 
#>     Null deviance: 879.30  on 6823  degrees of freedom
#> Residual deviance: 879.28  on 6822  degrees of freedom
#> AIC: 883.28
#> 
#> Number of Fisher Scoring iterations: 7
```

# compare model with sex and null model

```r
lrt<-anova(model1,model2,test="LRT")
lrt
#> Analysis of Deviance Table
#> 
#> Model 1: STATUS ~ 1
#> Model 2: STATUS ~ SEX
#>   Resid. Df Resid. Dev Df Deviance Pr(>Chi)
#> 1      6823     879.30                     
#> 2      6822     879.28  1 0.024461   0.8757
```

# model with marital status

```r
model3<-glm(STATUS ~ `Marital Status`,data=df,family=binomial)
summary(model3)
#> 
#> Call:
#> glm(formula = STATUS ~ `Marital Status`, family = binomial, data = df)
#> 
#> Deviance Residuals: 
#>     Min       1Q   Median       3Q      Max  
#> -0.2801  -0.1671  -0.1671  -0.1524   3.6591  
#> 
#> Coefficients:
#>                         Estimate Std. Error z value Pr(>|z|)   
#> (Intercept)               -3.219      1.020  -3.156   0.0016 **
#> `Marital Status`Engaged  -13.347    550.494  -0.024   0.9807   
#> `Marital Status`Married   -1.045      1.028  -1.017   0.3093   
#> `Marital Status`Other     -3.474      1.429  -2.432   0.0150 * 
#> `Marital Status`Single    -1.231      1.046  -1.177   0.2392   
#> ---
#> Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
#> 
#> (Dispersion parameter for binomial family taken to be 1)
#> 
#>     Null deviance: 879.3  on 6823  degrees of freedom
#> Residual deviance: 863.7  on 6819  degrees of freedom
#> AIC: 873.7
#> 
#> Number of Fisher Scoring iterations: 15
```

# compare null model with marital status model

```r
LRT1<-anova(model3,model1,test="LRT")
LRT1
#> Analysis of Deviance Table
#> 
#> Model 1: STATUS ~ `Marital Status`
#> Model 2: STATUS ~ 1
#>   Resid. Df Resid. Dev Df Deviance Pr(>Chi)   
#> 1      6819      863.7                        
#> 2      6823      879.3 -4  -15.607 0.003594 **
#> ---
#> Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

# add exposure to marital status model

```r
model5<-glm(STATUS ~ `RTGS EXPOSURE`+ `Marital Status`,data=df,family=binomial)

summary(model5)
#> 
#> Call:
#> glm(formula = STATUS ~ `RTGS EXPOSURE` + `Marital Status`, family = binomial, 
#>     data = df)
#> 
#> Deviance Residuals: 
#>     Min       1Q   Median       3Q      Max  
#> -0.4322  -0.1971  -0.1385  -0.0604   4.3944  
#> 
#> Coefficients:
#>                             Estimate   Std. Error z value     Pr(>|z|)    
#> (Intercept)              -1.83322889   1.04911419  -1.747       0.0806 .  
#> `RTGS EXPOSURE`          -0.00044324   0.00008176  -5.421 0.0000000591 ***
#> `Marital Status`Engaged -13.08076745 523.70290688  -0.025       0.9801    
#> `Marital Status`Married  -0.99006551   1.03683577  -0.955       0.3396    
#> `Marital Status`Other    -2.34733702   1.43846067  -1.632       0.1027    
#> `Marital Status`Single   -1.24715662   1.05437281  -1.183       0.2369    
#> ---
#> Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
#> 
#> (Dispersion parameter for binomial family taken to be 1)
#> 
#>     Null deviance: 879.30  on 6823  degrees of freedom
#> Residual deviance: 808.63  on 6818  degrees of freedom
#> AIC: 820.63
#> 
#> Number of Fisher Scoring iterations: 15
```

# compare model with marital status to the one with both

```r
LRT1<-anova(model3,model5,test="LRT")
LRT1
#> Analysis of Deviance Table
#> 
#> Model 1: STATUS ~ `Marital Status`
#> Model 2: STATUS ~ `RTGS EXPOSURE` + `Marital Status`
#>   Resid. Df Resid. Dev Df Deviance           Pr(>Chi)    
#> 1      6819     863.70                                   
#> 2      6818     808.63  1   55.066 0.0000000000001165 ***
#> ---
#> Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

# compare marital status model with model containing both

```r
model6<-glm(STATUS ~ `RTGS EXPOSURE`+`Marital Status`+`Age Group`,data=df,family=binomial)
summary(model6)
#> 
#> Call:
#> glm(formula = STATUS ~ `RTGS EXPOSURE` + `Marital Status` + `Age Group`, 
#>     family = binomial, data = df)
#> 
#> Deviance Residuals: 
#>     Min       1Q   Median       3Q      Max  
#> -0.4571  -0.1922  -0.1358  -0.0597   4.4447  
#> 
#> Coefficients:
#>                              Estimate    Std. Error z value     Pr(>|z|)    
#> (Intercept)               -2.42151338    1.20818555  -2.004        0.045 *  
#> `RTGS EXPOSURE`           -0.00044330    0.00008117  -5.461 0.0000000473 ***
#> `Marital Status`Engaged  -12.98152086  522.77176953  -0.025        0.980    
#> `Marital Status`Married   -0.88891522    1.03938005  -0.855        0.392    
#> `Marital Status`Other     -2.24263515    1.44042494  -1.557        0.119    
#> `Marital Status`Single    -1.04409472    1.06031177  -0.985        0.325    
#> `Age Group`30-39           0.26597436    0.61648455   0.431        0.666    
#> `Age Group`40-49           0.70606674    0.61702931   1.144        0.252    
#> `Age Group`50-59           0.40749938    0.66032219   0.617        0.537    
#> `Age Group`60-69           0.85164136    0.78032359   1.091        0.275    
#> `Age Group`70+           -11.67148243 1634.65825214  -0.007        0.994    
#> ---
#> Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
#> 
#> (Dispersion parameter for binomial family taken to be 1)
#> 
#>     Null deviance: 879.30  on 6823  degrees of freedom
#> Residual deviance: 804.49  on 6813  degrees of freedom
#> AIC: 826.49
#> 
#> Number of Fisher Scoring iterations: 15
```
# compare model with marital status to the one with both

```r
LRT1<-anova(model5,model6,test="LRT")
LRT1
#> Analysis of Deviance Table
#> 
#> Model 1: STATUS ~ `RTGS EXPOSURE` + `Marital Status`
#> Model 2: STATUS ~ `RTGS EXPOSURE` + `Marital Status` + `Age Group`
#>   Resid. Df Resid. Dev Df Deviance Pr(>Chi)
#> 1      6818     808.63                     
#> 2      6813     804.49  5   4.1354   0.5301
```
- age group is insignificant so we remove it

# lets add Gross income

```r
model7<-glm(STATUS ~ `RTGS EXPOSURE`+`Marital Status` + `Gross Income` ,data=df,family=binomial)
summary(model7)
#> 
#> Call:
#> glm(formula = STATUS ~ `RTGS EXPOSURE` + `Marital Status` + `Gross Income`, 
#>     family = binomial, data = df)
#> 
#> Deviance Residuals: 
#>     Min       1Q   Median       3Q      Max  
#> -0.4207  -0.1971  -0.1374  -0.0558   4.1282  
#> 
#> Coefficients:
#>                             Estimate   Std. Error z value  Pr(>|z|)    
#> (Intercept)              -1.53001136   1.06871159  -1.432    0.1522    
#> `RTGS EXPOSURE`          -0.00036624   0.00009327  -3.927 0.0000861 ***
#> `Marital Status`Engaged -13.04375382 517.83889026  -0.025    0.9799    
#> `Marital Status`Married  -1.03211956   1.03805014  -0.994    0.3201    
#> `Marital Status`Other    -2.38777747   1.44020087  -1.658    0.0973 .  
#> `Marital Status`Single   -1.28721062   1.05555781  -1.219    0.2227    
#> `Gross Income`           -0.00070500   0.00046467  -1.517    0.1292    
#> ---
#> Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
#> 
#> (Dispersion parameter for binomial family taken to be 1)
#> 
#>     Null deviance: 879.30  on 6823  degrees of freedom
#> Residual deviance: 805.54  on 6817  degrees of freedom
#> AIC: 819.54
#> 
#> Number of Fisher Scoring iterations: 15
```

# compare model with gross income

```r
LRT1<-anova(model5,model7,test="LRT")
LRT1
#> Analysis of Deviance Table
#> 
#> Model 1: STATUS ~ `RTGS EXPOSURE` + `Marital Status`
#> Model 2: STATUS ~ `RTGS EXPOSURE` + `Marital Status` + `Gross Income`
#>   Resid. Df Resid. Dev Df Deviance Pr(>Chi)  
#> 1      6818     808.63                       
#> 2      6817     805.54  1   3.0858  0.07898 .
#> ---
#> Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```
- final model should include gross income apparently
- for sake of progress model with gross income is appropriate but we will use the one we used in the lecture
 
# final model according to lecture


```r
model7<-glm(STATUS ~ `RTGS EXPOSURE`+`Marital Status`,data=df,family=binomial)
summary(model7)
#> 
#> Call:
#> glm(formula = STATUS ~ `RTGS EXPOSURE` + `Marital Status`, family = binomial, 
#>     data = df)
#> 
#> Deviance Residuals: 
#>     Min       1Q   Median       3Q      Max  
#> -0.4322  -0.1971  -0.1385  -0.0604   4.3944  
#> 
#> Coefficients:
#>                             Estimate   Std. Error z value     Pr(>|z|)    
#> (Intercept)              -1.83322889   1.04911419  -1.747       0.0806 .  
#> `RTGS EXPOSURE`          -0.00044324   0.00008176  -5.421 0.0000000591 ***
#> `Marital Status`Engaged -13.08076745 523.70290688  -0.025       0.9801    
#> `Marital Status`Married  -0.99006551   1.03683577  -0.955       0.3396    
#> `Marital Status`Other    -2.34733702   1.43846067  -1.632       0.1027    
#> `Marital Status`Single   -1.24715662   1.05437281  -1.183       0.2369    
#> ---
#> Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
#> 
#> (Dispersion parameter for binomial family taken to be 1)
#> 
#>     Null deviance: 879.30  on 6823  degrees of freedom
#> Residual deviance: 808.63  on 6818  degrees of freedom
#> AIC: 820.63
#> 
#> Number of Fisher Scoring iterations: 15
```


# calculation of probabilities
`$$P_i=\frac{1}{1+e^-{(\beta_0+\sum^n_{i=1}\beta_iX_i)}}$$`
- e.g for client who is married with no information at the bank

```r
1/(1+exp(-1.83-13.08076))
#> [1] 0.9999997
```

# convert log odds to odds

```r
coef(model7) |> exp()
#>             (Intercept)         `RTGS EXPOSURE` `Marital Status`Engaged 
#>            1.598964e-01            9.995569e-01            2.084946e-06 
#> `Marital Status`Married   `Marital Status`Other  `Marital Status`Single 
#>            3.715523e-01            9.562347e-02            2.873206e-01
```

# reporting the model output

```r
report::report(model7)
#> We fitted a logistic model (estimated using ML) to predict STATUS with RTGS
#> EXPOSURE and Marital Status (formula: STATUS ~ `RTGS EXPOSURE` + `Marital
#> Status`). The model's explanatory power is very weak (Tjur's R2 = 0.02). The
#> model's intercept, corresponding to RTGS EXPOSURE = 0 and Marital Status =
#> Divorced, is at -1.83 (95% CI [-4.74, -0.19], p = 0.081). Within this model:
#> 
#>   - The effect of RTGS EXPOSURE is statistically significant and negative (beta =
#> -4.43e-04, 95% CI [-6.14e-04, -2.93e-04], p < .001; Std. beta = -7.49, 95% CI
#> [-10.37, -4.96])
#>   - The effect of Marital Status [Engaged] is statistically non-significant and
#> negative (beta = -13.08, 95% CI [-202.23, 6.27], p = 0.980; Std. beta = -13.08,
#> 95% CI [-202.23, 6.27])
#>   - The effect of Marital Status [Married] is statistically non-significant and
#> negative (beta = -0.99, 95% CI [-2.60, 1.91], p = 0.340; Std. beta = -0.99, 95%
#> CI [-2.60, 1.91])
#>   - The effect of Marital Status [Other] is statistically non-significant and
#> negative (beta = -2.35, 95% CI [-5.61, 0.91], p = 0.103; Std. beta = -2.35, 95%
#> CI [-5.61, 0.91])
#>   - The effect of Marital Status [Single] is statistically non-significant and
#> negative (beta = -1.25, 95% CI [-2.91, 1.67], p = 0.237; Std. beta = -1.25, 95%
#> CI [-2.91, 1.67])
#> 
#> Standardized parameters were obtained by fitting the model on a standardized
#> version of the dataset. 95% Confidence Intervals (CIs) and p-values were
#> computed using a Wald z-distribution approximation.
```


