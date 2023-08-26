---
title: 'Understanding why learning SQL and R can be fun : Comparison between the two'
author: "Bongani Ncube"
date: "2023-08-26"
slug: "understanding-why-learning-sql-and-r-can-be-fun-comparison-between-the-two"
categories:
- R
- dplyr
tags: []
subtitle: ''
summary: ''
authors: []
lastmod: "2023-08-26T13:42:36+02:00"
featured: no
image:
  caption: art by Allison Host
  focal_point: ''
  preview_only: no
projects: []
---



In this tutorial i will show you it's easy to learn R's dplyr together with SQL. I show some of the most similar ways of handling data in R and SQL

# Introduction

learning to code in more than one software at once is no easy pizzy but it's much easy if the two softwares have some form of resemblence in them . In this tutorial i will show you how to connect to a database using Rmarkdown and Rstudio as well as query this database using SQL (Within an rmarkdown document)

# setup

+ load packages required (assuming you already installed them)


```r
library(tidyverse)
library(odbc)
library(DBI)
library(RSQLite)
```

# data for the tutorial

Next up we load our data for the tutorial , I have used a dataset from a project i did from datacamp to be `certified as data scientist associate` . I then sample only a few rows and create two dataframes which i will turn into tables later on. 


```r
## read in the dataset
df <- readr::read_csv("recipe_site_traffic_2212.csv")

## sample 100 observations and select first 3 variables
set.seed(1123)
data1<- df |>
  sample_n(size=25) |> 
  select(1,2,3,6)

## sample 100 observations and select subsequent 3 variables(including the first(ID))
## 
set.seed(1123)
data2<- df |>
  sample_n(size=25) |> 
  select(1,2,4,5,6)
```

## Create a database


```r
con<-dbConnect(RSQLite::SQLite(), ":memory:")
copy_to(con,data1)
copy_to(con,data2)
```

# Sql queries in R and dplyr code 

+ A *query* is a request for data from a database table (or combination of tables). 
+ Querying is an essential skill for a data scientist, since the data you need for your analyses will often live in databases.

## Selecting all data in SQL

+ In SQL, you can select data from a table using a *SELECT* statement. For example, the following query selects the name column from the people table:
`SELECT name FROM people;`
+ you may want to select all columns from a table use `*` rather than typing all the columns


```r
dbGetQuery(con,'SELECT * FROM data2')
#>    recipe calories sugar protein       category
#> 1     624   236.62  0.81    9.07         Potato
#> 2     102   198.98  0.39   39.12      Vegetable
#> 3     427   187.41 86.97    4.49        Dessert
#> 4     324    49.50  4.69   53.33      Breakfast
#> 5     912       NA    NA      NA        Dessert
#> 6     380    75.89  8.18   17.64           Meat
#> 7     609       NA    NA      NA Chicken Breast
#> 8     671   481.88  1.34   51.90        Chicken
#> 9     683   147.24  0.94   54.00        Chicken
#> 10    208    20.98  9.80    0.82      Beverages
#> 11    633   105.95  0.07    7.55      Vegetable
#> 12    859   388.44  4.62   13.93           Pork
#> 13    171   431.28  4.17   32.79  One Dish Meal
#> 14    282   409.99  1.96    8.77      Vegetable
#> 15    091   388.37 11.13    2.67      Breakfast
#> 16    879    88.26  5.21   99.64           Meat
#> 17    868   307.36 52.17   10.12        Dessert
#> 18    598   212.40  2.25   23.78      Breakfast
#> 19    929     5.87 30.06   24.72           Meat
#> 20    439   151.88  6.09   40.24  One Dish Meal
#> 21    885   504.09  1.46   25.73  One Dish Meal
#> 22    419  1830.28  1.83   44.74 Chicken Breast
#> 23    117       NA    NA      NA Chicken Breast
#> 24    639   321.95 10.76  112.64           Meat
#> 25    526    93.50  2.57   23.68      Breakfast
```

## Selecting a subset of variables


