---
title: "Survival Analysis"
author: "Bongani Ncube"
date: "2023-08-28"
slug: "survival-analysis"
categories: []
tags:
- kaplan meier
- cox
- event studies
subtitle: ''
summary: ''
authors: []
lastmod: "2023-08-28T00:26:48+02:00"
featured: no
image:
  caption: ''
  focal_point: ''
  preview_only: no
projects: []
---

<script src="{{< blogdown/postref >}}index.en_files/kePrint/kePrint.js"></script>

<link href="{{< blogdown/postref >}}index.en_files/lightable/lightable.css" rel="stylesheet" />

<script src="//yihui.org/js/math-code.js" defer></script>
<!-- Just one possible MathJax CDN below. You may use others. -->
<script defer
  src="//mathjax.rstudio.com/latest/MathJax.js?config=TeX-MML-AM_CHTML">
</script>

This presentation will cover some basics of survival analysis, and the
following series of tutorial papers can be helpful for additional
reading:

> Clark, T., Bradburn, M., Love, S., & Altman, D. (2003). Survival
> analysis part I: Basic concepts and first analyses. 232-238. ISSN
> 0007-0920.

> M J Bradburn, T G Clark, S B Love, & D G Altman. (2003). Survival
> Analysis Part II: Multivariate data analysis – an introduction to
> concepts and methods. British Journal of Cancer, 89(3), 431-436.

> Bradburn, M., Clark, T., Love, S., & Altman, D. (2003). Survival
> analysis Part III: Multivariate data analysis – choosing a model and
> assessing its adequacy and fit. 89(4), 605-11.

> Clark, T., Bradburn, M., Love, S., & Altman, D. (2003). Survival
> analysis part IV: Further concepts and methods in survival analysis.
> 781-786. ISSN 0007-0920.

# setup

In this section, we will use the following packages:

``` r
library(survival)
library(survminer)
library(lubridate)
library(ggsurvfit)
library(gtsummary)
#library(tidycmprsk)
#library(condsurv)
library(tidyverse)
```

# basic Definitions in survival analysis

- **Survival analysis** lets you analyze the rates of occurrence of
  events over time, without assuming the rates are constant.
  Generally, survival analysis lets you model the *time until an event
  occurs*,[^1] or compare the time-to-event between different groups,
  or how time-to-event correlates with quantitative variables.

# Special features of survival data😝

- Survival times are generally not symmetrically distributed. Usually
  the data is positively skewed and it will be unreasonable to assume
  that of this type have a normal distribution. However data can be
  transformed to give a more symmetric distribution.
- Survival times are frequently censored. The survival time of an
  individual is said to be censored when the end-point of interest has
  not been observed for that individual.

# Example of the distribution of follow-up times according to event status:

<div class="columns">

<div class="column">

``` r
library(paletteer)
dft<-ggplot(lung, aes(x = time, fill = factor(status))) +
  geom_histogram(bins = 25, alpha = 0.5, position = "identity") +
  scale_fill_manual(values = paletteer_c("ggthemes::Blue", 3), 
                    labels = c("Censored", "Dead")) +
  
  labs(x = "Days",
       y = "Count")
```

</div>

<div class="column">

``` r
dft
```

<img src="{{< blogdown/postref >}}index.en_files/figure-html/unnamed-chunk-2-1.png" width="1023.999552" />

</div>

</div>

# 

## 

- **Censoring** is a type of missing data problem unique to survival
  analysis. This happens when you track the sample/subject through the
  end of the study and the event never occurs. This could also happen
  due to the sample/subject dropping out of the study for reasons
  other than death, or some other loss to followup. The sample is
  *censored* in that you only know that the individual survived up to
  the loss to followup, but you don’t know anything about survival
  after that.\[^censoring\]

# A subject may be censored due to:

- Loss to follow-up
- Withdrawal from study
- No event by end of fixed study period

Specifically these are examples of **right** censoring. Left censoring
and interval censoring are also possible, and methods exist to analyze
these types of data, but this tutorial will be focus on right censoring.

# illustrating the impact of censoring:

<div class="columns">

<div class="column">

``` r
# make fake data
fkdt <- tibble(Subject = as.factor(1:10), 
              Years = sample(4:20, 10, replace = T),
              censor = sample(c("Censor", rep("Event", 2)), 10, 
              replace = T)) 

# plot with shapes to indicate censoring or event
p<-ggplot(fkdt, aes(Subject, Years)) + 
    geom_bar(stat = "identity", width = 0.5) + 
    geom_point(data = fkdt, 
               aes(Subject, Years, 
                   color = censor, shape = censor), 
               size = 6) +
    coord_flip() +
    theme_minimal() + 
    theme(legend.title = element_blank(),
          legend.position = "bottom")
```

</div>

<div class="column">

``` r
p
```

<img src="{{< blogdown/postref >}}index.en_files/figure-html/unnamed-chunk-3-1.png" width="1023.999552" />

</div>

</div>

# whats happening

- Subjects 6 and 7 were **event-free at 10 years**.
- Subjects 2, 9, and 10 had the **event before 10 years**.
- Subjects 1, 3, 4, 5, and 8 were **censored before 10 years**, so we
  don’t know whether they had the event or not at 10 years. But we
  know something about them - that they were each followed for a
  certain amount of time without the event of interest prior to being
  censored.

# 

## types of censoring

- If the individual was last known to be alive at time `\(t_0 + C\)`, the
  time c is called a censored survival time. This censoring occurs
  after the individual has been entered into a study, that is, to the
  right of the last known survival time, and is therefore known as
  *right censoring*. The right-censored survival time is then less
  than the actual, but unknown, survival time.

- which is encountered when the actual survival time of an individual
  is less than that observed. To illustrate this form of censoring,
  consider a study in which interest centres on the time to recurrence
  of a particular cancer following surgical removal of the primary
  tumour. Three months after their operation, the patients are
  examined to determine if the cancer has recurred. At this time, some
  of the patients may be found to have a recurrence. For such
  patients, the actual time to recurrence is less than three months,

*Survival analysis techniques provide a way to appropriately account for
censored patients in the analysis.*

# Survivor and hazard functions

- The **hazard** is the instantaneous event (death) rate at a
  particular time point *t*. Survival analysis doesn’t assume the
  hazard is constant over time. The *cumulative hazard* is the total
  hazard experienced up to time *t*.

- The **survival function**, is the probability an individual survives
  (or, the probability that the event of interest does not occur) up
  to and including time *t*. It’s the probability that the event
  (e.g., death) hasn’t occured yet. It looks like this, where `\(T\)` is
  the time of death, and `\(Pr(T>t)\)` is the probability that the time of
  death is greater than some time `\(t\)`. `\(S\)` is a probability, so
  `\(0 \leq S(t) \leq 1\)`, since survival times are always positive
  ($T \geq 0$). \> probability that an individual survives beyond any
  given time

$$ S(t) = Pr(T>t) $$

# Survival function

Survival analysis typically involves using T as the response variable,
as it represents the time till an outcome occurs, while t refers to the
actual survival time of an individual. The distribution function F(t) is
used to describe chances of time of survival being less than a given
value, t. In some cases, the cumulative distribution function is of
interest and can be obtained as follows: Interest also tends to focus on the survival or
survivorship function which in this study is the chances of a neonate
surviving after time `\(t\)` and also given by the formula

`\(S(t)\)` monotonically decreasing function with `\(S(0) = 1\)` and
`\(S(\infty) = \text{lim}_{t \rightarrow \infty} S(t) = 0\)`.

# Hazard function

Suppose we have `\(R (t)\)` (set at risk) that has neonates who are prone to
dying by time t, the chances of a neonate in that set to die in a given
interval `\([t, t + \delta t)\)` is given by the following forrmula, where
`\(h(t)\)` is the hazard rate and is defined as:

`$$h(t)  = \lim_{\delta t \rightarrow 0} \frac{P(t \le T <  t+\delta t | T \ge t)}{\delta t}$$`
The hazard function’s shape can be any strictly positive function and it
changes based on the specific survival data provided.

# Relationship between h(t) and S(t)

we know that `\(f(t) = - \frac{d}{dt} S(t)\)` hence equation simplifies to

$$
h(t)=\frac{f(t)}{S(t)} =\frac{- \frac{d}{dt} S(t)}{S(t)}= - \frac{d}{dt} [\log S(t)] $$

Taking intergrals both sides the above reduces to: `$$H(t)= -\log S(t)$$`

where `\(H(t)=\int_{t}^{t} h(u) du\)` ,is the cumulative risk of a neonate
dying by time t. Since the event is death, then H(t) summarises the risk
of death up to time t, assuming that death has not occurred before t.
The survival function is also approximately simplified as follows.
$$ S(t) = e^{-H(t)} \approx 1 -H(t) \text{ when H(t) is small. }$$

# Kaplan-Meier estimate

If there are `\(r\)` times of deaths among neonates in ICU, such that
`\(r\leq n\)` and `\(n\)` is the number of neonates with observed survival
times. Arranging these times in from the smallest to the largest,the
`\(j\)`-th death time is noted by `\(t_{(j)}\)` , for `\(j = 1, 2, \cdots , r\)`,
such that the `\(r\)` death times ordred are
$$ t_{1}<t_{2}< \cdots < t_{m}$$ .

