---
title: "dplyr vs Pandas"
author: "Bongani Ncube"
date: "2023-09-13"
slug: "dplyr-vs-pandas"
categories:
- dplyr
- pandas
- python
- R
tags: []
subtitle: ''
summary: ''
authors: []
lastmod: "2023-09-13T01:02:51+02:00"
featured: no
image:
  caption: ''
  focal_point: ''
  preview_only: no
projects: []
---

<script src="//yihui.org/js/math-code.js" defer></script>
<!-- Just one possible MathJax CDN below. You may use others. -->
<script defer
  src="//mathjax.rstudio.com/latest/MathJax.js?config=TeX-MML-AM_CHTML">
</script>



# Introduction

{{% callout note %}}

Over the years , the debate has always been  ...which one is better for data science ,R or Python? . I say it all depends with where you are coming from and as long as you get the job done . Rstudio is a great `IDE` that supports many languages such as `sql` ,`R` and `Python` . In this tutorial i will show you how to use `python` in Rstudio as well as compare the two software syntax inorder to leverage the power of both languages. Make sure you have installed `anaconda` here https://repo.anaconda.com/archive/Anaconda3-2023.07-2-Windows-x86_64.exe

{{% /callout %}}

# Set up


```r
# enable python in RMarkdown
library(tidyverse)
library(reticulate)
use_condaenv("base")
```

## Reading A CSV
### Python


```python
import pandas as pd

df = pd.read_csv('diabetes.csv')
df
#>      Pregnancies  Glucose  ...  Age  Outcome
#> 0              6      148  ...   50        1
#> 1              1       85  ...   31        0
#> 2              8      183  ...   32        1
#> 3              1       89  ...   21        0
#> 4              0      137  ...   33        1
#> ..           ...      ...  ...  ...      ...
#> 763           10      101  ...   63        0
#> 764            2      122  ...   27        0
#> 765            5      121  ...   30        0
#> 766            1      126  ...   47        1
#> 767            1       93  ...   23        0
#> 
#> [768 rows x 9 columns]
# verify whether the object df is a dataframe
type(df)
#> <class 'pandas.core.frame.DataFrame'>
```

### R


```r

library(tidyverse)

df <- read_csv('diabetes.csv')

# verify whether the object df is a dataframe
class(df)
#> [1] "spec_tbl_df" "tbl_df"      "tbl"         "data.frame"
```

## Storing a DataFrame to a CSV

### Python


```python
import pandas as pd

# access the R main module via the 'r' object
df = r.df

# Storing a DataFrame to a CSV, do not include the index
df.to_csv('diabetes_new.csv', index=False)

# verify the dataframe is indeed saved there (review Method #1)
diab = pd.read_csv('diabetes_new.csv')
type(diab)
#> <class 'pandas.core.frame.DataFrame'>
```


### R


```r

library(tidyverse)

# access the python main module via the 'py' object
df <- py$diab

# Storing a DataFrame to a CSV
write_csv(df, 'diabetes_clean.csv')

# verify the dataframe is indeed saved there (review Method #1)
diab_clean = read_csv('diabetes_clean.csv')
class(diab_clean)
#> [1] "spec_tbl_df" "tbl_df"      "tbl"         "data.frame"
```

## dimensions

### Python

`shape` returns the dimensionality (number_of_rows, number_of_columns) of a dataframe


```python
import pandas as pd

df = pd.read_csv('diabetes.csv')

df.shape
#> (768, 9)
```

### R

Similary, `dim()` in base R returns the dimensionality of a dataframe


```r
library(readr) # a package in tidyverse that allows us to use read_csv

df <- read_csv('diabetes.csv')

dim(df)
#> [1] 768   9
```

## first terms
### Python

Use `head()` to show the top N rows. 


```python
import pandas as pd

df = pd.read_csv('diabetes.csv')

# print the top 3 rows in the dataframe
print(df.head(3))
#>    Pregnancies  Glucose  BloodPressure  ...  DiabetesPedigreeFunction  Age  Outcome
#> 0            6      148             72  ...                     0.627   50        1
#> 1            1       85             66  ...                     0.351   31        0
#> 2            8      183             64  ...                     0.672   32        1
#> 
#> [3 rows x 9 columns]
```


We can also sort the dataframe first then show the top N. For more on sorting a dataframe, please refer to method 13.