```r
dbGetQuery(con,'SELECT recipe,sugar FROM data2')
#>    recipe sugar
#> 1     624  0.81
#> 2     102  0.39
#> 3     427 86.97
#> 4     324  4.69
#> 5     912    NA
#> 6     380  8.18
#> 7     609    NA
#> 8     671  1.34
#> 9     683  0.94
#> 10    208  9.80
#> 11    633  0.07
#> 12    859  4.62
#> 13    171  4.17
#> 14    282  1.96
#> 15    091 11.13
#> 16    879  5.21
#> 17    868 52.17
#> 18    598  2.25
#> 19    929 30.06
#> 20    439  6.09
#> 21    885  1.46
#> 22    419  1.83
#> 23    117    NA
#> 24    639 10.76
#> 25    526  2.57
```


## Selecting all data in R


```r
data2 |> select(everything())
#> # A tibble: 25 x 5
#>    recipe calories sugar protein category      
#>    <chr>     <dbl> <dbl>   <dbl> <chr>         
#>  1 624       237.   0.81    9.07 Potato        
#>  2 102       199.   0.39   39.1  Vegetable     
#>  3 427       187.  87.0     4.49 Dessert       
#>  4 324        49.5  4.69   53.3  Breakfast     
#>  5 912        NA   NA      NA    Dessert       
#>  6 380        75.9  8.18   17.6  Meat          
#>  7 609        NA   NA      NA    Chicken Breast
#>  8 671       482.   1.34   51.9  Chicken       
#>  9 683       147.   0.94   54    Chicken       
#> 10 208        21.0  9.8     0.82 Beverages     
#> # i 15 more rows
```

## selecting a subset of variables in R


```r
data2 |> 
  select(recipe,sugar)
#> # A tibble: 25 x 2
#>    recipe sugar
#>    <chr>  <dbl>
#>  1 624     0.81
#>  2 102     0.39
#>  3 427    87.0 
#>  4 324     4.69
#>  5 912    NA   
#>  6 380     8.18
#>  7 609    NA   
#>  8 671     1.34
#>  9 683     0.94
#> 10 208     9.8 
#> # i 15 more rows
```


## filtering using `WHERE` in SQL

+ *WHERE* is a filtering clause
+ In SQL, the WHERE keyword allows you to filter based on both text and numeric values in a table. There are a few different comparison operators you can use:

+ _= equal_
+ _<> not equal_
+ _< less than_
+ _> greater than_
+ _<= less than or equal to_
+ _>= greater than or equal to_

+ You can build up your WHERE queries by combining multiple conditions with the _AND_ keyword.


```r
dbGetQuery(con,"SELECT * 
                FROM data2 
                WHERE category='Potato'")
#>   recipe calories sugar protein category
#> 1    624   236.62  0.81    9.07   Potato
```

## filtering in R


```r
data2 |> 
  filter(category=="Potato")
#> # A tibble: 1 x 5
#>   recipe calories sugar protein category
#>   <chr>     <dbl> <dbl>   <dbl> <chr>   
#> 1 624        237.  0.81    9.07 Potato
```

## filtering using `IN` and `WHERE` in SQL


```r
dbGetQuery(con,"SELECT * 
                FROM data2 
                WHERE category IN ('Chicken','Chicken Breast')")
#>   recipe calories sugar protein       category
#> 1    609       NA    NA      NA Chicken Breast
#> 2    671   481.88  1.34   51.90        Chicken
#> 3    683   147.24  0.94   54.00        Chicken
#> 4    419  1830.28  1.83   44.74 Chicken Breast
#> 5    117       NA    NA      NA Chicken Breast
```

## filtering using `%in%`


```r
data2 |> 
  filter(category %in% c("Chicken","Chicken Breast"))
#> # A tibble: 5 x 5
#>   recipe calories sugar protein category      
#>   <chr>     <dbl> <dbl>   <dbl> <chr>         
#> 1 609         NA  NA       NA   Chicken Breast
#> 2 671        482.  1.34    51.9 Chicken       
#> 3 683        147.  0.94    54   Chicken       
#> 4 419       1830.  1.83    44.7 Chicken Breast
#> 5 117         NA  NA       NA   Chicken Breast
```

