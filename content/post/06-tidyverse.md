---
title: "Introduction to Data Manipulation in R"
author: 'Bongani Ncube : statistical analyst'
date: "June 2023"
titlegraphic: front.png
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




# Manipulate data with the tidyverse

### Using tidyr to reshape data frames

![](images/tidyr_logo.png){width="200"}

# Why "tidy" your data?

Tidying allows you to manipulate the structure of your data while
preserving all original information. Many functions in R require (or
work better) with a data structure that isn't always easily readable by
people.


# Wide vs. long data

**Wide** format data has a separate column for each variable or each
factor in your study. One row therefore can therefore include several
different observations.

**Long** format data has a column stating the measured variable types
and a column containing the values associated to those variables (each
column is a variable, each row is one observation). This is considered
"tidy" data because it is easily interpreted by most packages for
visualization and analysis in `R`.

#
##

The format of your data depends on your specific needs, but some
functions and packages such as `dplyr`, `lm()`, `glm()`, `gam()` require
long format data. The `ggplot2` package can use wide data format for
some basic plotting, but more complex plots require the long format
(example to come).


-   1. `pivot_longer()` our data (wide \--\> long)
-   2. `pivot_wider()` our data (long \--\> wide)

#

![](images/gather-spread.png){width="500"}


# Intro to dplyr

The vision of the `dplyr` package is to simplify data manipulation by
distilling all the common data manipulation tasks to a set of intuitive
functions (or "verbs"). The result is a comprehensive set of tools
that facilitates data manipulation, such as filtering rows, selecting
specific columns, re-ordering rows, adding new columns and summarizing
data.

#
##

Certain R base functions work similarly to dplyr functions, including:
`split()`, `subset()`, `apply()`, `sapply()`, `lapply()`, `tapply()` and
`aggregate()`

The `dplyr` package is built around a core set of "verbs" (or
functions). 

-   `select()`: select columns from a data frame
-   `filter()`: filter rows according to defined criteria
-   `arrange()`: re-order data based on criteria (e.g. ascending,
    descending)
-   `mutate()`: create or transform values in a column

# Select a subset of columns with `select()`

![](images/select.png){width="500"}

##

The general syntax for this function is
`select(dataframe, column1, column2, ...)`. Most `dplyr` functions will
follow a similarly simple syntax. `select()` requires at least 2
arguments:

-   **data**: the dataset to manipulate
-   **...**: column names, positions, or complex expressions (separated
    by commas)

#
##

For example:


```r
select(data, column1, column2) # select columns 1 and 2
select(data, c(2:4,6) # select columns 2 to 4 and 6
select(data, -column1) # select all columns except column 1
select(data, start_with(x.)) # select all columns that start with "x."
```


#
##
The `airquality` dataset contains several columns:


```r
> head(airquality)
  Ozone Solar.R Wind Temp Month Day
1    41     190  7.4   67     5   1
2    36     118  8.0   72     5   2
3    12     149 12.6   74     5   3
4    18     313 11.5   62     5   4
5    NA      NA 14.3   56     5   5
6    28      NA 14.9   66     5   6
```


#
##

For example, suppose we are only interested in the variation of
"Ozone" over time within the `airquality` dataset, then we can select
the subset of required columns for further analysis:


```r
> ozone <- select(airquality, Ozone, Month, Day)
> head(ozone)
  Ozone Month Day
1    41     5   1
2    36     5   2
3    12     5   3
4    18     5   4
5    NA     5   5
6    28     5   6
```

# Select a subset of rows with `filter()`

A common operation in data manipulation is the extraction of a subset
based on specific conditions. The general syntax for this function is
`filter(dataframe, logical statement 1, logical statement 2, ...)`.

![](images/filter.png){width="500"}

#
##

The `filter()` function retains all the data for which the statement is
TRUE. This can also be applied on characters and factors. Here is a
useful reminder of how logic works in R.

![](images/logic.helper.png){width="500"}

#
##

For example, in the `airquality` dataset, suppose we are interested in
analyses that focus on the month of August during high temperature
events:


```r
> august <- filter(airquality, Month == 8, Temp >= 90)
> head(august)
  Ozone Solar.R Wind Temp Month Day
1    89     229 10.3   90     8   8
2   110     207  8.0   90     8   9
3    NA     222  8.6   92     8  10
4    76     203  9.7   97     8  28
5   118     225  2.3   94     8  29
6    84     237  6.3   96     8  30
```

# Sorting rows with `arrange()`

In data manipulation, we sometimes need to sort our data (e.g.
numerically or alphabetically) for subsequent operations. A common
example of this is a time series.