```python
# to sort the dataframe first then check out the top N
df.sort_values('Age')\
  .head(5)
#>      Pregnancies  Glucose  ...  Age  Outcome
#> 255            1      113  ...   21        1
#> 60             2       84  ...   21        0
#> 102            0      125  ...   21        0
#> 182            1        0  ...   21        0
#> 623            0       94  ...   21        0
#> 
#> [5 rows x 9 columns]
```

### R

To do these tasks in R is pretty straightforward. 


```r

df <- py$df # get the dataframe from python

# print the top 3 rows in the dataframe
print(df |>  head(3))
#>   Pregnancies Glucose BloodPressure SkinThickness Insulin  BMI
#> 1           6     148            72            35       0 33.6
#> 2           1      85            66            29       0 26.6
#> 3           8     183            64             0       0 23.3
#>   DiabetesPedigreeFunction Age Outcome
#> 1                    0.627  50       1
#> 2                    0.351  31       0
#> 3                    0.672  32       1
```

To sort first, we can use the `arrange()` function in the dplyr package.


```r

library(dplyr) 

# to sort the dataframe first then check out the top N
df |> 
  arrange(Age) |> 
  relocate(Age) |> 
  head(5)
#>   Age Pregnancies Glucose BloodPressure SkinThickness Insulin  BMI
#> 1  21           1      89            66            23      94 28.1
#> 2  21           1      73            50            10       0 23.0
#> 3  21           2      84             0             0       0  0.0
#> 4  21           1      80            55             0       0 19.1
#> 5  21           2     142            82            18      64 24.7
#>   DiabetesPedigreeFunction Outcome
#> 1                    0.167       0
#> 2                    0.248       0
#> 3                    0.304       0
#> 4                    0.258       0
#> 5                    0.761       0
```

## Printing the Datatype of

### Python


```python
# .dtypes returns the data type of all
df.dtypes
#> Pregnancies                   int64
#> Glucose                       int64
#> BloodPressure                 int64
#> SkinThickness                 int64
#> Insulin                       int64
#> BMI                         float64
#> DiabetesPedigreeFunction    float64
#> Age                           int64
#> Outcome                       int64
#> dtype: object
```

### R

{{% callout note %}}
The `str()` function in base R returns the data type of all, the default option also returns the dimensionality of the dataframe, length and head of each column, and gives attributes as sub structures. 
{{% /callout %}}



```r
df |> str(give.attr = FALSE)
#> 'data.frame':	768 obs. of  9 variables:
#>  $ Pregnancies             : num  6 1 8 1 0 5 3 10 2 8 ...
#>  $ Glucose                 : num  148 85 183 89 137 116 78 115 197 125 ...
#>  $ BloodPressure           : num  72 66 64 66 40 74 50 0 70 96 ...
#>  $ SkinThickness           : num  35 29 0 23 35 0 32 0 45 0 ...
#>  $ Insulin                 : num  0 0 0 94 168 0 88 0 543 0 ...
#>  $ BMI                     : num  33.6 26.6 23.3 28.1 43.1 25.6 31 35.3 30.5 0 ...
#>  $ DiabetesPedigreeFunction: num  0.627 0.351 0.672 0.167 2.288 ...
#>  $ Age                     : num  50 31 32 21 33 30 26 29 53 54 ...
#>  $ Outcome                 : num  1 0 1 0 1 0 1 0 1 1 ...
```

Another option is `glimpse()` function in the dplyr package, which returns the dimensionality of the dataframe, data type of all and the head of each column as well.


```r

library(dplyr)

df |> glimpse()
#> Rows: 768
#> Columns: 9
#> $ Pregnancies              <dbl> 6, 1, 8, 1, 0, 5, 3, 10, 2, 8, 4, 10, 10, 1, ~
#> $ Glucose                  <dbl> 148, 85, 183, 89, 137, 116, 78, 115, 197, 125~
#> $ BloodPressure            <dbl> 72, 66, 64, 66, 40, 74, 50, 0, 70, 96, 92, 74~
#> $ SkinThickness            <dbl> 35, 29, 0, 23, 35, 0, 32, 0, 45, 0, 0, 0, 0, ~
#> $ Insulin                  <dbl> 0, 0, 0, 94, 168, 0, 88, 0, 543, 0, 0, 0, 0, ~
#> $ BMI                      <dbl> 33.6, 26.6, 23.3, 28.1, 43.1, 25.6, 31.0, 35.~
#> $ DiabetesPedigreeFunction <dbl> 0.627, 0.351, 0.672, 0.167, 2.288, 0.201, 0.2~
#> $ Age                      <dbl> 50, 31, 32, 21, 33, 30, 26, 29, 53, 54, 30, 3~
#> $ Outcome                  <dbl> 1, 0, 1, 0, 1, 0, 1, 0, 1, 1, 0, 1, 0, 1, 1, ~
```