Let `\(n_j\)`, for `\(j = 1, 2, \ldots, r\)`, denote the number of neonates who
are still alive before time `\(t(j)\)`, including the ones that are expected
to die at that time. Additionally, let `\(d_j\)` denote the number of
neonates who die at time `\(t(j)\)`. The estimate for the product limit can
be expressed in the following form:

# 

## 

To survive until time `\(t\)`, a neonate must start by surviving till
`\(t(1)\)`, and then continue to survive until each subsequent time point
`\(t(2), \ldots, t(r)\)`. It is assumed that there are no deaths between two
consecutive time points `\(t(j-1)\)` and `\(t(j)\)`. The conditional probability
of surviving at time `\(t(i)\)`, given that the neonate has managed to
survive up to `\(t(i-1)\)`, is the complement of the proportion of the new
born babies who die at time `\(t(i)\)`, denoted by `\(d_i\)`, to the new born
babies who are alive just before `\(t(i)\)`, denoted by `\(n_i\)`. Therefore,
the probability that is conditional of surviving at time `\(t(i)\)` is given
by `\(1 - \frac{d_i}{n_i}\)`.

# 

The variance of the estimator is given by The corresponding standard deviation is therefore given
by:

The **Kaplan-Meier** curve illustrates the survival function. It’s a
step function illustrating the cumulative survival probability over
time. The curve is horizontal over periods where no event occurs, then
drops vertically corresponding to a change in the survival function at
each time an event occurs.

# Log rank test

Given the problem of contrasting two or more survival functions,for
instance survival times between male and female neonates in the ICU. Let
$$ t_{1}<t_{2}< \cdots < t_{r}$$

Let `\(t_i\)` be the unique times of death observed among the neonates,
found by joining all groups of interest. For group `\(j\)`,\\ let `\(d_{ij}\)`
denote the number of deaths at time `\(t_i\)`, and\\ let `\(n_{ij}\)` denote the
number at risk at time `\(t_i\)` in that group. Let `\(d_i\)` denote the total
number of deaths at time `\(t_i\)` across all groups, and\\

# 

the expected number of deaths in group `\(j\)` at time `\(t_i\)` is: ,

$$E(d_{ij}) = \frac{n_{ij} \, d_i}{n_i} = n_{ij} \left(\frac{d_i}{n_i}\right) $$

At time `\(t_i\)`, suppose there are `\(d_i\)` deaths and `\(n_i\)` individuals at
risk in total, with `\(d_{i0}\)` and `\(d_{i1}\)` deaths and `\(n_{i0}\)` and
`\(n_{i1}\)` individuals at risk in groups 0 and 1, respectively, such that
`\(d_{i0} + d_{i1} = d_i\)` and `\(n_{i0} + n_{i1} = n_i\)`. Such data can be
summarized in a `\(2 \times 2\)` table at each death time `\(t_i\)`.

# 

# 

Given that the null hypothesis is true, the number of deaths is expected
to follow the hypergeometric distribution, and therefore:

the statistic `\(U_L\)` is given by
`$$U_L=\sum^r_{i=1}(d_{i0}-e_{i0})$$` so that the variance of `\(U_L\)` is
`$$Var(U_L)=\sum^r_{j=1}v_{i0}=V_L$$` which then follows that :
`$$\frac{U_L}{\sqrt{V_L}} \sim N(0,1)$$` and squaring results in
`$$\frac{U^2_L}{V_L}\sim \chi^2_1$$`

# 

# Regression models in Survival analysis

## Cox’s Proportional Hazards

The model is semi-parametric in nature since no assumption about a
probabilty distribution is made for the survival times. The baseline
model can take any form and the covariate enter the model linearly
(Fox,2008). The model can thus be represented as :

In the above equation, `\(h_0(t)\)` is known as the baseline
hazard function, which represents the hazard function for a neonate when
all the included variables in the model are zero. On the other hand,
`\(h(t|X)\)` represents the hazard of a neonate at time `\(t\)` with a covariate
vector `\(X=(x_1,x_2,\ldots,x_p)\)` and
`\(\beta^T=(\beta_1,\beta_2,\ldots,\beta_p)\)` is a vector of regression
coefficients.

# Fitting a proportional hazards model

## The partial likelihood

Given that `\(t(1) < t(2) < \ldots < t(r)\)` denote the `\(r\)` ordered death
times. The partial likelihood is given by :

Maximising the logarithmic of the likelihood
function is more easier and computationally efficient and this is
generally given by:

# Residuals for Cox Regression Model

Six types of residuals are studied in this thesis: Cox-Snell, Modified
Cox-Snell, Schoenfeld, Martingale, Deviance, and Score residuals.

## Cox-Snell Residuals

Cox-Snell definition of residuals given by Cox and Snell (1968) is the
most common residual in survival analysis. The Cox-Snell residual for
the `\(ith\)` individual, `\(i = 1, 2, \cdots , n\)`, is given by

where `\(\hat{H}_0(t_i)\)` is an estimate of the baseline
cumulative hazard function at time `\(t_i\)`. It is sometimes called the
Nelson-Aalen estimator.

# Martingale residuals

These are useful in determing the functional form of the covariates to
be included in the model. If the test reveals that the covariate can not
be included linearly then there is need for such a covariate to be
transformed . The martingale residuals are represented in the following
form

# Deviance Residuals

The skew range of Martingale residual makes it difficult to use it to
detect outliers. The deviance residuals are much more symmetrically
distributed about zero and are defined by

Here, `\(r_{Mi}\)` represents the martingale residual for the
`\(i\)`-th individual, and the function `\(\text{sgn}(\cdot)\)` denotes the sign
function. Specifically, the function takes the value +1 if its argument
is positive and -1 if negative.

# Schoenfield residuals

Schoenfeld residuals are a useful tool for examining and testing the
proportional hazard assumption, detecting leverage points, and
identifying outliers. They can be calculated as follows:
where `\(x_{ji}\)` is the value of the `\(jth\)` explanatory
variable,$j = 1, 2, \cdots , p$, for the `\(ith\)` individual in the study,

# doing survival analysis in R

## functions

The core functions we’ll use out of the survival package include:

- `Surv()`: Creates a survival object.
- `survfit()`: Fits a survival curve using either a formula, of from a previously fitted Cox model.
- `coxph()`: Fits a Cox proportional hazards regression model.

Other optional functions you might use include:

- `cox.zph()`: Tests the proportional hazards assumption of a Cox regression model.
- `survdiff()`: Tests for differences in survival between two groups using a log-rank / Mantel-Haenszel test.[^2]

`Surv()` creates the response variable, and typical usage takes the time to event,\[^time2\] and whether or not the event occured (i.e., death vs censored). `survfit()` creates a survival curve that you could then display or plot. `coxph()` implements the regression analysis, and models specified the same way as in regular linear models, but using the `coxph()` function.

# Data description

- status : event at discharge (alive or dead)  
- sex : male or female  
- dm : diabetes (yes or no)  
- gcs : Glasgow Coma Scale (value from 3 to 15)  
- sbp : Systolic blood pressure (mmHg)  
- dbp : Diastolic blood pressure (mmHg)  
- wbc : Total white cell count  
- time2 : days in ward  
- stroke_type : stroke type (Ischaemic stroke or Haemorrhagic stroke)  
- referral_from : patient was referred from a hospital or not from a hospital

# setup

``` r
# load in packages
library(tidyverse)
library(haven)
library(rms)
library(broom)
library(survival)
library(survminer)
library(data.table)
library(DT)

stroke <- read_csv('stroke_data.csv')
```

# take a look at the dataset

``` r
kableExtra::kbl(head(stroke))
```