The `arrange()` function re-orders rows by one or multiple columns,
using the following syntax: `arrange(data, variable1, variable2, ...)`.

#
##

Example: Let's use the following code to create a scrambled version of
the airquality dataset


```r
> air_mess <- sample_frac(airquality, 1)
> head(air_mess)
    Ozone Solar.R Wind Temp Month Day
21      1       8  9.7   59     5  21
42     NA     259 10.9   93     6  11
151    14     191 14.3   75     9  28
108    22      71 10.3   77     8  16
8      19      99 13.8   59     5   8
104    44     192 11.5   86     8  12
```


#
##

Now, let's arrange the data frame back into chronological order,
sorting by `Month`, and then by `Day`:


```r
> air_chron <- arrange(air_mess, Month, Day)
> head(air_chron)
  Ozone Solar.R Wind Temp Month Day
1    41     190  7.4   67     5   1
2    36     118  8.0   72     5   2
3    12     149 12.6   74     5   3
4    18     313 11.5   62     5   4
5    NA      NA 14.3   56     5   5
6    28      NA 14.9   66     5   6
```



# Create and populate columns with `mutate()`

Besides subsetting or sorting your data frame, you will often require
tools to transform your existing data or generate some additional data
based on existing variables. We can use the function `mutate()` to
compute and add new columns in your dataset.


#
##

The `mutate()` function follows this syntax:
`mutate(data, newVar1 = expression1, newVar2 = expression2, ...)`.

![](images/mutate.png){width="500"}

#
##

Let's create a new column using `mutate()`. For example, suppose we
would like to convert the temperature variable from degrees Fahrenheit
to degrees Celsius:


```r
> airquality_C <- mutate(airquality, Temp_C = (Temp-32)*(5/9))
> head(airquality_C)
  Ozone Solar.R Wind Temp Month Day   Temp_C
1    41     190  7.4   67     5   1 19.44444
2    36     118  8.0   72     5   2 22.22222
3    12     149 12.6   74     5   3 23.33333
4    18     313 11.5   62     5   4 16.66667
5    NA      NA 14.3   56     5   5 13.33333
6    28      NA 14.9   66     5   6 18.88889
```



# dplyr and magrittr

![](images/magrittr.png){width="200"}

#
##

The `magrittr` package brings a new and exciting tool to the table: a
pipe operator. Pipe operators provide ways of linking functions together
so that the output of a function flows into the input of next function
in the chain. The syntax for the `magrittr` pipe operator is `%>%`. 

###

Using it is quite simple, and we will demonstrate that by combining some
of the examples used above. Suppose we wanted to `filter()` rows to
limit our analysis to the month of June, then convert the temperature
variable to degrees Celsius. We can tackle this problem step by step, as
before:

#


```r
june_C <- mutate(filter(airquality, Month == 6), Temp_C = (Temp-32)*(5/9))
```

###

This code can be difficult to decipher because we start on the inside
and work our way out. As we add more operations, the resulting code
becomes increasingly illegible. Instead of wrapping each function one
inside the other, we can accomplish these 2 operations by linking both
functions together:

#
##


```r
june_C <- airquality %>%
    filter(Month == 6) %>%
    mutate(Temp_C = (Temp-32)*(5/9))
```

Notice that within each function, we have removed the first argument
which specifies the dataset. Instead, we specify our dataset first, then
"pipe" into the next function in the chain.

# dplyr - grouped operations and summaries

The `dplyr` verbs we have explored so far can be useful on their own,
but they become especially powerful when we link them with each other
using the pipe operator (`%>%`) and by applying them to groups of
observations. The following functions allow us to split our data frame
into distinct groups on which we can then perform operations
individually, such as aggregating/summarising:

-   `group_by()`: group data frame by a factor for downstream commands
    (usually summarise)
-   `summarise()`: summarise values in a data frame or in groups within
    the data frame with aggregation functions (e.g. `min()`, `max()`,
    `mean()`, etc...)

These verbs provide the needed backbone for the Split-Apply-Combine
strategy that was initially implemented in the `plyr` package on which
`dplyr` is built.


#
##

Let's demonstrate the use of these with an example using the
`airquality` dataset. Suppose we are interested in the mean temperature
and standard deviation within each month:


```r
> month_sum <- airquality %>%
      group_by(Month) %>%
      summarise(mean_temp = mean(Temp),
                sd_temp = sd(Temp))
> month_sum
Source: local data frame [5 x 3]

  Month mean_temp  sd_temp
  (int)     (dbl)    (dbl)
1     5  65.54839 6.854870
2     6  79.10000 6.598589
3     7  83.90323 4.315513
4     8  83.96774 6.585256
5     9  76.90000 8.355671
```

