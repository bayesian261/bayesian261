---
title: 'Introduction to R : Part 1'
author: Bongani Ncube
date: '2023-09-09'
slug: introduction-to-r-part-1
categories:
  - rstudio
  - R
  - Rstats
tags: []
subtitle: ''
summary: ''
authors: []
lastmod: '2023-09-09T13:53:26+02:00'
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


# What is R?

R is a programming language that was originally developed by and for statisticians, but in recent years its capabilities and the environments in which it is used have expanded greatly, with extensive use nowadays in academia and the public and private sectors.  There are many advantages to using a programming language like R.  Here are some:

1.  It is completely free and open source.
2.  It is faster and more efficient with memory than popular graphical user interface analytics tools.
3.  It facilitates easier replication of analysis from person to person compared with many alternatives.
4.  It has a large and growing global community of active users.
5.  It has a large and rapidly growing universe of packages, which are all free and which provide the ability to do an extremely wide range of general and highly specialized tasks, statistical and otherwise.

#

There is often heated debate about which tools are better for doing non-trivial statistical analysis.  I personally find that R provides the widest array of resources for those interested in statistical modeling, 

# How to start using R

Just like most programming languages, R itself is an interpreter which receives input and returns output.  It is not very easy to use without an IDE.  An IDE is an *Integrated Development Environment*, which is a convenient user interface allowing an R programmer to do all their main tasks including writing and running R code, saving files, viewing data and plots, integrating code into documents and many other things.  By far the most popular IDE for R is RStudio. 

#
<div class="figure" style="text-align: center">
<img src="rstudio-windows.png" alt="The RStudio IDE" width="474" />
<p class="caption">Figure 1: The RStudio IDE</p>
</div>


# To start using R, follow these steps:

1.  Download and install the latest version of R from https://www.r-project.org/.  Ensure that the version suits your operating system.
2.  Download the latest version of the RStudio IDE from https://rstudio.com/products/rstudio/ and view the video on that page to familiarize yourself with its features.  
3.  Open RStudio and play around.

The initial stages of using R can be challenging, mostly due to the need to become familiar with how R understands, stores and processes data. Extensive trial and error is a learning necessity.  Perseverance is important in these early stages, as well as an openness to seek help from others either in person or via online forums.

# Data in R

As you start to do tasks involving data in R, you will generally want to store the things you create so that you can refer to them later.  Simply calculating something does not store it in R.  For example, a simple calculation like this can be performed easily:



```r
3 + 3
#> [1] 6
```

#

However, as soon as the calculation is complete, it is forgotten by R because the result hasn't been assigned anywhere.  To store something in your R session, you will assign it a name using the `<-` operator.  So I can assign my previous calculation to an object called `my_sum`, and this allows me to access the value at any time.


```r
# store the result
my_sum <- 3 + 3

# now I can work with it
my_sum + 3
#> [1] 9
```

You will see above that you can comment your code by simply adding a `#` to the start of a line to ensure that the line is ignored by the interpreter.

#
Note that assignment to an object does not result in the value being displayed.  To display the value, the name of the object must be typed, the `print()` command used or the command should be wrapped in parentheses.


```r
# show me the value of my_sum
my_sum
#> [1] 6

# assign my_sum + 3 to new_sum and show its value
(new_sum <- my_sum + 3)
#> [1] 9
```


# Data types

All data in R has an associated type, to reflect the wide range of data that R is able to work with.  The `typeof()` function can be used to see the type of a single scalar value. Let's look at the most common scalar data types.


## **Numeric data** can be in integer form or double (decimal) form.


```r
# integers can be signified by adding an 'L' to the end
my_integer <- 1L  
my_double <- 6.38

typeof(my_integer)
#> [1] "integer"
typeof(my_double)
#> [1] "double"
```

#
**Character data** is text data surrounded by single or double quotes.


```r
my_character <- "THIS IS TEXT"
typeof(my_character)
#> [1] "character"
```


#
**Logical data** takes the form `TRUE` or `FALSE`.


```r
my_logical <- TRUE
typeof(my_logical)
#> [1] "logical"
```

# Homogeneous data structures

##

**Vectors** are one-dimensional structures containing data of the same type and are notated by using `c()`. The type of the vector can also be viewed using the `typeof()` function, but the `str()` function can be used to display both the contents of the vector and its type.