<table>
<thead>
<tr>
<th style="text-align:left;">
doa
</th>
<th style="text-align:left;">
dod
</th>
<th style="text-align:left;">
status
</th>
<th style="text-align:left;">
sex
</th>
<th style="text-align:left;">
dm
</th>
<th style="text-align:right;">
gcs
</th>
<th style="text-align:right;">
sbp
</th>
<th style="text-align:right;">
dbp
</th>
<th style="text-align:right;">
wbc
</th>
<th style="text-align:right;">
time2
</th>
<th style="text-align:left;">
stroke_type
</th>
<th style="text-align:left;">
referral_from
</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align:left;">
17/2/2011
</td>
<td style="text-align:left;">
18/2/2011
</td>
<td style="text-align:left;">
alive
</td>
<td style="text-align:left;">
male
</td>
<td style="text-align:left;">
no
</td>
<td style="text-align:right;">
15
</td>
<td style="text-align:right;">
151
</td>
<td style="text-align:right;">
73
</td>
<td style="text-align:right;">
12.5
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:left;">
IS
</td>
<td style="text-align:left;">
non-hospital
</td>
</tr>
<tr>
<td style="text-align:left;">
20/3/2011
</td>
<td style="text-align:left;">
21/3/2011
</td>
<td style="text-align:left;">
alive
</td>
<td style="text-align:left;">
male
</td>
<td style="text-align:left;">
no
</td>
<td style="text-align:right;">
15
</td>
<td style="text-align:right;">
196
</td>
<td style="text-align:right;">
123
</td>
<td style="text-align:right;">
8.1
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:left;">
IS
</td>
<td style="text-align:left;">
non-hospital
</td>
</tr>
<tr>
<td style="text-align:left;">
9/4/2011
</td>
<td style="text-align:left;">
10/4/2011
</td>
<td style="text-align:left;">
dead
</td>
<td style="text-align:left;">
female
</td>
<td style="text-align:left;">
no
</td>
<td style="text-align:right;">
11
</td>
<td style="text-align:right;">
126
</td>
<td style="text-align:right;">
78
</td>
<td style="text-align:right;">
15.3
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:left;">
HS
</td>
<td style="text-align:left;">
hospital
</td>
</tr>
<tr>
<td style="text-align:left;">
12/4/2011
</td>
<td style="text-align:left;">
13/4/2011
</td>
<td style="text-align:left;">
dead
</td>
<td style="text-align:left;">
male
</td>
<td style="text-align:left;">
no
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:right;">
170
</td>
<td style="text-align:right;">
103
</td>
<td style="text-align:right;">
13.9
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:left;">
IS
</td>
<td style="text-align:left;">
hospital
</td>
</tr>
<tr>
<td style="text-align:left;">
12/4/2011
</td>
<td style="text-align:left;">
13/4/2011
</td>
<td style="text-align:left;">
alive
</td>
<td style="text-align:left;">
female
</td>
<td style="text-align:left;">
yes
</td>
<td style="text-align:right;">
15
</td>
<td style="text-align:right;">
103
</td>
<td style="text-align:right;">
62
</td>
<td style="text-align:right;">
14.7
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:left;">
IS
</td>
<td style="text-align:left;">
non-hospital
</td>
</tr>
<tr>
<td style="text-align:left;">
4/5/2011
</td>
<td style="text-align:left;">
5/5/2011
</td>
<td style="text-align:left;">
dead
</td>
<td style="text-align:left;">
female
</td>
<td style="text-align:left;">
no
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:right;">
91
</td>
<td style="text-align:right;">
55
</td>
<td style="text-align:right;">
14.2
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:left;">
HS
</td>
<td style="text-align:left;">
hospital
</td>
</tr>
</tbody>
</table>

# The survival probabilities for all patients:

``` r
>KM <- survfit(Surv(time = time2,event = status == "dead" ) ~ 1, 
              data = stroke)
>summary(KM)
Call: survfit(formula = Surv(time = time2, event = status == "dead") ~ 
    1, data = stroke)

 time n.risk n.event survival std.err lower 95% CI upper 95% CI
    1    213       9    0.958  0.0138       0.9311        0.985
    2    190       4    0.938  0.0168       0.9053        0.971
    3    166       4    0.915  0.0198       0.8770        0.955
    4    130       4    0.887  0.0237       0.8416        0.934
    5     90       5    0.838  0.0310       0.7790        0.901
    6     65       3    0.799  0.0367       0.7301        0.874
    7     56       4    0.742  0.0438       0.6608        0.833
    9     42       1    0.724  0.0462       0.6391        0.821
   10     37       1    0.705  0.0489       0.6150        0.807
   12     33       4    0.619  0.0587       0.5142        0.746
   14     24       2    0.568  0.0642       0.4548        0.708
   18     19       1    0.538  0.0674       0.4206        0.687
   22     15       1    0.502  0.0718       0.3792        0.664
   25      9       2    0.390  0.0892       0.2494        0.611
   28      5       1    0.312  0.0998       0.1669        0.584
   29      4       1    0.234  0.1009       0.1007        0.545
   41      2       1    0.117  0.0970       0.0231        0.593
```

# Next, we will estimate the survival probabilities for stroke type:

``` r
>KM_str_type2 <- survfit(Surv(time = time2, 
                             event = status == "dead" ) ~ stroke_type, 
                        data = stroke)
>summary(KM_str_type2)

Call: survfit(formula = Surv(time = time2, event = status == "dead") ~ 
    stroke_type, data = stroke)

                stroke_type=HS 
 time n.risk n.event survival std.err lower 95% CI upper 95% CI
    1     69       6    0.913  0.0339       0.8489        0.982
    2     61       1    0.898  0.0365       0.8293        0.973
    3     58       4    0.836  0.0453       0.7520        0.930
    4     52       2    0.804  0.0489       0.7136        0.906
    5     47       4    0.736  0.0554       0.6346        0.853
    6     38       2    0.697  0.0589       0.5905        0.822
    7     34       2    0.656  0.0621       0.5447        0.790
    9     30       1    0.634  0.0638       0.5205        0.772
   10     27       1    0.611  0.0656       0.4945        0.754
   12     24       2    0.560  0.0693       0.4390        0.713
   14     19       1    0.530  0.0717       0.4068        0.691
   18     15       1    0.495  0.0751       0.3675        0.666
   22     11       1    0.450  0.0806       0.3166        0.639
   25      6       2    0.300  0.1019       0.1541        0.584
   29      2       1    0.150  0.1176       0.0322        0.698
```

# 

``` r
stroke_type=IS 
 time n.risk n.event survival std.err lower 95% CI upper 95% CI
    1    144       3    0.979  0.0119        0.956        1.000
    2    129       3    0.956  0.0174        0.923        0.991
    4     78       2    0.932  0.0241        0.886        0.980
    5     43       1    0.910  0.0318        0.850        0.975
    6     27       1    0.876  0.0451        0.792        0.970
    7     22       2    0.797  0.0676        0.675        0.941
   12      9       2    0.620  0.1223        0.421        0.912
   14      5       1    0.496  0.1479        0.276        0.890
   28      3       1    0.331  0.1671        0.123        0.890
   41      1       1    0.000     NaN           NA           NA
```

## Plot the survival probability

The KM estimate provides the survival probabilities. We can plot these probabilities to look at the trend of survival over time. The plot provides

1.  survival probability on the `\(y-axis\)`
2.  time on the `\(x-axis\)`

``` r
library(paletteer)
p1<-ggsurvplot(KM_str_type2, 
           data = stroke,
           palette = paletteer_d("ggsci::light_blue_material")[seq(2,10,2)], 
                 size = 1.2, conf.int = FALSE, 
                 legend.labs = levels(stroke$stroke_type),
                 legend.title = "",
                 ggtheme = theme_minimal() + 
             theme(plot.title = element_text(face = "bold")),
                 title = "Probability of dying",
                 xlab = "Time",
                 ylab = "Probability of dying",
                 legend = "bottom", censor = FALSE)

p1$plot +
  scale_x_continuous(expand = c(0, 0), breaks = seq(1,43,1),
                     labels = seq(1,43,1),
                     limits = c(0, 820)) +
  scale_y_continuous(expand = c(0, 0), breaks = seq(0,1,0.2),
                     labels = scales::percent_format(accuracy = 1)) +
  theme_classic() +
  tvthemes::theme_avatar()+
  theme(legend.position = c(0.9,0.8),
        legend.background = element_blank(),
        plot.title = element_text(face = "bold"),
        panel.grid.major = element_line(size = .2, colour = "grey90"),
        panel.grid.minor = element_line(size = .2, colour = "grey90"))
```

<img src="{{< blogdown/postref >}}index.en_files/figure-html/unnamed-chunk-10-1.png" width="1023.999552" />

We can perform the Kaplan-Meier estimates for variable dm too:

``` r
KM_dm <- survfit(Surv(time = time2, 
                      event = status == "dead" ) ~ dm,
                 data = stroke)
summary(KM_dm)
#> Call: survfit(formula = Surv(time = time2, event = status == "dead") ~ 
#>     dm, data = stroke)
#> 
#>                 dm=no 
#>  time n.risk n.event survival std.err lower 95% CI upper 95% CI
#>     1    141       8    0.943  0.0195       0.9058        0.982
#>     2    122       4    0.912  0.0242       0.8661        0.961
#>     3    102       2    0.894  0.0268       0.8434        0.949
#>     4     82       2    0.873  0.0303       0.8152        0.934
#>     5     54       5    0.792  0.0441       0.7100        0.883
#>     6     40       3    0.732  0.0524       0.6366        0.843
#>     7     34       2    0.689  0.0575       0.5854        0.812
#>    10     24       1    0.661  0.0619       0.5498        0.794
#>    12     20       4    0.529  0.0771       0.3971        0.703
#>    18     13       1    0.488  0.0812       0.3521        0.676
#>    22      9       1    0.434  0.0884       0.2908        0.647
#>    25      4       1    0.325  0.1149       0.1627        0.650
#>    29      3       1    0.217  0.1171       0.0752        0.625
#> 
#>                 dm=yes 
#>  time n.risk n.event survival std.err lower 95% CI upper 95% CI
#>     1     72       1    0.986  0.0138       0.9594        1.000
#>     3     64       2    0.955  0.0253       0.9070        1.000
#>     4     48       2    0.915  0.0367       0.8463        0.990
#>     7     22       2    0.832  0.0653       0.7137        0.971
#>     9     15       1    0.777  0.0811       0.6330        0.953
#>    14      9       2    0.604  0.1248       0.4030        0.906
#>    25      5       1    0.483  0.1471       0.2662        0.878
#>    28      2       1    0.242  0.1860       0.0534        1.000
#>    41      1       1    0.000     NaN           NA           NA
```