## `COUNT` and `AS` alias in SQL

+ The *COUNT* statement lets you count then returning the number of rows in one or more columns.
+ we use `AS` to rename default name 
+ `COUNT(*)` tells you how many rows are in a table


```r
dbGetQuery(con,"SELECT COUNT(*) AS n FROM data2")
#>    n
#> 1 25
```

## Counting in dplyr


```r
data2 |> count()
#> # A tibble: 1 x 1
#>       n
#>   <int>
#> 1    25
```

## count filters in SQL


```r
dbGetQuery(con,"SELECT COUNT(category) AS n_potato
                FROM data2 
                WHERE category IN ('Chicken Breast','Chicken')")
#>   n_potato
#> 1        5
```

## counting filters in dplyr


```r
data2 |> 
  filter(category %in% c("Chicken","Chicken Breast")) |> 
  summarise(n_potato=n())
#> # A tibble: 1 x 1
#>   n_potato
#>      <int>
#> 1        5
```

## Updating a database using `dbExecute`

+ categories before


```r
data2 |> 
  janitor::tabyl(category)
#>        category n percent
#>       Beverages 1    0.04
#>       Breakfast 4    0.16
#>         Chicken 2    0.08
#>  Chicken Breast 3    0.12
#>         Dessert 3    0.12
#>            Meat 4    0.16
#>   One Dish Meal 3    0.12
#>            Pork 1    0.04
#>          Potato 1    0.04
#>       Vegetable 3    0.12
```

## Updating a database

+ we need to change a category called `Breakfast` to `Breakfast meal`
+ we shall use `REPLACE`


```r
dbExecute(con,"UPDATE data2 
               SET category= REPLACE(category,'Breakfast','Breakfast meal')
               WHERE category='Breakfast'")
#> [1] 4
```

## Querying to check results


```r
dbGetQuery(con,"SELECT category, COUNT(category) as n_per_category
                FROM data2
                GROUP BY category")
#>          category n_per_category
#> 1       Beverages              1
#> 2  Breakfast meal              4
#> 3         Chicken              2
#> 4  Chicken Breast              3
#> 5         Dessert              3
#> 6            Meat              4
#> 7   One Dish Meal              3
#> 8            Pork              1
#> 9          Potato              1
#> 10      Vegetable              3
```

+ we see that `Breakfast` has updated to `Breakfast meal`


## Updating and grouping in R

+ We use `stringr::str_replace` to replace elements in a string variable


```r
data2 |> 
  mutate(category=stringr::str_replace(category,"Breakfast","Breakfast meal")) |> 
  group_by(category) |> 
  summarise(n_per_category=n())
#> # A tibble: 10 x 2
#>    category       n_per_category
#>    <chr>                   <int>
#>  1 Beverages                   1
#>  2 Breakfast meal              4
#>  3 Chicken                     2
#>  4 Chicken Breast              3
#>  5 Dessert                     3
#>  6 Meat                        4
#>  7 One Dish Meal               3
#>  8 Pork                        1
#>  9 Potato                      1
#> 10 Vegetable                   3
```

## Missing data in SQL

+n SQL, NULL represents a missing or unknown value. You can check for NULL values using the expression IS NULL
+ Use `IS NULL` AND `IS NOT NULL`


```r
dbGetQuery(con,"SELECT * 
                FROM data2 
                WHERE Protein IS NULL")
#>   recipe calories sugar protein       category
#> 1    912       NA    NA      NA        Dessert
#> 2    609       NA    NA      NA Chicken Breast
#> 3    117       NA    NA      NA Chicken Breast
```


