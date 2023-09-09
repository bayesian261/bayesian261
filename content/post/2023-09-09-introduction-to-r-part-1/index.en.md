---
title: 'Introduction to R : Part 2'
author: Bongani Ncube
date: '2023-09-09'
slug: introduction-to-r-part-2
categories:
  - rstudio
  - R
tags: []
subtitle: ''
summary: ''
authors: []
lastmod: '2023-09-09T13:52:18+02:00'
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



# Working with dataframes

The dataframe is the most common data structure used by analysts in R, due to its similarity to data tables found in databases and spreadsheets.  We will work almost entirely with dataframes in this book, so let's get to know them.

### Loading and tidying data in dataframes

To work with data in R, you usually need to pull it in from an outside source into a dataframe^[R also has some built-in data sets for testing and playing with.  For example, check out `mtcars` by typing it into the terminal, or type `data()` to see a full list of built-in data sets.].  R facilitates numerous ways of importing data from simple `.csv` files, from Excel files, from online sources or from databases.  Let's load a data set that we will use later---the `loan_data` data set,   The `read.csv()` function can accept a URL or a path address of the file.

# read in data

```r
# PATH TO data set 
PATH <- "D:/ALLSTUFF/BONGANI-NCUBE/loan_data.csv"
# load the data set and store it as a dataframe called loan_data
#loan_data <- readr::read_csv(PATH)
loan_data<-read.csv(PATH)
```

# head() and dim()

We might not want to display this entire data set before knowing how big it is.  We can view the dimensions, and if it is too big to display, we can use the `head()` function to display just the first few rows.

##


```r
dim(loan_data)
#> [1] 29092     9

# hundreds of rows, so view first few
head(loan_data)
#>   X loan_status loan_amnt int_rate grade emp_length home_ownership annual_inc
#> 1 1           0      5000    10.65     B         10           RENT      24000
#> 2 2           0      2400       NA     C         25           RENT      12252
#> 3 3           0     10000    13.49     C         13           RENT      49200
#> 4 4           0      5000       NA     A          3           RENT      36000
#> 5 5           0      3000       NA     E          9           RENT      48000
#> 6 6           0     12000    12.69     B         11            OWN      75000
#>   age
#> 1  33
#> 2  31
#> 3  24
#> 4  39
#> 5  24
#> 6  28
```


We can view a specific column by using `$`, and we can use square brackets to view a specific entry.   For example if we wanted to see the 6th entry of the `loan_amnt` column:

##

```r
loan_data$loan_amnt[6]
#> [1] 12000
```

#

Alternatively, we can use a `[row, column]` index to get a specific entry in the dataframe.

##

```r
loan_data[34, 4]
#> [1] 16.77
```

We can take a look at the data types using `str()`.

##

```r
str(loan_data)
#> 'data.frame':	29092 obs. of  9 variables:
#>  $ X             : int  1 2 3 4 5 6 7 8 9 10 ...
#>  $ loan_status   : int  0 0 0 0 0 0 1 0 1 0 ...
#>  $ loan_amnt     : int  5000 2400 10000 5000 3000 12000 9000 3000 10000 1000 ...
#>  $ int_rate      : num  10.6 NA 13.5 NA NA ...
#>  $ grade         : chr  "B" "C" "C" "A" ...
#>  $ emp_length    : int  10 25 13 3 9 11 0 3 3 0 ...
#>  $ home_ownership: chr  "RENT" "RENT" "RENT" "RENT" ...
#>  $ annual_inc    : num  24000 12252 49200 36000 48000 ...
#>  $ age           : int  33 31 24 39 24 28 22 22 28 22 ...
```

#

We can also see a statistical summary of each column using `summary()`, which tells us various statistics depending on the type of the column.