## Modifying the Datatype of a Column

### Python


```python
import pandas as pd

data = {'id': [1,2,3,4,5],
        'name': ['Bongani', 'blaize', 'Ncube', 'Ropae', 'James']}
      
df1 = pd.DataFrame(data)

df1.dtypes
#> id       int64
#> name    object
#> dtype: object
```

The id field is of integer type. Use `astype()` method to change it to string/character type as follows. 


```python
df2 = df1.copy()
# change the id field to string/character type
df2['id'] = df2['id'].astype(str)
df2.dtypes
#> id      object
#> name    object
#> dtype: object
```

### R


```r
# get the dataframe from python
df1 = py$df1

library(dplyr)

df1 |>  glimpse()
#> Rows: 5
#> Columns: 2
#> $ id   <dbl> 1, 2, 3, 4, 5
#> $ name <chr> "Bongani", "blaize", "Ncube", "Ropae", "James"
```

{{% callout note %}}
Use the `as.character()` function to change the id field into string/character type, and use `as.numeric()` function to change it back to numeric. (id: what did I do? :p)

{{% /callout %}}


```r

# change the id field to string/character type
df1 =df1 |> mutate(id = as.character(id))
df1 |>  glimpse()
#> Rows: 5
#> Columns: 2
#> $ id   <chr> "1", "2", "3", "4", "5"
#> $ name <chr> "Bongani", "blaize", "Ncube", "Ropae", "James"

# change the id field back to numeric type
df1 = df1 |> mutate(id = as.numeric(id))
df1 |> glimpse()
#> Rows: 5
#> Columns: 2
#> $ id   <dbl> 1, 2, 3, 4, 5
#> $ name <chr> "Bongani", "blaize", "Ncube", "Ropae", "James"
```



## Printing Descriptive Info about the DataFrame 

### Python

`info()` method can be used to print the missing-value stats and the datatypes. Recall that we can also get datatypes info using `.dtypes`.


```python
df.info()
#> <class 'pandas.core.frame.DataFrame'>
#> RangeIndex: 768 entries, 0 to 767
#> Data columns (total 9 columns):
#>  #   Column                    Non-Null Count  Dtype  
#> ---  ------                    --------------  -----  
#>  0   Pregnancies               768 non-null    int64  
#>  1   Glucose                   768 non-null    int64  
#>  2   BloodPressure             768 non-null    int64  
#>  3   SkinThickness             768 non-null    int64  
#>  4   Insulin                   768 non-null    int64  
#>  5   BMI                       768 non-null    float64
#>  6   DiabetesPedigreeFunction  768 non-null    float64
#>  7   Age                       768 non-null    int64  
#>  8   Outcome                   768 non-null    int64  
#> dtypes: float64(2), int64(7)
#> memory usage: 54.1 KB
```

### R

`summary()` in base R returns the number of missings as well as some summary statistics. 



```r

df |>  summary()
#>   Pregnancies        Glucose      BloodPressure    SkinThickness  
#>  Min.   : 0.000   Min.   :  0.0   Min.   :  0.00   Min.   : 0.00  
#>  1st Qu.: 1.000   1st Qu.: 99.0   1st Qu.: 62.00   1st Qu.: 0.00  
#>  Median : 3.000   Median :117.0   Median : 72.00   Median :23.00  
#>  Mean   : 3.845   Mean   :120.9   Mean   : 69.11   Mean   :20.54  
#>  3rd Qu.: 6.000   3rd Qu.:140.2   3rd Qu.: 80.00   3rd Qu.:32.00  
#>  Max.   :17.000   Max.   :199.0   Max.   :122.00   Max.   :99.00  
#>     Insulin           BMI        DiabetesPedigreeFunction      Age       
#>  Min.   :  0.0   Min.   : 0.00   Min.   :0.0780           Min.   :21.00  
#>  1st Qu.:  0.0   1st Qu.:27.30   1st Qu.:0.2437           1st Qu.:24.00  
#>  Median : 30.5   Median :32.00   Median :0.3725           Median :29.00  
#>  Mean   : 79.8   Mean   :31.99   Mean   :0.4719           Mean   :33.24  
#>  3rd Qu.:127.2   3rd Qu.:36.60   3rd Qu.:0.6262           3rd Qu.:41.00  
#>  Max.   :846.0   Max.   :67.10   Max.   :2.4200           Max.   :81.00  
#>     Outcome     
#>  Min.   :0.000  
#>  1st Qu.:0.000  
#>  Median :0.000  
#>  Mean   :0.349  
#>  3rd Qu.:1.000  
#>  Max.   :1.000
```