```r
dbGetQuery(con,"SELECT * 
                FROM data2 
                WHERE Protein IS NOT NULL")
#>    recipe calories sugar protein       category
#> 1     624   236.62  0.81    9.07         Potato
#> 2     102   198.98  0.39   39.12      Vegetable
#> 3     427   187.41 86.97    4.49        Dessert
#> 4     324    49.50  4.69   53.33 Breakfast meal
#> 5     380    75.89  8.18   17.64           Meat
#> 6     671   481.88  1.34   51.90        Chicken
#> 7     683   147.24  0.94   54.00        Chicken
#> 8     208    20.98  9.80    0.82      Beverages
#> 9     633   105.95  0.07    7.55      Vegetable
#> 10    859   388.44  4.62   13.93           Pork
#> 11    171   431.28  4.17   32.79  One Dish Meal
#> 12    282   409.99  1.96    8.77      Vegetable
#> 13    091   388.37 11.13    2.67 Breakfast meal
#> 14    879    88.26  5.21   99.64           Meat
#> 15    868   307.36 52.17   10.12        Dessert
#> 16    598   212.40  2.25   23.78 Breakfast meal
#> 17    929     5.87 30.06   24.72           Meat
#> 18    439   151.88  6.09   40.24  One Dish Meal
#> 19    885   504.09  1.46   25.73  One Dish Meal
#> 20    419  1830.28  1.83   44.74 Chicken Breast
#> 21    639   321.95 10.76  112.64           Meat
#> 22    526    93.50  2.57   23.68 Breakfast meal
```

## missing values in R

+ use `is.na()` and `!is.na`


```r
data2 |> 
  filter(is.na(protein))
#> # A tibble: 3 x 5
#>   recipe calories sugar protein category      
#>   <chr>     <dbl> <dbl>   <dbl> <chr>         
#> 1 912          NA    NA      NA Dessert       
#> 2 609          NA    NA      NA Chicken Breast
#> 3 117          NA    NA      NA Chicken Breast
```


```r
data2 |> 
  filter(!is.na(protein))
#> # A tibble: 22 x 5
#>    recipe calories sugar protein category 
#>    <chr>     <dbl> <dbl>   <dbl> <chr>    
#>  1 624       237.   0.81    9.07 Potato   
#>  2 102       199.   0.39   39.1  Vegetable
#>  3 427       187.  87.0     4.49 Dessert  
#>  4 324        49.5  4.69   53.3  Breakfast
#>  5 380        75.9  8.18   17.6  Meat     
#>  6 671       482.   1.34   51.9  Chicken  
#>  7 683       147.   0.94   54    Chicken  
#>  8 208        21.0  9.8     0.82 Beverages
#>  9 633       106.   0.07    7.55 Vegetable
#> 10 859       388.   4.62   13.9  Pork     
#> # i 12 more rows
```

# How many categories do we have
## select `distinct` items in SQL
+ Often your results will include many duplicate values. If you want to select all the unique values from a column, you can use the *DISTINCT* keyword.


```r
dbGetQuery(con,"SELECT COUNT(DISTINCT category) AS unique_categories 
                FROM data2")
#>   unique_categories
#> 1                10
```

## select distinct in R

+ use `distinct` in R


```r
data2 |> 
  distinct(category) |> 
  summarise(unique_categories=n())
#> # A tibble: 1 x 1
#>   unique_categories
#>               <int>
#> 1                10
```

# Advanced filters
## filtering in SQL


```r
dbGetQuery(con,"SELECT * 
                FROM data2 WHERE sugar > 1 AND sugar < 5 
                AND category='Breakfast meal'")
#>   recipe calories sugar protein       category
#> 1    324     49.5  4.69   53.33 Breakfast meal
#> 2    598    212.4  2.25   23.78 Breakfast meal
#> 3    526     93.5  2.57   23.68 Breakfast meal
```

+ also achieved by using `BETWEEN` and `AND`

```r
dbGetQuery(con,"SELECT * 
                FROM data2 
                WHERE sugar BETWEEN 1 AND 5 
                AND category='Breakfast meal'")
#>   recipe calories sugar protein       category
#> 1    324     49.5  4.69   53.33 Breakfast meal
#> 2    598    212.4  2.25   23.78 Breakfast meal
#> 3    526     93.5  2.57   23.68 Breakfast meal
```