```r
summary(loan_data)
#>        X          loan_status       loan_amnt        int_rate    
#>  Min.   :    1   Min.   :0.0000   Min.   :  500   Min.   : 5.42  
#>  1st Qu.: 7274   1st Qu.:0.0000   1st Qu.: 5000   1st Qu.: 7.90  
#>  Median :14546   Median :0.0000   Median : 8000   Median :10.99  
#>  Mean   :14546   Mean   :0.1109   Mean   : 9594   Mean   :11.00  
#>  3rd Qu.:21819   3rd Qu.:0.0000   3rd Qu.:12250   3rd Qu.:13.47  
#>  Max.   :29092   Max.   :1.0000   Max.   :35000   Max.   :23.22  
#>                                                   NA's   :2776   
#>     grade             emp_length     home_ownership       annual_inc     
#>  Length:29092       Min.   : 0.000   Length:29092       Min.   :   4000  
#>  Class :character   1st Qu.: 2.000   Class :character   1st Qu.:  40000  
#>  Mode  :character   Median : 4.000   Mode  :character   Median :  56424  
#>                     Mean   : 6.145                      Mean   :  67169  
#>                     3rd Qu.: 8.000                      3rd Qu.:  80000  
#>                     Max.   :62.000                      Max.   :6000000  
#>                     NA's   :809                                          
#>       age       
#>  Min.   : 20.0  
#>  1st Qu.: 23.0  
#>  Median : 26.0  
#>  Mean   : 27.7  
#>  3rd Qu.: 30.0  
#>  Max.   :144.0  
#> 
```

#

Note that there is missing data in this dataframe, indicated by `NA`s in the summary.  Missing data is identified by a special `NA` value in R.  This should not be confused with `"NA"`, which is simply a character string.  The function `is.na()` will look at all values in a vector or dataframe and return `TRUE` or `FALSE` based on whether they are `NA` or not.  By adding these up using the `sum()` function, it will take `TRUE` as 1 and `FALSE` as 0, which effectively provides a count of missing data.


```r
sum(is.na(loan_data))
#> [1] 3585
```

#

This is a small number of `NA`s given the dimensions of our data set and we might want to remove the rows of data that contain NAs.  The easiest way is to use the `complete.cases()` function, which identifies the rows that have no `NA`s, and then we can select those rows from the dataframe based on that condition.  Note that you can overwrite objects with the same name in R.


```r
loan_data <- loan_data[complete.cases(loan_data), ]
# confirm no NAs
sum(is.na(loan_data))
#> [1] 0
```

#

We can see the unique values of a vector or column using the `unique()` function.

```r
unique(loan_data$home_ownership)
#> [1] "RENT"     "OWN"      "MORTGAGE" "OTHER"
```

If we need to change the type of a column in a dataframe, we can use the `as.numeric()`, `as.character()`, `as.logical()` or `as.factor()` functions.  For example, given that there are only four unique values for the `loan_status` column, we may want to convert it to a factor.

##

```r
loan_data$loan_status <- as.factor(loan_data$loan_status)
str(loan_data)
#> 'data.frame':	25571 obs. of  9 variables:
#>  $ X             : int  1 3 6 7 8 9 10 12 14 15 ...
#>  $ loan_status   : Factor w/ 2 levels "0","1": 1 1 1 2 1 2 1 1 1 2 ...
#>  $ loan_amnt     : int  5000 10000 12000 9000 3000 10000 1000 3600 9200 21000 ...
#>  $ int_rate      : num  10.65 13.49 12.69 13.49 9.91 ...
#>  $ grade         : chr  "B" "C" "B" "C" ...
#>  $ emp_length    : int  10 13 11 0 3 3 0 13 6 17 ...
#>  $ home_ownership: chr  "RENT" "RENT" "OWN" "RENT" ...
#>  $ annual_inc    : num  24000 49200 75000 30000 15000 ...
#>  $ age           : int  33 24 28 22 22 28 22 27 24 29 ...
```

# Manipulating dataframes

Dataframes can be subsetted to contain only rows that satisfy specific conditions.

```r
loan_amnt_10000 <- subset(loan_data, subset = loan_amnt == 10000)
loan_amnt_10000 %>% head()
#>     X loan_status loan_amnt int_rate grade emp_length home_ownership annual_inc
#> 3   3           0     10000    13.49     C         13           RENT      49200
#> 9   9           1     10000    10.65     B          3           RENT     100000
#> 16 16           0     10000    11.71     B         13            OWN      50000
#> 17 17           0     10000    11.71     B          5           RENT      50000
#> 38 38           0     10000    10.65     B          6           RENT      27000
#> 46 46           0     10000    12.42     B          0            OWN      39000
#>    age
#> 3   24
#> 9   28
#> 16  23
#> 17  22
#> 38  23
#> 46  33
```

#