And then we can plot the survival estimates for patients with and without diabetes:

``` r
p2<-ggsurvplot(KM_dm, 
           data = stroke, 
                 palette = paletteer_c("grDevices::Set 2", 12), 
                 size = 1.2, conf.int = FALSE,
                 legend.labs = levels(stroke$dm),
                 legend.title = "",
                 ggtheme = theme_minimal() + 
             theme(plot.title = element_text(face = "bold")),
                 title = "Probability of dying",
                 xlab = "Time till discharge",
                 ylab = "Probability of dying",
                 legend = "bottom", censor = FALSE)

p2$plot+
  tvthemes::theme_avatar()
```

<img src="{{< blogdown/postref >}}index.en_files/figure-html/unnamed-chunk-12-1.png" width="1023.999552" />

- Typically we will also want to see the numbers at risk in a table below
  the x-axis. We can add this using `add_risktable()`:

::: columns
::: column

``` r
library(ggsurvfit)
survfit2(Surv(time = time2,event = status == "dead" ) ~ dm, data = stroke) %>% 
  ggsurvfit() +
  labs(
    x = "Days",
    y = "Overall survival probability"
    ) + 
  add_confidence_interval() +
  add_risktable()
```

<img src="{{< blogdown/postref >}}index.en_files/figure-html/unnamed-chunk-13-1.png" width="1023.999552" />
:::

# Comparing Kaplan-Meier estimates across groups

There are a number of available tests to compare the survival estimates between groups based on KM. The tests include:

1.  log-rank (default)
2.  peto-peto test

### Log-rank test

to answer question if the survival estimates are different between levels or groups we can use statistical tests for example the log rank and the peto-peto tests.

For all the test, the null hypothesis is that that the survival estimates between levels or groups are not different. For example, to do that:

# 

``` r
>survdiff(Surv(time = time2, 
              event = status == "dead") ~ stroke_type, 
         data = stroke,
         rho = 0)
Call:
survdiff(formula = Surv(time = time2, event = status == "dead") ~ 
    stroke_type, data = stroke, rho = 0)

                 N Observed Expected (O-E)^2/E (O-E)^2/V
stroke_type=HS  69       31     24.2      1.92      4.51
stroke_type=IS 144       17     23.8      1.95      4.51

 Chisq= 4.5  on 1 degrees of freedom, p= 0.03 
```

> The survival estimates between the stroke types (*IS* vs *HS* groups) are different at the level of `\(5\%\)` significance (p-value = 0.03).

# *And for the survival estimates based on diabetes status:*

``` r
>survdiff(Surv(time = time2, 
              event = status == "dead") ~ dm, 
         data = stroke,
         rho = 0)
Call:
survdiff(formula = Surv(time = time2, event = status == "dead") ~ 
    dm, data = stroke, rho = 0)

         N Observed Expected (O-E)^2/E (O-E)^2/V
dm=no  141       35     29.8     0.919      2.54
dm=yes  72       13     18.2     1.500      2.54

 Chisq= 2.5  on 1 degrees of freedom, p= 0.1 
```

The survival estimates between patients with and without diabetes (dm status *yes* vs *no* groups) are not different (p-value = 0.1).

::: columns
::: column

# tables in survival analysis

We can produce nice tables of `\(x\)`-time survival probability estimates
using the `tbl_survfit()` function from the {gtsummary} package:

``` r
library(gtsummary)
survfit(Surv(time = time2, 
              event = status == "dead") ~ dm, 
         data = stroke) %>% 
  tbl_survfit(
    times = 43,
    label_header = "**43-days survival (95% CI)**"
  )
```

<div id="trygohuykz" style="padding-left:0px;padding-right:0px;padding-top:10px;padding-bottom:10px;overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<style>html {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Helvetica Neue', 'Fira Sans', 'Droid Sans', Arial, sans-serif;
}

#trygohuykz .gt_table {
  display: table;
  border-collapse: collapse;
  margin-left: auto;
  margin-right: auto;
  color: #333333;
  font-size: 16px;
  font-weight: normal;
  font-style: normal;
  background-color: #FFFFFF;
  width: auto;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #A8A8A8;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #A8A8A8;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
}

#trygohuykz .gt_heading {
  background-color: #FFFFFF;
  text-align: center;
  border-bottom-color: #FFFFFF;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#trygohuykz .gt_caption {
  padding-top: 4px;
  padding-bottom: 4px;
}

#trygohuykz .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#trygohuykz .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 0;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#trygohuykz .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#trygohuykz .gt_col_headings {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#trygohuykz .gt_col_heading {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  overflow-x: hidden;
}

#trygohuykz .gt_column_spanner_outer {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  padding-top: 0;
  padding-bottom: 0;
  padding-left: 4px;
  padding-right: 4px;
}

#trygohuykz .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#trygohuykz .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#trygohuykz .gt_column_spanner {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 5px;
  overflow-x: hidden;
  display: inline-block;
  width: 100%;
}

#trygohuykz .gt_group_heading {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  text-align: left;
}

#trygohuykz .gt_empty_group_heading {
  padding: 0.5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: middle;
}

#trygohuykz .gt_from_md > :first-child {
  margin-top: 0;
}

#trygohuykz .gt_from_md > :last-child {
  margin-bottom: 0;
}

#trygohuykz .gt_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  margin: 10px;
  border-top-style: solid;
  border-top-width: 1px;
  border-top-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  overflow-x: hidden;
}

#trygohuykz .gt_stub {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
}

#trygohuykz .gt_stub_row_group {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
  vertical-align: top;
}

#trygohuykz .gt_row_group_first td {
  border-top-width: 2px;
}

#trygohuykz .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#trygohuykz .gt_first_summary_row {
  border-top-style: solid;
  border-top-color: #D3D3D3;
}

#trygohuykz .gt_first_summary_row.thick {
  border-top-width: 2px;
}

#trygohuykz .gt_last_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#trygohuykz .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#trygohuykz .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#trygohuykz .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#trygohuykz .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#trygohuykz .gt_footnotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#trygohuykz .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding-left: 4px;
  padding-right: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#trygohuykz .gt_sourcenotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#trygohuykz .gt_sourcenote {
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#trygohuykz .gt_left {
  text-align: left;
}

#trygohuykz .gt_center {
  text-align: center;
}

#trygohuykz .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#trygohuykz .gt_font_normal {
  font-weight: normal;
}

#trygohuykz .gt_font_bold {
  font-weight: bold;
}

#trygohuykz .gt_font_italic {
  font-style: italic;
}

#trygohuykz .gt_super {
  font-size: 65%;
}

#trygohuykz .gt_footnote_marks {
  font-style: italic;
  font-weight: normal;
  font-size: 75%;
  vertical-align: 0.4em;
}

#trygohuykz .gt_asterisk {
  font-size: 100%;
  vertical-align: 0;
}

#trygohuykz .gt_indent_1 {
  text-indent: 5px;
}

#trygohuykz .gt_indent_2 {
  text-indent: 10px;
}

#trygohuykz .gt_indent_3 {
  text-indent: 15px;
}

#trygohuykz .gt_indent_4 {
  text-indent: 20px;
}

#trygohuykz .gt_indent_5 {
  text-indent: 25px;
}
</style>
<table class="gt_table">
  
  <thead class="gt_col_headings">
    <tr>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col" id="&lt;strong&gt;Characteristic&lt;/strong&gt;"><strong>Characteristic</strong></th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" scope="col" id="&lt;strong&gt;43-days survival (95% CI)&lt;/strong&gt;"><strong>43-days survival (95% CI)</strong></th>
    </tr>
  </thead>
  <tbody class="gt_table_body">
    <tr><td headers="label" class="gt_row gt_left">dm</td>
<td headers="stat_1" class="gt_row gt_center"></td></tr>
    <tr><td headers="label" class="gt_row gt_left">    no</td>
<td headers="stat_1" class="gt_row gt_center">22% (7.5%, 62%)</td></tr>
    <tr><td headers="label" class="gt_row gt_left">    yes</td>
<td headers="stat_1" class="gt_row gt_center">— (—, —)</td></tr>
  </tbody>
  
  
</table>
</div>

# Estimating median survival time

Another quantity often of interest in a survival analysis is the average
survival time, which we quantify using the median. Survival times are
not expected to be normally distributed so the mean is not an
appropriate summary.

# 

We can produce nice tables of median survival time estimates using the
`tbl_survfit()` function from the {gtsummary} package:

``` r
survfit(Surv(time = time2, 
              event = status == "dead") ~ dm, 
         data = stroke) %>% 
  tbl_survfit(
    probs = 0.5,
    label_header = "**Median survival (95% CI)**"
  )
```

<div id="lylstmswuw" style="padding-left:0px;padding-right:0px;padding-top:10px;padding-bottom:10px;overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<style>html {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Helvetica Neue', 'Fira Sans', 'Droid Sans', Arial, sans-serif;
}