## In R


```r
data2 |> 
  filter(between(sugar,1,5) & category=="Breakfast")
#> # A tibble: 3 x 5
#>   recipe calories sugar protein category 
#>   <chr>     <dbl> <dbl>   <dbl> <chr>    
#> 1 324        49.5  4.69    53.3 Breakfast
#> 2 598       212.   2.25    23.8 Breakfast
#> 3 526        93.5  2.57    23.7 Breakfast
```

## filtering text data in SQL

+ use `LIKE`
+ the _LIKE_ operator can be used in a WHERE clause to search for a pattern in a column. 
+ To accomplish this, you use something called a wildcard as a placeholder for some other values. There are two wildcards you can use with LIKE:

> The % wildcard will match zero, one, or many characters in text

> The _ wildcard will match a single character


```r
dbGetQuery(con,"SELECT * 
                FROM data2 
                WHERE category LIKE 'Chicken%'")
#>   recipe calories sugar protein       category
#> 1    609       NA    NA      NA Chicken Breast
#> 2    671   481.88  1.34   51.90        Chicken
#> 3    683   147.24  0.94   54.00        Chicken
#> 4    419  1830.28  1.83   44.74 Chicken Breast
#> 5    117       NA    NA      NA Chicken Breast
```

## Filter text in R

+ use `str_like`


```r
data2 |> 
  filter(str_like(category,"Chicken%"))
#> # A tibble: 5 x 5
#>   recipe calories sugar protein category      
#>   <chr>     <dbl> <dbl>   <dbl> <chr>         
#> 1 609         NA  NA       NA   Chicken Breast
#> 2 671        482.  1.34    51.9 Chicken       
#> 3 683        147.  0.94    54   Chicken       
#> 4 419       1830.  1.83    44.7 Chicken Breast
#> 5 117         NA  NA       NA   Chicken Breast
```

## Aggregate functions in SQL


```r
sqldf::sqldf("SELECT AVG(sugar) AS avg_sugar,
                       MAX(sugar) AS max_sugar,
                       MIN(sugar) AS min_sugar
                FROM data2;") 
#>   avg_sugar max_sugar min_sugar
#> 1  11.24864     86.97      0.07
```
## Aggregate functions in R


```r
data2 |> 
  summarise(avg_sugar=mean(sugar,na.rm=T),
            max_sugar= max(sugar,na.rm=T),
            min_sugar= min(sugar,na.rm=T))
#> # A tibble: 1 x 3
#>   avg_sugar max_sugar min_sugar
#>       <dbl>     <dbl>     <dbl>
#> 1      11.2      87.0      0.07
```
# Grouping and aggregating in SQL


```r
sqldf::sqldf("SELECT category,AVG(sugar) AS avg_sugar,
                       MAX(sugar) AS max_sugar,
                       MIN(sugar) AS min_sugar
                FROM data2
                GROUP BY category;") 
#>          category  avg_sugar max_sugar min_sugar
#> 1       Beverages  9.8000000      9.80      9.80
#> 2       Breakfast  5.1600000     11.13      2.25
#> 3         Chicken  1.1400000      1.34      0.94
#> 4  Chicken Breast  1.8300000      1.83      1.83
#> 5         Dessert 69.5700000     86.97     52.17
#> 6            Meat 13.5525000     30.06      5.21
#> 7   One Dish Meal  3.9066667      6.09      1.46
#> 8            Pork  4.6200000      4.62      4.62
#> 9          Potato  0.8100000      0.81      0.81
#> 10      Vegetable  0.8066667      1.96      0.07
```

## group and Aggregate functions in R