Note the use of `==`, which is used in many programming languages, to test for precise equality.  Similarly we can select columns based on inequalities (`>` for 'greater than'\&zwj;, `<` for 'less than'\&zwj;, `>=` for 'greater than or equal to'\&zwj;, `<=` for 'less than or equal to'\&zwj;, or `!=` for 'not equal to').  For example:


```r
high_loan_amnt <- subset(loan_data, subset = loan_amnt >= 20000)
head(high_loan_amnt)
#>       X loan_status loan_amnt int_rate grade emp_length home_ownership
#> 15   15           1     21000    12.42     B         17           RENT
#> 24   24           0     31825     7.90     A          5       MORTGAGE
#> 76   76           0     24000    10.65     B         15           RENT
#> 94   94           0     35000     8.90     A          6       MORTGAGE
#> 97   97           1     24000    15.96     C          8       MORTGAGE
#> 124 124           0     22000     9.91     B          2       MORTGAGE
#>     annual_inc age
#> 15      105000  29
#> 24       75000  23
#> 76       45000  40
#> 94      125000  23
#> 97       90000  24
#> 124      50000  22
```

#

To select specific columns use the `select` argument.


```r
loan_data_loan_amnt_status <- subset(loan_data, 
                                 select = c("loan_amnt", "loan_status"))
head(loan_data_loan_amnt_status)
#>   loan_amnt loan_status
#> 1      5000           0
#> 3     10000           0
#> 6     12000           0
#> 7      9000           1
#> 8      3000           0
#> 9     10000           1
```
#

Two dataframes with the same column names can be combined by their rows.


```r
low_loan_amnt <- subset(loan_data, subset = loan_amnt < 8000)

# bind the rows of low_loan_amnt and high_loan_amnt together
low_and_high_loan_amnt = rbind(low_loan_amnt, high_loan_amnt)
head(low_and_high_loan_amnt)
#>     X loan_status loan_amnt int_rate grade emp_length home_ownership annual_inc
#> 1   1           0      5000    10.65     B         10           RENT      24000
#> 8   8           0      3000     9.91     B          3           RENT      15000
#> 10 10           0      1000    16.29     D          0           RENT      28000
#> 12 12           0      3600     6.03     A         13       MORTGAGE     110000
#> 18 18           1      6000    11.71     B          1           RENT      76000
#> 21 21           0      4000    11.71     B         19       MORTGAGE     106000
#>    age
#> 1   33
#> 8   22
#> 10  22
#> 12  27
#> 18  31
#> 21  27
```
#
Two dataframes with different column names can be combined by their columns.


```r
# two dataframes with two columns each
loan_amnt_perf <- subset(loan_data, 
                     select = c("loan_amnt", "loan_status"))
prom_custrate <- subset(loan_data, 
                        select = c("home_ownership", "grade"))

# bind the columns to create a dataframe with four columns
full_df <- cbind(loan_amnt_perf, prom_custrate)
head(full_df)
#>   loan_amnt loan_status home_ownership grade
#> 1      5000           0           RENT     B
#> 3     10000           0           RENT     C
#> 6     12000           0            OWN     B
#> 7      9000           1           RENT     C
#> 8      3000           0           RENT     B
#> 9     10000           1           RENT     B
```

# Functions, packages and libraries

In the code so far we have used a variety of functions.  For example `head()`, `subset()`, `rbind()`.  Functions are operations that take certain defined inputs and return an output.  Functions exist to perform common useful operations.



# Help with functions

Most functions in R have excellent help documentation.  To get help on the `head()` function, type `help(head)` or `?head`.  This will display the results in the Help browser window in RStudio.  Alternatively you can open the Help browser window directly in RStudio and do a search there. 

# The help page normally shows the following:

* Description of the purpose of the function
* Usage examples, so you can quickly see how it is used
* Arguments list so you can see the names and order of arguments
* Details or notes on further considerations on use
* Expected value of the output (for example `head()` is expected to return a similar object to its first input `x`)
* Examples to help orient you further (sometimes examples can be very abstract in nature and not so helpful to users)

# Installing packages

Before an external package can be used, it must be installed into your package library using `install.packages()`.  So to install `MASS`, type `install.packages("MASS")` into the console.  This will send R to the main internet repository for R packages (known as CRAN). It will find the right version of `MASS` for your operating system and download and install it into your package library.  If `MASS` needs other packages in order to work, it will also install these packages.  