## Printing Descriptive Info about the DataFrame (Method 2)

### Python

`describe()` returns standard statistics like mean, standard deviation, maximum etc. of every numeric-valued column


```python
df.describe()
#>        Pregnancies     Glucose  ...         Age     Outcome
#> count   768.000000  768.000000  ...  768.000000  768.000000
#> mean      3.845052  120.894531  ...   33.240885    0.348958
#> std       3.369578   31.972618  ...   11.760232    0.476951
#> min       0.000000    0.000000  ...   21.000000    0.000000
#> 25%       1.000000   99.000000  ...   24.000000    0.000000
#> 50%       3.000000  117.000000  ...   29.000000    0.000000
#> 75%       6.000000  140.250000  ...   41.000000    1.000000
#> max      17.000000  199.000000  ...   81.000000    1.000000
#> 
#> [8 rows x 9 columns]
```

`describe()` can also offer some info on categorical: the number of unique values, the most frequent value and its frequency, if we add `include = all` argument


```python
df.describe(include = 'all')
#>        Pregnancies     Glucose  ...         Age     Outcome
#> count   768.000000  768.000000  ...  768.000000  768.000000
#> mean      3.845052  120.894531  ...   33.240885    0.348958
#> std       3.369578   31.972618  ...   11.760232    0.476951
#> min       0.000000    0.000000  ...   21.000000    0.000000
#> 25%       1.000000   99.000000  ...   24.000000    0.000000
#> 50%       3.000000  117.000000  ...   29.000000    0.000000
#> 75%       6.000000  140.250000  ...   41.000000    1.000000
#> max      17.000000  199.000000  ...   81.000000    1.000000
#> 
#> [8 rows x 9 columns]
```

### R

As discussed in Method 9, `summary()` in base R returns the number of missings as well as some summary statistics for all numerical and factor.  


```r

df = py$df

df |>  summary()
#>   Pregnancies        Glucose      BloodPressure    SkinThickness  
#>  Min.   : 0.000   Min.   :  0.0   Min.   :  0.00   Min.   : 0.00  
#>  1st Qu.: 1.000   1st Qu.: 99.0   1st Qu.: 62.00   1st Qu.: 0.00  
#>  Median : 3.000   Median :117.0   Median : 72.00   Median :23.00  
#>  Mean   : 3.845   Mean   :120.9   Mean   : 69.11   Mean   :20.54  
#>  3rd Qu.: 6.000   3rd Qu.:140.2   3rd Qu.: 80.00   3rd Qu.:32.00  
#>  Max.   :17.000   Max.   :199.0   Max.   :122.00   Max.   :99.00  
#>     Insulin           BMI        DiabetesPedigreeFunction      Age       
#>  Min.   :  0.0   Min.   : 0.00   Min.   :0.0780           Min.   :21.00  
#>  1st Qu.:  0.0   1st Qu.:27.30   1st Qu.:0.2437           1st Qu.:24.00  
#>  Median : 30.5   Median :32.00   Median :0.3725           Median :29.00  
#>  Mean   : 79.8   Mean   :31.99   Mean   :0.4719           Mean   :33.24  
#>  3rd Qu.:127.2   3rd Qu.:36.60   3rd Qu.:0.6262           3rd Qu.:41.00  
#>  Max.   :846.0   Max.   :67.10   Max.   :2.4200           Max.   :81.00  
#>     Outcome     
#>  Min.   :0.000  
#>  1st Qu.:0.000  
#>  Median :0.000  
#>  Mean   :0.349  
#>  3rd Qu.:1.000  
#>  Max.   :1.000
```