#lylstmswuw .gt_table {
  display: table;
  border-collapse: collapse;
  margin-left: auto;
  margin-right: auto;
  color: #333333;
  font-size: 16px;
  font-weight: normal;
  font-style: normal;
  background-color: #FFFFFF;
  width: auto;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #A8A8A8;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #A8A8A8;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
}

#lylstmswuw .gt_heading {
  background-color: #FFFFFF;
  text-align: center;
  border-bottom-color: #FFFFFF;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#lylstmswuw .gt_caption {
  padding-top: 4px;
  padding-bottom: 4px;
}

#lylstmswuw .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#lylstmswuw .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 0;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#lylstmswuw .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#lylstmswuw .gt_col_headings {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#lylstmswuw .gt_col_heading {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  overflow-x: hidden;
}

#lylstmswuw .gt_column_spanner_outer {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  padding-top: 0;
  padding-bottom: 0;
  padding-left: 4px;
  padding-right: 4px;
}

#lylstmswuw .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#lylstmswuw .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#lylstmswuw .gt_column_spanner {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 5px;
  overflow-x: hidden;
  display: inline-block;
  width: 100%;
}

#lylstmswuw .gt_group_heading {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  text-align: left;
}

#lylstmswuw .gt_empty_group_heading {
  padding: 0.5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: middle;
}

#lylstmswuw .gt_from_md > :first-child {
  margin-top: 0;
}

#lylstmswuw .gt_from_md > :last-child {
  margin-bottom: 0;
}

#lylstmswuw .gt_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  margin: 10px;
  border-top-style: solid;
  border-top-width: 1px;
  border-top-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  overflow-x: hidden;
}

#lylstmswuw .gt_stub {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
}

#lylstmswuw .gt_stub_row_group {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
  vertical-align: top;
}

#lylstmswuw .gt_row_group_first td {
  border-top-width: 2px;
}

#lylstmswuw .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#lylstmswuw .gt_first_summary_row {
  border-top-style: solid;
  border-top-color: #D3D3D3;
}

#lylstmswuw .gt_first_summary_row.thick {
  border-top-width: 2px;
}

#lylstmswuw .gt_last_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#lylstmswuw .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#lylstmswuw .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#lylstmswuw .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#lylstmswuw .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#lylstmswuw .gt_footnotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#lylstmswuw .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding-left: 4px;
  padding-right: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#lylstmswuw .gt_sourcenotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#lylstmswuw .gt_sourcenote {
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#lylstmswuw .gt_left {
  text-align: left;
}

#lylstmswuw .gt_center {
  text-align: center;
}

#lylstmswuw .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#lylstmswuw .gt_font_normal {
  font-weight: normal;
}

#lylstmswuw .gt_font_bold {
  font-weight: bold;
}

#lylstmswuw .gt_font_italic {
  font-style: italic;
}

#lylstmswuw .gt_super {
  font-size: 65%;
}

#lylstmswuw .gt_footnote_marks {
  font-style: italic;
  font-weight: normal;
  font-size: 75%;
  vertical-align: 0.4em;
}

#lylstmswuw .gt_asterisk {
  font-size: 100%;
  vertical-align: 0;
}

#lylstmswuw .gt_indent_1 {
  text-indent: 5px;
}

#lylstmswuw .gt_indent_2 {
  text-indent: 10px;
}

#lylstmswuw .gt_indent_3 {
  text-indent: 15px;
}

#lylstmswuw .gt_indent_4 {
  text-indent: 20px;
}

#lylstmswuw .gt_indent_5 {
  text-indent: 25px;
}
</style>
<table class="gt_table">
  
  <thead class="gt_col_headings">
    <tr>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col" id="&lt;strong&gt;Characteristic&lt;/strong&gt;"><strong>Characteristic</strong></th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" scope="col" id="&lt;strong&gt;Median survival (95% CI)&lt;/strong&gt;"><strong>Median survival (95% CI)</strong></th>
    </tr>
  </thead>
  <tbody class="gt_table_body">
    <tr><td headers="label" class="gt_row gt_left">dm</td>
<td headers="stat_1" class="gt_row gt_center"></td></tr>
    <tr><td headers="label" class="gt_row gt_left">    no</td>
<td headers="stat_1" class="gt_row gt_center">18 (12, —)</td></tr>
    <tr><td headers="label" class="gt_row gt_left">    yes</td>
<td headers="stat_1" class="gt_row gt_center">25 (14, —)</td></tr>
  </tbody>
  
  
</table>
</div>

# Cox PH General model

The Cox model is expressed by the **hazard function** denoted by `\(h(t)\)`.
This model can be used to fit univariable and multivariable regression
models that have survival outcomes. The hazard function can be
interpreted as the risk of dying at time t. It can be estimated as
follow:

`\(h(t, X_{i}) = h_{0}(t)e^{ \sum_{j=1}^{p} \beta_{j}X_{i,j}} = h_{0}(t)exp(\beta_{1}X_{i,1} + ... +\ beta_{p}X_{i,p})\)`

## 

where:

- `\(h(t)\)` is the hazard, the instantaneous rate at which events occur.
- `\(h_{0}(t)\)` is called the **baseline hazards** (when all X’s are
  equal to 0), depends on `\(t\)`
- `\(X = (X_{1}, X_{2},..., X_{p})\)` explanatory/predictor variables
- `\(e^{ \sum_{i=1}^{p} \beta_{i}X_{i}}\)`, depends only on X’s, called
  .

Because the **baseline hazard** `\(h_{0}(t)\)` is an unspecified function,
the Cox model us a **semiparametric** model.

Advantages of the model: “robust” model, so that the results from using
the Cox model will closely approximate the results for the correct
parametric model.

# 

The Cox model can be written as a multiple linear regression of the
logarithm of the hazard on the variables `\(X_{i}\)`, with the baseline
hazard, `\(h_{0}(t)\)`, being an ‘intercept’ term that varies with time.

`$$log(h(t, X_{i})) = log(h_{0}(t)) + \sum_{j=1}^{p} \beta_{j}X_{i,j}$$`

We can compute the **hazard ratio**, which is the ratio of hazards
between two groups at any particular point in time: “hazard for one
individual divided by the hazard for a different individual”.

`$$\hat{HR} = \frac{\hat{h}(t, X^{*})}{\hat{h}(t, X)} = e^{ \sum_{i=1}^{p} \beta_{i} (X^{*}_{i} - X_{i})}$$`

with:

X$^{*}$: set of predictors for one individual

X: set of predictors for the other individual

# 

This model shows that the hazard ratio is equal to
`\(e^{ \sum_{i=1}^{p} \beta_{i} (X^{*}_{i} - X_{i})}\)`, and remains
constant over time t (hence the name proportional hazards regression).
In this sense, we do not need the baseline hazard because we can
interpret coefficients as hazard ratios.

A hazard ratio above 1 indicates a covariate that is positively
associated with the event probability, and thus negatively associated
with the length of survival.

In summary,

- HR = 1 : No effect
- HR \< 1: Reduction in the hazard
- HR \> 1: Increase in Hazard

As a note, in clinical studies, a covariate with hazard ratio :

- greater than 1 (i.e.: b\>0) is called bad prognostic factor.
- smaller than 1 (i.e.: b\<0) is called good prognostic factor.

# 

As a consequence, a major assumption of this model is that the HR is
constant over time because it is independent of time. Or equivalently
that the hazard for one individual is proportional to the hazard for any
other individual, where the proportionality constant is independent of
time.

It is possible, nevertheless, to consider X’s which do involve t. Such
X’s are called time-dependent variables. If time-dependent variables are
considered, the Cox model form may still be used, but such a model no
longer satisfies the PH assumption, and is called the extended Cox
model.

# Compute the Cox Model

- The coxph() function uses the same syntax as lm(), glm(), etc. The
  response variable you create with Surv() goes on the left hand side
  of the formula, specified with a \~. Explanatory variables go on the
  right side.

## COX PH model with stroke type variable only

``` r
(stroke_stype <- coxph(Surv(time2,status == 'dead') ~  stroke_type
                       ,data = stroke))
#> Call:
#> coxph(formula = Surv(time2, status == "dead") ~ stroke_type, 
#>     data = stroke)
#> 
#>                  coef exp(coef) se(coef)      z      p
#> stroke_typeIS -0.6622    0.5157   0.3172 -2.088 0.0368
#> 
#> Likelihood ratio test=4.52  on 1 df, p=0.03344
#> n= 213, number of events= 48
```

# interpretting

The effect of stroke type is significantly related to survival (p-value =
0.0368), with better survival in Ischaemic stroke in comparison to the other type (hazard ratio of dying = 0.5157).

The model is statistically significant. That 0.03344 p-value of the
model is really close to the p = 0.03 p-value we saw on the
Kaplan-Meier nodel as well as the likelihood ratio test = 4.52 is close
to the log-rank chi-square (4.5) in the Kaplan-Meier model.

`\(e^{\beta_{1}}\)` = `\(e^{-0.6622}\)` = 0.5157 is the hazard ratio - the
multiplicative effect of that variable on the hazard rate (for each unit
increase in that variable). Ischaemic stroke patients have 0.588 (\~ 60%) times the hazard of dying in comparison to haemorage.