If you want to install more than one package, put the names of the packages inside a character vector---for example:


```r
my_packages <- c("MASS", "DescTools", "dplyr")
install.packages(my_packages)
```

# 

Once you have installed a package, you can see what functions are available by calling for help on it, for example using `help(package = MASS)`.  

## Using packages

Once you have installed a package into your package library, to use it in your R session you need to load it using the  `library()` function. For example, to load `MASS` after installing it, use `library(MASS)`.  Often nothing will happen when you use this command, but rest assured the package has been loaded and you can start to use the functions inside it.  Sometimes when you load the package a series of messages will display, usually to make you aware of certain things that you need to keep in mind when using the package. If you have not installed the package, the `library()` command will f
fail.
 
# 
##

Problems can occur when you load packages that contain functions with the same name as functions that already exist in your R session.  Often the messages you see when loading a package will alert you to this.  When R is faced with a situation where a function exists in multiple packages you have loaded, R always defaults to the function in *the most recently loaded* package.  This may not always be what you intended.

#

One way to completely avoid this issue is to get in the habit of *namespacing* your functions.  To namespace, you simply use `package::function()`, so to safely call `stepAIC()` from `MASS`, you use `MASS::stepAIC()`.  Most of the time in this book when a function is being called from a package outside base R, I use namespacing to call that function.  This should help avoid confusion about which packages are being used for which functions.

# The pipe operator

 The pipe operator makes code more natural to read and write and reduces the typical computing problem of many nested operations inside parentheses.  The pipe operator comes inside many R packages, particularly `magrittr` and `dplyr`.

As an example, imagine we wanted to do the following two operations in one command:

1. Subset `loan_data` to only the `loan_amnt` values of those with `loan_amnt` less than 15000
2. Take the mean of those values

#

In base R, one way to do this is:

##

```r
mean(subset(loan_data$loan_amnt, subset = loan_data$loan_amnt < 15000))
#> [1] 7095.706
```

This is nested and needs to be read from the inside out in order to align with the instructions.  The pipe operator `%>%` takes the command that comes before it and places it inside the function that follows it (by default as the first argument). This reduces complexity and allows you to follow the logic more clearly.

#
##

```r
# load magrittr library to get the pipe operator
library(magrittr)
# use the pipe operator to lay out the steps more logically
subset(loan_data$loan_amnt, subset = loan_data$loan_amnt < 15000) %>% 
  mean() 
#> [1] 7095.706
```

This can be extended to perform arbitrarily many operations in one piped command.

##

```r
loan_data$loan_amnt %>% # start with all data
  subset(subset = loan_data$loan_amnt < 15000) %>% # get the subsetted data
  mean() %>% # take the mean value
  round() # round to the nearest integer
#> [1] 7096
```

# Errors, warnings and messages

getting familiar with R can be frustrating at the beginning if you have never programmed before.  You can expect to regularly see messages, warnings or errors in response to your commands.  I encourage you to regard these as your friend rather than your enemy.  It is very tempting to take the latter approach when you are starting out, but over time I hope you will appreciate some wisdom from my words.

*Errors* are serious problems which usually result in the halting of your code and a failure to return your requested output.  They usually come with an indication of the source of the error, and these can sometimes be easy to understand and sometimes frustratingly vague and abstract.  For example, an easy-to-understand error is:

#
##

```r
subset(loan_data, subset = loan_amnt = 12000)
```

```
Error: unexpected '=' in "subset(loan_data, subset = loan_amnt ="
```

This helps you see that you have used `loan_amnt = 12000` as a condition to subset your data, when you should have used `loan_amnt == 720` for precise equality.

#
A much more challenging error to understand is:

##


```r
head[loan_data]
```
```
Error in head[loan_data] : object of type 'closure' is not subsettable
```

When first faced with an error that you can't understand, try not to get frustrated and proceed in the knowledge that it usually can be fixed easily and quickly.  Often the problem is much more obvious than you think, and if not, there is still a 99% likelihood that others have made this error and you can read about it online.  The first step is to take a look at your code to see if you can spot what you did wrong.  In this case, you may see that you have used square brackets `[]` instead of parentheses `()` when calling your `head()` function.  

