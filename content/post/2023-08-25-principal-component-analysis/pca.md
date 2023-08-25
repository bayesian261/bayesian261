---
title: "Principal Component Analysis"
author: 'Bongani Ncube : statistical analyst'
date: "June 2023"
output:
  beamer_presentation:
    theme: Copenhagen
    colortheme: beaver
    fonttheme: structurebold
    fig_caption: no
    includes:
      in_header: header.tex
    latex_engine: pdflatex
    slide_level: null
  pdf_document: default
  revealjs::revealjs_presentation:
  html_document:
    df_print: paged
  ioslides_presentation: default
  slidy_presentation: default
subtitle: NCUBE ON DATA
classoption: aspectratio=169
editor_options:
  markdown:
    wrap: 72
---



# setup
##


```r
library(tidyverse) # cleaning & wrangling functions
library(tidymodels) # classification
library(factoextra) # PCA
library(janitor) # data cleaning
library(magrittr) # piping
library(flextable) #table layout and formatting
library(corrplot)
library(viridis) #coloration for box plots + ROC_AUC
library(patchwork) # easy plot layout
```

# Principal Components 

## what is it (a.k.a dimension reduction technique)

-   Unsupervised learning
-   find important features
-   reduce the dimensions of the data set
-   "decorrelate" multivariate vectors that have dependence.
-   uses eigenvector/eigvenvalue decomposition of covariance (correlation) matrices.

# the math you need...

According to the "spectral decomposition theorem", if `\(\mathbf{\Sigma}_{p \times p}\)` i s a positive semi-definite, symmetric, real matrix, then there exists an orthogonal matrix `\(\mathbf{A}\)` such that `\(\mathbf{A'\Sigma A} = v\)` where `\(v\)` is a diagonal matrix containing the eigenvalues `\(\mathbf{\Sigma}\)`

##

$$
\mathbf{v} = 
\left(
\begin{array}
{cccc}
v_1 & 0 & \ldots & 0 \\
0 & v_2 & \ldots & 0 \\
\vdots & \vdots & \ddots & \vdots \\
0 & 0 & \ldots & v_p
\end{array}
\right)
$$


##
$$
\mathbf{A} =
\left(
\begin{array}
{cccc}
\mathbf{a}_1 & \mathbf{a}_2 & \ldots & \mathbf{a}_p
\end{array}
\right)
$$

#

the i-th column of `\(\mathbf{A}\)` , `\(\mathbf{a}_i\)`, is the i-th `\(p \times 1\)` eigenvector of `\(\mathbf{\Sigma}\)` that corresponds to the eigenvalue, `\(v_i\)` , where `\(v_1 \ge v_2 \ge \ldots \ge v_p\)` . Alternatively, express in matrix decomposition:

$$
\mathbf{\Sigma} = \mathbf{A v A}'
$$

$$
\mathbf{\Sigma} = \mathbf{A}
\left(
\begin{array}
{cccc}
v_1 & 0 & \ldots & 0 \\
0 & v_2 & \ldots & 0 \\
\vdots & \vdots& \ddots & \vdots \\
0 & 0 & \ldots & v_p
\end{array}
\right)
\mathbf{A}'
= \sum_{i=1}^p v_i \mathbf{a}_i \mathbf{a}_i'
$$

#

where the outer product `\(\mathbf{a}_i \mathbf{a}_i'\)` is a `\(p \times p\)` matrix of rank 1.

For example,

`\(\mathbf{x} \sim N_2(\mathbf{\mu}, \mathbf{\Sigma})\)`

$$
\mathbf{\mu} = 
\left(
\begin{array}
{c}
5 \\ 
12 
\end{array} 
\right);
\mathbf{\Sigma} = 
\left(
\begin{array}
{cc}
4 & 1 \\
1 & 2 
\end{array}
\right)
$$

#

Here,

$$
\mathbf{A} = 
\left(
\begin{array}
{cc}
0.9239 & -0.3827 \\
0.3827 & 0.9239 \\
\end{array}
\right)
$$

#

Columns of `\(\mathbf{A}\)` are the eigenvectors for the decomposition