# Model Building

> this is important when perfoming statistical analysis

- first build a model with all varibles

``` r
>stroke_stype <- coxph(Surv(time2,status == 'dead') ~ gcs + stroke_type
                      + sex + dm + sbp ,data = stroke)
>summary(stroke_stype)
Call:
coxph(formula = Surv(time2, status == "dead") ~ gcs + stroke_type + 
    sex + dm + sbp, data = stroke)

  n= 213, number of events= 48 

                   coef exp(coef)  se(coef)      z Pr(>|z|)    
gcs           -0.170038  0.843633  0.037167 -4.575 4.76e-06 ***
stroke_typeIS -0.103523  0.901655  0.346749 -0.299    0.765    
sexmale       -0.203488  0.815880  0.334159 -0.609    0.543    
dmyes         -0.439913  0.644093  0.343960 -1.279    0.201    
sbp           -0.001765  0.998237  0.004017 -0.439    0.660    
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
```

``` r
              exp(coef) exp(-coef) lower .95 upper .95
gcs              0.8436      1.185    0.7844    0.9074
stroke_typeIS    0.9017      1.109    0.4570    1.7791
sexmale          0.8159      1.226    0.4238    1.5706
dmyes            0.6441      1.553    0.3282    1.2639
sbp              0.9982      1.002    0.9904    1.0061

Concordance= 0.78  (se = 0.035 )
Likelihood ratio test= 28.88  on 5 df,   p=2e-05
Wald test            = 27.71  on 5 df,   p=4e-05
Score (logrank) test = 31.45  on 5 df,   p=8e-06
```

# 

## 

- the estimate which is the log hazard. If you exponentiate it, you will get hazard ratio
- the standard error
- the p-value
- the confidence intervals for the log hazard

# 

## 

``` r
stroke_stype <- coxph(Surv(time2,status == 'dead') ~ gcs + stroke_type+dbp+wbc
                      + sex + dm + sbp ,data = stroke)
tidy(stroke_stype,
     exponentiate = TRUE) 
#> # A tibble: 7 x 5
#>   term          estimate std.error statistic    p.value
#>   <chr>            <dbl>     <dbl>     <dbl>      <dbl>
#> 1 gcs              0.839   0.0391     -4.48  0.00000740
#> 2 stroke_typeIS    0.892   0.349      -0.329 0.742     
#> 3 dbp              0.988   0.0119     -1.00  0.317     
#> 4 wbc              1.01    0.0389      0.269 0.788     
#> 5 sexmale          0.862   0.350      -0.423 0.672     
#> 6 dmyes            0.632   0.364      -1.26  0.208     
#> 7 sbp              1.00    0.00691     0.529 0.597
```

# using rms package

``` r
fatal_mv1<-rms::cph(Surv(time2,status == 'dead') ~ gcs + stroke_type+dbp+wbc
                      + sex + dm + sbp ,data = stroke)
```

``` r
plot(anova(fatal_mv1),margin=c("chisq","d.f","P"))
```

<img src="{{< blogdown/postref >}}index.en_files/figure-html/unnamed-chunk-23-1.png" width="1023.999552" />

# now we create univariate models as in logistic regression

By using `tbl_uvregression()` we can generate simple univariable model for all covariates in one line of code. In return, we get the crude HR for all the covariates of interest.

``` r
library(gt)
library(gtsummary)
stroke |>
  dplyr::select(time2, status, sex, dm, gcs, sbp, dbp, wbc, 
                stroke_type) |>
  tbl_uvregression(
    method = coxph,
    y = Surv(time2, event = status == 'dead'),
    exponentiate = TRUE,
    pvalue_fun = ~style_pvalue(.x, digits = 3)
  ) |>
  as_gt()
```

<div id="hsarpbzxyw" style="padding-left:0px;padding-right:0px;padding-top:10px;padding-bottom:10px;overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<style>html {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Helvetica Neue', 'Fira Sans', 'Droid Sans', Arial, sans-serif;
}

#hsarpbzxyw .gt_table {
  display: table;
  border-collapse: collapse;
  margin-left: auto;
  margin-right: auto;
  color: #333333;
  font-size: 16px;
  font-weight: normal;
  font-style: normal;
  background-color: #FFFFFF;
  width: auto;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #A8A8A8;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #A8A8A8;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
}

#hsarpbzxyw .gt_heading {
  background-color: #FFFFFF;
  text-align: center;
  border-bottom-color: #FFFFFF;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#hsarpbzxyw .gt_caption {
  padding-top: 4px;
  padding-bottom: 4px;
}

#hsarpbzxyw .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#hsarpbzxyw .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 0;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#hsarpbzxyw .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#hsarpbzxyw .gt_col_headings {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#hsarpbzxyw .gt_col_heading {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  overflow-x: hidden;
}

#hsarpbzxyw .gt_column_spanner_outer {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  padding-top: 0;
  padding-bottom: 0;
  padding-left: 4px;
  padding-right: 4px;
}

#hsarpbzxyw .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#hsarpbzxyw .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#hsarpbzxyw .gt_column_spanner {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 5px;
  overflow-x: hidden;
  display: inline-block;
  width: 100%;
}

#hsarpbzxyw .gt_group_heading {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  text-align: left;
}

#hsarpbzxyw .gt_empty_group_heading {
  padding: 0.5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: middle;
}

#hsarpbzxyw .gt_from_md > :first-child {
  margin-top: 0;
}

#hsarpbzxyw .gt_from_md > :last-child {
  margin-bottom: 0;
}

#hsarpbzxyw .gt_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  margin: 10px;
  border-top-style: solid;
  border-top-width: 1px;
  border-top-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  overflow-x: hidden;
}

#hsarpbzxyw .gt_stub {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
}

#hsarpbzxyw .gt_stub_row_group {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
  vertical-align: top;
}

#hsarpbzxyw .gt_row_group_first td {
  border-top-width: 2px;
}

#hsarpbzxyw .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#hsarpbzxyw .gt_first_summary_row {
  border-top-style: solid;
  border-top-color: #D3D3D3;
}

#hsarpbzxyw .gt_first_summary_row.thick {
  border-top-width: 2px;
}

#hsarpbzxyw .gt_last_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#hsarpbzxyw .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#hsarpbzxyw .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#hsarpbzxyw .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#hsarpbzxyw .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#hsarpbzxyw .gt_footnotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#hsarpbzxyw .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding-left: 4px;
  padding-right: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#hsarpbzxyw .gt_sourcenotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#hsarpbzxyw .gt_sourcenote {
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#hsarpbzxyw .gt_left {
  text-align: left;
}

#hsarpbzxyw .gt_center {
  text-align: center;
}

#hsarpbzxyw .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#hsarpbzxyw .gt_font_normal {
  font-weight: normal;
}

#hsarpbzxyw .gt_font_bold {
  font-weight: bold;
}

#hsarpbzxyw .gt_font_italic {
  font-style: italic;
}

#hsarpbzxyw .gt_super {
  font-size: 65%;
}

#hsarpbzxyw .gt_footnote_marks {
  font-style: italic;
  font-weight: normal;
  font-size: 75%;
  vertical-align: 0.4em;
}

#hsarpbzxyw .gt_asterisk {
  font-size: 100%;
  vertical-align: 0;
}

#hsarpbzxyw .gt_indent_1 {
  text-indent: 5px;
}

#hsarpbzxyw .gt_indent_2 {
  text-indent: 10px;
}

#hsarpbzxyw .gt_indent_3 {
  text-indent: 15px;
}

#hsarpbzxyw .gt_indent_4 {
  text-indent: 20px;
}

#hsarpbzxyw .gt_indent_5 {
  text-indent: 25px;
}
</style>
<table class="gt_table">
  
  <thead class="gt_col_headings">
    <tr>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col" id="&lt;strong&gt;Characteristic&lt;/strong&gt;"><strong>Characteristic</strong></th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" scope="col" id="&lt;strong&gt;N&lt;/strong&gt;"><strong>N</strong></th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" scope="col" id="&lt;strong&gt;HR&lt;/strong&gt;&lt;sup class=&quot;gt_footnote_marks&quot;&gt;1&lt;/sup&gt;"><strong>HR</strong><sup class="gt_footnote_marks">1</sup></th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" scope="col" id="&lt;strong&gt;95% CI&lt;/strong&gt;&lt;sup class=&quot;gt_footnote_marks&quot;&gt;1&lt;/sup&gt;"><strong>95% CI</strong><sup class="gt_footnote_marks">1</sup></th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" scope="col" id="&lt;strong&gt;p-value&lt;/strong&gt;"><strong>p-value</strong></th>
    </tr>
  </thead>
  <tbody class="gt_table_body">
    <tr><td headers="label" class="gt_row gt_left">sex</td>
<td headers="stat_n" class="gt_row gt_center">213</td>
<td headers="estimate" class="gt_row gt_center"></td>
<td headers="ci" class="gt_row gt_center"></td>
<td headers="p.value" class="gt_row gt_center"></td></tr>
    <tr><td headers="label" class="gt_row gt_left">    female</td>