```r
my_double_vector <- c(2.3, 6.8, 4.5, 65, 6)
str(my_double_vector)
#>  num [1:5] 2.3 6.8 4.5 65 6
```

# categorical data

which takes only a finite number of possible values---can be stored as a factor vector to make it easier to perform grouping and manipulation.


```r
categories <- factor(
  c("A", "B", "C", "A", "C")
)

str(categories)
#>  Factor w/ 3 levels "A","B","C": 1 2 3 1 3
```


# If needed, the factors can be given order.


```r
# character vector 
ranking <- c("Medium", "High", "Low")
str(ranking)
#>  chr [1:3] "Medium" "High" "Low"

# turn it into an ordered factor
ranking_factors <- ordered(
  ranking, levels = c("Low", "Medium", "High")
)

str(ranking_factors)
#>  Ord.factor w/ 3 levels "Low"<"Medium"<..: 2 3 1
```

# length

The number of elements in a vector can be seen using the `length()` function.


```r
length(categories)
#> [1] 5
```

Simple numeric sequence vectors can be created using shorthand notation.


```r
(my_sequence <- 1:10)
#>  [1]  1  2  3  4  5  6  7  8  9 10
```


# coercion

If you try to mix data types inside a vector, it will usually result in *type coercion*, where one or more of the types are forced into a different type to ensure homogeneity. Often this means the vector will become a character vector.


```r
# numeric sequence vector
vec <- 1:5
str(vec)
#>  int [1:5] 1 2 3 4 5

# create a new vector containing vec and the character "hello"
new_vec <- c(vec, "hello")

# numeric values have been coerced into their character equivalents
str(new_vec)
#>  chr [1:6] "1" "2" "3" "4" "5" "hello"
```

#
But sometimes logical or factor types will be coerced to numeric.


```r
# attempt a mixed logical and numeric
mix <- c(TRUE, 6)

# logical has been converted to binary numeric (TRUE = 1)
str(mix)
#>  num [1:2] 1 6

# try to add a numeric to our previous categories factor vector
new_categories <- c(categories, 1)

# categories have been coerced to background integer representations
str(new_categories)
#>  num [1:6] 1 2 3 1 3 1
```

# matrices

**Matrices** are two-dimensional data structures of the same type and are built from a vector by defining the number of rows and columns.  Data is read into the matrix down the columns, starting left and moving right.  Matrices are rarely used for non-numeric data types.


```r
# create a 2x2 matrix with the first four integers
(m <- matrix(c(1, 2, 3, 4), nrow = 2, ncol = 2))
#>      [,1] [,2]
#> [1,]    1    3
#> [2,]    2    4
```

## arrays

**Arrays** are n-dimensional data structures with the same data type and are not used extensively by most R users.

# Heterogeneous data structures

## lists

**Lists** are one-dimensional data structures that can take data of any type.


```r
my_list <- list(6, TRUE, "hello")
str(my_list)
#> List of 3
#>  $ : num 6
#>  $ : logi TRUE
#>  $ : chr "hello"
```

List elements can be any data type and any dimension.  Each element can be given a name.

#

```r
new_list <- list(
  scalar = 6, 
  vector = c("Hello", "Goodbye"), 
  matrix = matrix(1:4, nrow = 2, ncol = 2)
)

str(new_list)
#> List of 3
#>  $ scalar: num 6
#>  $ vector: chr [1:2] "Hello" "Goodbye"
#>  $ matrix: int [1:2, 1:2] 1 2 3 4
```

Named list elements can be accessed by using `$`.


```r
new_list$matrix
#>      [,1] [,2]
#> [1,]    1    3
#> [2,]    2    4
```

# data frames

**Dataframes** are the most used data structure in R; they are effectively a named list of vectors of the same length, with each vector as a column.  As such, a dataframe is very similar in nature to a typical database table or spreadsheet.  


```r
# two vectors of different types but same length
names <- c("John", "Ayesha")
ages <- c(31, 24)

# create a dataframe
(df <- data.frame(names, ages))
#>    names ages
#> 1   John   31
#> 2 Ayesha   24
```

#

```r
# get types of columns
str(df)
#> 'data.frame':	2 obs. of  2 variables:
#>  $ names: chr  "John" "Ayesha"
#>  $ ages : num  31 24

# get dimensions of df
dim(df)
#> [1] 2 2
```