```r
data2 |>
  group_by(category) |> 
  summarise(avg_sugar=mean(sugar,na.rm=T),
            max_sugar= max(sugar,na.rm=T),
            min_sugar= min(sugar,na.rm=T))
#> # A tibble: 10 x 4
#>    category       avg_sugar max_sugar min_sugar
#>    <chr>              <dbl>     <dbl>     <dbl>
#>  1 Beverages          9.8        9.8       9.8 
#>  2 Breakfast          5.16      11.1       2.25
#>  3 Chicken            1.14       1.34      0.94
#>  4 Chicken Breast     1.83       1.83      1.83
#>  5 Dessert           69.6       87.0      52.2 
#>  6 Meat              13.6       30.1       5.21
#>  7 One Dish Meal      3.91       6.09      1.46
#>  8 Pork               4.62       4.62      4.62
#>  9 Potato             0.81       0.81      0.81
#> 10 Vegetable          0.807      1.96      0.07
```
## Basic arithmetic

+ In addition to using aggregate functions, you can perform basic arithmetic with symbols like _+, -, *, and /_.
+ lets create weird variables here


```r
sqldf::sqldf("SELECT category,(sugar-protein) AS diff_sugar_protein 
                FROM data2")
#>          category diff_sugar_protein
#> 1          Potato              -8.26
#> 2       Vegetable             -38.73
#> 3         Dessert              82.48
#> 4       Breakfast             -48.64
#> 5         Dessert                 NA
#> 6            Meat              -9.46
#> 7  Chicken Breast                 NA
#> 8         Chicken             -50.56
#> 9         Chicken             -53.06
#> 10      Beverages               8.98
#> 11      Vegetable              -7.48
#> 12           Pork              -9.31
#> 13  One Dish Meal             -28.62
#> 14      Vegetable              -6.81
#> 15      Breakfast               8.46
#> 16           Meat             -94.43
#> 17        Dessert              42.05
#> 18      Breakfast             -21.53
#> 19           Meat               5.34
#> 20  One Dish Meal             -34.15
#> 21  One Dish Meal             -24.27
#> 22 Chicken Breast             -42.91
#> 23 Chicken Breast                 NA
#> 24           Meat            -101.88
#> 25      Breakfast             -21.11
```

## basic arithmetic in R using `mutate()`


```r
data2 |> 
  mutate(diff_sugar_protein=sugar-protein) |> 
  select(category,diff_sugar_protein)
#> # A tibble: 25 x 2
#>    category       diff_sugar_protein
#>    <chr>                       <dbl>
#>  1 Potato                      -8.26
#>  2 Vegetable                  -38.7 
#>  3 Dessert                     82.5 
#>  4 Breakfast                  -48.6 
#>  5 Dessert                     NA   
#>  6 Meat                        -9.46
#>  7 Chicken Breast              NA   
#>  8 Chicken                    -50.6 
#>  9 Chicken                    -53.1 
#> 10 Beverages                    8.98
#> # i 15 more rows
```


# SQL subqueries

+ use data1 and data2 databases for this task
+ the following is just an example and calories in data2 and data1 are the same so the result is the same


```r
sqldf::sqldf("SELECT recipe,calories
                FROM data2 
                WHERE calories > 
                          (SELECT AVG(calories) FROM data1)")
#>   recipe calories
#> 1    671   481.88
#> 2    859   388.44
#> 3    171   431.28
#> 4    282   409.99
#> 5    091   388.37
#> 6    868   307.36
#> 7    885   504.09
#> 8    419  1830.28
#> 9    639   321.95
```

+ the above is the same as follows in R


```r
data2 |> 
  select(recipe,sugar,calories) |> 
  filter(calories>(data1 |> 
           summarise(mean_calories=mean(calories,na.rm=TRUE)) |> 
             pull(mean_calories)))
#> # A tibble: 9 x 3
#>   recipe sugar calories
#>   <chr>  <dbl>    <dbl>
#> 1 671     1.34     482.
#> 2 859     4.62     388.
#> 3 171     4.17     431.
#> 4 282     1.96     410.
#> 5 091    11.1      388.
#> 6 868    52.2      307.
#> 7 885     1.46     504.
#> 8 419     1.83    1830.
#> 9 639    10.8      322.
```