<td headers="stat_n" class="gt_row gt_center"></td>
<td headers="estimate" class="gt_row gt_center">—</td>
<td headers="ci" class="gt_row gt_center">—</td>
<td headers="p.value" class="gt_row gt_center"></td></tr>
    <tr><td headers="label" class="gt_row gt_left">    male</td>
<td headers="stat_n" class="gt_row gt_center"></td>
<td headers="estimate" class="gt_row gt_center">0.71</td>
<td headers="ci" class="gt_row gt_center">0.37, 1.36</td>
<td headers="p.value" class="gt_row gt_center">0.299</td></tr>
    <tr><td headers="label" class="gt_row gt_left">dm</td>
<td headers="stat_n" class="gt_row gt_center">213</td>
<td headers="estimate" class="gt_row gt_center"></td>
<td headers="ci" class="gt_row gt_center"></td>
<td headers="p.value" class="gt_row gt_center"></td></tr>
    <tr><td headers="label" class="gt_row gt_left">    no</td>
<td headers="stat_n" class="gt_row gt_center"></td>
<td headers="estimate" class="gt_row gt_center">—</td>
<td headers="ci" class="gt_row gt_center">—</td>
<td headers="p.value" class="gt_row gt_center"></td></tr>
    <tr><td headers="label" class="gt_row gt_left">    yes</td>
<td headers="stat_n" class="gt_row gt_center"></td>
<td headers="estimate" class="gt_row gt_center">0.60</td>
<td headers="ci" class="gt_row gt_center">0.31, 1.13</td>
<td headers="p.value" class="gt_row gt_center">0.112</td></tr>
    <tr><td headers="label" class="gt_row gt_left">gcs</td>
<td headers="stat_n" class="gt_row gt_center">213</td>
<td headers="estimate" class="gt_row gt_center">0.84</td>
<td headers="ci" class="gt_row gt_center">0.79, 0.90</td>
<td headers="p.value" class="gt_row gt_center"><0.001</td></tr>
    <tr><td headers="label" class="gt_row gt_left">sbp</td>
<td headers="stat_n" class="gt_row gt_center">213</td>
<td headers="estimate" class="gt_row gt_center">1.00</td>
<td headers="ci" class="gt_row gt_center">0.99, 1.01</td>
<td headers="p.value" class="gt_row gt_center">0.617</td></tr>
    <tr><td headers="label" class="gt_row gt_left">dbp</td>
<td headers="stat_n" class="gt_row gt_center">213</td>
<td headers="estimate" class="gt_row gt_center">1.00</td>
<td headers="ci" class="gt_row gt_center">0.98, 1.01</td>
<td headers="p.value" class="gt_row gt_center">0.772</td></tr>
    <tr><td headers="label" class="gt_row gt_left">wbc</td>
<td headers="stat_n" class="gt_row gt_center">213</td>
<td headers="estimate" class="gt_row gt_center">1.04</td>
<td headers="ci" class="gt_row gt_center">0.97, 1.11</td>
<td headers="p.value" class="gt_row gt_center">0.270</td></tr>
    <tr><td headers="label" class="gt_row gt_left">stroke_type</td>
<td headers="stat_n" class="gt_row gt_center">213</td>
<td headers="estimate" class="gt_row gt_center"></td>
<td headers="ci" class="gt_row gt_center"></td>
<td headers="p.value" class="gt_row gt_center"></td></tr>
    <tr><td headers="label" class="gt_row gt_left">    HS</td>
<td headers="stat_n" class="gt_row gt_center"></td>
<td headers="estimate" class="gt_row gt_center">—</td>
<td headers="ci" class="gt_row gt_center">—</td>
<td headers="p.value" class="gt_row gt_center"></td></tr>
    <tr><td headers="label" class="gt_row gt_left">    IS</td>
<td headers="stat_n" class="gt_row gt_center"></td>
<td headers="estimate" class="gt_row gt_center">0.52</td>
<td headers="ci" class="gt_row gt_center">0.28, 0.96</td>
<td headers="p.value" class="gt_row gt_center">0.037</td></tr>
  </tbody>
  
  <tfoot class="gt_footnotes">
    <tr>
      <td class="gt_footnote" colspan="5"><sup class="gt_footnote_marks">1</sup> HR = Hazard Ratio, CI = Confidence Interval</td>
    </tr>
  </tfoot>
</table>
</div>

# 

- it is clear that `gcs` has the least p-value hence can be included in the model first

``` r
stroke_gcs <- coxph(Surv(time = time2,event = status == 'dead') ~ gcs,
                     data = stroke)
summary(stroke_gcs)
#> Call:
#> coxph(formula = Surv(time = time2, event = status == "dead") ~ 
#>     gcs, data = stroke)
#> 
#>   n= 213, number of events= 48 
#> 
#>         coef exp(coef) se(coef)      z Pr(>|z|)    
#> gcs -0.17454   0.83984  0.03431 -5.087 3.63e-07 ***
#> ---
#> Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
#> 
#>     exp(coef) exp(-coef) lower .95 upper .95
#> gcs    0.8398      1.191    0.7852    0.8983
#> 
#> Concordance= 0.763  (se = 0.039 )
#> Likelihood ratio test= 26.01  on 1 df,   p=3e-07
#> Wald test            = 25.88  on 1 df,   p=4e-07
#> Score (logrank) test = 29.33  on 1 df,   p=6e-08
```

The simple Cox PH model with covariate gcs shows that with each one unit increase in gcs, the crude log hazard for death changes by a factor of `\(-0.175\)`.

# lets tidy it up

``` r
tidy(stroke_gcs,
     exponentiate = TRUE,
     conf.int = TRUE)
#> # A tibble: 1 x 7
#>   term  estimate std.error statistic     p.value conf.low conf.high
#>   <chr>    <dbl>     <dbl>     <dbl>       <dbl>    <dbl>     <dbl>
#> 1 gcs      0.840    0.0343     -5.09 0.000000363    0.785     0.898
```

When we exponentiate the log HR, the simple Cox PH model shows that with each one unit increase in gcs, the crude risk for death decreases for about `\(16\%\)` and the of decrease are between `\(95\% CI (0.785, 0.898)\)`. The relationship between stroke death and gcs is highly significant (p-value `\(< 0.0001\)`) when not adjusting for other covariates.

# next up we add stroke type

``` r
stroke_mv <- 
  coxph(Surv(time = time2, 
             event = status == 'dead') ~ stroke_type +  gcs , 
        data = stroke)
tidy(stroke_mv, exponentiate = TRUE, conf.int = TRUE)
#> # A tibble: 2 x 7
#>   term          estimate std.error statistic    p.value conf.low conf.high
#>   <chr>            <dbl>     <dbl>     <dbl>      <dbl>    <dbl>     <dbl>
#> 1 stroke_typeIS    0.774    0.323     -0.794 0.427         0.411     1.46 
#> 2 gcs              0.846    0.0357    -4.68  0.00000290    0.789     0.908
```

# lets test if stroke type is worth it

``` r
anova(stroke_mv,stroke_gcs,test="LRT")
#> Analysis of Deviance Table
#>  Cox model: response is  Surv(time = time2, event = status == "dead")
#>  Model 1: ~ stroke_type + gcs
#>  Model 2: ~ gcs
#>    loglik  Chisq Df Pr(>|Chi|)
#> 1 -187.48                     
#> 2 -187.80 0.6422  1     0.4229
```

- The variable is not significant

# we try another one

``` r
stroke_dm <- 
  coxph(Surv(time = time2, 
             event = status == 'dead') ~ dm +  gcs , 
        data = stroke)
tidy(stroke_dm, exponentiate = TRUE, conf.int = TRUE)
#> # A tibble: 2 x 7
#>   term  estimate std.error statistic     p.value conf.low conf.high
#>   <chr>    <dbl>     <dbl>     <dbl>       <dbl>    <dbl>     <dbl>
#> 1 dmyes    0.625    0.328      -1.43 0.152          0.329     1.19 
#> 2 gcs      0.840    0.0347     -5.04 0.000000466    0.785     0.899
```

# lets test if dm is worth it

``` r
anova(stroke_dm,stroke_gcs,test="LRT")
#> Analysis of Deviance Table
#>  Cox model: response is  Surv(time = time2, event = status == "dead")
#>  Model 1: ~ dm + gcs
#>  Model 2: ~ gcs
#>    loglik Chisq Df Pr(>|Chi|)
#> 1 -186.71                    
#> 2 -187.80 2.181  1     0.1397
```

- still not worth is it , we can go on and on…

# lets do a backward elimination

``` r
fatal_mv1<-rms::cph(Surv(time2,status == 'dead') ~ gcs + stroke_type+dbp+wbc
                      + sex + dm + sbp ,data = stroke)
fastbw(fatal_mv1)
#> 
#>  Deleted     Chi-Sq d.f. P      Residual d.f. P      AIC  
#>  wbc         0.07   1    0.7881 0.07     1    0.7881 -1.93
#>  stroke_type 0.14   1    0.7130 0.21     2    0.9015 -3.79
#>  sex         0.16   1    0.6934 0.36     3    0.9478 -5.64
#>  sbp         0.39   1    0.5326 0.75     4    0.9447 -7.25
#>  dbp         1.12   1    0.2897 1.87     5    0.8664 -8.13
#>  dm          2.03   1    0.1542 3.90     6    0.6898 -8.10
#> 
#> Approximate Estimates after Deleting Factors
#> 
#>        Coef    S.E. Wald Z         P
#> gcs -0.1762 0.03495 -5.041 4.635e-07
#> 
#> Factors in Final Model
#> 
#> [1] gcs
```