For categorical variables, like `Species` in the iris dataset, `summary()` could give us its frequency counts if we turn it into factor type in R. 


```r

library(dplyr) #for mutate

df |> 
  mutate(Outcome = as.factor(Outcome)) |> # see method17 for more on mutate()   
  summary()
#>   Pregnancies        Glucose      BloodPressure    SkinThickness  
#>  Min.   : 0.000   Min.   :  0.0   Min.   :  0.00   Min.   : 0.00  
#>  1st Qu.: 1.000   1st Qu.: 99.0   1st Qu.: 62.00   1st Qu.: 0.00  
#>  Median : 3.000   Median :117.0   Median : 72.00   Median :23.00  
#>  Mean   : 3.845   Mean   :120.9   Mean   : 69.11   Mean   :20.54  
#>  3rd Qu.: 6.000   3rd Qu.:140.2   3rd Qu.: 80.00   3rd Qu.:32.00  
#>  Max.   :17.000   Max.   :199.0   Max.   :122.00   Max.   :99.00  
#>     Insulin           BMI        DiabetesPedigreeFunction      Age       
#>  Min.   :  0.0   Min.   : 0.00   Min.   :0.0780           Min.   :21.00  
#>  1st Qu.:  0.0   1st Qu.:27.30   1st Qu.:0.2437           1st Qu.:24.00  
#>  Median : 30.5   Median :32.00   Median :0.3725           Median :29.00  
#>  Mean   : 79.8   Mean   :31.99   Mean   :0.4719           Mean   :33.24  
#>  3rd Qu.:127.2   3rd Qu.:36.60   3rd Qu.:0.6262           3rd Qu.:41.00  
#>  Max.   :846.0   Max.   :67.10   Max.   :2.4200           Max.   :81.00  
#>  Outcome
#>  0:500  
#>  1:268  
#>         
#>         
#>         
#> 
```

In python, we could use `value_counts()` to get frequency counts. See #method27 for more.


```python
df['Outcome'].value_counts()
#> 0    500
#> 1    268
#> Name: Outcome, dtype: int64
```

## Filling NaN values

### Python

We can use the `df.fillna()` method to replace missing values with a specific value. Let's start by creating a dataframe with missing values. 


```python
import pandas as pd
import numpy as np

df = pd.DataFrame({'col1': [1,2],
                   'col2': [3,np.nan],
                   'col3': ['A',np.nan]})
print(df)
#>    col1  col2 col3
#> 0     1   3.0    A
#> 1     2   NaN  NaN
```

To replace the missing value with `0`, just do `.fillna(0)`. 


```python
# replace all NA values with 0, inplace = True means df itself will be modefied
df.fillna(0, inplace = True)
print(df)
#>    col1  col2 col3
#> 0     1   3.0    A
#> 1     2   0.0    0
```

Or if you only wnat to replace missing values in one particular column, simply select it first


```python
df2 = df.copy()
df2['col2'].fillna(0, inplace = True) 
print(df2)
#>    col1  col2 col3
#> 0     1   3.0    A
#> 1     2   0.0    0
```


### R

We can use either `replace()` in base R to replace all missings in a dataframe with a specific value, or `replace_na` in tidyr to offer tailored replacement for each specific column.


```r

df = data.frame(col1 = c(1,2),
                col2 = c(3, NA),
                col3 = c('A',NA))

print(df)
#>   col1 col2 col3
#> 1    1    3    A
#> 2    2   NA <NA>

# use replace() in base R to replace all missings to 0
replace(df, is.na(df), 0)
#>   col1 col2 col3
#> 1    1    3    A
#> 2    2    0    0

library(tidyr)
# or use replace_na() in tidyverse to offer tailored replacement for each column. 
df |>  replace_na(list(col2=0,col3="Unknown"))
#>   col1 col2    col3
#> 1    1    3       A
#> 2    2    0 Unknown
```



## Grouping a DataFrame


### Python

{{% callout note %}}
We can use the `groupby` method in Pandas to group a dataframe and then perform aggregations with `agg()`. We could put both methods in one line, or wrap the chain of methods in brackets and show them in separate lines. The latter can enhance readability when we have multiple methods chained together. 
{{% /callout %}}


```python

import pandas as pd

df = pd.DataFrame([[1, 2,  "A"], 
                   [5, 8,  "B"], 
                   [3, 10, "B"]], 
                  = ["col1", "col2", "col3"])

# put both methods in one line 
df.groupby('col3').agg({'col1':sum, 'col2':max}) # 

```