## Joining tables in SQL and R

* Inner Join - only keep observations found in *both* `x` *and* `y`
* Left Join - keep all observations in `x`
* Right Join - keep all observations in `y`
* Full Join - keep *any* observations in `x` *or* `y`

## for this dataset we shall use `INNER JOIN` Alone

### Inner Join

When talking about inner joins, we are only going to keep an observation if it is found in all of the tables we're combining.


```r
sqldf::sqldf("SELECT data2.category,data2.recipe,data2.calories,
                       carbohydrate,protein,sugar 
                FROM data2
                INNER JOIN data1 ON data2.recipe=data1.recipe")
#>          category recipe calories carbohydrate protein sugar
#> 1          Potato    624   236.62         9.67    9.07  0.81
#> 2       Vegetable    102   198.98        87.68   39.12  0.39
#> 3         Dessert    427   187.41        19.12    4.49 86.97
#> 4       Breakfast    324    49.50        66.64   53.33  4.69
#> 5         Dessert    912       NA           NA      NA    NA
#> 6            Meat    380    75.89        22.51   17.64  8.18
#> 7  Chicken Breast    609       NA           NA      NA    NA
#> 8         Chicken    671   481.88        12.74   51.90  1.34
#> 9         Chicken    683   147.24         9.72   54.00  0.94
#> 10      Beverages    208    20.98         1.26    0.82  9.80
#> 11      Vegetable    633   105.95        55.80    7.55  0.07
#> 12           Pork    859   388.44        12.89   13.93  4.62
#> 13  One Dish Meal    171   431.28        14.69   32.79  4.17
#> 14      Vegetable    282   409.99        13.61    8.77  1.96
#> 15      Breakfast    091   388.37        13.67    2.67 11.13
#> 16           Meat    879    88.26        18.58   99.64  5.21
#> 17        Dessert    868   307.36        31.39   10.12 52.17
#> 18      Breakfast    598   212.40        19.20   23.78  2.25
#> 19           Meat    929     5.87        47.91   24.72 30.06
#> 20  One Dish Meal    439   151.88         7.41   40.24  6.09
#> 21  One Dish Meal    885   504.09        32.76   25.73  1.46
#> 22 Chicken Breast    419  1830.28         3.92   44.74  1.83
#> 23 Chicken Breast    117       NA           NA      NA    NA
#> 24           Meat    639   321.95         1.41  112.64 10.76
#> 25      Breakfast    526    93.50        39.28   23.68  2.57
```

## Inner join in R


```r
dplyr::inner_join(data1,data2,by=join_by(recipe)) |> 
  select(recipe,carbohydrate,sugar,protein,ends_with(".x"))
#> # A tibble: 25 x 6
#>    recipe carbohydrate sugar protein calories.x category.x    
#>    <chr>         <dbl> <dbl>   <dbl>      <dbl> <chr>         
#>  1 624            9.67  0.81    9.07      237.  Potato        
#>  2 102           87.7   0.39   39.1       199.  Vegetable     
#>  3 427           19.1  87.0     4.49      187.  Dessert       
#>  4 324           66.6   4.69   53.3        49.5 Breakfast     
#>  5 912           NA    NA      NA          NA   Dessert       
#>  6 380           22.5   8.18   17.6        75.9 Meat          
#>  7 609           NA    NA      NA          NA   Chicken Breast
#>  8 671           12.7   1.34   51.9       482.  Chicken       
#>  9 683            9.72  0.94   54         147.  Chicken       
#> 10 208            1.26  9.8     0.82       21.0 Beverages     
#> # i 15 more rows
```



# For full,right and left joins i am using some dummy datasets that i created

## setting up the data


```r
# read in example csv files (join_df1 and join_df2)
join_df1 <- read.csv("join_df1.csv") |> 
  rename(A=`ï..A`)
join_df2 <- read.csv("join_df2.csv")|> 
  rename(A=`ï..A`)

join<-dbConnect(RSQLite::SQLite(), ":memory:")
copy_to(join,join_df1)
copy_to(join,join_df2)
```