Under matrix multiplication ($\mathbf{A'\Sigma A}$ or `\(\mathbf{A'A}\)` ), the off-diagonal elements equal to 0

Multiplying data by this matrix (i.e., projecting the data onto the orthogonal axes); the distriubiton of the resulting data (i.e., "scores") is

$$
N_2 (\mathbf{A'\mu,A'\Sigma A}) = N_2 (\mathbf{A'\mu, v})
$$

#

Notes:

-   The i-th eigenvalue is the variance of a linear combination of the elements of `\(\mathbf{x}\)` ; `\(var(y_i) = var(\mathbf{a'_i x}) = v_i\)`

-   The values on the transformed set of axes (i.e., the `\(y_i\)`'s) are called the scores. These are the orthogonal projections of the data onto the "new principal component axes

-   Variances of `\(y_1\)` are greater than those for any other possible projection

Covariance matrix decomposition and projection onto orthogonal axes = PCA


# Population Principal Components

`\(p \times 1\)` vectors `\(\mathbf{x}_1, \dots , \mathbf{x}_n\)` which are iid with `\(var(\mathbf{x}_i) = \mathbf{\Sigma}\)`

-   The first PC is the linear combination `\(y_1 = \mathbf{a}_1' \mathbf{x} = a_{11}x_1 + \dots + a_{1p}x_p\)` with `\(\mathbf{a}_1' \mathbf{a}_1 = 1\)` such that `\(var(y_1)\)` is the maximum of all linear combinations of `\(\mathbf{x}\)` which have unit length

-   The second PC is the linear combination `\(y_1 = \mathbf{a}_2' \mathbf{x} = a_{21}x_1 + \dots + a_{2p}x_p\)` with `\(\mathbf{a}_2' \mathbf{a}_2 = 1\)` such that `\(var(y_1)\)` is the maximum of all linear combinations of `\(\mathbf{x}\)` which have unit length and uncorrelated with `\(y_1\)` (i.e., `\(cov(\mathbf{a}_1' \mathbf{x}, \mathbf{a}'_2 \mathbf{x}) =0\)`

-   continues for all `\(y_i\)` to `\(y_p\)`

`\(\mathbf{a}_i\)`'s are those that make up the matrix `\(\mathbf{A}\)` in the symmetric decomposition `\(\mathbf{A'\Sigma A} = \mathbf{v}\)` , where `\(var(y_1) = v_1, \dots , var(y_p) = v_p\)` And the total variance of `\(\mathbf{x}\)` is

$$
\begin{aligned}
var(x_1) + \dots + var(x_p) &= tr(\Sigma) = v_1 + \dots + v_p \\
&= var(y_1) + \dots + var(y_p) 
\end{aligned}
$$

# Data Reduction

To reduce the dimension of data from p (original) to k dimensions without much "loss of information", we can use properties of the population principal components

-   Suppose `\(\mathbf{\Sigma} \approx \sum_{i=1}^k v_i \mathbf{a}_i \mathbf{a}_i'\)` . Even thought the true variance-covariance matrix has rank `\(p\)` , it can be be well approximate by a matrix of rank k (k \<p)

-   New "traits" are linear combinations of the measured traits. We can attempt to make meaningful interpretation fo the combinations (with orthogonality constraints).

-   The proportion of the total variance accounted for by the j-th principal component is

$$
\frac{var(y_j)}{\sum_{i=1}^p var(y_i)} = \frac{v_j}{\sum_{i=1}^p v_i}
$$

#

-   The proportion of the total variation accounted for by the first k principal components is `\(\frac{\sum_{i=1}^k v_i}{\sum_{i=1}^p v_i}\)`

-   Above example , we have `\(4.4144/(4+2) = .735\)` of the total variability can be explained by the first principal component



## Sample Principal Components

Since `\(\mathbf{\Sigma}\)` is unknown, we use

$$
\mathbf{S} = \frac{1}{n-1}\sum_{i=1}^n (\mathbf{x}_i - \bar{\mathbf{x}})(\mathbf{x}_i - \bar{\mathbf{x}})'
$$

Let `\(\hat{v}_1 \ge \hat{v}_2 \ge \dots \ge \hat{v}_p \ge 0\)` be the eigenvalues of `\(\mathbf{S}\)` and `\(\hat{\mathbf{a}}_1, \hat{\mathbf{a}}_2, \dots, \hat{\mathbf{a}}_p\)` denote the eigenvectors of `\(\mathbf{S}\)`

Then, the i-th sample principal component score (or principal component or score) is

$$
\hat{y}_{ij} = \sum_{k=1}^p \hat{a}_{ik}x_{kj} = \hat{\mathbf{a}}_i'\mathbf{x}_j
$$

# **Properties of Sample Principal Components**

-   The estimated variance of `\(y_i = \hat{\mathbf{a}}_i'\mathbf{x}_j\)` is `\(\hat{v}_i\)`

-   The sample covariance between `\(\hat{y}_i\)` and `\(\hat{y}_{i'}\)` is 0 when `\(i \neq i'\)`

-   The proportion of the total sample variance accounted for by the i-th sample principal component is `\(\frac{\hat{v}_i}{\sum_{k=1}^p \hat{v}_k}\)`

-   The estimated correlation between the i-th principal component score and the l-th attribute of `\(\mathbf{x}\)` is

$$
r_{x_l , \hat{y}_i} = \frac{\hat{a}_{il}\sqrt{v_i}}{\sqrt{s_{ll}}}
$$

-   The correlation coefficient is typically used to interpret the components (i.e., if this correlation is high then it suggests that the l-th original trait is important in the i-th principle component). According to \[@Johnson_1988, pp.433-434\], `\(r_{x_l, \hat{y}_i}\)` only measures the univariate contribution of an individual X to a component Y without taking into account the presence of the other X's. Hence, some prefer `\(\hat{a}_{il}\)` coefficient to interpret the principal component.

-   `\(r_{x_l, \hat{y}_i} ; \hat{a}_{il}\)` are referred to as "loadings"

#

To use k principal components, we must calculate the scores for each data vector in the sample

$$
\mathbf{y}_j = 
\left(
\begin{array}
{c}
y_{1j} \\
y_{2j} \\
\vdots \\
y_{kj} 
\end{array}
\right) = 
\left(
\begin{array}
{c}
\hat{\mathbf{a}}_1' \mathbf{x}_j \\
\hat{\mathbf{a}}_2' \mathbf{x}_j \\
\vdots \\
\hat{\mathbf{a}}_k' \mathbf{x}_j
\end{array}
\right) = 
\left(
\begin{array}
{c}
\hat{\mathbf{a}}_1' \\
\hat{\mathbf{a}}_2' \\
\vdots \\
\hat{\mathbf{a}}_k'
\end{array}
\right) \mathbf{x}_j
$$


#

-   Large sample theory exists for eigenvalues and eigenvectors of sample covariance matrices if inference is necessary. But we do not do inference with PCA, we only use it as exploratory or descriptive analysis.

-   PC is not invariant to changes in scale (Exception: if all trait are resecaled by multiplying by the same constant, such as feet to inches).

 -   PCA based on the correlation matrix `\(\mathbf{R}\)` is different than that based on the covariance matrix `\(\mathbf{\Sigma}\)`

-   PCA for the correlation matrix is just rescaling each trait to have unit variance

-   Transform `\(\mathbf{x}\)` to `\(\mathbf{z}\)` where `\(z_{ij} = (x_{ij} - \bar{x}_i)/\sqrt{s_{ii}}\)` where the denominator affects the PCA

-   After transformation, `\(cov(\mathbf{z}) = \mathbf{R}\)`

-   PCA on `\(\mathbf{R}\)` is calculated in the same way as that on `\(\mathbf{S}\)` (where `\(\hat{v}{}_1 + \dots + \hat{v}{}_p = p\)` )

-   The use of `\(\mathbf{R}, \mathbf{S}\)` depends on the purpose of PCA.

-   If the scale of the observations if different, covariance matrix is more preferable. but if they are dramatically different, analysis can still be dominated by the large variance traits.

# How many PCs to use can be guided by
##  

-   Scree Graphs: plot the eigenvalues against their indices. Look for the "elbow" where the steep decline in the graph suddenly flattens out; or big gaps.

-   minimum Percent of total variation (e.g., choose enough components to have 50% or 90%). can be used for interpretations.

-   Kaiser's rule: use only those PC with eigenvalues larger than 1 (applied to PCA on the correlation matrix) - ad hoc

-   Compare to the eigenvalue scree plot of data to the scree plot when the data are randomized.

# Application

- PCA on the covariance matrix is usually not preferred due to the fact that PCA is not invariant to changes in scale. Hence, PCA on the correlation matrix is more preferred

- This also addresses the problem of multicollinearity
- The eigvenvectors may differ by a multiplication of -1 for different implementation, but same interpretation.

# in R
## example 1


```r
library(tidyverse)
## Read in and check data
stock <- read.csv("D:/MY THESIS/stock.csv") |> 
  select(-1)
str(stock)
#> 'data.frame':	100 obs. of  5 variables:
#>  $ allied : num  0 0.027 0.1228 0.057 0.0637 ...
#>  $ dupont : num  0 -0.04485 0.06077 0.02995 -0.00379 ...
#>  $ carbide: num  0 -0.00303 0.08815 0.06681 -0.03979 ...
#>  $ exxon  : num  0.0395 -0.0145 0.0862 0.0135 -0.0186 ...
#>  $ texaco : num  0 0.0435 0.0781 0.0195 -0.0242 ...
```

# Covariance matrix


```r
## Covariance matrix of data
cov(stock)
#>               allied       dupont      carbide        exxon       texaco
#> allied  0.0016299269 0.0008166676 0.0008100713 0.0004422405 0.0005139715
#> dupont  0.0008166676 0.0012293759 0.0008276330 0.0003868550 0.0003109431
#> carbide 0.0008100713 0.0008276330 0.0015560763 0.0004872816 0.0004624767
#> exxon   0.0004422405 0.0003868550 0.0004872816 0.0008023323 0.0004084734
#> texaco  0.0005139715 0.0003109431 0.0004624767 0.0004084734 0.0007587370
```

# Correlation Matrix

```r
## Correlation matrix of data
cor(stock)
#>            allied    dupont   carbide     exxon    texaco
#> allied  1.0000000 0.5769244 0.5086555 0.3867206 0.4621781
#> dupont  0.5769244 1.0000000 0.5983841 0.3895191 0.3219534
#> carbide 0.5086555 0.5983841 1.0000000 0.4361014 0.4256266
#> exxon   0.3867206 0.3895191 0.4361014 1.0000000 0.5235293
#> texaco  0.4621781 0.3219534 0.4256266 0.5235293 1.0000000
```

#

```r
corrs = cor(stock)
corrplot(corrs, type="upper", method="color", addCoef.col = "black")
```

<img src="/post/2023-08-25-principal-component-analysis/pca_files/figure-html/unnamed-chunk-5-1.png" width="1023.999552" />

# PCA with covariance

```r
(cov_pca <- prcomp(stock)) # 
#> Standard deviations (1, .., p=5):
#> [1] 0.05996154 0.02814569 0.02713748 0.02255368 0.01854106
#> 
#> Rotation (n x k) = (5 x 5):
#>               PC1         PC2        PC3         PC4         PC5
#> allied  0.5605914  0.73884565 -0.1260222  0.28373183 -0.20846832
#> dupont  0.4698673 -0.09286987 -0.4675066 -0.68793190  0.28069055
#> carbide 0.5473322 -0.65401929 -0.1140581  0.50045312 -0.09603973
#> exxon   0.2908932 -0.11267353  0.6099196 -0.43808002 -0.58203935
#> texaco  0.2842017  0.07103332  0.6168831  0.06227778  0.72784638
```


# eigen values

```r
cov_results <- data.frame(eigen_values = cov_pca$sdev ^ 2)
cov_results |>
    mutate(proportion = eigen_values / sum(eigen_values),
           cumulative = cumsum(proportion)) # first 2 PCs account for 73% variance in the data
#>   eigen_values proportion cumulative
#> 1 0.0035953867 0.60159252  0.6015925
#> 2 0.0007921798 0.13255027  0.7341428
#> 3 0.0007364426 0.12322412  0.8573669
#> 4 0.0005086686 0.08511218  0.9424791
#> 5 0.0003437707 0.05752091  1.0000000
```


# eigen vectors

```r
cov_pca$rotation # prcomp calls rotation
#>               PC1         PC2        PC3         PC4         PC5
#> allied  0.5605914  0.73884565 -0.1260222  0.28373183 -0.20846832
#> dupont  0.4698673 -0.09286987 -0.4675066 -0.68793190  0.28069055
#> carbide 0.5473322 -0.65401929 -0.1140581  0.50045312 -0.09603973
#> exxon   0.2908932 -0.11267353  0.6099196 -0.43808002 -0.58203935
#> texaco  0.2842017  0.07103332  0.6168831  0.06227778  0.72784638
# princomp calls loadings.
```

# PCA with correlation

```r
#same as scale(stock) |> prcomp
cor_pca <- prcomp(stock, scale = T)
```

##

```r
# eigen values
cor_results <- data.frame(eigen_values = cor_pca$sdev ^ 2)
cor_results |>
    mutate(proportion = eigen_values / sum(eigen_values),
           cumulative = cumsum(proportion))
#>   eigen_values proportion cumulative
#> 1    2.8564869 0.57129738  0.5712974
#> 2    0.8091185 0.16182370  0.7331211
#> 3    0.5400440 0.10800880  0.8411299
#> 4    0.4513468 0.09026936  0.9313992
#> 5    0.3430038 0.06860076  1.0000000
```

+ first egiven values corresponds to less variance than PCA based on the covariance matrix

# eigen vectors


```r
cor_pca$rotation
#>               PC1        PC2        PC3        PC4        PC5
#> allied  0.4635405 -0.2408499  0.6133570 -0.3813727  0.4532876
#> dupont  0.4570764 -0.5090997 -0.1778996 -0.2113068 -0.6749814
#> carbide 0.4699804 -0.2605774 -0.3370355  0.6640985  0.3957247
#> exxon   0.4216770  0.5252647 -0.5390181 -0.4728036  0.1794482
#> texaco  0.4213291  0.5822416  0.4336029  0.3812273 -0.3874672
```
#
##

```r
summary(cor_pca)
#> Importance of components:
#>                           PC1    PC2    PC3     PC4    PC5
#> Standard deviation     1.6901 0.8995 0.7349 0.67182 0.5857
#> Proportion of Variance 0.5713 0.1618 0.1080 0.09027 0.0686
#> Cumulative Proportion  0.5713 0.7331 0.8411 0.93140 1.0000
```



# NB
##

*`Principal Component Analysis`* (PCA) is a dimension reduction method that aims at reducing the feature space, such that, most of the information or variability in the data set can be explained using fewer uncorrelated features.
> PCA works by receiving as input P variables (in this case six) and calculating the normalized linear combination of the P variables. This new variable is the linear combination of the six variables that captures the greatest variance out of all of them. PCA continues to calculate other normalized linear combinations **but** with the constraint that they need to be `completely uncorrelated` to all the other normalized linear combinations. Please see:

# Tidymodels Approach
##

Let's see this in action by creating a specification of a `recipe` that will estimate the *principal components* based on our six variables. We'll then `prep` and`bake` the recipe to apply the computations.

> PCA works well when the variables are normalized (`centered` and `scaled`)


```r
# Specify a recipe for pca
pca_rec <- recipe(~ ., data = stock) |> 
  step_normalize(all_predictors()) |> 
  step_pca(all_predictors(), num_comp = 2, id = "pca")

# Print out recipe
pca_rec
```

Compared to supervised learning techniques, we have no `outcome` variable in this recipe.

#
##

By calling `prep()` which estimates the statistics required by PCA and applying them to `seeds_features` using `bake(new_data = NULL)`, we can get the fitted PC transformation of our features.


```r
# Estimate required statistcs 
pca_estimates <- prep(pca_rec)

# Return preprocessed data using bake
features_2d <- pca_estimates |> 
  bake(new_data = NULL)

# Print baked data set
features_2d |> 
  slice_head(n = 5)
#> # A tibble: 5 x 2
#>      PC1    PC2
#>    <dbl>  <dbl>
#> 1  0.245  0.677
#> 2 -0.204  1.11 
#> 3  5.39   0.998
#> 4  2.00  -0.609
#> 5 -0.783 -0.973
```
#
##

These two components capture the maximum amount of information (i.e. variance) in the original variables. From the output of our prepped recipe `pca_estimates`, we can examine how much variance each component accounts for:


```r
# Examine how much variance each PC accounts for
pca_estimates |> 
  tidy(id = "pca", type = "variance") |> 
  filter(str_detect(terms, "percent"))
#> # A tibble: 10 x 4
#>    terms                        value component id   
#>    <chr>                        <dbl>     <int> <chr>
#>  1 percent variance             57.1          1 pca  
#>  2 percent variance             16.2          2 pca  
#>  3 percent variance             10.8          3 pca  
#>  4 percent variance              9.03         4 pca  
#>  5 percent variance              6.86         5 pca  
#>  6 cumulative percent variance  57.1          1 pca  
#>  7 cumulative percent variance  73.3          2 pca  
#>  8 cumulative percent variance  84.1          3 pca  
#>  9 cumulative percent variance  93.1          4 pca  
#> 10 cumulative percent variance 100            5 pca
```

#
##
This output tibbles and plots shows how well each principal component is explaining the original six variables. For example, the first principal component (PC1) explains about `57%` of the variance of the six variables. The second principal component explains an additional `16.18%`, giving a cumulative percent variance of `73.18%`. This is certainly better. It means that the first two variables seem to have some power in summarizing the original six variables.


```r
theme_set(theme_light())
# Plot how much variance each PC accounts for
pc<-pca_estimates |> 
  tidy(id = "pca", type = "variance") |> 
  filter(terms == "percent variance") |> 
  ggplot(mapping = aes(x = component, y = value)) +
  geom_col(fill = "midnightblue", alpha = 0.7) +
  ylab("% of total variance")
```

#

```r
pc
```

<img src="/post/2023-08-25-principal-component-analysis/pca_files/figure-html/unnamed-chunk-14-1.png" width="1023.999552" />

#

Naturally, the first PC (PC1) captures the most variance followed by PC2, then PC3, etc.

Now that we have the data points translated to two dimensions PC1 and PC2, we can visualize them in a plot:


```r
# Visualize PC scores
pd<-features_2d |> 
  ggplot(mapping = aes(x = PC1, y = PC2)) +
  geom_point(size = 2, color = "dodgerblue3")
```

#

```r
pd
```

<img src="/post/2023-08-25-principal-component-analysis/pca_files/figure-html/unnamed-chunk-15-1.png" width="1023.999552" />


# using factoextra

```r
# estimate pca scores by covariate

components <- prcomp(stock , scale = TRUE)

# apply rotation

components$rotation <- components$rotation

# show components

components$rotation|>
  as.data.frame()
#>               PC1        PC2        PC3        PC4        PC5
#> allied  0.4635405 -0.2408499  0.6133570 -0.3813727  0.4532876
#> dupont  0.4570764 -0.5090997 -0.1778996 -0.2113068 -0.6749814
#> carbide 0.4699804 -0.2605774 -0.3370355  0.6640985  0.3957247
#> exxon   0.4216770  0.5252647 -0.5390181 -0.4728036  0.1794482
#> texaco  0.4213291  0.5822416  0.4336029  0.3812273 -0.3874672
```

#

```r
fviz_screeplot(components, addlabels = TRUE, ylim = c(0, 36))+
  labs(title='Figure 11. Proportion of Variance Explained by Individual PCA Components (Dimensions)')
```

<img src="/post/2023-08-25-principal-component-analysis/pca_files/figure-html/unnamed-chunk-17-1.png" width="1023.999552" />


# assess variable importance to each if the first 4 components (dim)

```r
v1<-fviz_contrib(components, choice = "var", axes = 1, top = 10, title='Figure 12. Contribution of Variables \n to PCA1')
v2<-fviz_contrib(components, choice = "var", axes = 2, top = 10, title='Figure 13. Contribution of Variables \n to PCA2')
v3<-fviz_contrib(components, choice = "var", axes = 3, top = 10, title='Figure 14. Contribution of Variables \n to PCA3')
v4<-fviz_contrib(components, choice = "var", axes = 4, top = 10, title='Figure 15. Contribution of Variables \n to PCA4')
```

#


```r
v1|v2
```

<img src="/post/2023-08-25-principal-component-analysis/pca_files/figure-html/unnamed-chunk-19-1.png" width="1023.999552" />

#

```r
v3|v4
```

<img src="/post/2023-08-25-principal-component-analysis/pca_files/figure-html/unnamed-chunk-20-1.png" width="1023.999552" />

#

```r
fviz_pca_var(components, alpha.var = "contrib", col.var = "contrib", # Color by contributions to the PC
             gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07"),
             title = 'Figure 16. Influence of Variables on PCA1 and PCA2', repel = TRUE )
```

<img src="/post/2023-08-25-principal-component-analysis/pca_files/figure-html/unnamed-chunk-21-1.png" width="1023.999552" />

#

```r
#Graph of individuals. Individuals with a similar profile are grouped together.
fviz_pca_ind(components,col.ind = "contrib", gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07"),
             title='Figure 17. Distribution of seeds (seed property) based on PCA1 and PCA2',
             repel = TRUE)
```

<img src="/post/2023-08-25-principal-component-analysis/pca_files/figure-html/unnamed-chunk-22-1.png" width="1023.999552" />

#

```r
fviz_pca_ind(components, col.ind = "cos2", gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07"),
             title='Figure 17. Distribution of seeds (seed property) based on PCA1 and PCA2',
             repel = TRUE)
```

<img src="/post/2023-08-25-principal-component-analysis/pca_files/figure-html/unnamed-chunk-23-1.png" width="1023.999552" />

#

```r
#Biplot of individuals and variables
fviz_pca_biplot(components, repel = TRUE,
                title='Figure 18. Distribution of seeds based on seed property: from PCA1 and PCA2',
                col.var = "#2E9FDF",col.ind = "#696969")
```

<img src="/post/2023-08-25-principal-component-analysis/pca_files/figure-html/unnamed-chunk-24-1.png" width="1023.999552" />