```python
# alternatively, show each method in separate lines
(df
 .groupby("col3")
 .agg({"col1":sum, "col2":max}) # get sum for col1 and max for col2
 )
```

Above we specify different aggregates for each column, but the code can be simplified if same aggregates are needed for all.


```python
(df
 .groupby("col3")
 .agg(['min','max','median']) # get these three aggregates for all
)

```

### R

In `tidyverse`, similarly we use `group_by()` to do the grouping, then use `summarize()` for the aggregation.



```r
library(dplyr)

df <- py$df

df |> 
  group_by(col3) |> 
  summarise(col1_sum = sum(col1),
            col2_max = max(col2))

```

## complex aggregation

### R

{{% callout note %}}
What if we want to do a slightly more complex aggregation which is not available as a default function/method? Let's say we want to add a column to represent percentage within each group. For example, below we have the sale of three types of fruits in two months. We would like to add a column `pct_month` to represent the sale of each fruit within each month. 
{{% /callout %}}


```r

df <- data.frame(
  month = c(rep('Jan',3), rep('Feb',3)),
  fruit = c('Apple', 'Kiwi','banana', 'Apple', 'Kiwi','banana'),
  sale = c(20,30, 30,30,20,15)
)

df
#>   month  fruit sale
#> 1   Jan  Apple   20
#> 2   Jan   Kiwi   30
#> 3   Jan banana   30
#> 4   Feb  Apple   30
#> 5   Feb   Kiwi   20
#> 6   Feb banana   15
```


Notice that here we need one value for *each row*, rather than one value for *each group*. Therefore, instead of using `summarize()` as we did above, this time `mutate()` function is our friend. We can also easily add a `round()` function to round the percentage.


```r
func<-function(x){
  ratio<-x/sum(x)
  return(ratio)
}
df |>  
  group_by(month) |>  
  mutate(pct_month = func(sale) |> round(3) * 100)
#> # A tibble: 6 x 4
#> # Groups:   month [2]
#>   month fruit   sale pct_month
#>   <chr> <chr>  <dbl>     <dbl>
#> 1 Jan   Apple     20      25  
#> 2 Jan   Kiwi      30      37.5
#> 3 Jan   banana    30      37.5
#> 4 Feb   Apple     30      46.2
#> 5 Feb   Kiwi      20      30.8
#> 6 Feb   banana    15      23.1
```


### Python

Now let's see how to do this in Python. We can create a function first, then call it with the `transform()` method.


```python
df = r.df 

def pct_total(s):
  return s/sum(s)

df['pct_month'] = (df
                    .groupby('month')['sale']
                    .transform(pct_total).round(3) * 100
                    )
df
#>   month   fruit  sale  pct_month
#> 0   Jan   Apple  20.0       25.0
#> 1   Jan    Kiwi  30.0       37.5
#> 2   Jan  banana  30.0       37.5
#> 3   Feb   Apple  30.0       46.2
#> 4   Feb    Kiwi  20.0       30.8
#> 5   Feb  banana  15.0       23.1
```

## Create a dataframe in Python


```python
import pandas as pd

df = pd.DataFrame({'col1': [1,5,3],
                   'col2': [8,4,10],
                   'col3': ['A','B','B']})
df
#>    col1  col2 col3
#> 0     1     8    A
#> 1     5     4    B
#> 2     3    10    B
```


### Load the dataframe into R


```r
df <- py$df #load the df object created in Python above

df
#>   col1 col2 col3
#> 1    1    8    A
#> 2    5    4    B
#> 3    3   10    B
```

## Filtering a DataFrame1: Boolean Filtering

### Filter with a value

A row can be selected when the condition specified is evaluated to be True for it. For example 

### Python


```python
df[df['col2']>5]
#>    col1  col2 col3
#> 0     1     8    A
#> 2     3    10    B
```



```python
# or to improve readability, we could do it in two steps
col2_larger_than_5 = df['col2'] > 5
df[col2_larger_than_5]
#>    col1  col2 col3
#> 0     1     8    A
#> 2     3    10    B
```




### R


```r

library(dplyr)

df |> 
  filter(col2 > 5)
#>   col1 col2 col3
#> 1    1    8    A
#> 2    3   10    B
```