## look at the databases now


```r
dbGetQuery(join,"SELECT * FROM join_df1")
#>        A B C
#> 1    red 2 3
#> 2 orange 4 6
#> 3 yellow 8 9
#> 4  green 0 0
#> 5 indigo 3 3
#> 6   blue 1 1
#> 7 purple 5 5
#> 8  white 8 2
```


```r
dbGetQuery(join,"SELECT * FROM join_df2")
#>        A D
#> 1    red 3
#> 2 orange 5
#> 3 yellow 7
#> 4  green 1
#> 5 indigo 3
#> 6   blue 6
#> 7   pink 9
```

## left join in SQL

### Left Join

For a left join, all rows in the first table specified will be included in the output. Any row in the second table that is *not* in the first table will not be included. 


```r
sqldf::sqldf("SELECT * 
                 FROM join_df1
                 LEFT JOIN join_df2
                 USING(A)")
#>        A B C  D
#> 1    red 2 3  3
#> 2 orange 4 6  5
#> 3 yellow 8 9  7
#> 4  green 0 0  1
#> 5 indigo 3 3  3
#> 6   blue 1 1  6
#> 7 purple 5 5 NA
#> 8  white 8 2 NA
```

## RIGHT JOIN IN SQL

Right Join is similar to what we just discussed; however, in the output from a right join, all rows in the final table specified are included in the output. NAs will be included for any observations found in the last specified table but not in the other tables.



```r
sqldf::sqldf("SELECT * 
                 FROM join_df1
                 RIGHT JOIN join_df2
                 USING(A)")
#>        A  B  C D
#> 1    red  2  3 3
#> 2 orange  4  6 5
#> 3 yellow  8  9 7
#> 4  green  0  0 1
#> 5 indigo  3  3 3
#> 6   blue  1  1 6
#> 7   pink NA NA 9
```



## left join df1 and df2

```r
dplyr::left_join(join_df1, join_df2,by = join_by(A))
#>        A B C  D
#> 1    red 2 3  3
#> 2 orange 4 6  5
#> 3 yellow 8 9  7
#> 4  green 0 0  1
#> 5 indigo 3 3  3
#> 6   blue 1 1  6
#> 7 purple 5 5 NA
#> 8  white 8 2 NA
```


## right join df1 and df2

```r
dplyr::right_join(join_df1, join_df2,by = join_by(A))
#>        A  B  C D
#> 1    red  2  3 3
#> 2 orange  4  6 5
#> 3 yellow  8  9 7
#> 4  green  0  0 1
#> 5 indigo  3  3 3
#> 6   blue  1  1 6
#> 7   pink NA NA 9
```

## full join in SQL

Finally, a full join will take every observation from every table and include it in the output.



```r
sqldf::sqldf("SELECT * FROM join_df1 
                 FULL JOIN join_df2
                 USING(A)")
#>        A  B  C  D
#> 1    red  2  3  3
#> 2 orange  4  6  5
#> 3 yellow  8  9  7
#> 4  green  0  0  1
#> 5 indigo  3  3  3
#> 6   blue  1  1  6
#> 7 purple  5  5 NA
#> 8  white  8  2 NA
#> 9   pink NA NA  9
```


## full join df1 and df2 specifying which column is the same


```r
dplyr::full_join(join_df1, join_df2,by = join_by(A))
#>        A  B  C  D
#> 1    red  2  3  3
#> 2 orange  4  6  5
#> 3 yellow  8  9  7
#> 4  green  0  0  1
#> 5 indigo  3  3  3
#> 6   blue  1  1  6
#> 7 purple  5  5 NA
#> 8  white  8  2 NA
#> 9   pink NA NA  9
```

# References

+ Tips on Getting Started with databases using R (from Rstudio)
+ Using SQL in Rstudio from Irene Steves - a discussion of the Rubymine IDE and working with SQL in RSTUDIO.
+ CRAN