- final model has gcs variable

# Validity of the Cox PH model

The Cox proportional hazards model makes several assumptions. We use
residuals methods to:

- check the proportional hazards assumption with the Schoenfeld
  residuals
- detect nonlinearity in relationship between the log hazard and the
  covariates using Martingale residual
- examining influential observations (or outliers) with deviance
  residual (symmetric transformation of the martinguale residuals), to
  examine influential observations

# Testing proportional hazard

The proportional hazard assumption is supported by a non-significant
relationship between residuals and time, and refuted by a significant
relationship.

We can test with the **Goodness of Fit (GOF)** approach based on the
residuals defined by Schoenfeld.

The idea behind the statistical test is that if the PH assumption holds
for a particular covariate then the Schoenfeld residuals for that
covariate will not be related to survival time.

# The implementation of the test can be thought of as a three-step process.

- Step 1. Run a Cox PH model and obtain Schoenfeld residuals for each
  predictor.

- Step 2. Create a variable that ranks the order of failures. The
  subject who has the first (earliest) event gets a value of 1, the
  next gets a value of 2, and so on.

- Step 3. Test the correlation between the variables created in the
  first and second steps. The null hypothesis is that the correlation
  between the Schoenfeld residuals and ranked failure time is zero.

For each covariate, the function cox.zph() correlates the corresponding
set of scaled Schoenfeld residuals with time, to test for independence
between residuals and time. Additionally, it performs a global test for
the model as a whole.

# 

``` r
test.ph <- cox.zph(stroke_stype)
print(test.ph)
#>              chisq df    p
#> gcs         0.0206  1 0.89
#> stroke_type 1.2745  1 0.26
#> dbp         1.0480  1 0.31
#> wbc         0.0235  1 0.88
#> sex         0.4560  1 0.50
#> dm          1.9324  1 0.16
#> sbp         1.2716  1 0.26
#> GLOBAL      6.1719  7 0.52
```

# 

``` r
ggcoxzph(test.ph)
```

<img src="{{< blogdown/postref >}}index.en_files/figure-html/unnamed-chunk-33-1.png" width="1023.999552" />

# 

From the output above, the test is not statistically significant, and
therefore the global test is also not statistically significant.
Therefore, we can assume the proportional hazards.

In the graphical diagnostic using the function ggcoxzph() \[in the
survminer package\], the solid line is a smoothing spline fit to the
plot, with the dashed lines representing a +/- 2-standard-error band
around the fit. From the graphical inspection, there is no pattern with
time. The assumption of proportional hazards appears to be supported for
the covariates sex (which is, recall, a two-level factor, accounting for
the two bands in the graph).

# another approach

Another approach is to graphically check the PH assumption by comparing
**-log–log survival curves**. A log–log survival curve is simply a
transformation of an estimated survival curve that results from taking
the natural log of an estimated survival probability twice.

`\(h(t, X) = h_{0}(t)e^{ \sum_{j=1}^{p} \beta_{j}X_{j}}\)` which is
equivalent to `\(S(t,X) = [S_{0}(t)]^{e^{ \sum_{j=1}^{p} \beta_{j}X_{j}}}\)`

Therefore, `$$-ln(-ln(S(t, X)))$$`

# 

`$$= -ln(-ln([S_{0}(t)]^{e^{ \sum_{j=1}^{p} \beta_{j}X_{j}}}))$$`
`$$= -ln[-ln(S_{0}(t))] - ln[e^{ \sum_{j=1}^{p} \beta_{j}X_{j}}]$$`

`$$=  - \sum_{j=1}^{p} \beta_{j} X_{j} - ln[-ln(S_{0}(t))]$$`

Therefore, the corresponding log–log curves for these individuals are
given as shown here, where we have simply substituted `\(X_1\)` and `\(X_2\)`
for `\(X\)` in the previous expression for the log–log curve for any
individual `\(X\)`.

# 

`$$ln(-ln(S(t, X_1))) - ln(-ln(S(t, X_2)))$$`
`$$= \sum_{j=1}^{p} \beta_{j} (X_{1j} - X_{2j})$$`

The baseline survival function has dropped out, so that the difference
in log–log curves involves an expression that does not involve time t.
The above formula says that if we use a Cox PH model and we plot the
estimated -log–log survival curves for two groups of individuals on the
same graph, the two plots would be approximately parallel.

# 

The distance between the two curves is the linear expression involving
the differences in predictor values, which does not involve time. Note,
in general, if the vertical distance between two curves is constant,
then the curves are parallel.

``` r
m = survfit(Surv(time2,status == 'dead') ~  stroke_type
                       ,data = stroke)
s = summary(m)
s_table = data.frame(s$strata, s$time, s$n.risk, s$n.event, s$n.censor, s$surv, s$lower, s$upper)
s_table = s_table %>%
              rename(strata=s.strata, time=s.time, surv=s.surv, lower=s.lower, upper=s.upper) %>%
              mutate(negloglogsurv=-log(-log(surv)))
```

# 

``` r
plot<-ggplot(s_table, aes(x=time, y=negloglogsurv, color=strata)) + 
  geom_line(size=1.25) +
  theme(text=element_text(size=16),
        plot.title=element_text(hjust=0.5)) +
  ggthemes::scale_colour_tableau()+
  tvthemes::theme_avatar()+
  ylab("-ln(-ln(S(t)))") +
  ggtitle("-log-log plot of survival time by stroke type")
```

# 

``` r
plot
```

<img src="{{< blogdown/postref >}}index.en_files/figure-html/unnamed-chunk-36-1.png" width="1023.999552" />

The two curve cross, therefore this result suggests that the two
groups in stroke type do not satisfy the PH assumption.

# Testing influential observations

To test influential observations or outliers, we can visualize either:
the **dfbeta values** or the **deviance residuals**.

- 1)  dfbeta values

This plot produces the estimated changes in the coefficients divided by
their standard errors. The comparison of the magnitudes of the largest
dfbeta values to the regression coefficients suggests that none of the
observations is terribly influential individually.

# 

``` r
ggcoxdiagnostics(stroke_stype, type = "dfbeta",
                 linear.predictions = FALSE, ggtheme = theme_bw())
```

<img src="{{< blogdown/postref >}}index.en_files/figure-html/unnamed-chunk-37-1.png" width="1023.999552" />

# 

- 2)  deviance residuals

The deviance residual is a normalized transformation of the martingale
residual. These residuals should be roughly symmetrically distributed
about zero with a standard deviation of 1.

- Positive values correspond to individuals that “died too soon”
  compared to expected survival times.

- Negative values correspond to individual that “lived too long”.

- Very large or small values are outliers, which are poorly predicted
  by the model.

# 

``` r
ggcoxdiagnostics(stroke_stype, type = "deviance",
                 linear.predictions = FALSE, tvtheme = theme_avatar())
```

<img src="{{< blogdown/postref >}}index.en_files/figure-html/unnamed-chunk-38-1.png" width="1023.999552" />

# 

``` r
ggcoxdiagnostics(stroke_stype, type = "martingale",
                 linear.predictions = FALSE, ggtheme = theme_bw())
```

<img src="{{< blogdown/postref >}}index.en_files/figure-html/unnamed-chunk-39-1.png" width="1023.999552" />

``` r
ggcoxdiagnostics(stroke_stype, type = "deviance", ox.scale = 'time')
```

<img src="{{< blogdown/postref >}}index.en_files/figure-html/unnamed-chunk-40-1.png" width="1023.999552" />

``` r
ggcoxdiagnostics(stroke_stype, type = "deviance", ox.scale = "linear.predictions")
```

<img src="{{< blogdown/postref >}}index.en_files/figure-html/unnamed-chunk-41-1.png" width="1023.999552" />

``` r
ggcoxdiagnostics(stroke_stype, type = "schoenfeld", ox.scale = "observation.id")
```

<img src="{{< blogdown/postref >}}index.en_files/figure-html/unnamed-chunk-42-1.png" width="1023.999552" />

[^1]: In the medical world, we typically think of *survival analysis*
    literally – tracking time until death. But, it’s more general than
    that – survival analysis models time until an *event* occurs (*any*
    event). This might be death of a biological organism. But it could
    also be the time until a hardware failure in a mechanical system,
    time until recovery, time someone remains unemployed after losing a
    job, time until a ripe tomato is eaten by a grazing deer, time until
    someone falls asleep in a workshop, etc. *Survival analysis* also
    goes by *reliability theory* in engineering, *duration analysis* in
    economics, and *event history analysis* in sociology.

[^2]: Cox regression and the logrank test from `survdiff` are going to give you similar results most of the time. The log-rank test is asking if survival curves differ significantly between two groups. Cox regression is asking which of many categorical or continuous variables significantly affect survival.
