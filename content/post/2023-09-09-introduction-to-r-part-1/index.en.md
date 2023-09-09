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
loan_amnt_10000
#>           X loan_status loan_amnt int_rate grade emp_length home_ownership
#> 3         3           0     10000    13.49     C         13           RENT
#> 9         9           1     10000    10.65     B          3           RENT
#> 16       16           0     10000    11.71     B         13            OWN
#> 17       17           0     10000    11.71     B          5           RENT
#> 38       38           0     10000    10.65     B          6           RENT
#> 46       46           0     10000    12.42     B          0            OWN
#> 47       47           0     10000    10.65     B          2           RENT
#> 60       60           0     10000    14.27     C          2           RENT
#> 83       83           1     10000    18.25     D          1           RENT
#> 85       85           0     10000     8.90     A          6           RENT
#> 87       87           0     10000     7.90     A          1           RENT
#> 90       90           0     10000     9.91     B          3           RENT
#> 95       95           0     10000     7.51     A          3           RENT
#> 112     112           1     10000    11.71     B          8           RENT
#> 121     121           0     10000     9.91     B          2            OWN
#> 122     122           0     10000     6.62     A          5       MORTGAGE
#> 133     133           1     10000    13.49     C          5           RENT
#> 177     177           1     10000    12.69     B          2           RENT
#> 178     178           0     10000     6.62     A          5           RENT
#> 188     188           0     10000    12.42     B          4           RENT
#> 197     197           1     10000    12.42     B         10           RENT
#> 202     202           0     10000    13.49     C         10       MORTGAGE
#> 218     218           0     10000     7.51     A          5           RENT
#> 232     232           0     10000    12.42     B         15           RENT
#> 237     237           0     10000    16.29     D         15           RENT
#> 241     241           0     10000    13.49     C          3           RENT
#> 244     244           0     10000    11.71     B          3           RENT
#> 257     257           1     10000    11.71     B          5           RENT
#> 264     264           0     10000    10.65     B         14       MORTGAGE
#> 265     265           1     10000    12.69     B          2           RENT
#> 277     277           0     10000    15.96     C         13           RENT
#> 284     284           0     10000    11.71     B          2           RENT
#> 285     285           0     10000     9.91     B          4           RENT
#> 319     319           0     10000     7.90     A          5       MORTGAGE
#> 322     322           0     10000     7.90     A          2           RENT
#> 328     328           0     10000     9.91     B          4       MORTGAGE
#> 360     360           0     10000     6.62     A          4           RENT
#> 362     362           1     10000    17.27     D          8           RENT
#> 387     387           0     10000    14.27     C         34            OWN
#> 405     405           0     10000    16.29     D          3           RENT
#> 426     426           0     10000     7.90     A          6           RENT
#> 436     436           1     10000    12.69     B          6            OWN
#> 472     472           0     10000    14.27     C          4           RENT
#> 477     477           0     10000    12.69     B          4           RENT
#> 478     478           0     10000    15.96     C          1           RENT
#> 482     482           1     10000    13.49     C         15           RENT
#> 491     491           0     10000    11.71     B          5       MORTGAGE
#> 505     505           0     10000    11.71     B          4       MORTGAGE
#> 519     519           0     10000     9.91     B          0       MORTGAGE
#> 520     520           1     10000    14.27     C         14       MORTGAGE
#> 527     527           0     10000    14.27     C         57       MORTGAGE
#> 532     532           0     10000    17.27     D          3           RENT
#> 534     534           0     10000    15.27     C         27           RENT
#> 549     549           0     10000     6.62     A          8       MORTGAGE
#> 553     553           0     10000    14.27     C         21           RENT
#> 555     555           0     10000    10.65     B          1           RENT
#> 583     583           0     10000    14.27     C          4           RENT
#> 595     595           0     10000    10.65     B          4           RENT
#> 599     599           0     10000    16.77     D          4           RENT
#> 608     608           0     10000    16.77     D          1           RENT
#> 660     660           0     10000    10.65     B          6       MORTGAGE
#> 663     663           1     10000    11.71     B          5           RENT
#> 667     667           0     10000     9.91     B         15           RENT
#> 675     675           0     10000     9.91     B          3           RENT
#> 676     676           0     10000     9.91     B         10           RENT
#> 679     679           0     10000    10.65     B          3           RENT
#> 681     681           0     10000     6.62     A          2       MORTGAGE
#> 692     692           0     10000    14.27     C          0           RENT
#> 714     714           0     10000     8.90     A         11           RENT
#> 715     715           0     10000    11.71     B          5       MORTGAGE
#> 734     734           0     10000    10.65     B          3           RENT
#> 739     739           0     10000     9.91     B          2           RENT
#> 741     741           0     10000    13.49     C          4           RENT
#> 744     744           0     10000    14.27     C          3           RENT
#> 766     766           0     10000     7.51     A          2       MORTGAGE
#> 783     783           1     10000    15.27     C          0           RENT
#> 784     784           0     10000    15.27     C          1            OWN
#> 793     793           0     10000    12.69     B          4       MORTGAGE
#> 849     849           0     10000    12.42     B         22       MORTGAGE
#> 863     863           0     10000    15.96     C          2           RENT
#> 876     876           0     10000     6.03     A         14       MORTGAGE
#> 886     886           0     10000     6.62     A          2           RENT
#> 897     897           0     10000    12.42     B          6           RENT
#> 911     911           1     10000    17.58     D         40           RENT
#> 912     912           1     10000    13.49     C          0           RENT
#> 929     929           0     10000     6.03     A          0           RENT
#> 940     940           0     10000    14.65     C          4       MORTGAGE
#> 960     960           1     10000    13.49     C          5           RENT
#> 992     992           0     10000    17.27     D          5           RENT
#> 994     994           0     10000    14.65     C          4           RENT
#> 996     996           0     10000     9.91     B          0       MORTGAGE
#> 999     999           0     10000     8.90     A         11       MORTGAGE
#> 1003   1003           0     10000     9.91     B         15           RENT
#> 1018   1018           0     10000    12.69     B         22       MORTGAGE
#> 1024   1024           0     10000    12.42     B          3           RENT
#> 1029   1029           0     10000    12.42     B          5           RENT
#> 1035   1035           0     10000    18.25     D          3           RENT
#> 1055   1055           0     10000    13.49     C          5           RENT
#> 1095   1095           0     10000    11.71     B          1           RENT
#> 1099   1099           0     10000     6.03     A         17       MORTGAGE
#> 1103   1103           0     10000     6.03     A         13       MORTGAGE
#> 1109   1109           0     10000    11.71     B          5           RENT
#> 1127   1127           0     10000    15.27     C          0           RENT
#> 1130   1130           0     10000     6.03     A         16       MORTGAGE
#> 1139   1139           0     10000    15.96     C          4           RENT
#> 1141   1141           0     10000    13.49     C         13       MORTGAGE
#> 1175   1175           0     10000    16.77     D          6            OWN
#> 1193   1193           0     10000    11.71     B         16       MORTGAGE
#> 1226   1226           0     10000    13.49     C          5            OWN
#> 1247   1247           0     10000    12.42     B          0           RENT
#> 1257   1257           0     10000     7.51     A          2       MORTGAGE
#> 1271   1271           0     10000     6.62     A          8           RENT
#> 1272   1272           0     10000     6.03     A         14       MORTGAGE
#> 1278   1278           1     10000    16.29     D          6       MORTGAGE
#> 1280   1280           0     10000    12.69     B         17           RENT
#> 1292   1292           0     10000     6.62     A          2       MORTGAGE
#> 1305   1305           0     10000    11.71     B          2       MORTGAGE
#> 1321   1321           0     10000    13.49     C         13           RENT
#> 1351   1351           0     10000     7.51     A          5           RENT
#> 1364   1364           0     10000    10.65     B          8            OWN
#> 1370   1370           1     10000     7.51     A          5            OWN
#> 1378   1378           0     10000     6.62     A          3           RENT
#> 1402   1402           0     10000    11.71     B         25           RENT
#> 1409   1409           0     10000     8.90     A          8           RENT
#> 1416   1416           1     10000    16.77     D         16       MORTGAGE
#> 1463   1463           0     10000    12.42     B          2           RENT
#> 1472   1472           0     10000    10.65     B          8           RENT
#> 1478   1478           0     10000    11.71     B          2           RENT
#> 1480   1480           0     10000    16.77     D          9       MORTGAGE
#> 1500   1500           0     10000    12.42     B          3           RENT
#> 1506   1506           0     10000    10.65     B         11           RENT
#> 1526   1526           0     10000     9.91     B          6       MORTGAGE
#> 1542   1542           0     10000    16.77     D          2       MORTGAGE
#> 1546   1546           0     10000    12.69     B          2           RENT
#> 1555   1555           1     10000    14.27     C          6       MORTGAGE
#> 1556   1556           0     10000    12.42     B          1           RENT
#> 1560   1560           0     10000    11.71     B         14           RENT
#> 1565   1565           0     10000     6.03     A         14       MORTGAGE
#> 1568   1568           0     10000    13.49     C          7           RENT
#> 1569   1569           1     10000     7.51     A          2           RENT
#> 1587   1587           0     10000     9.91     B          6           RENT
#> 1597   1597           0     10000    10.65     B          4           RENT
#> 1627   1627           0     10000    16.29     D         12           RENT
#> 1646   1646           0     10000    14.27     C          6       MORTGAGE
#> 1649   1649           0     10000    10.65     B         12           RENT
#> 1654   1654           0     10000    13.49     C          8       MORTGAGE
#> 1655   1655           0     10000    16.77     D         12           RENT
#> 1656   1656           1     10000    11.71     B         12           RENT
#> 1673   1673           0     10000    12.69     B          4           RENT
#> 1686   1686           0     10000    12.42     B          5       MORTGAGE
#> 1688   1688           1     10000    15.96     C          9           RENT
#> 1690   1690           0     10000    13.49     C          1            OWN
#> 1691   1691           0     10000    11.71     B          2           RENT
#> 1717   1717           0     10000    14.27     C          7       MORTGAGE
#> 1736   1736           0     10000    13.49     C          1           RENT
#> 1739   1739           0     10000    15.96     C          7           RENT
#> 1756   1756           0     10000    10.65     B         11           RENT
#> 1760   1760           0     10000    16.77     D          3           RENT
#> 1761   1761           0     10000    12.42     B          2           RENT
#> 1762   1762           0     10000    16.77     D          3           RENT
#> 1765   1765           0     10000    11.71     B          4           RENT
#> 1773   1773           0     10000    10.65     B         18       MORTGAGE
#> 1794   1794           0     10000     7.90     A          9       MORTGAGE
#> 1823   1823           0     10000    12.69     B         11           RENT
#> 1834   1834           0     10000    10.65     B          1           RENT
#> 1837   1837           0     10000     9.91     B          6           RENT
#> 1857   1857           0     10000    16.29     D          5           RENT
#> 1860   1860           0     10000     6.62     A          4       MORTGAGE
#> 1872   1872           0     10000    14.65     C          2           RENT
#> 1879   1879           0     10000     7.51     A         17           RENT
#> 1882   1882           0     10000     9.91     B         27           RENT
#> 1914   1914           1     10000    12.69     B         17           RENT
#> 1925   1925           0     10000    16.29     D          4           RENT
#> 1940   1940           0     10000     6.03     A          1           RENT
#> 1967   1967           0     10000    11.71     B          0           RENT
#> 2002   2002           1     10000    15.96     C         13       MORTGAGE
#> 2069   2069           0     10000    12.42     B          9       MORTGAGE
#> 2070   2070           0     10000    11.71     B          4           RENT
#> 2091   2091           0     10000    14.65     C          1           RENT
#> 2113   2113           0     10000    11.71     B          5           RENT
#> 2118   2118           0     10000     7.51     A          7       MORTGAGE
#> 2135   2135           0     10000     7.51     A          7           RENT
#> 2137   2137           0     10000    14.27     C          0           RENT
#> 2203   2203           1     10000    19.42     E          3           RENT
#> 2204   2204           0     10000     6.62     A         20       MORTGAGE
#> 2259   2259           0     10000     9.91     B          3       MORTGAGE
#> 2347   2347           0     10000     8.90     A          3           RENT
#> 2351   2351           1     10000    14.27     C         11       MORTGAGE
#> 2357   2357           0     10000    14.27     C          5           RENT
#> 2359   2359           1     10000    15.27     C          0           RENT
#> 2364   2364           0     10000     6.62     A         22           RENT
#> 2382   2382           0     10000     6.62     A          1       MORTGAGE
#> 2384   2384           0     10000     6.03     A          2       MORTGAGE
#> 2403   2403           1     10000    14.27     C         34           RENT
#> 2404   2404           0     10000     7.90     A          4           RENT
#> 2418   2418           0     10000    12.42     B          3           RENT
#> 2421   2421           0     10000     6.62     A          8            OWN
#> 2443   2443           0     10000     9.91     B          1           RENT
#> 2449   2449           0     10000     6.62     A         15       MORTGAGE
#> 2485   2485           0     10000    12.69     B          1       MORTGAGE
#> 2490   2490           0     10000    10.65     B          2       MORTGAGE
#> 2500   2500           0     10000     6.03     A          3           RENT
#> 2552   2552           0     10000     8.90     A         17       MORTGAGE
#> 2581   2581           0     10000    13.49     C          7       MORTGAGE
#> 2592   2592           0     10000     7.90     A         12       MORTGAGE
#> 2617   2617           0     10000    12.69     B          9           RENT
#> 2619   2619           0     10000     7.90     A          6           RENT
#> 2649   2649           0     10000     6.03     A          5       MORTGAGE
#> 2658   2658           0     10000     7.51     A          7           RENT
#> 2705   2705           0     10000    10.65     B          1           RENT
#> 2714   2714           0     10000     7.90     A         16       MORTGAGE
#> 2728   2728           1     10000    15.27     C          5           RENT
#> 2740   2740           1     10000    12.69     B          1           RENT
#> 2746   2746           0     10000     6.62     A          6           RENT
#> 2750   2750           0     10000     6.03     A          2       MORTGAGE
#> 2765   2765           0     10000     6.03     A         19       MORTGAGE
#> 2780   2780           0     10000    12.42     B         13            OWN
#> 2809   2809           0     10000     7.51     A          7           RENT
#> 2812   2812           0     10000     6.62     A          4           RENT
#> 2813   2813           0     10000    11.71     B         19            OWN
#> 2829   2829           0     10000     7.90     A          2       MORTGAGE
#> 2855   2855           0     10000     7.90     A          6       MORTGAGE
#> 2864   2864           0     10000    16.77     D         10       MORTGAGE
#> 2902   2902           0     10000     7.51     A          2           RENT
#> 2914   2914           0     10000    18.64     E          5           RENT
#> 2919   2919           0     10000     7.90     A          6           RENT
#> 2931   2931           0     10000    14.27     C          5           RENT
#> 2936   2936           0     10000    11.71     B         13           RENT
#> 2938   2938           0     10000     7.90     A         13       MORTGAGE
#> 2970   2970           1     10000     6.62     A         17           RENT
#> 2988   2988           0     10000     7.90     A          1            OWN
#> 3015   3015           0     10000    14.65     C          4           RENT
#> 3067   3067           0     10000    10.65     B          3           RENT
#> 3069   3069           0     10000    10.65     B         24       MORTGAGE
#> 3071   3071           0     10000    11.71     B         22       MORTGAGE
#> 3073   3073           0     10000     7.90     A          9           RENT
#> 3075   3075           0     10000     7.90     A          2           RENT
#> 3084   3084           0     10000    11.71     B          5       MORTGAGE
#> 3134   3134           0     10000    14.27     C         13           RENT
#> 3161   3161           1     10000    13.49     C          3       MORTGAGE
#> 3175   3175           0     10000     8.90     A         13           RENT
#> 3192   3192           0     10000    10.65     B          4       MORTGAGE
#> 3194   3194           0     10000     6.62     A          5       MORTGAGE
#> 3215   3215           0     10000    11.71     B          2           RENT
#> 3248   3248           0     10000    14.27     C          5           RENT
#> 3263   3263           0     10000    17.58     D          0            OWN
#> 3265   3265           0     10000     7.90     A          1       MORTGAGE
#> 3291   3291           0     10000    12.69     B          4       MORTGAGE
#> 3309   3309           0     10000    10.65     B         39       MORTGAGE
#> 3312   3312           0     10000    14.65     C          1       MORTGAGE
#> 3320   3320           0     10000    13.49     C          5           RENT
#> 3349   3349           0     10000    10.65     B         13           RENT
#> 3373   3373           0     10000    10.65     B          7       MORTGAGE
#> 3400   3400           1     10000     9.91     B          4           RENT
#> 3404   3404           0     10000     9.91     B          7       MORTGAGE
#> 3405   3405           0     10000     6.03     A          3       MORTGAGE
#> 3407   3407           0     10000     8.90     A          6       MORTGAGE
#> 3410   3410           0     10000     6.62     A          4       MORTGAGE
#> 3424   3424           0     10000    16.29     D         24           RENT
#> 3499   3499           0     10000    10.65     B          2           RENT
#> 3513   3513           0     10000     6.03     A          4       MORTGAGE
#> 3529   3529           0     10000    18.25     D          0           RENT
#> 3555   3555           0     10000     7.90     A          3           RENT
#> 3557   3557           0     10000    12.42     B          0           RENT
#> 3561   3561           0     10000     6.62     A          0       MORTGAGE
#> 3583   3583           0     10000     6.03     A          8       MORTGAGE
#> 3594   3594           0     10000    13.49     C          2       MORTGAGE
#> 3597   3597           0     10000    17.27     D          0       MORTGAGE
#> 3609   3609           0     10000    14.27     C          1           RENT
#> 3618   3618           0     10000    14.27     C         13       MORTGAGE
#> 3630   3630           0     10000     6.03     A         17       MORTGAGE
#> 3637   3637           0     10000    12.42     B         23       MORTGAGE
#> 3650   3650           0     10000    12.69     B          2       MORTGAGE
#> 3664   3664           0     10000    15.27     C          9       MORTGAGE
#> 3670   3670           0     10000     6.03     A          6       MORTGAGE
#> 3680   3680           0     10000    14.65     C          4            OWN
#> 3693   3693           0     10000     6.03     A          0       MORTGAGE
#> 3703   3703           0     10000     6.03     A          5       MORTGAGE
#> 3721   3721           0     10000     6.62     A          0       MORTGAGE
#> 3726   3726           0     10000    14.27     C          3           RENT
#> 3735   3735           0     10000    11.71     B          5           RENT
#> 3742   3742           0     10000     6.03     A          5           RENT
#> 3768   3768           0     10000    15.96     C          0            OWN
#> 3814   3814           0     10000    10.65     B          2           RENT
#> 3817   3817           0     10000    17.58     D          3           RENT
#> 3836   3836           0     10000    14.27     C          2           RENT
#> 3837   3837           0     10000    18.64     E          8           RENT
#> 3846   3846           0     10000     7.90     A          0       MORTGAGE
#> 3862   3862           0     10000    11.71     B         16       MORTGAGE
#> 3903   3903           0     10000    13.49     C          6       MORTGAGE
#> 3918   3918           0     10000     6.62     A         14       MORTGAGE
#> 3926   3926           0     10000    16.29     D         17       MORTGAGE
#> 3937   3937           0     10000    14.27     C          3       MORTGAGE
#> 3959   3959           0     10000     7.51     A         13       MORTGAGE
#> 3961   3961           0     10000    12.69     B         18           RENT
#> 3965   3965           0     10000     7.51     A          5           RENT
#> 3991   3991           0     10000     8.90     A          5           RENT
#> 4005   4005           0     10000     7.51     A          1           RENT
#> 4043   4043           0     10000    19.03     E          0           RENT
#> 4048   4048           0     10000    12.42     B          2           RENT
#> 4070   4070           0     10000     6.03     A          5           RENT
#> 4078   4078           0     10000     6.62     A         17           RENT
#> 4125   4125           0     10000     6.62     A          5       MORTGAGE
#> 4137   4137           0     10000    12.69     B          1           RENT
#> 4142   4142           0     10000    12.42     B         21       MORTGAGE
#> 4195   4195           0     10000     6.62     A         14       MORTGAGE
#> 4219   4219           0     10000     9.91     B          3       MORTGAGE
#> 4242   4242           0     10000    14.27     C          3           RENT
#> 4252   4252           0     10000    11.71     B          2       MORTGAGE
#> 4284   4284           0     10000    13.49     C          1       MORTGAGE
#> 4326   4326           0     10000     6.03     A         12            OWN
#> 4362   4362           0     10000     6.03     A          2           RENT
#> 4367   4367           0     10000     7.90     A         16       MORTGAGE
#> 4394   4394           1     10000    15.96     C          0           RENT
#> 4457   4457           0     10000    18.25     D         31       MORTGAGE
#> 4471   4471           1     10000    16.29     D          4            OWN
#> 4502   4502           0     10000     7.90     A          0           RENT
#> 4513   4513           0     10000    11.71     B          1           RENT
#> 4547   4547           0     10000    14.27     C          7           RENT
#> 4554   4554           0     10000    11.99     B          4           RENT
#> 4555   4555           0     10000     9.91     B          7       MORTGAGE
#> 4561   4561           0     10000     6.03     A          8       MORTGAGE
#> 4592   4592           0     10000    12.69     B          5       MORTGAGE
#> 4644   4644           0     10000    12.69     B          1           RENT
#> 4652   4652           1     10000    13.49     C          5           RENT
#> 4653   4653           0     10000     6.62     A          0       MORTGAGE
#> 4677   4677           0     10000     6.03     A          1           RENT
#> 4697   4697           0     10000     8.90     A         10            OWN
#> 4702   4702           0     10000    10.65     B         40           RENT
#> 4725   4725           0     10000    12.42     B         11           RENT
#> 4731   4731           0     10000     6.03     A          4       MORTGAGE
#> 4808   4808           0     10000    10.65     B          8       MORTGAGE
#> 4823   4823           1     10000     6.62     A          4           RENT
#> 4834   4834           0     10000     6.03     A          9       MORTGAGE
#> 4843   4843           0     10000     6.62     A          2            OWN
#> 4888   4888           0     10000     6.62     A          5       MORTGAGE
#> 4898   4898           0     10000    11.71     B         14           RENT
#> 4901   4901           0     10000     9.91     B         14       MORTGAGE
#> 4908   4908           1     10000    20.89     F          4           RENT
#> 4909   4909           0     10000    12.69     B          1           RENT
#> 4914   4914           0     10000     7.90     A          1       MORTGAGE
#> 4972   4972           0     10000     6.62     A          3           RENT
#> 4978   4978           0     10000    14.65     C         17       MORTGAGE
#> 4996   4996           0     10000     7.51     A          6       MORTGAGE
#> 5008   5008           0     10000     9.91     B          6       MORTGAGE
#> 5042   5042           0     10000     6.62     A          3           RENT
#> 5081   5081           1     10000    11.71     B          4           RENT
#> 5094   5094           0     10000    11.71     B          4           RENT
#> 5110   5110           0     10000    14.65     C          0       MORTGAGE
#> 5134   5134           0     10000    15.62     D          6           RENT
#> 5136   5136           0     10000     9.99     B          5           RENT
#> 5148   5148           0     10000     8.49     A          2           RENT
#> 5168   5168           0     10000    11.49     B          3       MORTGAGE
#> 5195   5195           1     10000    12.99     C          3           RENT
#> 5196   5196           0     10000    13.99     C         27       MORTGAGE
#> 5212   5212           0     10000     5.42     A          5           RENT
#> 5219   5219           0     10000     5.42     A         20       MORTGAGE
#> 5222   5222           0     10000     5.99     A          5       MORTGAGE
#> 5254   5254           0     10000     5.42     A          8       MORTGAGE
#> 5271   5271           0     10000     8.49     A          2           RENT
#> 5273   5273           0     10000    11.99     B         11       MORTGAGE
#> 5285   5285           0     10000    16.89     D          4           RENT
#> 5317   5317           0     10000    15.62     D          1           RENT
#> 5319   5319           0     10000    16.89     D          4           RENT
#> 5335   5335           0     10000    15.62     D          1           RENT
#> 5348   5348           0     10000     9.99     B         19       MORTGAGE
#> 5350   5350           0     10000    11.99     B         15           RENT
#> 5364   5364           0     10000     5.99     A          4           RENT
#> 5378   5378           0     10000     5.99     A         19       MORTGAGE
#> 5392   5392           0     10000     5.99     A          6       MORTGAGE
#> 5431   5431           1     10000    12.99     C          1            OWN
#> 5440   5440           0     10000    15.62     D          9       MORTGAGE
#> 5488   5488           0     10000     9.99     B          3           RENT
#> 5534   5534           0     10000     5.99     A         23           RENT
#> 5570   5570           0     10000    15.99     D          1           RENT
#> 5609   5609           0     10000    12.99     C          5           RENT
#> 5614   5614           0     10000     8.49     A         16           RENT
#> 5652   5652           0     10000    12.99     C          3       MORTGAGE
#> 5681   5681           0     10000     5.99     A          4       MORTGAGE
#> 5687   5687           0     10000    10.99     B         19       MORTGAGE
#> 5736   5736           0     10000     9.99     B         11            OWN
#> 5742   5742           0     10000    10.99     B          8       MORTGAGE
#> 5748   5748           0     10000     6.99     A          1           RENT
#> 5767   5767           0     10000     6.99     A          7       MORTGAGE
#> 5788   5788           0     10000    15.99     D         12           RENT
#> 5814   5814           1     10000    10.99     B          1            OWN
#> 5815   5815           1     10000     8.49     A         16           RENT
#> 5829   5829           0     10000    13.49     C         10           RENT
#> 5830   5830           0     10000     7.49     A          3           RENT
#> 5858   5858           0     10000    12.99     C         37       MORTGAGE
#> 5867   5867           0     10000     5.99     A         11       MORTGAGE
#> 5880   5880           0     10000     5.42     A          6       MORTGAGE
#> 5884   5884           0     10000    10.99     B          4           RENT
#> 5929   5929           0     10000    11.49     B         10       MORTGAGE
#> 5932   5932           0     10000     9.99     B          4           RENT
#> 5939   5939           0     10000     5.99     A          6       MORTGAGE
#> 5944   5944           0     10000    10.99     B          2           RENT
#> 5957   5957           0     10000    10.99     B          5       MORTGAGE
#> 5964   5964           0     10000    13.99     C          5            OWN
#> 5975   5975           0     10000    13.99     C          0       MORTGAGE
#> 5976   5976           0     10000     5.99     A          0           RENT
#> 5982   5982           0     10000     5.42     A          4           RENT
#> 5991   5991           0     10000     5.99     A          3            OWN
#> 5998   5998           0     10000    10.99     B          3       MORTGAGE
#> 6008   6008           0     10000     9.99     B          7           RENT
#> 6029   6029           1     10000     5.42     A          6       MORTGAGE
#> 6033   6033           0     10000     6.99     A          2       MORTGAGE
#> 6074   6074           0     10000    15.23     C          5           RENT
#> 6076   6076           0     10000    12.99     C          0           RENT
#> 6092   6092           1     10000    13.99     C          0           RENT
#> 6138   6138           0     10000    10.99     B          3       MORTGAGE
#> 6163   6163           0     10000    10.59     B         16           RENT
#> 6165   6165           0     10000     7.49     A          1           RENT
#> 6207   6207           0     10000    19.29     E          8            OWN
#> 6226   6226           0     10000    16.89     D          4       MORTGAGE
#> 6235   6235           0     10000    11.49     B          0           RENT
#> 6246   6246           0     10000    15.23     C          3       MORTGAGE
#> 6251   6251           0     10000    11.49     B          0           RENT
#> 6270   6270           0     10000    10.99     B          1            OWN
#> 6292   6292           0     10000     7.49     A         16       MORTGAGE
#> 6302   6302           0     10000     8.49     A          2       MORTGAGE
#> 6335   6335           0     10000    10.99     B          1           RENT
#> 6353   6353           0     10000     5.99     A          3       MORTGAGE
#> 6401   6401           0     10000    10.59     B          3           RENT
#> 6439   6439           0     10000     8.49     A          3       MORTGAGE
#> 6460   6460           0     10000     5.42     A          3       MORTGAGE
#> 6465   6465           1     10000    15.99     D          4       MORTGAGE
#> 6477   6477           0     10000    13.49     C          5       MORTGAGE
#> 6480   6480           0     10000     9.99     B          3           RENT
#> 6483   6483           0     10000     9.99     B          1           RENT
#> 6498   6498           0     10000    11.49     B          3           RENT
#> 6508   6508           0     10000     8.49     A          5       MORTGAGE
#> 6515   6515           0     10000     7.49     A          1           RENT
#> 6522   6522           0     10000    13.49     C          8       MORTGAGE
#> 6532   6532           0     10000    10.59     B          2       MORTGAGE
#> 6536   6536           0     10000     7.49     A          5           RENT
#> 6542   6542           0     10000     9.99     B          5           RENT
#> 6553   6553           0     10000     8.49     A          5       MORTGAGE
#> 6560   6560           1     10000    10.59     B          0       MORTGAGE
#> 6609   6609           1     10000    10.99     B         13       MORTGAGE
#> 6610   6610           0     10000     7.49     A          6           RENT
#> 6613   6613           0     10000    11.49     B          5       MORTGAGE
#> 6672   6672           0     10000    13.49     C         26       MORTGAGE
#> 6695   6695           0     10000     9.99     B          0           RENT
#> 6698   6698           0     10000     7.49     A          5           RENT
#> 6702   6702           0     10000     5.99     A          0       MORTGAGE
#> 6713   6713           0     10000     6.99     A         24       MORTGAGE
#> 6735   6735           0     10000    11.49     B          7       MORTGAGE
#> 6758   6758           0     10000    10.99     B          6       MORTGAGE
#> 6783   6783           0     10000    10.59     B          1       MORTGAGE
#> 6787   6787           0     10000     6.99     A          6       MORTGAGE
#> 6797   6797           0     10000    15.62     D         13       MORTGAGE
#> 6818   6818           0     10000    15.99     D          4           RENT
#> 6829   6829           0     10000     5.99     A          2           RENT
#> 6858   6858           0     10000     7.49     A          2       MORTGAGE
#> 6889   6889           0     10000    16.89     D         43           RENT
#> 6899   6899           0     10000    10.99     B          3       MORTGAGE
#> 6920   6920           0     10000    16.89     D          6       MORTGAGE
#> 6992   6992           0     10000     7.49     A          3           RENT
#> 6995   6995           0     10000     8.49     A          0           RENT
#> 7002   7002           0     10000     9.99     B          1           RENT
#> 7049   7049           0     10000     8.49     A          2           RENT
#> 7073   7073           0     10000     7.49     A          1           RENT
#> 7136   7136           0     10000     7.49     A          3           RENT
#> 7162   7162           0     10000    11.49     B          5           RENT
#> 7177   7177           0     10000    20.99     F          2       MORTGAGE
#> 7207   7207           0     10000    16.89     D          1           RENT
#> 7221   7221           0     10000     5.99     A          1       MORTGAGE
#> 7249   7249           0     10000    13.49     C          2           RENT
#> 7264   7264           0     10000    10.99     B          6       MORTGAGE
#> 7290   7290           0     10000    10.99     B          0            OWN
#> 7334   7334           0     10000     7.49     A          5       MORTGAGE
#> 7344   7344           0     10000     7.49     A         21       MORTGAGE
#> 7358   7358           0     10000     8.49     A          4       MORTGAGE
#> 7362   7362           0     10000     7.49     A         13       MORTGAGE
#> 7377   7377           0     10000     7.49     A          4           RENT
#> 7405   7405           0     10000    10.59     B         14       MORTGAGE
#> 7411   7411           0     10000     7.49     A         13       MORTGAGE
#> 7419   7419           0     10000     6.99     A         20       MORTGAGE
#> 7423   7423           0     10000    13.99     C          9           RENT
#> 7443   7443           0     10000     8.49     A         15           RENT
#> 7471   7471           0     10000     6.99     A          3           RENT
#> 7475   7475           1     10000    15.62     D          6       MORTGAGE
#> 7501   7501           0     10000     7.49     A          0           RENT
#> 7522   7522           0     10000    15.62     D          6           RENT
#> 7542   7542           0     10000     5.99     A          3       MORTGAGE
#> 7555   7555           0     10000    13.99     C         19           RENT
#> 7558   7558           0     10000     6.99     A         33       MORTGAGE
#> 7580   7580           1     10000     8.49     A         15       MORTGAGE
#> 7597   7597           0     10000    10.99     B          4       MORTGAGE
#> 7608   7608           0     10000     7.49     A          3       MORTGAGE
#> 7651   7651           0     10000    11.49     B          4           RENT
#> 7652   7652           0     10000    10.99     B          0           RENT
#> 7658   7658           0     10000    20.62     F          2       MORTGAGE
#> 7668   7668           0     10000    13.99     C          5       MORTGAGE
#> 7690   7690           0     10000    11.99     B          5           RENT
#> 7694   7694           0     10000     7.49     A          2       MORTGAGE
#> 7700   7700           0     10000     7.49     A          0            OWN
#> 7716   7716           0     10000     8.49     A          5           RENT
#> 7720   7720           0     10000    13.99     C          3           RENT
#> 7725   7725           0     10000    13.99     C         12       MORTGAGE
#> 7773   7773           0     10000    19.69     E         11           RENT
#> 7792   7792           1     10000    18.39     E         26       MORTGAGE
#> 7793   7793           0     10000     8.49     A          5       MORTGAGE
#> 7797   7797           0     10000    13.49     C         23       MORTGAGE
#> 7808   7808           0     10000    10.59     B          3            OWN
#> 7810   7810           0     10000    11.99     B          1       MORTGAGE
#> 7822   7822           0     10000    10.59     B          4           RENT
#> 7836   7836           0     10000     8.49     A         17           RENT
#> 7930   7930           1     10000    13.49     C          3           RENT
#> 7933   7933           0     10000     6.99     A          4       MORTGAGE
#> 7936   7936           0     10000    16.49     D          4       MORTGAGE
#> 7996   7996           0     10000    16.89     D         14       MORTGAGE
#> 8003   8003           0     10000    11.99     B          5           RENT
#> 8021   8021           0     10000    11.49     B          6       MORTGAGE
#> 8042   8042           0     10000    16.89     D         10           RENT
#> 8056   8056           0     10000    16.49     D          1            OWN
#> 8064   8064           0     10000     5.42     A          9       MORTGAGE
#> 8078   8078           0     10000     8.49     A          6       MORTGAGE
#> 8099   8099           0     10000     7.49     A         14       MORTGAGE
#> 8102   8102           0     10000     7.49     A         12            OWN
#> 8106   8106           0     10000     9.99     B          6       MORTGAGE
#> 8118   8118           0     10000     9.99     B          7       MORTGAGE
#> 8176   8176           0     10000     5.42     A         14           RENT
#> 8202   8202           0     10000     5.99     A          0       MORTGAGE
#> 8245   8245           0     10000     8.49     A         14            OWN
#> 8334   8334           0     10000    11.99     B          5           RENT
#> 8343   8343           0     10000    15.62     D          8       MORTGAGE
#> 8357   8357           0     10000    10.99     B         11       MORTGAGE
#> 8379   8379           0     10000     5.99     A          4       MORTGAGE
#> 8381   8381           0     10000    14.79     C          5       MORTGAGE
#> 8386   8386           0     10000     5.42     A          1           RENT
#> 8401   8401           0     10000     7.49     A         20       MORTGAGE
#> 8449   8449           0     10000    18.39     E         14       MORTGAGE
#> 8451   8451           0     10000     5.99     A         13       MORTGAGE
#> 8452   8452           1     10000     8.49     A         15       MORTGAGE
#> 8457   8457           0     10000     5.42     A         10       MORTGAGE
#> 8460   8460           0     10000     5.99     A         12       MORTGAGE
#> 8508   8508           0     10000     8.49     A          5           RENT
#> 8518   8518           0     10000     7.49     A          2           RENT
#> 8531   8531           0     10000     5.42     A         13       MORTGAGE
#> 8538   8538           0     10000     5.42     A          0           RENT
#> 8548   8548           0     10000     7.49     A          4           RENT
#> 8569   8569           0     10000    13.49     C          3           RENT
#> 8593   8593           0     10000    15.62     D         21           RENT
#> 8597   8597           0     10000     6.99     A          1       MORTGAGE
#> 8607   8607           0     10000     8.49     A          0           RENT
#> 8628   8628           0     10000    14.79     C         11       MORTGAGE
#> 8631   8631           0     10000    16.49     D          2            OWN
#> 8644   8644           0     10000     5.99     A          2       MORTGAGE
#> 8661   8661           0     10000     6.99     A          6       MORTGAGE
#> 8679   8679           0     10000    10.99     B         23       MORTGAGE
#> 8701   8701           1     10000    18.39     E          9           RENT
#> 8706   8706           0     10000    10.99     B          1       MORTGAGE
#> 8714   8714           0     10000     7.49     A          2           RENT
#> 8745   8745           0     10000     5.99     A          3           RENT
#> 8788   8788           0     10000     5.99     A          3       MORTGAGE
#> 8813   8813           0     10000    10.59     B          2       MORTGAGE
#> 8833   8833           0     10000     7.49     A          6           RENT
#> 8852   8852           0     10000    13.99     C         10       MORTGAGE
#> 8858   8858           0     10000     7.49     A          4           RENT
#> 8859   8859           0     10000     9.99     B          0           RENT
#> 8885   8885           0     10000    11.99     B          4       MORTGAGE
#> 8903   8903           1     10000     6.99     A          1       MORTGAGE
#> 8907   8907           0     10000     8.49     A          6           RENT
#> 8909   8909           0     10000     5.99     A          0           RENT
#> 8918   8918           0     10000    13.49     C          5           RENT
#> 8920   8920           0     10000    14.79     C          1       MORTGAGE
#> 8940   8940           0     10000     5.99     A         23           RENT
#> 8952   8952           0     10000    10.99     B         12           RENT
#> 8992   8992           0     10000    16.11     C          4           RENT
#> 9014   9014           0     10000     5.42     A          6       MORTGAGE
#> 9022   9022           0     10000     5.42     A          0       MORTGAGE
#> 9046   9046           0     10000    18.07     D          6            OWN
#> 9078   9078           0     10000    16.11     C          7       MORTGAGE
#> 9102   9102           0     10000     9.99     B          3            OWN
#> 9114   9114           0     10000     7.49     A         12       MORTGAGE
#> 9133   9133           0     10000    15.99     D         15       MORTGAGE
#> 9158   9158           0     10000     7.49     A          4       MORTGAGE
#> 9170   9170           0     10000    10.59     B         15            OWN
#> 9177   9177           0     10000    13.49     C         17       MORTGAGE
#> 9190   9190           1     10000    11.99     B         12           RENT
#> 9206   9206           1     10000    15.23     C          0           RENT
#> 9268   9268           0     10000    11.49     B          8       MORTGAGE
#> 9290   9290           0     10000     7.49     A          4           RENT
#> 9294   9294           0     10000    11.99     B          4           RENT
#> 9330   9330           0     10000     8.49     A         13           RENT
#> 9335   9335           0     10000    12.99     C          5           RENT
#> 9344   9344           0     10000    14.79     C          1           RENT
#> 9346   9346           0     10000    11.99     B          4            OWN
#> 9348   9348           0     10000    10.99     B          2           RENT
#> 9350   9350           0     10000    17.99     E          7           RENT
#> 9367   9367           0     10000     9.99     B          7       MORTGAGE
#> 9377   9377           0     10000    10.59     B          3           RENT
#> 9387   9387           0     10000    16.89     D          9       MORTGAGE
#> 9408   9408           0     10000     5.99     A          6       MORTGAGE
#> 9410   9410           0     10000    16.49     D          4           RENT
#> 9421   9421           0     10000     7.49     A          7       MORTGAGE
#> 9424   9424           0     10000     6.99     A          0           RENT
#> 9431   9431           0     10000    11.49     B          8           RENT
#> 9443   9443           0     10000    15.62     D          0           RENT
#> 9449   9449           0     10000    12.99     C         10           RENT
#> 9451   9451           0     10000    10.59     B          0           RENT
#> 9484   9484           0     10000     5.42     A         13       MORTGAGE
#> 9488   9488           0     10000    16.89     D          0       MORTGAGE
#> 9493   9493           0     10000    15.99     D          1           RENT
#> 9501   9501           0     10000     9.99     B          4           RENT
#> 9510   9510           0     10000     6.99     A         34       MORTGAGE
#> 9578   9578           0     10000     7.49     A          5           RENT
#> 9597   9597           0     10000    10.59     B          3       MORTGAGE
#> 9617   9617           0     10000    10.59     B         21           RENT
#> 9635   9635           0     10000     7.49     A          0           RENT
#> 9649   9649           0     10000    12.99     C         12       MORTGAGE
#> 9651   9651           0     10000     6.99     A          6           RENT
#> 9659   9659           0     10000     7.49     A          1       MORTGAGE
#> 9667   9667           1     10000    16.89     D         14       MORTGAGE
#> 9668   9668           0     10000     9.99     B         10       MORTGAGE
#> 9676   9676           0     10000    19.29     E          0           RENT
#> 9727   9727           1     10000    17.99     E          5       MORTGAGE
#> 9742   9742           0     10000    16.49     D          2           RENT
#> 9743   9743           0     10000     7.49     A          6       MORTGAGE
#> 9763   9763           0     10000     7.49     A         13           RENT
#> 9776   9776           0     10000    15.23     C          4            OWN
#> 9786   9786           0     10000     8.49     A          1           RENT
#> 9792   9792           0     10000     9.99     B          2       MORTGAGE
#> 9809   9809           0     10000    10.99     B          4            OWN
#> 9815   9815           0     10000    10.99     B         27       MORTGAGE
#> 9821   9821           0     10000     7.49     A          4           RENT
#> 9854   9854           0     10000     7.49     A          5       MORTGAGE
#> 9859   9859           1     10000     7.49     A         20            OWN
#> 9862   9862           0     10000    13.49     C          5           RENT
#> 9891   9891           0     10000    13.99     C          3           RENT
#> 9893   9893           0     10000    11.99     B          5           RENT
#> 9922   9922           0     10000    11.99     B         12            OWN
#> 9949   9949           0     10000    11.99     B          5       MORTGAGE
#> 9958   9958           0     10000     7.49     A          2       MORTGAGE
#> 9959   9959           0     10000    11.99     B         13       MORTGAGE
#> 9982   9982           0     10000     5.42     A          1       MORTGAGE
#> 10007 10007           0     10000     7.49     A          2       MORTGAGE
#> 10029 10029           0     10000    10.59     B         16           RENT
#> 10040 10040           0     10000     7.49     A         26       MORTGAGE
#> 10053 10053           0     10000    10.99     B         10       MORTGAGE
#> 10059 10059           0     10000     7.49     A          4            OWN
#> 10063 10063           0     10000    16.49     D          3           RENT
#> 10080 10080           0     10000    13.49     C          1       MORTGAGE
#> 10081 10081           0     10000     8.49     A          6       MORTGAGE
#> 10106 10106           0     10000    16.89     D          1       MORTGAGE
#> 10138 10138           1     10000    16.49     D          6       MORTGAGE
#> 10148 10148           0     10000     7.49     A         20       MORTGAGE
#> 10156 10156           0     10000     7.49     A         19           RENT
#> 10161 10161           0     10000    10.59     B         12       MORTGAGE
#> 10196 10196           0     10000    10.99     B         17       MORTGAGE
#> 10198 10198           0     10000     5.99     A          5       MORTGAGE
#> 10205 10205           0     10000     5.99     A         13       MORTGAGE
#> 10208 10208           0     10000     7.49     A          7           RENT
#> 10237 10237           0     10000     5.99     A          4           RENT
#> 10239 10239           0     10000    10.99     B          4           RENT
#> 10254 10254           1     10000    10.59     B         28       MORTGAGE
#> 10258 10258           0     10000     7.49     A          3           RENT
#> 10278 10278           0     10000     7.49     A          7       MORTGAGE
#> 10304 10304           1     10000     8.49     A          2       MORTGAGE
#> 10313 10313           0     10000    13.49     C          5       MORTGAGE
#> 10314 10314           0     10000     5.99     A          8       MORTGAGE
#> 10315 10315           0     10000    11.99     B         11       MORTGAGE
#> 10320 10320           0     10000     8.49     A          4            OWN
#> 10321 10321           0     10000     5.99     A          5       MORTGAGE
#> 10323 10323           0     10000    13.99     C         17       MORTGAGE
#> 10327 10327           0     10000     7.49     A          2           RENT
#> 10333 10333           1     10000    12.99     C          8           RENT
#> 10343 10343           0     10000     8.49     A         34           RENT
#> 10348 10348           0     10000     7.49     A          3       MORTGAGE
#> 10351 10351           0     10000    11.99     B          4           RENT
#> 10372 10372           0     10000     8.49     A          2           RENT
#> 10409 10409           0     10000     6.99     A          1           RENT
#> 10421 10421           0     10000     6.99     A          4           RENT
#> 10427 10427           1     10000    11.99     B          3           RENT
#> 10431 10431           1     10000    15.99     D          4       MORTGAGE
#> 10491 10491           0     10000     8.49     A         24       MORTGAGE
#> 10505 10505           0     10000     7.49     A          2           RENT
#> 10530 10530           0     10000     9.99     B         13       MORTGAGE
#> 10548 10548           0     10000     7.49     A          2           RENT
#> 10555 10555           0     10000     7.29     A          9       MORTGAGE
#> 10575 10575           0     10000    10.74     B         12       MORTGAGE
#> 10585 10585           1     10000    17.14     E          0           RENT
#> 10630 10630           0     10000     9.63     B          0            OWN
#> 10635 10635           0     10000    10.74     B         21           RENT
#> 10659 10659           0     10000     5.42     A         27       MORTGAGE
#> 10665 10665           0     10000     5.79     A          6       MORTGAGE
#> 10668 10668           0     10000    10.00     B          0       MORTGAGE
#> 10689 10689           0     10000     5.79     A         10       MORTGAGE
#> 10707 10707           0     10000     7.66     A          6           RENT
#> 10715 10715           0     10000    13.43     C          2       MORTGAGE
#> 10722 10722           0     10000     5.42     A         12       MORTGAGE
#> 10726 10726           0     10000     6.92     A          2            OWN
#> 10727 10727           0     10000    14.54     D         13           RENT
#> 10734 10734           1     10000    11.11     B         16       MORTGAGE
#> 10735 10735           0     10000     7.66     A          2           RENT
#> 10748 10748           0     10000     7.29     A          1       MORTGAGE
#> 10777 10777           1     10000    13.43     C         15           RENT
#> 10787 10787           0     10000    10.74     B          3           RENT
#> 10801 10801           0     10000     9.63     B          2       MORTGAGE
#> 10814 10814           0     10000    13.43     C          6       MORTGAGE
#> 10821 10821           0     10000    12.68     C          3       MORTGAGE
#> 10853 10853           0     10000    11.11     B         12       MORTGAGE
#> 10858 10858           0     10000    10.37     B          0           RENT
#> 10872 10872           0     10000    16.40     E         16           RENT
#> 10882 10882           0     10000     7.29     A          2       MORTGAGE
#> 10903 10903           0     10000    13.06     C         21       MORTGAGE
#> 10925 10925           0     10000    16.77     E          6           RENT
#> 10982 10982           0     10000    10.74     B          3           RENT
#> 10983 10983           0     10000     7.66     A          9           RENT
#> 10990 10990           0     10000    14.17     C          0           RENT
#> 11027 11027           0     10000     7.29     A          8       MORTGAGE
#> 11030 11030           0     10000     7.29     A          5           RENT
#> 11047 11047           1     10000    13.43     C          3       MORTGAGE
#> 11069 11069           1     10000    10.37     B          5           RENT
#> 11075 11075           0     10000     6.92     A          3       MORTGAGE
#> 11086 11086           0     10000    11.11     B          3       MORTGAGE
#> 11097 11097           0     10000     7.29     A          3       MORTGAGE
#> 11118 11118           0     10000     5.79     A         12       MORTGAGE
#> 11121 11121           0     10000    15.65     D         15            OWN
#> 11170 11170           0     10000    10.37     B          6           RENT
#> 11184 11184           0     10000    14.91     D          7           RENT
#> 11188 11188           0     10000     5.79     A         14            OWN
#> 11194 11194           0     10000    14.17     C         15       MORTGAGE
#> 11202 11202           0     10000    13.06     C         16           RENT
#> 11219 11219           0     10000    15.28     D          2       MORTGAGE
#> 11229 11229           0     10000     6.92     A         15       MORTGAGE
#> 11231 11231           0     10000    13.06     C         14            OWN
#> 11241 11241           0     10000     7.29     A          5       MORTGAGE
#> 11246 11246           0     10000    11.11     B         14           RENT
#> 11261 11261           0     10000    11.11     B          0           RENT
#> 11289 11289           0     10000    14.54     D          3       MORTGAGE
#> 11295 11295           0     10000     6.92     A          4       MORTGAGE
#> 11309 11309           0     10000     6.92     A          5            OWN
#> 11316 11316           0     10000    10.00     B         12       MORTGAGE
#> 11317 11317           0     10000     7.29     A          2       MORTGAGE
#> 11320 11320           0     10000     7.29     A          0       MORTGAGE
#> 11326 11326           0     10000     7.66     A         10           RENT
#> 11333 11333           0     10000    10.74     B          5       MORTGAGE
#> 11368 11368           0     10000    10.74     B          3           RENT
#> 11390 11390           0     10000    13.06     C          6       MORTGAGE
#> 11422 11422           0     10000    15.28     D          2       MORTGAGE
#> 11430 11430           0     10000    14.54     D          0           RENT
#> 11438 11438           0     10000     7.66     A          8       MORTGAGE
#> 11453 11453           0     10000     6.92     A         12       MORTGAGE
#> 11459 11459           0     10000    12.68     C          0           RENT
#> 11501 11501           0     10000     5.79     A         15           RENT
#> 11519 11519           0     10000    15.65     D          5       MORTGAGE
#> 11560 11560           1     10000     6.92     A          3            OWN
#> 11602 11602           0     10000    10.00     B         14       MORTGAGE
#> 11603 11603           0     10000     9.63     B         10           RENT
#> 11648 11648           0     10000     7.66     A          3       MORTGAGE
#> 11697 11697           0     10000    13.43     C          2            OWN
#> 11726 11726           0     10000    13.06     C          8       MORTGAGE
#> 11751 11751           1     10000     5.42     A         25           RENT
#> 11772 11772           0     10000     6.92     A          1       MORTGAGE
#> 11797 11797           0     10000     5.42     A          4       MORTGAGE
#> 11803 11803           0     10000    10.37     B          4           RENT
#> 11805 11805           0     10000    11.11     B          0           RENT
#> 11819 11819           1     10000    10.37     B         14           RENT
#> 11824 11824           0     10000     7.29     A          7       MORTGAGE
#> 11861 11861           0     10000    11.11     B          0           RENT
#> 11890 11890           0     10000     5.42     A          4           RENT
#> 11898 11898           0     10000     6.92     A          3           RENT
#> 11899 11899           0     10000     9.63     B          9       MORTGAGE
#> 11904 11904           0     10000     7.29     A          2           RENT
#> 11905 11905           0     10000    14.91     D         13       MORTGAGE
#> 11911 11911           0     10000    12.68     C          5       MORTGAGE
#> 11918 11918           0     10000    16.40     E          0           RENT
#> 11923 11923           0     10000    10.00     B          4       MORTGAGE
#> 11937 11937           0     10000     9.63     B          3       MORTGAGE
#> 11941 11941           1     10000    10.37     B          5           RENT
#> 11944 11944           0     10000    15.65     D          2           RENT
#> 11947 11947           0     10000    16.02     D          7           RENT
#> 11948 11948           0     10000     5.79     A          3       MORTGAGE
#> 11961 11961           1     10000    13.80     C          3           RENT
#> 11971 11971           0     10000     5.79     A          7           RENT
#> 11975 11975           0     10000    10.37     B         18       MORTGAGE
#> 11980 11980           0     10000    16.40     E          1           RENT
#> 11986 11986           1     10000    10.74     B          4           RENT
#> 11992 11992           0     10000    10.37     B         30       MORTGAGE
#> 12009 12009           0     10000     5.42     A         12       MORTGAGE
#> 12017 12017           0     10000    10.74     B          3           RENT
#> 12031 12031           0     10000    11.11     B          2           RENT
#> 12036 12036           1     10000    11.11     B         14            OWN
#> 12041 12041           0     10000     9.63     B          5           RENT
#> 12081 12081           0     10000    10.37     B         13           RENT
#> 12102 12102           0     10000     5.79     A         20       MORTGAGE
#> 12128 12128           0     10000     9.63     B         13       MORTGAGE
#> 12129 12129           1     10000     7.29     A          6           RENT
#> 12137 12137           0     10000    17.14     E          7       MORTGAGE
#> 12160 12160           0     10000     6.92     A          0       MORTGAGE
#> 12171 12171           0     10000    13.06     C          7       MORTGAGE
#> 12175 12175           0     10000     7.29     A          1            OWN
#> 12194 12194           0     10000    15.28     D          0           RENT
#> 12198 12198           0     10000     9.63     B         14       MORTGAGE
#> 12222 12222           0     10000    10.74     B          7           RENT
#> 12225 12225           0     10000     5.42     A          9       MORTGAGE
#> 12226 12226           0     10000    13.06     C          7           RENT
#> 12271 12271           0     10000    16.02     D          1           RENT
#> 12277 12277           0     10000     5.79     A         15       MORTGAGE
#> 12301 12301           0     10000     7.29     A          0           RENT
#> 12311 12311           0     10000    10.37     B          0           RENT
#> 12321 12321           0     10000     7.29     A          0            OWN
#> 12361 12361           0     10000     6.92     A          2           RENT
#> 12382 12382           0     10000    11.11     B          7           RENT
#> 12404 12404           0     10000     7.29     A          6           RENT
#> 12425 12425           0     10000     9.63     B          5       MORTGAGE
#> 12441 12441           0     10000    15.65     D          3           RENT
#> 12459 12459           0     10000    10.37     B          4           RENT
#> 12468 12468           0     10000    10.37     B         16           RENT
#> 12495 12495           0     10000     7.29     A          3           RENT
#> 12500 12500           1     10000    10.37     B          2       MORTGAGE
#> 12502 12502           0     10000     6.92     A         23            OWN
#> 12533 12533           0     10000     7.66     A          3       MORTGAGE
#> 12558 12558           0     10000    10.37     B          7            OWN
#> 12566 12566           0     10000     7.66     A          1           RENT
#> 12573 12573           0     10000     7.66     A          3           RENT
#> 12602 12602           0     10000    15.28     D          2           RENT
#> 12615 12615           0     10000     7.66     A         15       MORTGAGE
#> 12617 12617           0     10000     5.79     A          1       MORTGAGE
#> 12625 12625           0     10000     6.92     A         12           RENT
#> 12631 12631           0     10000     9.63     B         14            OWN
#> 12641 12641           0     10000     6.92     A          3           RENT
#> 12646 12646           0     10000    10.37     B          0       MORTGAGE
#> 12686 12686           0     10000    13.43     C         15       MORTGAGE
#> 12691 12691           0     10000    10.37     B          1       MORTGAGE
#> 12700 12700           1     10000    13.06     C          0           RENT
#> 12708 12708           0     10000     7.29     A          0           RENT
#> 12721 12721           0     10000    11.11     B          2       MORTGAGE
#> 12723 12723           0     10000    10.74     B          1           RENT
#> 12725 12725           0     10000     7.66     A          6           RENT
#> 12741 12741           0     10000    14.91     D          3           RENT
#> 12751 12751           0     10000     6.92     A          9       MORTGAGE
#> 12756 12756           0     10000     7.66     A         20            OWN
#> 12769 12769           0     10000    16.02     D         11           RENT
#> 12770 12770           0     10000     5.42     A         14       MORTGAGE
#> 12777 12777           0     10000    12.68     C         11           RENT
#> 12778 12778           0     10000     7.29     A         11           RENT
#> 12780 12780           0     10000     7.29     A          3           RENT
#> 12784 12784           0     10000     7.66     A          1       MORTGAGE
#> 12785 12785           0     10000     7.66     A          0           RENT
#> 12788 12788           1     10000    17.88     E         12           RENT
#> 12811 12811           0     10000    10.00     B          1       MORTGAGE
#> 12819 12819           0     10000     7.29     A          3           RENT
#> 12831 12831           0     10000     6.92     A          2       MORTGAGE
#> 12844 12844           0     10000     7.29     A          9       MORTGAGE
#> 12849 12849           0     10000    10.37     B          3           RENT
#> 12852 12852           0     10000    10.37     B          4            OWN
#> 12864 12864           0     10000     7.66     A          3           RENT
#> 12868 12868           0     10000    10.74     B          4       MORTGAGE
#> 12893 12893           1     10000    17.14     E          0           RENT
#> 12914 12914           0     10000     9.63     B         12       MORTGAGE
#> 12945 12945           0     10000     7.29     A          0           RENT
#> 12946 12946           0     10000    10.37     B          7           RENT
#> 12951 12951           0     10000    15.65     D          5           RENT
#> 12952 12952           0     10000    14.91     D          2           RENT
#> 12965 12965           0     10000    16.40     E          2           RENT
#> 12973 12973           0     10000    15.28     D          0           RENT
#> 12993 12993           0     10000     7.66     A          4           RENT
#> 12998 12998           0     10000     5.79     A         17       MORTGAGE
#> 13000 13000           0     10000     5.79     A         42       MORTGAGE
#> 13001 13001           0     10000    10.00     B          1           RENT
#> 13028 13028           0     10000     7.29     A          5       MORTGAGE
#> 13044 13044           0     10000    10.74     B         14           RENT
#> 13082 13082           0     10000     7.29     A          5           RENT
#> 13086 13086           0     10000    10.00     B          5           RENT
#> 13103 13103           0     10000    16.02     D          3           RENT
#> 13109 13109           0     10000     5.79     A          1       MORTGAGE
#> 13123 13123           0     10000    17.14     E          3           RENT
#> 13127 13127           0     10000    11.11     B          2       MORTGAGE
#> 13141 13141           0     10000     5.79     A          1           RENT
#> 13164 13164           0     10000     5.79     A          3       MORTGAGE
#> 13180 13180           0     10000     7.66     A         26           RENT
#> 13186 13186           1     10000    13.06     C          7           RENT
#> 13195 13195           0     10000    11.11     B         14       MORTGAGE
#> 13196 13196           0     10000    10.37     B          5           RENT
#> 13215 13215           0     10000     7.66     A          6       MORTGAGE
#> 13221 13221           0     10000     7.29     A          4       MORTGAGE
#> 13222 13222           0     10000     7.29     A          2       MORTGAGE
#> 13252 13252           0     10000     5.79     A          0           RENT
#> 13264 13264           0     10000    10.37     B          2           RENT
#> 13268 13268           0     10000     7.29     A          2           RENT
#> 13270 13270           0     10000     5.79     A          1           RENT
#> 13272 13272           0     10000    13.80     C         30       MORTGAGE
#> 13284 13284           0     10000     7.29     A          1           RENT
#> 13287 13287           0     10000     5.79     A          5       MORTGAGE
#> 13299 13299           0     10000    10.00     B          6           RENT
#> 13302 13302           1     10000     6.92     A          0            OWN
#> 13321 13321           0     10000    10.74     B          6       MORTGAGE
#> 13324 13324           0     10000     7.29     A          5       MORTGAGE
#> 13325 13325           0     10000    18.25     F         25       MORTGAGE
#> 13331 13331           0     10000    10.37     B         13           RENT
#> 13335 13335           1     10000    14.54     D         30           RENT
#> 13337 13337           0     10000     6.92     A         25           RENT
#> 13347 13347           0     10000     5.79     A          0       MORTGAGE
#> 13352 13352           0     10000     7.29     A          8           RENT
#> 13364 13364           0     10000    11.11     B          0           RENT
#> 13368 13368           0     10000    10.37     B          7           RENT
#> 13372 13372           1     10000    10.37     B          2       MORTGAGE
#> 13380 13380           0     10000    12.68     C         12           RENT
#> 13394 13394           0     10000    14.54     D          1           RENT
#> 13395 13395           0     10000     5.42     A          1       MORTGAGE
#> 13397 13397           0     10000     7.29     A          0           RENT
#> 13407 13407           0     10000     5.42     A         11       MORTGAGE
#> 13415 13415           0     10000    10.00     B          1           RENT
#> 13421 13421           0     10000     5.79     A          5           RENT
#> 13423 13423           0     10000     7.66     A          6           RENT
#> 13424 13424           0     10000     6.92     A          2            OWN
#> 13443 13443           0     10000    10.00     B          1           RENT
#> 13444 13444           0     10000    10.74     B         20       MORTGAGE
#> 13453 13453           0     10000    16.40     E          6       MORTGAGE
#> 13473 13473           0     10000     7.29     A          5           RENT
#> 13477 13477           0     10000     9.63     B          4           RENT
#> 13480 13480           0     10000    13.80     C          6           RENT
#> 13495 13495           0     10000    16.40     E          0           RENT
#> 13503 13503           0     10000    10.74     B         25       MORTGAGE
#> 13505 13505           1     10000     7.66     A          8       MORTGAGE
#> 13507 13507           0     10000     7.66     A         18       MORTGAGE
#> 13519 13519           0     10000     6.92     A          0           RENT
#> 13525 13525           1     10000    10.37     B         12           RENT
#> 13532 13532           0     10000    12.68     C          0       MORTGAGE
#> 13558 13558           0     10000    15.65     D          4       MORTGAGE
#> 13569 13569           0     10000    10.37     B          6            OWN
#> 13577 13577           0     10000     9.63     B          9           RENT
#> 13598 13598           0     10000    16.40     E          4           RENT
#> 13617 13617           0     10000     7.66     A          0           RENT
#> 13624 13624           0     10000     7.66     A         13       MORTGAGE
#> 13628 13628           0     10000    10.00     B          2           RENT
#> 13630 13630           0     10000     7.29     A         14       MORTGAGE
#> 13640 13640           0     10000     5.79     A         18       MORTGAGE
#> 13658 13658           0     10000     7.66     A          0           RENT
#> 13675 13675           0     10000     9.99     B          5           RENT
#> 13694 13694           0     10000     9.99     B          5       MORTGAGE
#> 13756 13756           0     10000     9.25     B          1           RENT
#> 13763 13763           0     10000    15.57     D          2           RENT
#> 13786 13786           0     10000     6.91     A          0           RENT
#> 13800 13800           1     10000    10.36     B         23           RENT
#> 13802 13802           0     10000    13.72     C          2       MORTGAGE
#> 13809 13809           1     10000    12.61     C          0       MORTGAGE
#> 13839 13839           0     10000     6.54     A          4           RENT
#> 13853 13853           0     10000     9.99     B          2           RENT
#> 13879 13879           0     10000    12.98     C          6       MORTGAGE
#> 13881 13881           0     10000    14.09     D          3       MORTGAGE
#> 13891 13891           0     10000     9.99     B          3       MORTGAGE
#> 13904 13904           0     10000    12.98     C          0           RENT
#> 13914 13914           0     10000     6.91     A         25       MORTGAGE
#> 13915 13915           0     10000     6.54     A         23           RENT
#> 13931 13931           0     10000     6.54     A         16            OWN
#> 13938 13938           0     10000     6.17     A          6       MORTGAGE
#> 13955 13955           0     10000     5.79     A          6           RENT
#> 14023 14023           0     10000    12.98     C          2       MORTGAGE
#> 14040 14040           0     10000     5.79     A          4       MORTGAGE
#> 14043 14043           0     10000     6.54     A          1           RENT
#> 14060 14060           0     10000     8.88     B          8       MORTGAGE
#> 14081 14081           1     10000     5.79     A         18       MORTGAGE
#> 14084 14084           0     10000     6.54     A          5           RENT
#> 14094 14094           0     10000     6.91     A          3           RENT
#> 14105 14105           0     10000     9.99     B         25           RENT
#> 14126 14126           0     10000     6.17     A          8           RENT
#> 14161 14161           1     10000     6.54     A          2       MORTGAGE
#> 14166 14166           0     10000     5.79     A         12           RENT
#> 14175 14175           0     10000    16.32     E         17       MORTGAGE
#> 14187 14187           0     10000    10.36     B          0           RENT
#> 14189 14189           1     10000    14.09     D          0       MORTGAGE
#> 14197 14197           0     10000     6.17     A          0       MORTGAGE
#> 14210 14210           0     10000     5.79     A          2           RENT
#> 14227 14227           0     10000     6.54     A          9       MORTGAGE
#> 14240 14240           0     10000     6.91     A          1           RENT
#> 14257 14257           0     10000     5.79     A          3           RENT
#> 14260 14260           0     10000     9.99     B          1       MORTGAGE
#> 14266 14266           0     10000     6.54     A          3           RENT
#> 14269 14269           0     10000    13.35     C          1           RENT
#> 14277 14277           0     10000    14.83     D          7       MORTGAGE
#> 14295 14295           0     10000     6.17     A          5           RENT
#> 14296 14296           0     10000     9.62     B          5           RENT
#> 14330 14330           1     10000     9.99     B          4       MORTGAGE
#> 14352 14352           0     10000     6.91     A          0           RENT
#> 14363 14363           0     10000     9.62     B          1           RENT
#> 14393 14393           0     10000    14.46     D          0            OWN
#> 14432 14432           0     10000    10.36     B          3       MORTGAGE
#> 14449 14449           0     10000     6.54     A          8           RENT
#> 14451 14451           0     10000     6.54     A          1       MORTGAGE
#> 14452 14452           0     10000    15.20     D         22           RENT
#> 14456 14456           0     10000    13.35     C          4       MORTGAGE
#> 14474 14474           0     10000     6.17     A          6           RENT
#> 14483 14483           0     10000     8.88     B         13           RENT
#> 14487 14487           0     10000     5.42     A          2       MORTGAGE
#> 14491 14491           0     10000     5.79     A         11            OWN
#> 14502 14502           0     10000     9.99     B          1           RENT
#> 14522 14522           0     10000     5.79     A          1           RENT
#> 14537 14537           0     10000     6.17     A          5       MORTGAGE
#> 14547 14547           0     10000    10.36     B          2       MORTGAGE
#> 14549 14549           0     10000     6.17     A          8           RENT
#> 14574 14574           0     10000    10.36     B         13       MORTGAGE
#> 14607 14607           0     10000     6.17     A          3       MORTGAGE
#> 14639 14639           0     10000     5.42     A          3       MORTGAGE
#> 14660 14660           0     10000     6.54     A          7           RENT
#> 14675 14675           0     10000    16.69     E          4       MORTGAGE
#> 14679 14679           0     10000    14.83     D         16       MORTGAGE
#> 14684 14684           0     10000    10.36     B          6       MORTGAGE
#> 14691 14691           0     10000    16.32     E          3           RENT
#> 14697 14697           0     10000     5.79     A          7            OWN
#> 14706 14706           0     10000     6.17     A          3           RENT
#> 14756 14756           0     10000     5.79     A          3           RENT
#> 14758 14758           0     10000     9.62     B          5       MORTGAGE
#> 14765 14765           1     10000    14.83     D          5           RENT
#> 14799 14799           0     10000     9.99     B          0           RENT
#> 14803 14803           1     10000    15.20     D          2           RENT
#> 14814 14814           0     10000     6.17     A         13       MORTGAGE
#> 14831 14831           0     10000     5.79     A         14       MORTGAGE
#> 14834 14834           0     10000     6.54     A         19       MORTGAGE
#> 14842 14842           0     10000     5.42     A          9       MORTGAGE
#> 14843 14843           0     10000     5.79     A          5       MORTGAGE
#> 14845 14845           0     10000     6.17     A          5            OWN
#> 14854 14854           0     10000     5.79     A          7           RENT
#> 14865 14865           0     10000     9.25     B          6           RENT
#> 14881 14881           0     10000     9.25     B          3           RENT
#> 14892 14892           0     10000     9.25     B          7           RENT
#> 14904 14904           0     10000     5.79     A          0       MORTGAGE
#> 14912 14912           1     10000     6.91     A          2       MORTGAGE
#> 14915 14915           0     10000    12.23     C          2       MORTGAGE
#> 14944 14944           0     10000     6.91     A          6       MORTGAGE
#> 14949 14949           0     10000     6.17     A          0            OWN
#> 15006 15006           0     10000    10.36     B          1       MORTGAGE
#> 15021 15021           1     10000    15.95     E          0           RENT
#> 15030 15030           0     10000     6.17     A          3       MORTGAGE
#> 15052 15052           0     10000     5.42     A          2           RENT
#> 15058 15058           0     10000    12.61     C          9            OWN
#> 15059 15059           0     10000     6.17     A          4           RENT
#> 15119 15119           0     10000    12.61     C         18           RENT
#> 15132 15132           0     10000     6.54     A          2       MORTGAGE
#> 15149 15149           0     10000     6.17     A         20       MORTGAGE
#> 15175 15175           0     10000     9.99     B          3           RENT
#> 15179 15179           0     10000    12.61     C          5       MORTGAGE
#> 15203 15203           0     10000     6.54     A          8           RENT
#> 15207 15207           0     10000     5.42     A          2       MORTGAGE
#> 15221 15221           0     10000     5.42     A          5           RENT
#> 15232 15232           0     10000     6.54     A          5       MORTGAGE
#> 15234 15234           0     10000     6.91     A         17       MORTGAGE
#> 15254 15254           0     10000     5.79     A          6       MORTGAGE
#> 15277 15277           1     10000    10.36     B          7           RENT
#> 15282 15282           0     10000     5.42     A         11       MORTGAGE
#> 15291 15291           0     10000     6.91     A         13       MORTGAGE
#> 15314 15314           0     10000     6.17     A          2       MORTGAGE
#> 15316 15316           0     10000     5.79     A          1           RENT
#> 15348 15348           0     10000     5.42     A          6       MORTGAGE
#> 15361 15361           0     10000     5.79     A          0       MORTGAGE
#> 15380 15380           0     10000    10.36     B          2           RENT
#> 15388 15388           0     10000     6.54     A          4           RENT
#> 15391 15391           0     10000     6.91     A          1           RENT
#> 15392 15392           0     10000     6.54     A          1           RENT
#> 15394 15394           0     10000     6.91     A          3           RENT
#> 15411 15411           0     10000    14.09     D          1       MORTGAGE
#> 15434 15434           1     10000    12.61     C          7            OWN
#> 15436 15436           0     10000    13.35     C          3       MORTGAGE
#> 15450 15450           0     10000     5.42     A          6       MORTGAGE
#> 15459 15459           1     10000    21.14     G          2       MORTGAGE
#> 15468 15468           0     10000    12.23     C          5       MORTGAGE
#> 15476 15476           0     10000    10.36     B          5       MORTGAGE
#> 15486 15486           1     10000     6.54     A         12            OWN
#> 15492 15492           0     10000     6.17     A         20       MORTGAGE
#> 15495 15495           0     10000     6.17     A         14           RENT
#> 15496 15496           0     10000     5.79     A         11           RENT
#> 15506 15506           0     10000     9.99     B          1           RENT
#> 15530 15530           0     10000     6.17     A          4           RENT
#> 15543 15543           0     10000    13.72     C          3           RENT
#> 15557 15557           0     10000     5.79     A          0           RENT
#> 15559 15559           0     10000    14.83     D          8            OWN
#> 15574 15574           0     10000    12.61     C          0           RENT
#> 15584 15584           0     10000     6.54     A          5       MORTGAGE
#> 15587 15587           0     10000     6.91     A          1           RENT
#> 15592 15592           0     10000    10.36     B          3       MORTGAGE
#> 15603 15603           0     10000     9.99     B          5       MORTGAGE
#> 15610 15610           0     10000     5.42     A         15       MORTGAGE
#> 15626 15626           0     10000    13.72     C          6           RENT
#> 15654 15654           0     10000     6.91     A          6       MORTGAGE
#> 15661 15661           0     10000     9.25     B         34       MORTGAGE
#> 15666 15666           0     10000    13.35     C          0            OWN
#> 15678 15678           1     10000    12.23     C          0           RENT
#> 15717 15717           1     10000    12.23     C          9       MORTGAGE
#> 15747 15747           0     10000    10.36     B          5       MORTGAGE
#> 15787 15787           0     10000     8.88     B          5       MORTGAGE
#> 15793 15793           1     10000    10.36     B          5       MORTGAGE
#> 15809 15809           0     10000     6.54     A          3           RENT
#> 15828 15828           0     10000    13.72     C          4           RENT
#> 15829 15829           0     10000     9.99     B         12       MORTGAGE
#> 15832 15832           1     10000    14.09     D          3           RENT
#> 15849 15849           0     10000     6.54     A          0           RENT
#> 15855 15855           0     10000     6.91     A          8           RENT
#> 15859 15859           0     10000     9.62     B          6       MORTGAGE
#> 15871 15871           0     10000    13.35     C          0       MORTGAGE
#> 15875 15875           0     10000     9.62     B         10       MORTGAGE
#> 15886 15886           0     10000    13.35     C          4       MORTGAGE
#> 15904 15904           0     10000    10.36     B          7       MORTGAGE
#> 15911 15911           0     10000     9.25     B          0           RENT
#> 15948 15948           0     10000     6.54     A          6       MORTGAGE
#> 15974 15974           0     10000     7.51     A          0       MORTGAGE
#> 16007 16007           0     10000    17.93     E          0           RENT
#> 16009 16009           0     10000    16.82     E          0           RENT
#> 16010 16010           0     10000    15.58     D          6           RENT
#> 16041 16041           0     10000     7.88     A          0            OWN
#> 16082 16082           0     10000    13.98     C         19       MORTGAGE
#> 16084 16084           1     10000     7.51     A          0           RENT
#> 16091 16091           0     10000    11.49     B         12       MORTGAGE
#> 16095 16095           0     10000     7.51     A          5           RENT
#> 16134 16134           0     10000     7.88     A          4           RENT
#> 16148 16148           0     10000    14.35     C          0       MORTGAGE
#> 16165 16165           0     10000    15.95     D          3       MORTGAGE
#> 16169 16169           0     10000    11.86     B          1            OWN
#> 16189 16189           0     10000    11.12     B          2            OWN
#> 16231 16231           1     10000    11.49     B          3       MORTGAGE
#> 16237 16237           0     10000    10.38     B          5            OWN
#> 16238 16238           0     10000     7.88     A          5           RENT
#> 16248 16248           0     10000    11.12     B          9           RENT
#> 16274 16274           0     10000     7.51     A          2           RENT
#> 16284 16284           0     10000     7.51     A          4            OWN
#> 16287 16287           0     10000    10.38     B          3       MORTGAGE
#> 16304 16304           0     10000    15.95     D          4            OWN
#> 16308 16308           0     10000     7.51     A          7           RENT
#> 16318 16318           0     10000    11.12     B          3           RENT
#> 16320 16320           0     10000     7.88     A         20       MORTGAGE
#> 16332 16332           0     10000    13.98     C          5            OWN
#> 16357 16357           0     10000    14.72     C          3           RENT
#> 16381 16381           1     10000    10.38     B          7           RENT
#> 16392 16392           0     10000    11.86     B         16       MORTGAGE
#> 16413 16413           0     10000     7.14     A         18       MORTGAGE
#> 16434 16434           0     10000    13.23     C          1           RENT
#> 16445 16445           1     10000     7.88     A         13            OWN
#> 16454 16454           0     10000    11.12     B         27       MORTGAGE
#> 16486 16486           0     10000     7.51     A          4       MORTGAGE
#> 16517 16517           1     10000    15.95     D          4       MORTGAGE
#> 16520 16520           0     10000    11.12     B          4       MORTGAGE
#> 16526 16526           0     10000    15.58     D         16           RENT
#> 16559 16559           0     10000    10.38     B          1           RENT
#> 16562 16562           0     10000    10.38     B          9           RENT
#> 16564 16564           0     10000    13.23     C         17           RENT
#> 16567 16567           0     10000     7.51     A          3       MORTGAGE
#> 16576 16576           0     10000    10.75     B          3           RENT
#> 16580 16580           0     10000     7.88     A          2       MORTGAGE
#> 16586 16586           1     10000    13.98     C          5       MORTGAGE
#> 16587 16587           0     10000     7.51     A          2           RENT
#> 16603 16603           0     10000     7.51     A          2       MORTGAGE
#> 16621 16621           0     10000    10.75     B          1       MORTGAGE
#> 16632 16632           0     10000    15.58     D          1       MORTGAGE
#> 16637 16637           0     10000    13.98     C          0       MORTGAGE
#> 16652 16652           0     10000    14.72     C          3           RENT
#> 16670 16670           0     10000    13.61     C          0           RENT
#> 16725 16725           0     10000    13.98     C         11            OWN
#> 16728 16728           0     10000     7.88     A          5       MORTGAGE
#> 16730 16730           1     10000    17.93     E          4           RENT
#> 16733 16733           0     10000    10.75     B          2       MORTGAGE
#> 16737 16737           0     10000    13.61     C          0       MORTGAGE
#> 16741 16741           0     10000    13.98     C          3           RENT
#> 16742 16742           0     10000    10.75     B          2       MORTGAGE
#> 16759 16759           1     10000    14.84     D          1           RENT
#> 16787 16787           0     10000     7.14     A          0           RENT
#> 16804 16804           0     10000     7.88     A         17       MORTGAGE
#> 16807 16807           1     10000    15.58     D          0           RENT
#> 16826 16826           0     10000    13.61     C          1           RENT
#> 16828 16828           0     10000    10.38     B          2            OWN
#> 16844 16844           0     10000     7.14     A          4           RENT
#> 16876 16876           0     10000     7.51     A          3       MORTGAGE
#> 16928 16928           0     10000     7.51     A          9       MORTGAGE
#> 16933 16933           1     10000    13.61     C         12       MORTGAGE
#> 16941 16941           0     10000    14.72     C          7       MORTGAGE
#> 16943 16943           0     10000    15.21     D          2           RENT
#> 16947 16947           0     10000    15.58     D          2           RENT
#> 16951 16951           0     10000     7.88     A         22       MORTGAGE
#> 16965 16965           1     10000     7.51     A         20           RENT
#> 17005 17005           0     10000     7.14     A          0       MORTGAGE
#> 17026 17026           0     10000    14.84     D         12           RENT
#> 17037 17037           0     10000     7.51     A          4           RENT
#> 17056 17056           1     10000    16.45     E          5       MORTGAGE
#> 17071 17071           0     10000     7.51     A          0       MORTGAGE
#> 17120 17120           0     10000    11.12     B          5       MORTGAGE
#> 17179 17179           0     10000    13.98     C          1           RENT
#> 17200 17200           0     10000    16.82     E          3           RENT
#> 17209 17209           0     10000     7.14     A         12       MORTGAGE
#> 17217 17217           1     10000    10.38     B          3           RENT
#> 17230 17230           0     10000     7.51     A          4            OWN
#> 17236 17236           0     10000    13.61     C          2           RENT
#> 17304 17304           0     10000     7.88     A          3           RENT
#> 17321 17321           0     10000    14.72     C          3            OWN
#> 17324 17324           0     10000     7.51     A          5           RENT
#> 17339 17339           0     10000     7.51     A         12       MORTGAGE
#> 17361 17361           0     10000    14.72     C          7       MORTGAGE
#> 17410 17410           0     10000    11.86     B          4           RENT
#> 17412 17412           0     10000    13.61     C          0           RENT
#> 17477 17477           0     10000    11.12     B          2           RENT
#> 17484 17484           0     10000    11.86     B          2           RENT
#> 17490 17490           0     10000    15.58     D          3           RENT
#> 17509 17509           0     10000    10.38     B          8       MORTGAGE
#> 17516 17516           0     10000     7.51     A          3           RENT
#> 17540 17540           0     10000    16.32     D          5       MORTGAGE
#> 17551 17551           0     10000    13.61     C          3       MORTGAGE
#> 17571 17571           0     10000    11.86     B          0            OWN
#> 17573 17573           0     10000    15.95     D          3           RENT
#> 17584 17584           0     10000     7.51     A          4           RENT
#> 17589 17589           0     10000    15.95     D          5           RENT
#> 17596 17596           0     10000    13.98     C          7           RENT
#> 17598 17598           0     10000    14.35     C          4           RENT
#> 17619 17619           0     10000     7.88     A          5           RENT
#> 17654 17654           0     10000     7.51     A         11       MORTGAGE
#> 17658 17658           0     10000    11.86     B         23           RENT
#> 17679 17679           0     10000    10.38     B          4       MORTGAGE
#> 17713 17713           0     10000     7.88     A          8       MORTGAGE
#> 17715 17715           0     10000     7.51     A          8            OWN
#> 17721 17721           0     10000     7.14     A          2       MORTGAGE
#> 17726 17726           0     10000    10.75     B         15       MORTGAGE
#> 17756 17756           0     10000    16.45     E         19           RENT
#> 17760 17760           0     10000     7.51     A          0           RENT
#> 17769 17769           0     10000     7.51     A         16       MORTGAGE
#> 17780 17780           0     10000    15.95     D          0       MORTGAGE
#> 17781 17781           0     10000    11.49     B          2           RENT
#> 17795 17795           1     10000     7.14     A          0       MORTGAGE
#> 17823 17823           0     10000     7.88     A          3       MORTGAGE
#> 17865 17865           0     10000     7.51     A          5           RENT
#> 17884 17884           0     10000    11.49     B          2           RENT
#> 17900 17900           0     10000     7.88     A          5           RENT
#> 17904 17904           0     10000    17.19     E          3           RENT
#> 17915 17915           0     10000    13.61     C          4           RENT
#> 17924 17924           0     10000    14.72     C          6            OWN
#> 17952 17952           0     10000    15.95     D          4           RENT
#> 17988 17988           0     10000     7.88     A          3           RENT
#> 17990 17990           0     10000    13.23     C          5           RENT
#> 17993 17993           1     10000    13.23     C          2           RENT
#> 18066 18066           0     10000     7.88     A          3       MORTGAGE
#> 18098 18098           0     10000     7.88     A          6           RENT
#> 18106 18106           0     10000    11.49     B          0       MORTGAGE
#> 18113 18113           0     10000    10.75     B          4       MORTGAGE
#> 18129 18129           0     10000    10.38     B          5           RENT
#> 18138 18138           0     10000     7.51     A         51           RENT
#> 18145 18145           0     10000    10.75     B          2       MORTGAGE
#> 18152 18152           0     10000    11.86     B          3       MORTGAGE
#> 18159 18159           1     10000    11.86     B          4           RENT
#> 18170 18170           0     10000     7.51     A          2       MORTGAGE
#> 18187 18187           0     10000    13.61     C          5       MORTGAGE
#> 18194 18194           0     10000     7.51     A         14       MORTGAGE
#> 18229 18229           1     10000    16.32     D          4           RENT
#> 18234 18234           0     10000    10.38     B          3       MORTGAGE
#> 18268 18268           0     10000    13.61     C          1           RENT
#> 18312 18312           0     10000     7.88     A          2           RENT
#> 18315 18315           0     10000     7.88     A          3           RENT
#> 18339 18339           0     10000    13.23     C          4           RENT
#> 18353 18353           1     10000     7.51     A          4       MORTGAGE
#> 18369 18369           0     10000     7.88     A          5           RENT
#> 18387 18387           0     10000    11.86     B          3           RENT
#> 18395 18395           0     10000    13.61     C         17       MORTGAGE
#> 18396 18396           0     10000    10.75     B          3           RENT
#> 18398 18398           0     10000    10.75     B          7           RENT
#> 18408 18408           0     10000     7.14     A          1       MORTGAGE
#> 18430 18430           0     10000    13.61     C          4           RENT
#> 18432 18432           0     10000     7.88     A          2       MORTGAGE
#> 18435 18435           0     10000    13.23     C          4           RENT
#> 18436 18436           0     10000     7.51     A          9       MORTGAGE
#> 18445 18445           0     10000     7.51     A          4       MORTGAGE
#> 18448 18448           0     10000    10.75     B          3       MORTGAGE
#> 18492 18492           0     10000    14.84     D          3       MORTGAGE
#> 18501 18501           0     10000     7.88     A          3           RENT
#> 18503 18503           0     10000     7.51     A         14       MORTGAGE
#> 18521 18521           0     10000    15.21     D          3           RENT
#> 18531 18531           1     10000    15.58     D          3           RENT
#> 18537 18537           0     10000     7.88     A          2           RENT
#> 18544 18544           0     10000    10.75     B          5           RENT
#> 18550 18550           0     10000    16.32     D          3           RENT
#> 18599 18599           0     10000    13.61     C         12       MORTGAGE
#> 18605 18605           1     10000     7.88     A          5           RENT
#> 18614 18614           0     10000     7.88     A          3       MORTGAGE
#> 18628 18628           0     10000    13.23     C         11       MORTGAGE
#> 18664 18664           0     10000    10.75     B          2       MORTGAGE
#> 18706 18706           0     10000    13.98     C          5           RENT
#> 18724 18724           0     10000    11.86     B          1           RENT
#> 18762 18762           1     10000     7.14     A          9       MORTGAGE
#> 18769 18769           0     10000     7.88     A          1           RENT
#> 18772 18772           0     10000    11.86     B          2       MORTGAGE
#> 18774 18774           0     10000     7.14     A          5       MORTGAGE
#> 18787 18787           0     10000     7.51     A          4       MORTGAGE
#> 18789 18789           0     10000    10.38     B          9            OWN
#> 18791 18791           0     10000    15.58     D          4           RENT
#> 18820 18820           0     10000     7.88     A          6           RENT
#> 18828 18828           1     10000    14.35     C          1       MORTGAGE
#> 18830 18830           0     10000    16.45     E          4           RENT
#> 18845 18845           0     10000    14.35     C          3       MORTGAGE
#> 18889 18889           0     10000     7.14     A          2           RENT
#> 18893 18893           0     10000     7.88     A          5           RENT
#> 18897 18897           0     10000    11.86     B          3           RENT
#> 18929 18929           0     10000     7.51     A         11           RENT
#> 18935 18935           0     10000    13.23     C          2            OWN
#> 18944 18944           0     10000     7.88     A         20       MORTGAGE
#> 18949 18949           0     10000    11.86     B          2           RENT
#> 18969 18969           0     10000    11.86     B          4       MORTGAGE
#> 18988 18988           0     10000     7.88     A          0       MORTGAGE
#> 18996 18996           0     10000    13.23     C          4           RENT
#> 19003 19003           1     10000    10.38     B          6       MORTGAGE
#> 19032 19032           0     10000     7.51     A          8       MORTGAGE
#> 19038 19038           0     10000    11.86     B         15           RENT
#> 19057 19057           0     10000     7.88     A          9       MORTGAGE
#> 19069 19069           0     10000     9.88     B         16       MORTGAGE
#> 19090 19090           0     10000    15.33     D          1       MORTGAGE
#> 19091 19091           0     10000    13.85     C          3           RENT
#> 19130 19130           0     10000     7.51     A          5       MORTGAGE
#> 19131 19131           1     10000    15.33     D          7           RENT
#> 19140 19140           0     10000     7.51     A          2           RENT
#> 19141 19141           0     10000     7.51     A          7           RENT
#> 19151 19151           0     10000    11.36     B          7           RENT
#> 19163 19163           0     10000     9.88     B          5       MORTGAGE
#> 19186 19186           0     10000     7.51     A          3       MORTGAGE
#> 19197 19197           0     10000    11.36     B          4           RENT
#> 19216 19216           0     10000     7.51     A          5       MORTGAGE
#> 19218 19218           0     10000     7.51     A          5           RENT
#> 19242 19242           0     10000    11.36     B         56           RENT
#> 19243 19243           0     10000    15.33     D          6       MORTGAGE
#> 19255 19255           0     10000     7.51     A          3           RENT
#> 19266 19266           1     10000    13.11     C         18           RENT
#> 19271 19271           0     10000     7.88     A         17           RENT
#> 19275 19275           0     10000     7.88     A          4           RENT
#> 19290 19290           0     10000     7.88     A          6           RENT
#> 19316 19316           0     10000     7.88     A          5       MORTGAGE
#> 19325 19325           1     10000    14.59     D          9       MORTGAGE
#> 19336 19336           0     10000    13.48     C         13       MORTGAGE
#> 19391 19391           1     10000    11.36     B          7       MORTGAGE
#> 19453 19453           0     10000    13.48     C         11           RENT
#> 19473 19473           0     10000    10.99     B          2           RENT
#> 19495 19495           0     10000     7.14     A          5       MORTGAGE
#> 19567 19567           0     10000     7.51     A          6       MORTGAGE
#> 19576 19576           1     10000    17.19     E          6       MORTGAGE
#> 19598 19598           0     10000     9.88     B          3           RENT
#> 19618 19618           0     10000     7.51     A          0            OWN
#> 19635 19635           0     10000     7.14     A         25       MORTGAGE
#> 19644 19644           1     10000    11.36     B          4           RENT
#> 19645 19645           0     10000     9.88     B         27            OWN
#> 19654 19654           0     10000    14.22     C          3       MORTGAGE
#> 19655 19655           0     10000    15.33     D          7           RENT
#> 19657 19657           0     10000     7.51     A          0           RENT
#> 19666 19666           0     10000     9.88     B          3       MORTGAGE
#> 19680 19680           0     10000     7.51     A         15           RENT
#> 19687 19687           0     10000    14.22     C         15       MORTGAGE
#> 19703 19703           0     10000     9.88     B         22            OWN
#> 19710 19710           0     10000    16.07     D          2           RENT
#> 19712 19712           0     10000    13.48     C          3           RENT
#> 19730 19730           0     10000    12.73     C          1       MORTGAGE
#> 19745 19745           0     10000    14.96     D          9       MORTGAGE
#> 19749 19749           0     10000    10.99     B         15           RENT
#> 19762 19762           0     10000    10.99     B          3           RENT
#> 19772 19772           0     10000     9.88     B          9       MORTGAGE
#> 19814 19814           0     10000    10.25     B          2       MORTGAGE
#> 19815 19815           0     10000    10.25     B          4           RENT
#> 19821 19821           0     10000    12.73     C          8       MORTGAGE
#> 19822 19822           0     10000    10.99     B          1           RENT
#> 19826 19826           0     10000    15.33     D          4           RENT
#> 19853 19853           0     10000    13.11     C          2       MORTGAGE
#> 19872 19872           0     10000    12.73     C          5       MORTGAGE
#> 19882 19882           0     10000    13.48     C          3           RENT
#> 19888 19888           0     10000    10.99     B          9       MORTGAGE
#> 19894 19894           0     10000    10.62     B          4           RENT
#> 19909 19909           0     10000    17.93     E          3           RENT
#> 19938 19938           0     10000    19.04     F         18           RENT
#> 19943 19943           0     10000    10.62     B         14           RENT
#> 19949 19949           0     10000    11.36     B          5           RENT
#> 19964 19964           0     10000    12.73     C          5       MORTGAGE
#> 19966 19966           0     10000    15.33     D          4           RENT
#> 19989 19989           1     10000    13.11     C          5           RENT
#> 19991 19991           0     10000    14.59     D         23       MORTGAGE
#> 19998 19998           0     10000     9.88     B          8       MORTGAGE
#> 20004 20004           0     10000    11.36     B          4            OWN
#> 20035 20035           0     10000    14.22     C          8           RENT
#> 20045 20045           0     10000     9.88     B          2       MORTGAGE
#> 20055 20055           0     10000    14.22     C          7           RENT
#> 20094 20094           0     10000    12.73     C          5           RENT
#> 20103 20103           0     10000     7.14     A          4           RENT
#> 20109 20109           0     10000     7.51     A          4           RENT
#> 20124 20124           0     10000    14.59     D          9           RENT
#> 20135 20135           1     10000    10.62     B          7       MORTGAGE
#> 20159 20159           0     10000     7.14     A          5           RENT
#> 20169 20169           0     10000    13.11     C          1           RENT
#> 20187 20187           0     10000     7.14     A          5           RENT
#> 20191 20191           0     10000    14.22     C          3           RENT
#> 20197 20197           0     10000    10.62     B          4           RENT
#> 20207 20207           0     10000    10.99     B         28       MORTGAGE
#> 20221 20221           0     10000    14.59     D          5       MORTGAGE
#> 20246 20246           0     10000     7.14     A         11       MORTGAGE
#> 20268 20268           0     10000     7.51     A          4           RENT
#> 20280 20280           0     10000    10.99     B          6           RENT
#> 20292 20292           0     10000    10.25     B          2           RENT
#> 20293 20293           1     10000     9.88     B          1           RENT
#> 20311 20311           1     10000     7.88     A          5       MORTGAGE
#> 20335 20335           0     10000    10.62     B          3           RENT
#> 20338 20338           0     10000    10.99     B          1           RENT
#> 20339 20339           0     10000    13.48     C          4           RENT
#> 20385 20385           0     10000     7.88     A          2       MORTGAGE
#> 20386 20386           0     10000     7.51     A          8       MORTGAGE
#> 20394 20394           0     10000    13.48     C          4       MORTGAGE
#> 20397 20397           0     10000    13.48     C          6           RENT
#> 20401 20401           0     10000    11.36     B          5            OWN
#> 20408 20408           0     10000    15.33     D          9            OWN
#> 20414 20414           0     10000    13.48     C          4           RENT
#> 20420 20420           0     10000    11.36     B         17       MORTGAGE
#> 20432 20432           1     10000    10.99     B          6           RENT
#> 20445 20445           0     10000     7.51     A          0       MORTGAGE
#> 20466 20466           0     10000     7.14     A          5       MORTGAGE
#> 20470 20470           0     10000    10.99     B         12       MORTGAGE
#> 20475 20475           0     10000    15.33     D         13       MORTGAGE
#> 20498 20498           0     10000    13.48     C         10           RENT
#> 20519 20519           0     10000    12.73     C          0           RENT
#> 20540 20540           0     10000    14.59     D         12       MORTGAGE
#> 20546 20546           0     10000    10.99     B         11       MORTGAGE
#> 20558 20558           0     10000    15.33     D          5           RENT
#> 20559 20559           0     10000    10.99     B          4           RENT
#> 20560 20560           0     10000    10.25     B          3           RENT
#> 20563 20563           0     10000    10.25     B          0       MORTGAGE
#> 20570 20570           0     10000    10.62     B          0           RENT
#> 20595 20595           0     10000     9.88     B          3           RENT
#> 20604 20604           0     10000    10.99     B          2       MORTGAGE
#> 20607 20607           0     10000    14.96     D          4       MORTGAGE
#> 20608 20608           1     10000    11.36     B          6           RENT
#> 20610 20610           0     10000    14.22     C          7           RENT
#> 20615 20615           0     10000     7.88     A          2           RENT
#> 20621 20621           0     10000     7.88     A         18       MORTGAGE
#> 20622 20622           0     10000     7.14     A          5           RENT
#> 20642 20642           0     10000    10.25     B          7           RENT
#> 20662 20662           0     10000    14.96     D          6           RENT
#> 20667 20667           0     10000    15.33     D          5           RENT
#> 20678 20678           0     10000     7.14     A          3       MORTGAGE
#> 20681 20681           0     10000    10.62     B         31       MORTGAGE
#> 20690 20690           0     10000    12.73     C         14       MORTGAGE
#> 20699 20699           0     10000    15.70     D         31           RENT
#> 20702 20702           0     10000     7.51     A          7       MORTGAGE
#> 20734 20734           0     10000    15.33     D          9       MORTGAGE
#> 20737 20737           0     10000     7.88     A          2            OWN
#> 20745 20745           1     10000    10.25     B         19            OWN
#> 20748 20748           0     10000     7.14     A          5       MORTGAGE
#> 20755 20755           0     10000     9.88     B         15           RENT
#> 20795 20795           0     10000    16.82     E          4           RENT
#> 20796 20796           1     10000    13.48     C          2           RENT
#> 20819 20819           0     10000    13.48     C          2           RENT
#> 20830 20830           0     10000    13.48     C          5           RENT
#> 20831 20831           0     10000     7.14     A         19       MORTGAGE
#> 20840 20840           0     10000    12.73     C         18       MORTGAGE
#> 20873 20873           0     10000     9.88     B         13           RENT
#> 20879 20879           0     10000    10.99     B         16       MORTGAGE
#> 20885 20885           0     10000     7.51     A          4           RENT
#> 20887 20887           1     10000     9.88     B          0           RENT
#> 20903 20903           0     10000    17.93     E         13       MORTGAGE
#> 20905 20905           1     10000    10.62     B          5           RENT
#> 20920 20920           0     10000    12.73     C          2           RENT
#> 20921 20921           0     10000    12.73     C          3           RENT
#> 20926 20926           0     10000     7.14     A          8       MORTGAGE
#> 20931 20931           1     10000    14.59     D          8       MORTGAGE
#> 20940 20940           0     10000     7.88     A          3           RENT
#> 20961 20961           0     10000     7.51     A          9       MORTGAGE
#> 20964 20964           0     10000    12.73     C          1           RENT
#> 20966 20966           0     10000     7.88     A          0           RENT
#> 20967 20967           0     10000    15.33     D         15       MORTGAGE
#> 20970 20970           0     10000     9.88     B         48       MORTGAGE
#> 20982 20982           0     10000    10.25     B          3           RENT
#> 20997 20997           0     10000     7.88     A          5       MORTGAGE
#> 21027 21027           0     10000     7.51     A          8       MORTGAGE
#> 21049 21049           0     10000    10.25     B          5       MORTGAGE
#> 21052 21052           0     10000    13.48     C          8           RENT
#> 21066 21066           0     10000     7.51     A          6       MORTGAGE
#> 21085 21085           0     10000     9.88     B          4       MORTGAGE
#> 21088 21088           0     10000    15.70     D          4       MORTGAGE
#> 21090 21090           0     10000     7.88     A          9       MORTGAGE
#> 21100 21100           0     10000    11.36     B         14       MORTGAGE
#> 21106 21106           0     10000     9.88     B         16       MORTGAGE
#> 21115 21115           0     10000    15.70     D          3       MORTGAGE
#> 21123 21123           0     10000     7.88     A         22       MORTGAGE
#> 21126 21126           0     10000    14.96     D          0           RENT
#> 21131 21131           0     10000    12.73     C          4       MORTGAGE
#> 21152 21152           0     10000    13.48     C          2           RENT
#> 21153 21153           0     10000     7.51     A          4           RENT
#> 21193 21193           0     10000    10.99     B         17       MORTGAGE
#> 21205 21205           0     10000    11.36     B          6       MORTGAGE
#> 21206 21206           0     10000    13.11     C         11       MORTGAGE
#> 21235 21235           0     10000    16.07     D          4           RENT
#> 21252 21252           0     10000    16.07     D         12           RENT
#> 21287 21287           0     10000     7.88     A          2           RENT
#> 21295 21295           0     10000    10.25     B          3           RENT
#> 21296 21296           1     10000    13.85     C          3       MORTGAGE
#> 21313 21313           0     10000     7.51     A          5            OWN
#> 21316 21316           0     10000     7.51     A          0       MORTGAGE
#> 21327 21327           0     10000    11.36     B          8       MORTGAGE
#> 21330 21330           0     10000     7.88     A          9       MORTGAGE
#> 21334 21334           0     10000     9.88     B          2           RENT
#> 21351 21351           0     10000     7.51     A          1           RENT
#> 21385 21385           0     10000    13.48     C          1           RENT
#> 21386 21386           0     10000    10.62     B          2       MORTGAGE
#> 21423 21423           0     10000     9.88     B          1           RENT
#> 21425 21425           0     10000     7.51     A          4           RENT
#> 21428 21428           0     10000     7.51     A          0       MORTGAGE
#> 21439 21439           0     10000    13.11     C          0           RENT
#> 21441 21441           0     10000    11.36     B         13           RENT
#> 21453 21453           0     10000     7.51     A          8           RENT
#> 21466 21466           0     10000     9.88     B         29       MORTGAGE
#> 21471 21471           0     10000    10.25     B          4           RENT
#> 21473 21473           0     10000    11.36     B          2       MORTGAGE
#> 21478 21478           0     10000    13.48     C         27           RENT
#> 21514 21514           0     10000     9.88     B          2           RENT
#> 21523 21523           0     10000    15.33     D         22           RENT
#> 21525 21525           0     10000     9.88     B          5           RENT
#> 21555 21555           0     10000     9.88     B          4            OWN
#> 21562 21562           0     10000    13.48     C          9       MORTGAGE
#> 21573 21573           0     10000     7.88     A          0       MORTGAGE
#> 21578 21578           0     10000    14.96     D         14       MORTGAGE
#> 21579 21579           0     10000    10.25     B          7            OWN
#> 21581 21581           0     10000    12.73     C         13       MORTGAGE
#> 21603 21603           0     10000    10.99     B          1       MORTGAGE
#> 21605 21605           0     10000    14.22     C          8           RENT
#> 21634 21634           0     10000     9.88     B          7       MORTGAGE
#> 21656 21656           0     10000    14.96     D         21           RENT
#> 21674 21674           0     10000     7.51     A         11       MORTGAGE
#> 21704 21704           0     10000    10.25     B          2           RENT
#> 21710 21710           0     10000    11.36     B         10           RENT
#> 21730 21730           0     10000     7.88     A          0           RENT
#> 21742 21742           0     10000    12.73     C          1           RENT
#> 21753 21753           0     10000    10.99     B          6           RENT
#> 21757 21757           1     10000    13.85     C          2           RENT
#> 21773 21773           0     10000    15.70     D          5           RENT
#> 21779 21779           0     10000    15.70     D          2           RENT
#> 21792 21792           0     10000    10.99     B          1       MORTGAGE
#> 21817 21817           0     10000    10.99     B          2           RENT
#> 21825 21825           0     10000    10.25     B          9           RENT
#> 21849 21849           0     10000    10.99     B         12            OWN
#> 21853 21853           0     10000    15.70     D          3       MORTGAGE
#> 21862 21862           0     10000    10.25     B          2       MORTGAGE
#> 21873 21873           0     10000     9.88     B          6           RENT
#> 21877 21877           0     10000     7.51     A          9           RENT
#> 21883 21883           0     10000    10.25     B          3           RENT
#> 21885 21885           0     10000     7.88     A          8            OWN
#> 21898 21898           0     10000    12.73     C          3           RENT
#> 21910 21910           0     10000    10.25     B         12       MORTGAGE
#> 21949 21949           0     10000    13.85     C          4           RENT
#> 21972 21972           1     10000    13.85     C         11           RENT
#> 21974 21974           0     10000     7.88     A          2            OWN
#> 21990 21990           1     10000    16.45     E         13           RENT
#> 21993 21993           0     10000     7.88     A          2       MORTGAGE
#> 22016 22016           0     10000     7.51     A          9       MORTGAGE
#> 22047 22047           0     10000    15.70     D         14           RENT
#> 22060 22060           0     10000     7.88     A          2           RENT
#> 22065 22065           0     10000    13.85     C          5       MORTGAGE
#> 22096 22096           0     10000    11.83     B          1           RENT
#> 22121 22121           0     10000    11.83     B          2       MORTGAGE
#> 22127 22127           0     10000     8.94     A          0       MORTGAGE
#> 22129 22129           0     10000    11.48     B          1           RENT
#> 22140 22140           0     10000    12.87     C          3           RENT
#> 22176 22176           0     10000    14.61     D          5       MORTGAGE
#> 22191 22191           0     10000    11.14     B          2            OWN
#> 22205 22205           0     10000    12.53     B          3           RENT
#> 22206 22206           0     10000    14.61     D          0       MORTGAGE
#> 22217 22217           0     10000    12.53     B          3       MORTGAGE
#> 22220 22220           0     10000     7.74     A          2           RENT
#> 22226 22226           0     10000    12.87     C          3           RENT
#> 22239 22239           0     10000    11.48     B         18           RENT
#> 22240 22240           0     10000    12.87     C          3           RENT
#> 22251 22251           1     10000    11.83     B          3       MORTGAGE
#> 22270 22270           0     10000     7.74     A          0       MORTGAGE
#> 22271 22271           0     10000    11.83     B          4           RENT
#> 22278 22278           1     10000    18.43     F          3           RENT
#> 22300 22300           0     10000    11.14     B          5           RENT
#> 22303 22303           0     10000     8.94     A          0           RENT
#> 22325 22325           0     10000    16.70     E         14       MORTGAGE
#> 22351 22351           0     10000    14.61     D          4            OWN
#> 22354 22354           0     10000    14.61     D          5           RENT
#> 22362 22362           0     10000     8.94     A         18       MORTGAGE
#> 22374 22374           0     10000    16.00     D         16       MORTGAGE
#> 22384 22384           0     10000    12.53     B          6           RENT
#> 22393 22393           0     10000     7.74     A         17       MORTGAGE
#> 22394 22394           0     10000    12.87     C          1       MORTGAGE
#> 22436 22436           0     10000    12.53     B          1       MORTGAGE
#> 22442 22442           0     10000    11.48     B          3           RENT
#> 22445 22445           0     10000    17.39     E         15       MORTGAGE
#> 22448 22448           0     10000     8.59     A          9       MORTGAGE
#> 22471 22471           0     10000     8.94     A         31           RENT
#> 22478 22478           0     10000     8.94     A          1           RENT
#> 22500 22500           0     10000     7.74     A          0            OWN
#> 22503 22503           0     10000     7.74     A         12       MORTGAGE
#> 22523 22523           1     10000    12.18     B          0       MORTGAGE
#> 22531 22531           0     10000     8.94     A          6       MORTGAGE
#> 22539 22539           0     10000    15.31     D          9            OWN
#> 22554 22554           0     10000    13.22     C         18       MORTGAGE
#> 22570 22570           0     10000    12.53     B          2       MORTGAGE
#> 22572 22572           0     10000    11.14     B          4       MORTGAGE
#> 22574 22574           0     10000    11.14     B          1            OWN
#> 22581 22581           0     10000    11.14     B          1           RENT
#> 22589 22589           0     10000    12.87     C          1       MORTGAGE
#> 22605 22605           0     10000    13.57     C          2           RENT
#> 22647 22647           0     10000     8.94     A         10            OWN
#> 22689 22689           0     10000    11.48     B         23           RENT
#> 22693 22693           0     10000     8.59     A          3       MORTGAGE
#> 22734 22734           0     10000    12.18     B          3           RENT
#> 22787 22787           1     10000    12.18     B         13           RENT
#> 22795 22795           0     10000     8.94     A          6           RENT
#> 22808 22808           0     10000    11.14     B          9           RENT
#> 22816 22816           0     10000     8.59     A          5           RENT
#> 22835 22835           0     10000    15.31     D          2            OWN
#> 22852 22852           0     10000    13.57     C          0       MORTGAGE
#> 22858 22858           0     10000    14.26     C          0       MORTGAGE
#> 22861 22861           1     10000    13.22     C          0           RENT
#> 22863 22863           0     10000    11.14     B          0       MORTGAGE
#> 22872 22872           0     10000    15.65     D          3           RENT
#> 22883 22883           0     10000     7.74     A          3       MORTGAGE
#> 22885 22885           0     10000    12.87     C          0       MORTGAGE
#> 22905 22905           0     10000     8.59     A          7           RENT
#> 22916 22916           0     10000    13.22     C          3           RENT
#> 22957 22957           0     10000    12.87     C          0       MORTGAGE
#> 22968 22968           0     10000    15.31     D          0           RENT
#> 22989 22989           0     10000    13.92     C         14           RENT
#> 22992 22992           0     10000     8.59     A          0           RENT
#> 23000 23000           0     10000     7.74     A         12            OWN
#> 23005 23005           0     10000    12.87     C          0           RENT
#> 23009 23009           0     10000    13.22     C          3           RENT
#> 23017 23017           0     10000    12.87     C          0            OWN
#> 23022 23022           0     10000    12.18     B          8       MORTGAGE
#> 23033 23033           0     10000     8.59     A          2           RENT
#> 23061 23061           0     10000     8.94     A          9       MORTGAGE
#> 23071 23071           0     10000    13.57     C          6       MORTGAGE
#> 23075 23075           0     10000     8.94     A          8            OWN
#> 23077 23077           0     10000    14.26     C          0       MORTGAGE
#> 23080 23080           0     10000    11.48     B          2           RENT
#> 23086 23086           0     10000    12.87     C          4           RENT
#> 23100 23100           0     10000    11.83     B         26            OWN
#> 23120 23120           0     10000    11.48     B          7           RENT
#> 23148 23148           0     10000    15.31     D          2       MORTGAGE
#> 23174 23174           0     10000     8.59     A         15       MORTGAGE
#> 23177 23177           0     10000     8.59     A         11       MORTGAGE
#> 23178 23178           0     10000    13.22     C          5           RENT
#> 23180 23180           0     10000     8.94     A          5           RENT
#> 23185 23185           0     10000     8.94     A          2           RENT
#> 23197 23197           0     10000     8.94     A          0       MORTGAGE
#> 23209 23209           0     10000     8.59     A          3           RENT
#> 23216 23216           0     10000     7.74     A         23       MORTGAGE
#> 23220 23220           0     10000    11.14     B          1           RENT
#> 23226 23226           0     10000    11.14     B          0           RENT
#> 23240 23240           1     10000    13.57     C         19            OWN
#> 23261 23261           0     10000     7.74     A         13       MORTGAGE
#> 23286 23286           0     10000    11.14     B          0           RENT
#> 23304 23304           0     10000     7.74     A          6           RENT
#> 23315 23315           0     10000    12.53     B          2           RENT
#> 23320 23320           0     10000    11.14     B          0           RENT
#> 23338 23338           0     10000     8.94     A          3       MORTGAGE
#> 23344 23344           0     10000    14.26     C          5           RENT
#> 23348 23348           0     10000     8.59     A          0            OWN
#> 23352 23352           0     10000    12.53     B          7       MORTGAGE
#> 23354 23354           0     10000     8.59     A          9           RENT
#> 23376 23376           0     10000     8.59     A          2       MORTGAGE
#> 23377 23377           0     10000    12.18     B         21            OWN
#> 23378 23378           0     10000    12.18     B          1           RENT
#> 23389 23389           0     10000    12.87     C          1            OWN
#> 23400 23400           0     10000    15.65     D          7       MORTGAGE
#> 23413 23413           0     10000     8.59     A         13           RENT
#> 23417 23417           0     10000    12.18     B          0           RENT
#> 23444 23444           0     10000     8.59     A         15       MORTGAGE
#> 23453 23453           0     10000     8.59     A          9            OWN
#> 23461 23461           0     10000    11.83     B          3           RENT
#> 23463 23463           0     10000     8.59     A          0            OWN
#> 23464 23464           0     10000    11.48     B          5           RENT
#> 23476 23476           0     10000     8.94     A          0       MORTGAGE
#> 23490 23490           0     10000    14.26     C          6           RENT
#> 23500 23500           0     10000     8.59     A          0           RENT
#> 23502 23502           0     10000     8.59     A          5           RENT
#> 23514 23514           0     10000     8.94     A          9       MORTGAGE
#> 23523 23523           0     10000    13.57     C         25           RENT
#> 23532 23532           0     10000    13.22     C          2           RENT
#> 23546 23546           0     10000    11.14     B          6           RENT
#> 23578 23578           1     10000    14.26     C          0           RENT
#> 23579 23579           0     10000    12.18     B          4       MORTGAGE
#> 23618 23618           0     10000    12.18     B          0       MORTGAGE
#> 23679 23679           0     10000    11.48     B          7           RENT
#> 23711 23711           0     10000    12.87     C          0           RENT
#> 23723 23723           0     10000     8.94     A          3       MORTGAGE
#> 23752 23752           0     10000     8.59     A          1       MORTGAGE
#> 23762 23762           0     10000    12.87     C          9       MORTGAGE
#> 23771 23771           0     10000    14.26     C          1           RENT
#> 23807 23807           0     10000     8.59     A         18       MORTGAGE
#> 23816 23816           0     10000     8.59     A          0       MORTGAGE
#> 23833 23833           0     10000    13.22     C          4            OWN
#> 23834 23834           1     10000    15.31     D          3       MORTGAGE
#> 23836 23836           0     10000     8.94     A          1           RENT
#> 23839 23839           0     10000    13.57     C          3           RENT
#> 23863 23863           1     10000    14.61     D          1       MORTGAGE
#> 23869 23869           0     10000     8.94     A         24            OWN
#> 23871 23871           0     10000    12.53     B          4           RENT
#> 23880 23880           0     10000     8.94     A          1           RENT
#> 23891 23891           0     10000     8.59     A          0           RENT
#> 23913 23913           1     10000    11.14     B          7           RENT
#> 23938 23938           0     10000    11.14     B          1           RENT
#> 23939 23939           0     10000     8.94     A          1            OWN
#> 23969 23969           1     10000     8.94     A          0       MORTGAGE
#> 23990 23990           0     10000    18.43     F          0       MORTGAGE
#> 24012 24012           0     10000     8.94     A          2       MORTGAGE
#> 24019 24019           0     10000     8.59     A          1       MORTGAGE
#> 24028 24028           0     10000    11.14     B          2           RENT
#> 24044 24044           0     10000    11.83     B          1           RENT
#> 24051 24051           0     10000    11.14     B          3       MORTGAGE
#> 24057 24057           0     10000    13.22     C          3           RENT
#> 24075 24075           0     10000    11.83     B         10           RENT
#> 24084 24084           0     10000    12.18     B         16            OWN
#> 24092 24092           0     10000    12.18     B          5           RENT
#> 24095 24095           0     10000    18.09     F          1       MORTGAGE
#> 24099 24099           0     10000    12.18     B          4           RENT
#> 24101 24101           0     10000     8.94     A         15       MORTGAGE
#> 24125 24125           0     10000    15.31     D          2           RENT
#> 24220 24220           0     10000    15.31     D          1           RENT
#> 24253 24253           0     10000     8.94     A          1           RENT
#> 24260 24260           0     10000    13.57     C         11       MORTGAGE
#> 24296 24296           0     10000    14.96     D         17           RENT
#> 24304 24304           0     10000     8.94     A          4       MORTGAGE
#> 24340 24340           0     10000     8.59     A          4           RENT
#> 24344 24344           1     10000     8.94     A          0           RENT
#> 24366 24366           1     10000    11.14     B          3           RENT
#> 24378 24378           0     10000    14.96     D          0            OWN
#> 24390 24390           0     10000    13.57     C          8       MORTGAGE
#> 24404 24404           1     10000    12.53     B          0           RENT
#> 24429 24429           0     10000    13.57     C         14           RENT
#> 24456 24456           0     10000    13.57     C          3           RENT
#> 24465 24465           1     10000    11.83     B          9           RENT
#> 24478 24478           0     10000    13.57     C          4       MORTGAGE
#> 24489 24489           1     10000    13.57     C          9       MORTGAGE
#> 24505 24505           0     10000    13.22     C          7          OTHER
#> 24506 24506           0     10000     8.59     A          0       MORTGAGE
#> 24546 24546           0     10000    14.26     C          1           RENT
#> 24566 24566           0     10000    11.14     B          1           RENT
#> 24568 24568           0     10000    14.61     D          5           RENT
#> 24584 24584           0     10000     8.94     A          5           RENT
#> 24603 24603           0     10000    13.22     C          1           RENT
#> 24604 24604           0     10000    16.00     D          0           RENT
#> 24605 24605           0     10000     7.74     A         25       MORTGAGE
#> 24608 24608           0     10000    13.57     C          7       MORTGAGE
#> 24623 24623           0     10000     8.94     A          3           RENT
#> 24628 24628           0     10000     8.94     A          8           RENT
#> 24654 24654           0     10000     8.59     A          3       MORTGAGE
#> 24674 24674           0     10000    13.57     C         14       MORTGAGE
#> 24676 24676           0     10000    16.35     E          2       MORTGAGE
#> 24697 24697           0     10000     8.59     A          0           RENT
#> 24712 24712           0     10000     8.94     A          6           RENT
#> 24720 24720           0     10000     8.94     A          1           RENT
#> 24725 24725           0     10000     8.94     A          0       MORTGAGE
#> 24753 24753           0     10000    12.18     B          3           RENT
#> 24756 24756           0     10000    17.04     E          3           RENT
#> 24769 24769           0     10000     8.59     A          4            OWN
#> 24776 24776           0     10000    11.14     B          2       MORTGAGE
#> 24779 24779           0     10000    13.22     C          0           RENT
#> 24788 24788           0     10000     7.74     A          3           RENT
#> 24789 24789           0     10000    11.14     B          2       MORTGAGE
#> 24798 24798           0     10000    12.18     B          2       MORTGAGE
#> 24810 24810           0     10000    14.26     C          2       MORTGAGE
#> 24820 24820           0     10000     7.74     A          2       MORTGAGE
#> 24821 24821           0     10000     8.94     A          3       MORTGAGE
#> 24847 24847           0     10000    14.61     D          0           RENT
#> 24886 24886           0     10000     8.94     A         13       MORTGAGE
#> 24895 24895           0     10000    11.48     B          9       MORTGAGE
#> 24897 24897           0     10000    18.43     F          3            OWN
#> 24899 24899           0     10000    16.00     D          3           RENT
#> 24909 24909           1     10000     8.94     A          8       MORTGAGE
#> 24923 24923           0     10000    13.22     C          2           RENT
#> 24928 24928           0     10000     8.59     A         13       MORTGAGE
#> 24940 24940           0     10000     7.74     A         16       MORTGAGE
#> 24952 24952           0     10000    12.87     C          4       MORTGAGE
#> 24972 24972           0     10000     8.59     A          2           RENT
#> 24973 24973           0     10000     8.94     A          1       MORTGAGE
#> 25020 25020           0     10000     8.59     A          4           RENT
#> 25030 25030           0     10000     7.74     A         13       MORTGAGE
#> 25046 25046           0     10000    18.43     F          8       MORTGAGE
#> 25047 25047           0     10000     7.74     A          1           RENT
#> 25090 25090           0     10000     8.94     A          3           RENT
#> 25111 25111           0     10000    10.95     B          0           RENT
#> 25122 25122           0     10000    12.53     C          2           RENT
#> 25132 25132           1     10000     9.63     A          9       MORTGAGE
#> 25134 25134           1     10000    12.21     B          2           RENT
#> 25151 25151           0     10000     8.00     A          1       MORTGAGE
#> 25152 25152           0     10000     8.00     A         33            OWN
#> 25165 25165           0     10000    12.21     B          5       MORTGAGE
#> 25173 25173           0     10000    15.37     D          3           RENT
#> 25176 25176           0     10000    12.53     C          1           RENT
#> 25202 25202           0     10000    13.16     C          0           RENT
#> 25205 25205           0     10000    16.00     E          8           RENT
#> 25208 25208           0     10000    10.95     B          0           RENT
#> 25216 25216           0     10000    10.95     B          2           RENT
#> 25241 25241           0     10000     9.63     A          0           RENT
#> 25259 25259           0     10000     9.32     A         16       MORTGAGE
#> 25264 25264           1     10000    13.16     C          1           RENT
#> 25292 25292           0     10000     9.63     A         18           RENT
#> 25313 25313           0     10000    11.89     B         17           RENT
#> 25337 25337           0     10000    11.26     B          8       MORTGAGE
#> 25349 25349           0     10000     9.32     A          2            OWN
#> 25369 25369           0     10000    11.26     B          2           RENT
#> 25371 25371           0     10000    15.37     D          0           RENT
#> 25378 25378           0     10000    12.21     B          8           RENT
#> 25390 25390           0     10000     9.32     A         29       MORTGAGE
#> 25392 25392           0     10000    12.21     B          2           RENT
#> 25394 25394           0     10000    12.21     B          1       MORTGAGE
#> 25409 25409           0     10000     9.32     A          3       MORTGAGE
#> 25411 25411           0     10000    11.26     B          4           RENT
#> 25428 25428           0     10000    10.95     B          0           RENT
#> 25442 25442           0     10000     9.32     A          1           RENT
#> 25508 25508           0     10000     8.00     A         21       MORTGAGE
#> 25509 25509           0     10000    12.53     C          1           RENT
#> 25511 25511           0     10000    11.89     B          0       MORTGAGE
#> 25516 25516           0     10000    11.26     B          2           RENT
#> 25531 25531           0     10000     9.32     A          3           RENT
#> 25539 25539           0     10000     9.63     A          9            OWN
#> 25546 25546           0     10000    12.21     B         19       MORTGAGE
#> 25547 25547           0     10000    12.21     B          0           RENT
#> 25572 25572           0     10000    12.53     C          1       MORTGAGE
#> 25582 25582           0     10000    14.74     D          9       MORTGAGE
#> 25591 25591           0     10000    10.95     B          3       MORTGAGE
#> 25623 25623           0     10000    13.79     C          0            OWN
#> 25661 25661           1     10000    13.79     C          3           RENT
#> 25672 25672           0     10000     9.63     A          4           RENT
#> 25681 25681           1     10000     9.63     A         16       MORTGAGE
#> 25693 25693           0     10000    13.16     C          3           RENT
#> 25703 25703           0     10000    15.05     D          4           RENT
#> 25712 25712           0     10000     9.32     A          0           RENT
#> 25717 25717           0     10000     9.32     A          7       MORTGAGE
#> 25734 25734           0     10000    13.16     C          2           RENT
#> 25751 25751           0     10000    14.42     D         11       MORTGAGE
#> 25763 25763           0     10000     9.63     A          7       MORTGAGE
#> 25770 25770           0     10000    12.21     B          1       MORTGAGE
#> 25785 25785           0     10000    11.26     B          2           RENT
#> 25796 25796           0     10000    12.84     C          3       MORTGAGE
#> 25802 25802           0     10000    11.26     B          2       MORTGAGE
#> 25807 25807           0     10000     9.32     A          8       MORTGAGE
#> 25812 25812           0     10000     9.32     A         11       MORTGAGE
#> 25841 25841           0     10000    13.79     C          2           RENT
#> 25857 25857           0     10000     9.32     A          2           RENT
#> 25863 25863           1     10000    12.53     C          4           RENT
#> 25870 25870           0     10000    10.95     B         13           RENT
#> 25875 25875           0     10000    10.95     B          2           RENT
#> 25884 25884           0     10000    11.26     B          3           RENT
#> 25886 25886           0     10000    13.16     C          0           RENT
#> 25908 25908           0     10000    10.95     B         14       MORTGAGE
#> 25917 25917           0     10000     9.32     A         20           RENT
#> 25919 25919           0     10000    10.95     B         12       MORTGAGE
#> 25940 25940           0     10000    11.58     B          1            OWN
#> 25955 25955           0     10000    16.00     E          1           RENT
#> 25964 25964           0     10000    13.47     C          1           RENT
#> 25981 25981           0     10000     8.00     A         27       MORTGAGE
#> 25993 25993           0     10000    11.26     B          1       MORTGAGE
#> 25996 25996           0     10000     8.00     A          6       MORTGAGE
#> 26002 26002           0     10000     9.32     A          6       MORTGAGE
#> 26022 26022           0     10000    10.95     B          5           RENT
#> 26052 26052           0     10000    12.84     C          1           RENT
#> 26088 26088           0     10000    12.53     C          1       MORTGAGE
#> 26090 26090           0     10000    12.21     B          3           RENT
#> 26107 26107           0     10000    13.16     C         12       MORTGAGE
#> 26148 26148           1     10000    13.16     C          2           RENT
#> 26194 26194           0     10000    12.84     C          0           RENT
#> 26195 26195           0     10000    12.53     C         19       MORTGAGE
#> 26201 26201           0     10000    14.42     D          4           RENT
#> 26203 26203           1     10000    13.79     C         18       MORTGAGE
#> 26221 26221           0     10000    14.74     D         21          OTHER
#> 26232 26232           1     10000     8.00     A          4           RENT
#> 26236 26236           0     10000    14.74     D          4           RENT
#> 26275 26275           0     10000    12.21     B          5           RENT
#> 26292 26292           0     10000     9.32     A          0           RENT
#> 26303 26303           0     10000     9.63     A         17       MORTGAGE
#> 26313 26313           0     10000     8.00     A          0            OWN
#> 26317 26317           1     10000    16.63     E         15           RENT
#> 26318 26318           0     10000    16.00     E          1           RENT
#> 26342 26342           1     10000    14.11     D          1           RENT
#> 26345 26345           0     10000    12.84     C          1           RENT
#> 26349 26349           1     10000    12.53     C          1          OTHER
#> 26352 26352           0     10000    12.21     B          5       MORTGAGE
#> 26369 26369           1     10000    14.11     D          4       MORTGAGE
#> 26384 26384           0     10000    12.84     C          4           RENT
#> 26385 26385           0     10000     8.00     A          3       MORTGAGE
#> 26388 26388           1     10000    16.32     E         12           RENT
#> 26410 26410           0     10000    12.21     B          3           RENT
#> 26421 26421           0     10000    15.05     D          5           RENT
#> 26436 26436           0     10000    13.79     C          0           RENT
#> 26458 26458           0     10000     9.63     A          2           RENT
#> 26463 26463           0     10000     9.63     A          0       MORTGAGE
#> 26465 26465           1     10000    14.11     D          6       MORTGAGE
#> 26483 26483           0     10000     7.68     A          0           RENT
#> 26488 26488           0     10000     9.63     A          3           RENT
#> 26508 26508           0     10000     8.00     A         17           RENT
#> 26512 26512           0     10000    11.89     B          2           RENT
#> 26516 26516           0     10000     9.32     A          1           RENT
#> 26554 26554           0     10000    16.63     E          0       MORTGAGE
#> 26555 26555           0     10000     8.00     A          1       MORTGAGE
#> 26576 26576           1     10000    15.68     E          2       MORTGAGE
#> 26584 26584           0     10000    13.79     C          5       MORTGAGE
#> 26586 26586           0     10000    11.89     B         10           RENT
#> 26589 26589           0     10000    12.84     C          0           RENT
#> 26590 26590           0     10000    13.47     C          0           RENT
#> 26594 26594           0     10000    13.16     C          2           RENT
#> 26597 26597           0     10000    14.11     D          0           RENT
#> 26608 26608           0     10000    13.79     C          2           RENT
#> 26615 26615           0     10000    11.89     B          1           RENT
#> 26620 26620           0     10000     9.63     A          6       MORTGAGE
#> 26639 26639           0     10000    14.11     D          7           RENT
#> 26654 26654           0     10000    12.21     B         14       MORTGAGE
#> 26664 26664           0     10000    12.21     B          6           RENT
#> 26666 26666           1     10000     9.63     A          9       MORTGAGE
#> 26670 26670           1     10000     9.63     A          1           RENT
#> 26675 26675           0     10000    14.11     D          0           RENT
#> 26682 26682           0     10000    13.79     C          2           RENT
#> 26696 26696           0     10000    11.89     B         15           RENT
#> 26710 26710           0     10000    13.47     C          4           RENT
#> 26712 26712           1     10000    14.42     D          1           RENT
#> 26719 26719           0     10000    14.11     D          1           RENT
#> 26838 26838           0     10000    12.84     C          4           RENT
#> 26863 26863           0     10000    13.79     C          4           RENT
#> 26872 26872           0     10000    14.11     D          1           RENT
#> 26891 26891           0     10000    13.47     C         12           RENT
#> 26898 26898           1     10000     8.00     A         13       MORTGAGE
#> 26913 26913           0     10000    14.74     D          2       MORTGAGE
#> 26917 26917           1     10000    11.89     B          6           RENT
#> 26932 26932           0     10000    14.11     D          3          OTHER
#> 26935 26935           0     10000     9.63     A          2           RENT
#> 26947 26947           0     10000     9.32     A          2       MORTGAGE
#> 26951 26951           0     10000    12.84     C          3       MORTGAGE
#> 26963 26963           1     10000     9.63     A          4           RENT
#> 26978 26978           1     10000    13.79     C          6           RENT
#> 26984 26984           0     10000    15.05     D          3           RENT
#> 26989 26989           0     10000     9.63     A          0       MORTGAGE
#> 27006 27006           0     10000    16.00     E          3       MORTGAGE
#> 27012 27012           0     10000     9.32     A         20           RENT
#> 27021 27021           0     10000    13.79     C          1           RENT
#> 27034 27034           0     10000    12.53     C          1           RENT
#> 27046 27046           0     10000    12.21     B         17           RENT
#> 27058 27058           0     10000    15.37     D          3           RENT
#> 27063 27063           0     10000     9.32     A          4           RENT
#> 27066 27066           0     10000    13.79     C          1           RENT
#> 27102 27102           0     10000    10.95     B          4       MORTGAGE
#> 27122 27122           0     10000     9.63     A          4       MORTGAGE
#> 27135 27135           1     10000    14.11     D          3           RENT
#> 27138 27138           0     10000     9.32     A          0           RENT
#> 27154 27154           0     10000     9.32     A          3           RENT
#> 27158 27158           0     10000     9.63     A         19       MORTGAGE
#> 27173 27173           0     10000    11.26     B         13       MORTGAGE
#> 27175 27175           1     10000    11.58     B          4       MORTGAGE
#> 27186 27186           0     10000    12.21     B          2       MORTGAGE
#> 27192 27192           0     10000     9.32     A          6           RENT
#> 27195 27195           0     10000    14.11     D          4           RENT
#> 27205 27205           0     10000    11.26     B         22       MORTGAGE
#> 27206 27206           0     10000    14.42     D          4           RENT
#> 27212 27212           0     10000    13.47     C          2           RENT
#> 27226 27226           1     10000     9.63     A         13       MORTGAGE
#> 27249 27249           0     10000    11.26     B          1           RENT
#> 27262 27262           0     10000    13.16     C         11            OWN
#> 27271 27271           0     10000     9.32     A          1           RENT
#> 27294 27294           0     10000    14.74     D          6           RENT
#> 27346 27346           0     10000     9.63     A          8       MORTGAGE
#> 27347 27347           0     10000    11.26     B          0       MORTGAGE
#> 27350 27350           0     10000    14.74     D          9            OWN
#> 27352 27352           0     10000    11.26     B         21       MORTGAGE
#> 27353 27353           0     10000    13.47     C          4            OWN
#> 27354 27354           1     10000    14.74     D         11       MORTGAGE
#> 27359 27359           0     10000     9.32     A          3           RENT
#> 27362 27362           1     10000    14.11     D         12           RENT
#> 27365 27365           0     10000    11.26     B         10       MORTGAGE
#> 27370 27370           1     10000    12.21     B          9       MORTGAGE
#> 27371 27371           0     10000     8.00     A          1          OTHER
#> 27377 27377           1     10000    15.68     E          3       MORTGAGE
#> 27397 27397           0     10000    12.53     C          2           RENT
#> 27400 27400           0     10000    11.58     B          4       MORTGAGE
#> 27409 27409           1     10000    13.79     C          0           RENT
#> 27418 27418           0     10000     9.32     A          6       MORTGAGE
#> 27420 27420           0     10000     9.32     A          4       MORTGAGE
#> 27470 27470           0     10000    10.83     B         11       MORTGAGE
#> 27475 27475           0     10000    10.20     B          5           RENT
#> 27496 27496           0     10000    10.83     B         10       MORTGAGE
#> 27512 27512           0     10000    12.09     C          2           RENT
#> 27515 27515           0     10000    11.14     B         20       MORTGAGE
#> 27518 27518           0     10000    15.25     E          0       MORTGAGE
#> 27522 27522           0     10000    12.41     C          4           RENT
#> 27546 27546           0     10000    14.93     E          6           RENT
#> 27556 27556           0     10000    13.67     D          2           RENT
#> 27559 27559           0     10000    10.51     B         12           RENT
#> 27567 27567           0     10000    12.09     C          2       MORTGAGE
#> 27586 27586           0     10000     9.07     A          3       MORTGAGE
#> 27587 27587           0     10000    13.36     D          2           RENT
#> 27606 27606           0     10000     9.07     A          4       MORTGAGE
#> 27607 27607           0     10000    12.72     C         11          OTHER
#> 27612 27612           0     10000    13.67     D          1           RENT
#> 27622 27622           0     10000    11.46     B          0           RENT
#> 27658 27658           0     10000    11.78     C          1       MORTGAGE
#> 27666 27666           0     10000    11.78     C          2       MORTGAGE
#> 27668 27668           0     10000    14.93     E          2       MORTGAGE
#> 27676 27676           1     10000    11.46     B         15       MORTGAGE
#> 27681 27681           0     10000     9.07     A         20       MORTGAGE
#> 27683 27683           0     10000    11.14     B          2           RENT
#> 27684 27684           1     10000    14.93     E          1       MORTGAGE
#> 27687 27687           0     10000     8.00     A          0           RENT
#> 27692 27692           0     10000    10.51     B         18           RENT
#> 27698 27698           0     10000    11.46     B          2           RENT
#> 27700 27700           0     10000    11.46     B          2           RENT
#> 27715 27715           0     10000    12.41     C          0       MORTGAGE
#> 27736 27736           0     10000    13.36     D          4           RENT
#> 27879 27879           0     10000    12.22     C          2       MORTGAGE
#> 27881 27881           0     10000    10.96     B          3           RENT
#> 27882 27882           0     10000    13.80     D          3       MORTGAGE
#> 27891 27891           0     10000     9.70     B          5          OTHER
#> 28093 28093           0     10000    14.18     E          4           RENT
#> 28138 28138           0     10000     8.32     A          2       MORTGAGE
#> 28139 28139           0     10000    11.97     C         11           RENT
#> 28140 28140           1     10000     8.00     A          4       MORTGAGE
#> 28158 28158           1     10000    10.71     B          0       MORTGAGE
#> 28168 28168           1     10000    11.03     C          4       MORTGAGE
#> 28175 28175           1     10000    10.39     B          0       MORTGAGE
#> 28182 28182           1     10000    13.24     D         12           RENT
#> 28184 28184           1     10000     9.76     B         12       MORTGAGE
#> 28192 28192           0     10000    11.66     C          3           RENT
#> 28197 28197           0     10000    15.76     F          8            OWN
#> 28208 28208           0     10000    10.08     B          2           RENT
#> 28213 28213           1     10000    10.71     B          1           RENT
#> 28220 28220           0     10000     8.00     A          0       MORTGAGE
#> 28233 28233           0     10000    10.39     B          6           RENT
#> 28234 28234           0     10000    10.39     B          1           RENT
#> 28251 28251           0     10000    13.55     D          8           RENT
#> 28255 28255           0     10000    13.55     D          3           RENT
#> 28298 28298           0     10000    10.08     B          0           RENT
#> 28299 28299           0     10000     8.32     A          0       MORTGAGE
#> 28312 28312           0     10000    11.66     C          0           RENT
#> 28338 28338           0     10000    11.03     C         21       MORTGAGE
#> 28343 28343           1     10000     8.32     A          4           RENT
#> 28346 28346           0     10000    10.39     B          4       MORTGAGE
#> 28357 28357           0     10000    10.39     B          5       MORTGAGE
#> 28383 28383           0     10000     9.45     B          2           RENT
#> 28402 28402           0     10000     8.63     A          7       MORTGAGE
#> 28408 28408           0     10000    13.24     D          5       MORTGAGE
#> 28410 28410           1     10000    11.34     C          0           RENT
#> 28430 28430           0     10000     8.00     A          9           RENT
#> 28435 28435           0     10000    11.03     C          2           RENT
#> 28436 28436           0     10000    11.03     C          0       MORTGAGE
#> 28443 28443           0     10000    11.66     C          1           RENT
#> 28448 28448           0     10000    12.92     D          4           RENT
#> 28449 28449           0     10000    10.71     B          6           RENT
#> 28451 28451           0     10000     9.45     B          0           RENT
#> 28466 28466           0     10000    13.24     D          2           RENT
#> 28470 28470           0     10000     8.63     A          0       MORTGAGE
#> 28498 28498           0     10000    11.34     C          3           RENT
#> 28502 28502           1     10000     9.76     B          5           RENT
#> 28511 28511           0     10000     8.63     A          4       MORTGAGE
#> 28521 28521           0     10000    11.66     C          4           RENT
#> 28523 28523           0     10000     8.00     A          2           RENT
#> 28530 28530           1     10000    13.87     D          2           RENT
#> 28533 28533           0     10000    11.34     C         11       MORTGAGE
#> 28535 28535           0     10000     9.45     B          0           RENT
#> 28538 28538           1     10000    13.55     D          5           RENT
#> 28543 28543           0     10000     8.63     A          2           RENT
#> 28546 28546           0     10000     9.76     B          0           RENT
#> 28558 28558           0     10000    12.61     D          2           RENT
#> 28562 28562           1     10000    13.87     D         12       MORTGAGE
#> 28573 28573           0     10000     8.00     A          2       MORTGAGE
#> 28577 28577           1     10000    11.66     C         11       MORTGAGE
#> 28601 28601           0     10000    15.45     E          1           RENT
#> 28610 28610           0     10000     8.00     A          6       MORTGAGE
#> 28614 28614           1     10000    11.03     C         11           RENT
#> 28620 28620           0     10000    11.66     C         13       MORTGAGE
#> 28671 28671           0     10000     9.20     B          1           RENT
#> 28672 28672           0     10000     9.51     B          0           RENT
#> 28691 28691           0     10000    11.41     C          2           RENT
#> 28731 28731           1     10000    13.30     D         21            OWN
#> 28749 28749           0     10000     9.51     B          0           RENT
#> 28754 28754           0     10000     7.75     A         13       MORTGAGE
#> 28757 28757           0     10000     9.20     B          2           RENT
#> 28778 28778           0     10000     9.20     B          1           RENT
#> 28785 28785           0     10000     8.38     A          2           RENT
#> 28786 28786           0     10000    11.41     C          2           RENT
#> 28789 28789           0     10000    11.09     C          0           RENT
#> 28801 28801           0     10000    13.62     D          6           RENT
#> 28838 28838           0     10000     8.38     A          0           RENT
#> 28840 28840           0     10000     9.64     B          0           RENT
#> 28850 28850           0     10000     9.64     B          0           RENT
#> 28858 28858           1     10000     9.33     B          1       MORTGAGE
#> 28887 28887           0     10000    12.80     D          2           RENT
#> 28911 28911           0     10000     8.70     B          3           RENT
#> 28912 28912           1     10000     9.96     B          1           RENT
#> 28953 28953           0     10000     8.38     A          0           RENT
#> 28954 28954           0     10000     8.07     A          6       MORTGAGE
#> 28955 28955           0     10000     8.07     A          3       MORTGAGE
#> 28980 28980           0     10000    12.80     D          2           RENT
#> 28996 28996           0     10000    11.22     C          8       MORTGAGE
#> 29013 29013           0     10000    10.28     C          3           RENT
#> 29022 29022           0     10000     8.07     A          0       MORTGAGE
#> 29050 29050           0     10000    13.75     E          0           RENT
#> 29073 29073           0     10000    10.28     C          0           RENT
#>       annual_inc age
#> 3       49200.00  24
#> 9      100000.00  28
#> 16      50000.00  23
#> 17      50000.00  22
#> 38      27000.00  23
#> 46      39000.00  33
#> 47      51400.00  23
#> 60      68000.00  29
#> 83      75000.00  24
#> 85      24000.00  33
#> 87      43000.00  37
#> 90      31200.00  25
#> 95      33000.00  25
#> 112     60000.00  46
#> 121     30000.00  32
#> 122     70000.00  23
#> 133     65000.00  35
#> 177     70000.00  22
#> 178     45000.00  21
#> 188     45000.00  29
#> 197     39000.00  22
#> 202     50000.00  25
#> 218     50000.00  23
#> 232     43000.00  27
#> 237     40000.00  38
#> 241     62000.00  23
#> 244     33000.00  26
#> 257     32000.00  42
#> 264     90000.00  29
#> 265     35000.00  27
#> 277     53000.00  33
#> 284     40000.00  21
#> 285     50000.00  35
#> 319     46000.00  40
#> 322     72500.00  36
#> 328    120000.00  25
#> 360     75000.00  24
#> 362     68000.00  32
#> 387     75000.00  30
#> 405     83200.00  22
#> 426     66000.00  27
#> 436     36000.00  30
#> 472     44160.00  23
#> 477     45000.00  25
#> 478     37500.00  25
#> 482     30000.00  46
#> 491     60000.00  23
#> 505     45000.00  23
#> 519     95000.00  23
#> 520     77400.00  29
#> 527    115000.00  23
#> 532     80000.00  29
#> 534     55000.00  22
#> 549     50000.00  30
#> 553     55000.00  27
#> 555     26000.00  22
#> 583     40000.00  22
#> 595     45000.00  22
#> 599     35000.00  28
#> 608     38200.00  25
#> 660     45500.00  29
#> 663     29406.00  26
#> 667     34000.00  21
#> 675     50000.00  23
#> 676     75000.00  24
#> 679     67500.00  35
#> 681     65000.00  26
#> 692     62000.00  23
#> 714     31000.00  22
#> 715    145000.00  23
#> 734     36000.00  31
#> 739     52000.00  24
#> 741     86000.00  26
#> 744     65000.00  30
#> 766     69077.00  22
#> 783     42000.00  22
#> 784     53000.00  35
#> 793     44000.00  22
#> 849     76500.00  28
#> 863     47500.00  31
#> 876     80000.00  44
#> 886     45000.00  24
#> 897     32000.00  27
#> 911     30000.00  28
#> 912     26400.00  22
#> 929     48000.00  21
#> 940     77000.00  31
#> 960     60000.00  29
#> 992     72000.00  22
#> 994     33000.00  23
#> 996     38400.00  33
#> 999     80000.00  24
#> 1003    60000.00  25
#> 1018   200000.00  29
#> 1024    52000.00  24
#> 1029    56000.00  35
#> 1035    42910.00  25
#> 1055    38000.00  22
#> 1095    70000.00  24
#> 1099    60000.00  24
#> 1103    60000.00  23
#> 1109    39600.00  22
#> 1127    64000.00  27
#> 1130    79992.00  25
#> 1139   280000.00  26
#> 1141    75000.00  26
#> 1175    45000.00  35
#> 1193    32000.00  23
#> 1226    25000.00  29
#> 1247    40000.00  28
#> 1257    94800.00  84
#> 1271    70360.00  35
#> 1272   120000.00  24
#> 1278    80000.00  37
#> 1280    98000.00  25
#> 1292    98280.00  21
#> 1305    44959.00  26
#> 1321    60000.00  50
#> 1351    45000.00  30
#> 1364    35000.00  30
#> 1370    35000.00  28
#> 1378    80004.00  24
#> 1402    52000.00  37
#> 1409    60000.00  28
#> 1416    40000.00  28
#> 1463    36000.00  25
#> 1472    39870.00  37
#> 1478    60000.00  22
#> 1480    77000.00  32
#> 1500    65000.00  24
#> 1506    40000.00  30
#> 1526    30000.00  30
#> 1542   100000.00  30
#> 1546    52000.00  28
#> 1555    60000.00  27
#> 1556    42000.00  22
#> 1560    92000.00  23
#> 1565    55000.00  43
#> 1568   150000.00  56
#> 1569    80000.00  22
#> 1587    80000.00  34
#> 1597    45000.00  31
#> 1627    35000.00  28
#> 1646   300000.00  27
#> 1649    44000.00  22
#> 1654    72000.00  34
#> 1655    44000.00  27
#> 1656    60000.00  29
#> 1673    70000.00  22
#> 1686    65000.00  27
#> 1688    51000.00  22
#> 1690    72000.00  41
#> 1691    21000.00  21
#> 1717    75000.00  45
#> 1736    42000.00  22
#> 1739    61000.00  44
#> 1756    58000.00  34
#> 1760    49000.00  22
#> 1761    26000.00  34
#> 1762    40000.00  27
#> 1765    50000.00  21
#> 1773    48000.00  23
#> 1794    72000.00  27
#> 1823    51000.00  37
#> 1834    68000.00  29
#> 1837    45000.00  22
#> 1857    25000.00  37
#> 1860    80000.00  36
#> 1872    31000.00  24
#> 1879    75000.00  22
#> 1882   107000.00  54
#> 1914    62000.00  26
#> 1925    45500.00  39
#> 1940    50000.00  21
#> 1967    33200.00  27
#> 2002    80000.00  34
#> 2069    56000.00  26
#> 2070    73000.00  25
#> 2091    99275.00  25
#> 2113    48132.00  22
#> 2118   127500.00  26
#> 2135    60000.00  37
#> 2137    40992.00  27
#> 2203    31000.00  22
#> 2204    66000.00  41
#> 2259    53500.00  35
#> 2347    30000.00  28
#> 2351    78000.00  25
#> 2357    65000.00  26
#> 2359    30000.00  23
#> 2364    45000.00  23
#> 2382    75000.00  40
#> 2384    40000.00  22
#> 2403    90000.00  31
#> 2404    66000.00  29
#> 2418    78000.00  22
#> 2421    85000.00  24
#> 2443    45000.00  28
#> 2449    91154.00  55
#> 2485   110000.00  25
#> 2490    89000.00  27
#> 2500   102000.00  30
#> 2552    60000.00  22
#> 2581    65000.00  38
#> 2592   180000.00  32
#> 2617    90000.00  23
#> 2619    75000.00  28
#> 2649    30576.00  25
#> 2658    79000.00  35
#> 2705   122500.00  26
#> 2714    80000.00  29
#> 2728    50000.00  27
#> 2740    40000.00  24
#> 2746    54000.00  22
#> 2750    67200.00  31
#> 2765    79200.00  36
#> 2780    70000.00  26
#> 2809    60629.92  24
#> 2812    85000.00  30
#> 2813   180000.00  31
#> 2829    50000.00  25
#> 2855    55000.00  27
#> 2864    60000.00  25
#> 2902    45000.00  22
#> 2914    57000.00  29
#> 2919    54000.00  26
#> 2931    60000.00  26
#> 2936    52000.00  22
#> 2938    54000.00  30
#> 2970    55000.00  25
#> 2988    35000.00  24
#> 3015    43000.00  26
#> 3067   100000.00  22
#> 3069   104000.00  27
#> 3071   173467.00  26
#> 3073    66000.00  28
#> 3075    57000.00  26
#> 3084    98000.00  24
#> 3134    42000.00  25
#> 3161    30000.00  22
#> 3175    54000.00  33
#> 3192    45000.00  27
#> 3194    46000.00  34
#> 3215   120000.00  21
#> 3248    80000.00  22
#> 3263    45000.00  29
#> 3265    60000.00  22
#> 3291    96000.00  46
#> 3309   110000.00  30
#> 3312    42000.00  34
#> 3320    84000.00  25
#> 3349    70000.00  27
#> 3373    95000.00  24
#> 3400    24000.00  25
#> 3404    78000.00  28
#> 3405    50000.00  23
#> 3407    60000.00  24
#> 3410    57664.00  23
#> 3424   126000.00  35
#> 3499    64125.00  28
#> 3513    50000.00  29
#> 3529    85000.00  22
#> 3555    80004.00  24
#> 3557    60000.00  32
#> 3561    78000.00  23
#> 3583   130000.00  26
#> 3594    70000.00  24
#> 3597   300000.00  42
#> 3609    57000.00  25
#> 3618    94000.00  30
#> 3630   165000.00  29
#> 3637   115000.00  31
#> 3650    60000.00  30
#> 3664    45600.00  26
#> 3670   116000.00  46
#> 3680    42000.00  27
#> 3693    63132.00  22
#> 3703    65000.00  21
#> 3721   120000.00  27
#> 3726    85000.00  37
#> 3735    92000.00  36
#> 3742    70000.00  22
#> 3768    37000.00  25
#> 3814   108000.00  30
#> 3817    30000.00  27
#> 3836   124000.00  23
#> 3837    94000.00  24
#> 3846   187000.00  40
#> 3862    49995.00  26
#> 3903    45600.00  36
#> 3918    98000.00  24
#> 3926    68000.00  34
#> 3937    81000.00  38
#> 3959    82000.00  27
#> 3961    88000.00  26
#> 3965   100000.00  24
#> 3991    36996.00  30
#> 4005    50000.00  24
#> 4043    26400.00  37
#> 4048    55000.00  31
#> 4070    36000.00  41
#> 4078    57600.00  26
#> 4125    74000.00  26
#> 4137    64000.00  32
#> 4142    34000.00  25
#> 4195   100000.00  35
#> 4219    26004.00  25
#> 4242    50000.00  24
#> 4252    60000.00  24
#> 4284    35640.00  24
#> 4326    42000.00  22
#> 4362    56000.00  24
#> 4367   150000.00  35
#> 4394    39000.00  25
#> 4457    95234.00  35
#> 4471    36000.00  36
#> 4502    40000.00  23
#> 4513    50000.00  24
#> 4547    90000.00  27
#> 4554    33000.00  23
#> 4555    68000.00  23
#> 4561    50000.00  36
#> 4592    43200.00  23
#> 4644   157500.00  23
#> 4652   132600.00  31
#> 4653    90000.00  26
#> 4677   121200.00  41
#> 4697    52000.00  26
#> 4702    96000.00  23
#> 4725    90000.00  25
#> 4731    35000.00  32
#> 4808    48000.00  23
#> 4823    40000.00  25
#> 4834    51000.00  23
#> 4843    72000.00  27
#> 4888   120000.00  25
#> 4898    74000.00  28
#> 4901   120000.00  23
#> 4908    45600.00  30
#> 4909    50000.00  31
#> 4914    62000.00  23
#> 4972   100000.00  25
#> 4978    97000.00  29
#> 4996    30000.00  32
#> 5008    40000.00  24
#> 5042    66000.00  36
#> 5081    48000.00  31
#> 5094    66000.00  32
#> 5110   350000.00  33
#> 5134    48000.00  23
#> 5136   125000.00  28
#> 5148   100000.00  31
#> 5168    80000.00  42
#> 5195    38000.00  25
#> 5196    62000.00  24
#> 5212    53376.00  28
#> 5219   150000.00  25
#> 5222    62000.00  29
#> 5254    55000.00  39
#> 5271    50000.00  26
#> 5273    75996.00  25
#> 5285    74520.00  33
#> 5317   115000.00  37
#> 5319    60000.00  24
#> 5335    65000.00  44
#> 5348    85000.00  37
#> 5350    83000.00  29
#> 5364    78000.00  21
#> 5378   144000.00  23
#> 5392   105000.00  30
#> 5431    34800.00  28
#> 5440   135000.00  25
#> 5488    39580.80  22
#> 5534    84000.00  23
#> 5570    72000.00  38
#> 5609    42000.00  25
#> 5614    35000.00  27
#> 5652    65000.00  25
#> 5681   108000.00  24
#> 5687    59000.00  22
#> 5736    48000.00  33
#> 5742    91000.00  24
#> 5748    50000.00  21
#> 5767   200000.00  28
#> 5788    45000.00  36
#> 5814    60000.00  29
#> 5815    38400.00  23
#> 5829    60000.00  26
#> 5830    50000.00  24
#> 5858    85000.00  24
#> 5867   120000.00  26
#> 5880    99996.00  28
#> 5884    38000.00  23
#> 5929    60000.00  25
#> 5932    38004.00  35
#> 5939    45000.00  28
#> 5944    39996.00  25
#> 5957   110000.00  32
#> 5964    38400.00  22
#> 5975   285000.00  33
#> 5976    45500.00  22
#> 5982    42000.00  23
#> 5991    97333.00  26
#> 5998    35000.00  33
#> 6008    95000.00  34
#> 6029    50000.00  26
#> 6033    34000.00  23
#> 6074    38400.00  27
#> 6076    50000.00  22
#> 6092    84996.00  23
#> 6138   123000.00  55
#> 6163    55000.00  23
#> 6165    38000.00  25
#> 6207   120000.00  24
#> 6226    70000.00  30
#> 6235    75000.00  23
#> 6246    54000.00  33
#> 6251    65000.00  23
#> 6270    55000.00  22
#> 6292    60204.00  24
#> 6302    86748.00  23
#> 6335   145000.00  26
#> 6353   125000.00  25
#> 6401    55000.00  31
#> 6439    51000.00  22
#> 6460    96000.00  26
#> 6465    36000.00  24
#> 6477    83050.00  24
#> 6480    53000.00  22
#> 6483    65000.00  21
#> 6498   130000.00  27
#> 6508   240000.00  29
#> 6515    26400.00  22
#> 6522    55140.00  27
#> 6532    63000.00  23
#> 6536    90000.00  25
#> 6542    36000.00  23
#> 6553    65000.00  29
#> 6560    38000.00  42
#> 6609   150000.00  30
#> 6610   125000.00  26
#> 6613    68000.00  50
#> 6672    87600.00  24
#> 6695   140000.00  22
#> 6698    29000.00  25
#> 6702   141000.00  24
#> 6713   143004.00  33
#> 6735    88560.00  24
#> 6758    75000.00  33
#> 6783    34560.00  23
#> 6787    67000.00  30
#> 6797   140000.00  38
#> 6818   110000.00  31
#> 6829    39500.00  25
#> 6858    94000.00  35
#> 6889    49000.00  38
#> 6899    50000.00  23
#> 6920   120000.00  28
#> 6992    69228.00  42
#> 6995    38000.00  28
#> 7002    54996.00  29
#> 7049    65900.00  25
#> 7073    84000.00  23
#> 7136    38400.00  34
#> 7162    80000.00  43
#> 7177   120000.00  25
#> 7207    48720.00  23
#> 7221    57240.00  31
#> 7249    48000.00  22
#> 7264    85000.00  23
#> 7290    70000.00  34
#> 7334   250000.00  29
#> 7344    55000.00  26
#> 7358    38014.00  25
#> 7362    62000.00  24
#> 7377    90000.00  27
#> 7405   100000.00  23
#> 7411    48000.00  24
#> 7419    80000.00  43
#> 7423    30000.00  23
#> 7443   200000.00  24
#> 7471    58000.00  29
#> 7475    75000.00  22
#> 7501    90000.00  23
#> 7522    27000.00  27
#> 7542    85000.00  22
#> 7555    97000.00  23
#> 7558    70000.00  29
#> 7580    50000.00  23
#> 7597    78096.00  32
#> 7608    65000.00  28
#> 7651    30720.00  26
#> 7652    19200.00  21
#> 7658   185000.00  48
#> 7668   146000.00  37
#> 7690    52000.00  24
#> 7694    28800.00  22
#> 7700   105000.00  26
#> 7716    80000.00  23
#> 7720    31200.00  27
#> 7725    32400.00  25
#> 7773    96000.00  26
#> 7792   175400.00  33
#> 7793   108288.00  24
#> 7797    48000.00  22
#> 7808    72000.00  60
#> 7810    73000.00  24
#> 7822    82800.00  24
#> 7836    26000.00  45
#> 7930    40000.00  27
#> 7933    65000.00  29
#> 7936    82000.00  49
#> 7996    49000.00  24
#> 8003    47000.00  31
#> 8021    86000.00  22
#> 8042    40000.00  26
#> 8056    60000.00  25
#> 8064    90000.00  25
#> 8078   130000.00  30
#> 8099    56000.00  24
#> 8102   141000.00  24
#> 8106    45000.00  25
#> 8118    44000.00  24
#> 8176    28000.00  22
#> 8202   102000.00  28
#> 8245    32956.00  26
#> 8334    40000.00  24
#> 8343   110000.00  24
#> 8357   140000.00  22
#> 8379   325000.00  31
#> 8381    70000.00  23
#> 8386    33000.00  23
#> 8401    68000.00  22
#> 8449    48960.00  24
#> 8451    60000.00  21
#> 8452    72000.00  28
#> 8457    45992.00  23
#> 8460    84000.00  31
#> 8508    55000.00  32
#> 8518    60000.00  30
#> 8531   115000.00  36
#> 8538    55000.00  25
#> 8548    43200.00  27
#> 8569    62000.00  24
#> 8593    90000.00  30
#> 8597    30000.00  30
#> 8607    40000.00  24
#> 8628   153000.00  33
#> 8631    28800.00  22
#> 8644    62000.00  22
#> 8661    75000.00  36
#> 8679    28000.00  22
#> 8701    22000.00  32
#> 8706    72000.00  27
#> 8714    20000.00  22
#> 8745    36000.00  24
#> 8788   100000.00  24
#> 8813    63000.00  21
#> 8833    50000.00  25
#> 8852    85000.00  22
#> 8858    60000.00  24
#> 8859    85248.00  27
#> 8885    41004.00  41
#> 8903    57000.00  27
#> 8907    80000.00  22
#> 8909    33000.00  37
#> 8918    67000.00  44
#> 8920   100000.00  29
#> 8940    59600.00  24
#> 8952    50000.00  22
#> 8992    42000.00  30
#> 9014    60000.00  23
#> 9022    93000.00  32
#> 9046    98000.00  23
#> 9078    45600.00  23
#> 9102    96000.00  31
#> 9114    65000.00  23
#> 9133   162500.00  26
#> 9158    37000.00  28
#> 9170   100000.00  26
#> 9177   170000.00  31
#> 9190    30000.00  21
#> 9206    60000.00  25
#> 9268    66000.00  22
#> 9290    75000.00  26
#> 9294    65000.00  33
#> 9330    35000.00  45
#> 9335    54996.00  24
#> 9344   140900.00  32
#> 9346    82000.00  38
#> 9348    62364.00  22
#> 9350    54000.00  22
#> 9367    50000.00  33
#> 9377    80038.00  23
#> 9387    45000.00  26
#> 9408    62500.00  22
#> 9410    77500.00  31
#> 9421    75000.00  26
#> 9424    68000.00  24
#> 9431    72000.00  36
#> 9443    48600.00  41
#> 9449    72345.00  25
#> 9451    55000.00  23
#> 9484    70000.00  25
#> 9488    50000.00  30
#> 9493    66000.00  37
#> 9501   120000.00  21
#> 9510    48528.00  28
#> 9578    58216.00  23
#> 9597   115000.00  23
#> 9617    46000.00  32
#> 9635    78204.00  23
#> 9649    72972.35  25
#> 9651    32000.00  26
#> 9659    96000.00  23
#> 9667    56000.00  33
#> 9668    87000.00  26
#> 9676    30000.00  24
#> 9727    44000.00  30
#> 9742    60000.00  28
#> 9743    60000.00  27
#> 9763    75000.00  25
#> 9776    95000.00  24
#> 9786    25000.00  32
#> 9792    86004.00  43
#> 9809    38000.00  33
#> 9815    38400.00  24
#> 9821    47800.00  29
#> 9854   100000.00  29
#> 9859    59000.00  28
#> 9862    36000.00  22
#> 9891    50000.00  22
#> 9893    75000.00  36
#> 9922    65000.00  32
#> 9949    35000.00  25
#> 9958    42000.00  24
#> 9959    65000.00  24
#> 9982    60000.00  22
#> 10007   80000.00  25
#> 10029   72000.00  23
#> 10040   85000.00  27
#> 10053  135000.00  32
#> 10059   50004.00  28
#> 10063   95000.00  41
#> 10080  150000.00  29
#> 10081   52000.00  31
#> 10106   54000.00  29
#> 10138   48200.00  27
#> 10148  102000.00  22
#> 10156   63000.00  29
#> 10161  195054.78  25
#> 10196   41000.00  42
#> 10198   40000.00  38
#> 10205   45336.00  24
#> 10208  130000.00  25
#> 10237   39204.00  50
#> 10239   42000.00  22
#> 10254   56820.00  28
#> 10258   30000.00  23
#> 10278   59000.00  29
#> 10304   45912.00  28
#> 10313   39216.00  23
#> 10314  180000.00  45
#> 10315  192000.00  35
#> 10320   35000.00  33
#> 10321   50004.00  29
#> 10323   55000.00  23
#> 10327   90000.00  26
#> 10333   35238.48  27
#> 10343   62000.00  42
#> 10348   73000.00  24
#> 10351   64000.00  30
#> 10372   80000.00  26
#> 10409   30000.00  26
#> 10421   41000.00  24
#> 10427   45000.00  23
#> 10431   90000.00  28
#> 10491   68000.00  26
#> 10505   44000.00  24
#> 10530   69000.00  30
#> 10548   36000.00  25
#> 10555   75000.00  35
#> 10575   68000.00  22
#> 10585   75000.00  24
#> 10630   34500.00  33
#> 10635   50000.00  28
#> 10659  120000.00  25
#> 10665   40000.00  24
#> 10668   85000.00  24
#> 10689   71000.00  33
#> 10707   79200.00  28
#> 10715   91092.00  23
#> 10722   33600.00  47
#> 10726  104000.00  25
#> 10727   54996.00  25
#> 10734  127000.00  40
#> 10735   64900.00  31
#> 10748   40000.00  28
#> 10777   52000.00  23
#> 10787  125000.00  30
#> 10801   50750.00  22
#> 10814  305000.00  47
#> 10821  134400.00  26
#> 10853  108000.00  44
#> 10858   38832.00  26
#> 10872   50800.00  33
#> 10882  110000.00  34
#> 10903  193000.00  24
#> 10925   95000.00  25
#> 10982   49800.00  27
#> 10983   38400.00  21
#> 10990   59000.00  25
#> 11027   70000.00  22
#> 11030   99000.00  26
#> 11047   30000.00  35
#> 11069   27600.00  34
#> 11075   82000.00  27
#> 11086  170004.00  25
#> 11097   65000.00  26
#> 11118   65000.00  24
#> 11121  105000.00  26
#> 11170   30720.00  25
#> 11184  275000.00  27
#> 11188   82500.00  24
#> 11194  144000.00  37
#> 11202   56000.00  39
#> 11219   90000.00  25
#> 11229   50000.00  25
#> 11231  120000.00  30
#> 11241   52000.00  27
#> 11246   65496.00  22
#> 11261   36000.00  28
#> 11289  100000.00  26
#> 11295  140004.00  36
#> 11309   75000.00  23
#> 11316   72000.00  30
#> 11317  107004.00  22
#> 11320  105600.00  27
#> 11326  117000.00  37
#> 11333   75000.00  25
#> 11368   47508.00  41
#> 11390  204000.00  47
#> 11422   95004.00  21
#> 11430   30000.00  28
#> 11438  100000.00  23
#> 11453  185000.00  24
#> 11459   30000.00  27
#> 11501   43000.00  24
#> 11519  300000.00  23
#> 11560   60000.00  23
#> 11602   69996.00  22
#> 11603   22000.00  26
#> 11648   69504.00  24
#> 11697   44000.00  34
#> 11726  155000.00  25
#> 11751   57000.00  22
#> 11772   48000.00  28
#> 11797   38400.00  22
#> 11803   30636.00  34
#> 11805   73000.00  34
#> 11819   54996.00  28
#> 11824   80000.00  38
#> 11861   36000.00  45
#> 11890   36396.00  22
#> 11898   42000.00  22
#> 11899   40704.00  32
#> 11904   35000.00  23
#> 11905   53000.00  24
#> 11911   99000.00  44
#> 11918   70000.00  26
#> 11923   90000.00  25
#> 11937   44000.00  38
#> 11941   60000.00  24
#> 11944   50000.00  25
#> 11947   67600.00  24
#> 11948   68000.00  26
#> 11961   48000.00  25
#> 11971   32997.60  29
#> 11975  120000.00  25
#> 11980   69000.00  26
#> 11986   36000.00  27
#> 11992   38000.00  32
#> 12009  120000.00  26
#> 12017   60626.00  33
#> 12031   68400.00  21
#> 12036   78996.00  22
#> 12041   50000.00  23
#> 12081   30680.00  23
#> 12102   73000.00  27
#> 12128   66000.00  23
#> 12129   29000.00  22
#> 12137   44000.00  26
#> 12160   87200.00  23
#> 12171  114600.00  23
#> 12175   50004.00  25
#> 12194   40000.00  22
#> 12198  156000.00  32
#> 12222   43288.00  31
#> 12225  175000.00  24
#> 12226   50911.20  32
#> 12271   26400.00  22
#> 12277   53004.00  23
#> 12301   70000.00  24
#> 12311   80000.00  25
#> 12321   39500.00  40
#> 12361   37200.00  22
#> 12382   60000.00  35
#> 12404  115000.00  25
#> 12425  205000.00  24
#> 12441   36712.00  22
#> 12459   55000.00  23
#> 12468  115000.00  49
#> 12495   73000.00  26
#> 12500  157656.00  28
#> 12502  100000.00  29
#> 12533  132000.00  22
#> 12558   60000.00  24
#> 12566   65000.00  26
#> 12573   80000.00  31
#> 12602  108000.00  26
#> 12615   65000.00  24
#> 12617  150000.00  60
#> 12625   52000.00  28
#> 12631  158000.00  35
#> 12641   51000.00  28
#> 12646  110000.00  27
#> 12686   62000.00  26
#> 12691   81000.00  32
#> 12700   35000.00  33
#> 12708   18000.00  24
#> 12721   65000.00  22
#> 12723   29000.00  24
#> 12725   35000.00  21
#> 12741   37500.00  26
#> 12751   73500.00  23
#> 12756   64000.00  21
#> 12769   60000.00  28
#> 12770  120000.00  28
#> 12777  120000.00  26
#> 12778   31500.00  29
#> 12780   71000.00  22
#> 12784   69996.00  42
#> 12785   85000.00  22
#> 12788  100000.00  25
#> 12811   55000.00  26
#> 12819   75000.00  32
#> 12831   44004.00  27
#> 12844   42504.00  25
#> 12849  115000.00  25
#> 12852   54996.00  24
#> 12864   90000.00  27
#> 12868  108000.00  28
#> 12893   19896.00  37
#> 12914   92004.00  29
#> 12945   25000.00  34
#> 12946   40000.00  22
#> 12951   65000.00  24
#> 12952   48000.00  25
#> 12965   95400.00  39
#> 12973   70000.00  36
#> 12993   43000.00  25
#> 12998   55000.00  24
#> 13000   30000.00  33
#> 13001   89904.00  27
#> 13028   54000.00  34
#> 13044   38004.00  22
#> 13082   32000.00  23
#> 13086   29000.00  21
#> 13103   68000.00  24
#> 13109   60000.00  29
#> 13123   46000.00  35
#> 13127   45000.00  23
#> 13141   35000.00  23
#> 13164  137004.00  22
#> 13180  107500.00  23
#> 13186   84000.00  33
#> 13195   75000.00  34
#> 13196   38004.00  22
#> 13215   30000.00  23
#> 13221   82000.00  31
#> 13222   38400.00  25
#> 13252   40000.00  24
#> 13264   72000.00  25
#> 13268   75000.00  30
#> 13270   90000.00  61
#> 13272   42500.00  24
#> 13284   48000.00  23
#> 13287   90000.00  30
#> 13299   40000.00  25
#> 13302   68700.00  27
#> 13321   62000.00  24
#> 13324   87000.00  23
#> 13325  180000.00  25
#> 13331   85000.00  24
#> 13335   34000.00  30
#> 13337   43337.00  33
#> 13347  125000.00  29
#> 13352   45756.00  23
#> 13364   36000.00  25
#> 13368   55000.00  22
#> 13372   68000.00  23
#> 13380   44000.00  25
#> 13394   80000.00  24
#> 13395   42179.04  23
#> 13397   46200.00  22
#> 13407   75000.00  29
#> 13415   32400.00  40
#> 13421   60000.00  33
#> 13423   38000.00  26
#> 13424   24000.00  24
#> 13443   65000.00  22
#> 13444  100000.00  22
#> 13453  100400.00  24
#> 13473   81996.00  26
#> 13477   43000.00  24
#> 13480   48000.00  29
#> 13495  110000.00  23
#> 13503   65000.00  42
#> 13505   96000.00  28
#> 13507   62316.00  21
#> 13519   50000.00  23
#> 13525   30000.00  22
#> 13532   80000.00  27
#> 13558   61000.00  24
#> 13569   28000.00  24
#> 13577   75000.00  27
#> 13598  100000.00  24
#> 13617  110000.00  34
#> 13624   83000.00  23
#> 13628   75000.00  34
#> 13630   73000.00  48
#> 13640   79000.00  25
#> 13658   49500.00  37
#> 13675   56448.00  41
#> 13694   80000.00  37
#> 13756   43000.00  23
#> 13763   90000.00  21
#> 13786   31200.00  36
#> 13800   40000.00  23
#> 13802   80496.00  29
#> 13809  132000.00  27
#> 13839   60000.00  24
#> 13853   53500.00  22
#> 13879   72000.00  24
#> 13881   85000.00  26
#> 13891   54000.00  28
#> 13904   45000.00  25
#> 13914   63000.00  26
#> 13915   58000.00  22
#> 13931 1200000.00  36
#> 13938   70000.00  39
#> 13955   35000.00  30
#> 14023   53004.00  28
#> 14040   48000.00  26
#> 14043   42000.00  26
#> 14060   81000.00  23
#> 14081   55000.00  22
#> 14084   26400.00  24
#> 14094   72000.00  23
#> 14105  144000.00  28
#> 14126   54000.00  30
#> 14161   43200.00  60
#> 14166   55000.00  23
#> 14175  120000.00  26
#> 14187   50000.00  30
#> 14189  160000.00  25
#> 14197   96500.00  25
#> 14210   51996.00  32
#> 14227   78000.00  35
#> 14240   52000.00  25
#> 14257   30000.00  24
#> 14260   51000.00  32
#> 14266   83000.00  23
#> 14269   54000.00  24
#> 14277   78652.00  26
#> 14295   85000.00  23
#> 14296   80004.00  25
#> 14330   73524.00  24
#> 14352   44000.00  37
#> 14363   60000.00  34
#> 14393   43680.00  29
#> 14432   70000.00  22
#> 14449   98004.00  27
#> 14451  129700.00  27
#> 14452   80004.00  27
#> 14456   43000.00  33
#> 14474   68750.00  24
#> 14483   96500.00  29
#> 14487  120000.00  26
#> 14491   24000.00  29
#> 14502   70000.00  23
#> 14522   52000.00  25
#> 14537   72000.00  29
#> 14547   46000.00  23
#> 14549   42000.00  22
#> 14574   82000.00  32
#> 14607  118000.00  27
#> 14639   42000.00  25
#> 14660   52000.00  23
#> 14675   82000.00  35
#> 14679   97000.00  27
#> 14684   71000.00  24
#> 14691  160000.00  27
#> 14697   45996.00  21
#> 14706   95000.00  23
#> 14756   65000.00  23
#> 14758   66996.00  24
#> 14765   72000.00  30
#> 14799  100000.00  32
#> 14803   45000.00  23
#> 14814  100000.00  30
#> 14831   52188.00  37
#> 14834  100000.00  24
#> 14842   36000.00  22
#> 14843   45000.00  24
#> 14845   38400.00  36
#> 14854   78000.00  23
#> 14865   50000.00  32
#> 14881   57996.00  21
#> 14892   30000.00  37
#> 14904   78000.00  25
#> 14912   62000.00  27
#> 14915   97000.00  29
#> 14944   90722.00  30
#> 14949   30000.00  29
#> 15006   85000.00  23
#> 15021   60000.00  22
#> 15030   80000.00  46
#> 15052   65000.00  37
#> 15058   40800.00  22
#> 15059   75000.00  26
#> 15119   70800.00  22
#> 15132   80000.00  47
#> 15149  120000.00  29
#> 15175   47200.00  28
#> 15179   90000.00  25
#> 15203   44000.00  35
#> 15207   32400.00  21
#> 15221   55000.00  24
#> 15232  110000.00  21
#> 15234   45000.00  26
#> 15254   75000.00  27
#> 15277   45600.00  24
#> 15282   96060.00  23
#> 15291  150996.00  31
#> 15314   45000.00  27
#> 15316   48000.00  21
#> 15348   46450.00  23
#> 15361   80000.00  25
#> 15380   45000.00  35
#> 15388   60000.00  28
#> 15391   50000.00  26
#> 15392   45000.00  24
#> 15394   81004.00  30
#> 15411  140000.00  38
#> 15434   30000.00  24
#> 15436   38004.00  26
#> 15450   76000.00  35
#> 15459  108000.00  26
#> 15468   79380.00  26
#> 15476   49500.00  22
#> 15486  123996.00  25
#> 15492   87500.00  24
#> 15495   50004.00  23
#> 15496   75000.00  22
#> 15506   72000.00  30
#> 15530   50000.00  22
#> 15543  113000.00  26
#> 15557   72000.00  26
#> 15559   58000.00  22
#> 15574   27048.00  22
#> 15584  150000.00  25
#> 15587  126000.00  47
#> 15592   60000.00  25
#> 15603   46000.00  24
#> 15610  100000.00  28
#> 15626   85000.00  24
#> 15654   59000.00  29
#> 15661   63000.00  26
#> 15666  110000.00  24
#> 15678   44469.00  35
#> 15717  140004.00  22
#> 15747   87000.00  24
#> 15787   54000.00  26
#> 15793   50000.00  22
#> 15809   55812.00  27
#> 15828   21000.00  22
#> 15829  125000.00  23
#> 15832   75000.00  25
#> 15849   75000.00  22
#> 15855   28000.00  24
#> 15859   78720.00  25
#> 15871  131040.00  28
#> 15875   25000.00  43
#> 15886   65000.00  22
#> 15904   56331.24  27
#> 15911   48000.00  23
#> 15948  108000.00  27
#> 15974   59000.00  30
#> 16007   35000.00  23
#> 16009   62000.00  64
#> 16010   33900.00  28
#> 16041   75000.00  30
#> 16082  667680.00  51
#> 16084   31000.00  23
#> 16091  102000.00  23
#> 16095   53000.00  21
#> 16134  166000.00  36
#> 16148  125000.00  29
#> 16165   35100.00  32
#> 16169  159996.00  29
#> 16189   50004.00  24
#> 16231   60000.00  25
#> 16237   23396.63  41
#> 16238   50000.00  28
#> 16248   85000.00  38
#> 16274   23387.00  25
#> 16284   36996.00  23
#> 16287   75000.00  32
#> 16304   50000.00  30
#> 16308   71496.00  23
#> 16318   80000.00  25
#> 16320  122400.00  32
#> 16332   64999.92  26
#> 16357   33600.00  27
#> 16381   30000.00  28
#> 16392   77256.00  39
#> 16413  106000.00  23
#> 16434   51996.00  26
#> 16445   45000.00  29
#> 16454  147500.00  28
#> 16486   89004.00  27
#> 16517   71028.00  36
#> 16520   43344.00  28
#> 16526   75000.00  26
#> 16559   95000.00  29
#> 16562   38400.00  24
#> 16564   57996.00  23
#> 16567   73000.00  39
#> 16576   40000.00  23
#> 16580   75000.00  33
#> 16586   59000.00  36
#> 16587   72000.00  34
#> 16603  105000.00  34
#> 16621   55000.00  23
#> 16632   99996.00  31
#> 16637  138000.00  36
#> 16652   36000.00  22
#> 16670   80000.00  36
#> 16725   65000.00  23
#> 16728   62000.00  26
#> 16730   60000.00  23
#> 16733   65000.00  25
#> 16737   56004.00  23
#> 16741   42000.00  22
#> 16742   36000.00  26
#> 16759   25320.00  42
#> 16787  136000.00  29
#> 16804   45000.00  22
#> 16807   48000.00  23
#> 16826   32376.00  22
#> 16828   60000.00  27
#> 16844   51996.00  33
#> 16876   84500.00  23
#> 16928   60000.00  38
#> 16933   53004.00  28
#> 16941   55000.00  21
#> 16943   48000.00  29
#> 16947   50000.00  22
#> 16951   74000.00  22
#> 16965   30000.00  25
#> 17005   90000.00  27
#> 17026   99996.00  24
#> 17037   90000.00  23
#> 17056   60000.00  23
#> 17071   85000.00  48
#> 17120  142000.00  30
#> 17179   70000.00  35
#> 17200   30000.00  29
#> 17209   51000.00  23
#> 17217   24000.00  24
#> 17230  125000.00  28
#> 17236   48450.00  36
#> 17304   96000.00  27
#> 17321   80000.00  25
#> 17324   36996.00  22
#> 17339   50000.00  26
#> 17361   38400.00  24
#> 17410   30000.00  22
#> 17412   34000.00  21
#> 17477   90000.00  32
#> 17484   48000.00  25
#> 17490   57600.00  23
#> 17509   44000.00  43
#> 17516   65520.00  26
#> 17540   91000.00  23
#> 17551   65000.00  31
#> 17571   40000.00  26
#> 17573   60000.00  40
#> 17584   45000.00  22
#> 17589   44000.00  22
#> 17596   43080.00  27
#> 17598   30000.00  22
#> 17619   60000.00  29
#> 17654   59004.00  36
#> 17658   24000.00  36
#> 17679   31000.00  25
#> 17713  120000.00  23
#> 17715  115000.00  24
#> 17721   48000.00  34
#> 17726   70000.00  30
#> 17756   70000.00  24
#> 17760   54996.00  23
#> 17769   51600.00  46
#> 17780   74400.00  22
#> 17781   33200.00  26
#> 17795  135000.00  28
#> 17823   62000.00  33
#> 17865   97850.00  24
#> 17884  120000.00  36
#> 17900   64800.00  25
#> 17904   36000.00  27
#> 17915   38004.00  28
#> 17924   38400.00  22
#> 17952   60000.00  27
#> 17988   95000.00  37
#> 17990   54000.00  41
#> 17993   38400.00  21
#> 18066   66384.00  26
#> 18098   50000.00  22
#> 18106   54000.00  23
#> 18113   42000.00  28
#> 18129   32000.00  42
#> 18138   48000.00  29
#> 18145   39996.00  30
#> 18152   40272.00  26
#> 18159   51000.00  26
#> 18170  100000.00  25
#> 18187   99996.00  24
#> 18194  120000.00  23
#> 18229   53292.00  24
#> 18234   84000.00  22
#> 18268   59200.00  56
#> 18312   42500.00  28
#> 18315  120000.00  24
#> 18339   37000.00  23
#> 18353   61000.00  26
#> 18369   40000.00  24
#> 18387   75000.00  23
#> 18395   59650.00  25
#> 18396   38004.00  22
#> 18398   68000.00  30
#> 18408  107000.00  22
#> 18430  120000.00  24
#> 18432   61200.00  23
#> 18435   52000.00  29
#> 18436   32004.00  22
#> 18445   95004.00  23
#> 18448   49500.00  31
#> 18492   42000.00  50
#> 18501   68580.00  30
#> 18503  160000.00  37
#> 18521   84996.00  24
#> 18531   65000.00  23
#> 18537   37000.00  30
#> 18544   51160.00  24
#> 18550   59004.00  27
#> 18599   91000.00  23
#> 18605   30720.00  26
#> 18614   36000.00  27
#> 18628   97800.00  54
#> 18664   28644.00  23
#> 18706   30000.00  22
#> 18724   65488.00  23
#> 18762  135000.00  31
#> 18769   73000.00  25
#> 18772   74004.00  29
#> 18774   90000.00  27
#> 18787  103000.00  28
#> 18789  300000.00  26
#> 18791   25920.00  23
#> 18820   38244.00  24
#> 18828   62000.00  24
#> 18830   70000.00  35
#> 18845   52000.00  32
#> 18889   40000.00  22
#> 18893  110000.00  23
#> 18897   83004.00  28
#> 18929   40000.00  21
#> 18935   85000.00  27
#> 18944   88000.00  26
#> 18949   48000.00  45
#> 18969   50000.00  38
#> 18988   84000.00  22
#> 18996   92652.00  26
#> 19003  125000.00  23
#> 19032   88000.00  23
#> 19038   54316.00  26
#> 19057   65000.00  22
#> 19069   70000.00  36
#> 19090   61476.00  29
#> 19091   50500.00  25
#> 19130   39996.00  23
#> 19131   50004.00  29
#> 19140   33280.00  23
#> 19141   88000.00  29
#> 19151   56000.00  33
#> 19163   45000.00  31
#> 19186   75000.00  55
#> 19197   25000.00  24
#> 19216   92000.00  34
#> 19218   80004.00  35
#> 19242   70800.00  41
#> 19243   61000.00  23
#> 19255   45000.00  24
#> 19266   32000.00  23
#> 19271   65004.00  28
#> 19275   34995.00  26
#> 19290   52000.00  24
#> 19316   43000.00  25
#> 19325   62920.00  22
#> 19336   75689.00  30
#> 19391   50004.00  35
#> 19453   69000.00  49
#> 19473   46999.00  26
#> 19495   38400.00  23
#> 19567   54000.00  26
#> 19576  660000.00  35
#> 19598   26400.00  22
#> 19618   35004.00  22
#> 19635   72000.00  42
#> 19644   42000.00  22
#> 19645   93000.00  23
#> 19654   39500.00  23
#> 19655   53520.00  21
#> 19657   46000.00  31
#> 19666   54000.00  23
#> 19680   38000.00  23
#> 19687  186480.00  28
#> 19703   73500.00  28
#> 19710   45000.00  22
#> 19712   38004.00  26
#> 19730   41000.00  30
#> 19745   72000.00  25
#> 19749   54000.00  33
#> 19762   55000.00  39
#> 19772   50000.00  22
#> 19814   61000.00  36
#> 19815   58100.00  28
#> 19821   39996.00  30
#> 19822   42000.00  25
#> 19826   40000.00  33
#> 19853   83400.00  25
#> 19872  160000.00  36
#> 19882   64600.00  28
#> 19888   68004.00  29
#> 19894   48000.00  29
#> 19909   45000.00  22
#> 19938   96000.00  38
#> 19943   60132.00  27
#> 19949  200000.00  30
#> 19964   48000.00  29
#> 19966   37800.00  23
#> 19989   40000.00  26
#> 19991  120000.00  26
#> 19998   40000.00  24
#> 20004   55000.00  29
#> 20035   30500.00  38
#> 20045   52000.00  26
#> 20055   48000.00  24
#> 20094   31200.00  22
#> 20103   71500.00  41
#> 20109   58608.00  22
#> 20124   22000.00  26
#> 20135   40000.00  21
#> 20159  118000.00  30
#> 20169   49571.00  26
#> 20187   60000.00  23
#> 20191   61500.00  22
#> 20197   53000.00  21
#> 20207  125000.00  24
#> 20221   74000.00  25
#> 20246   80000.00  22
#> 20268   60000.00  32
#> 20280   22800.00  42
#> 20292   33500.00  25
#> 20293   33600.00  24
#> 20311  108000.00  25
#> 20335   36000.00  21
#> 20338   89000.00  31
#> 20339   23000.00  38
#> 20385   75000.00  26
#> 20386  105000.00  24
#> 20394   40720.00  26
#> 20397   40000.00  25
#> 20401  163000.00  23
#> 20408   41000.00  24
#> 20414   36000.00  22
#> 20420   65000.00  34
#> 20432   26000.00  24
#> 20445  135000.00  33
#> 20466   56000.00  32
#> 20470  109800.00  34
#> 20475   65000.00  29
#> 20498   35000.00  24
#> 20519   27000.00  24
#> 20540   42000.00  23
#> 20546   79000.00  22
#> 20558   63000.00  29
#> 20559   95000.00  23
#> 20560   55000.00  27
#> 20563   55000.00  21
#> 20570   48000.00  27
#> 20595   35000.00  27
#> 20604   76000.00  27
#> 20607   49600.00  22
#> 20608   50307.36  22
#> 20610   34000.00  33
#> 20615   58000.00  23
#> 20621   77000.00  23
#> 20622   60000.00  25
#> 20642   53000.00  27
#> 20662   45000.00  28
#> 20667   70000.00  38
#> 20678   40800.00  23
#> 20681   55000.00  22
#> 20690   56000.00  39
#> 20699   72000.00  28
#> 20702   45000.00  21
#> 20734  106000.00  26
#> 20737   47000.00  43
#> 20745  186000.00  25
#> 20748  150000.00  23
#> 20755   23000.00  22
#> 20795   50000.00  25
#> 20796   50000.00  28
#> 20819   35000.00  33
#> 20830   35000.00  27
#> 20831   67000.00  29
#> 20840  120000.00  26
#> 20873   60000.00  23
#> 20879   37000.00  24
#> 20885   33078.00  32
#> 20887   43200.00  53
#> 20903   85680.00  27
#> 20905  125000.00  27
#> 20920   21000.00  22
#> 20921   65000.00  30
#> 20926   40000.00  25
#> 20931   90305.00  31
#> 20940   79000.00  22
#> 20961  120000.00  31
#> 20964   80000.00  26
#> 20966   51000.00  27
#> 20967   68000.00  35
#> 20970   69000.00  28
#> 20982   45000.00  21
#> 20997   62000.00  25
#> 21027   39000.00  23
#> 21049   35300.00  43
#> 21052   48000.00  28
#> 21066  200000.00  27
#> 21085   60000.00  34
#> 21088   48600.00  27
#> 21090   50000.00  29
#> 21100   88800.00  26
#> 21106   36000.00  26
#> 21115   68500.00  23
#> 21123  425000.00  24
#> 21126   60000.00  29
#> 21131  195000.00  43
#> 21152   70000.00  28
#> 21153   88000.00  27
#> 21193   89000.00  34
#> 21205  115752.00  27
#> 21206   57600.00  23
#> 21235   32000.00  22
#> 21252   61000.00  29
#> 21287   70000.00  41
#> 21295   24500.00  27
#> 21296   34000.00  31
#> 21313   43000.00  38
#> 21316  125000.00  21
#> 21327   60000.00  34
#> 21330   90000.00  22
#> 21334   65000.00  22
#> 21351  100000.00  28
#> 21385   30000.00  31
#> 21386   67145.00  22
#> 21423   70000.00  24
#> 21425   30000.00  25
#> 21428   95000.00  30
#> 21439   45000.00  24
#> 21441   56253.00  27
#> 21453   30000.00  38
#> 21466   60000.00  43
#> 21471   65000.00  24
#> 21473  130000.00  23
#> 21478   41300.00  34
#> 21514  103241.00  28
#> 21523   83628.00  28
#> 21525   84456.00  32
#> 21555  100000.00  52
#> 21562  150000.00  37
#> 21573   52000.00  22
#> 21578   41000.00  23
#> 21579   35000.00  23
#> 21581   78000.00  29
#> 21603   96000.00  26
#> 21605   45000.00  49
#> 21634   70000.00  32
#> 21656   65000.00  28
#> 21674   57000.00  41
#> 21704   39000.00  35
#> 21710   40000.00  27
#> 21730   50000.00  22
#> 21742   60000.00  24
#> 21753   24000.00  24
#> 21757   83976.00  27
#> 21773   39312.00  34
#> 21779   30400.00  39
#> 21792   70000.00  23
#> 21817   70000.00  27
#> 21825   26400.00  27
#> 21849   54000.00  24
#> 21853   72900.00  27
#> 21862   86500.00  40
#> 21873   23624.95  26
#> 21877   45000.00  27
#> 21883   33600.00  22
#> 21885   33600.00  21
#> 21898   35000.00  24
#> 21910   67000.00  32
#> 21949   72000.00  23
#> 21972  140000.00  32
#> 21974   30000.00  31
#> 21990   55000.00  22
#> 21993   85000.00  29
#> 22016   94000.00  29
#> 22047   48000.00  34
#> 22060   42000.00  24
#> 22065   70000.00  29
#> 22096   51000.00  24
#> 22121   40000.00  24
#> 22127   41600.00  24
#> 22129   32400.00  21
#> 22140   45000.00  25
#> 22176   62400.00  37
#> 22191   80000.00  32
#> 22205   21600.00  33
#> 22206  165000.00  33
#> 22217   60000.00  27
#> 22220   56000.00  33
#> 22226   48000.00  30
#> 22239   72858.96  23
#> 22240   85000.00  34
#> 22251   80000.00  22
#> 22270   50000.00  26
#> 22271   52000.00  31
#> 22278   80000.00  25
#> 22300   80000.00  24
#> 22303  160000.00  22
#> 22325   92000.00  23
#> 22351   30000.00  25
#> 22354   35000.00  28
#> 22362   88000.00  23
#> 22374   86400.00  27
#> 22384   85900.00  38
#> 22393   29328.00  25
#> 22394   85000.00  40
#> 22436  191000.00  25
#> 22442   30000.00  23
#> 22445   53000.00  22
#> 22448   54000.00  28
#> 22471   90000.00  37
#> 22478   78513.00  26
#> 22500   36000.00  33
#> 22503   80000.00  23
#> 22523   18000.00  24
#> 22531   86000.00  22
#> 22539   51000.00  24
#> 22554  156000.00  25
#> 22570   65000.00  27
#> 22572   67222.00  29
#> 22574   52000.00  23
#> 22581   57000.00  34
#> 22589   44000.00  25
#> 22605   71500.00  29
#> 22647   72000.00  27
#> 22689   57000.00  23
#> 22693  110000.00  35
#> 22734   38000.00  21
#> 22787   30000.00  23
#> 22795  114800.00  24
#> 22808  170000.00  32
#> 22816  102000.00  26
#> 22835   81000.00  22
#> 22852  108960.00  25
#> 22858   43200.00  24
#> 22861   95000.00  25
#> 22863   98400.00  23
#> 22872   36000.00  51
#> 22883   51000.00  26
#> 22885  100000.00  24
#> 22905   55000.00  26
#> 22916   36000.00  21
#> 22957   34000.00  25
#> 22968   30000.00  27
#> 22989   67000.00  25
#> 22992   70000.00  46
#> 23000   72000.00  26
#> 23005   24000.00  28
#> 23009   50000.00  30
#> 23017   35000.00  29
#> 23022   64500.00  23
#> 23033   37000.00  22
#> 23061   54528.00  26
#> 23071   61000.00  37
#> 23075  762000.00  35
#> 23077  100000.00  26
#> 23080   44796.00  23
#> 23086   48996.00  22
#> 23100   47211.00  24
#> 23120   46256.00  24
#> 23148   33800.00  25
#> 23174   98518.00  24
#> 23177   57504.00  23
#> 23178   40000.00  23
#> 23180   64500.00  29
#> 23185   53000.00  33
#> 23197   65000.00  29
#> 23209   38000.00  38
#> 23216   85000.00  32
#> 23220   30000.00  21
#> 23226  140000.00  24
#> 23240   55000.00  25
#> 23261   68000.00  29
#> 23286   60000.00  22
#> 23304  130000.00  27
#> 23315   55000.00  29
#> 23320   32580.00  23
#> 23338   98000.00  23
#> 23344  116000.00  25
#> 23348  150000.00  27
#> 23352   84000.00  21
#> 23354  103000.00  27
#> 23376   44500.00  28
#> 23377   85000.00  26
#> 23378   48000.00  30
#> 23389   45000.00  25
#> 23400   82500.00  30
#> 23413   36000.00  28
#> 23417   40000.00  25
#> 23444   70000.00  45
#> 23453  100000.00  35
#> 23461   25000.00  23
#> 23463   91000.00  35
#> 23464   36000.00  21
#> 23476   75670.00  27
#> 23490   93000.00  23
#> 23500   80000.00  31
#> 23502   53000.00  26
#> 23514   35360.00  25
#> 23523   50000.00  22
#> 23532  110000.00  28
#> 23546   49920.00  22
#> 23578   52500.00  23
#> 23579   62000.00  23
#> 23618   34000.00  24
#> 23679   32647.60  22
#> 23711   62400.00  23
#> 23723   63000.00  22
#> 23752   56000.00  23
#> 23762   82000.00  22
#> 23771   68000.00  25
#> 23807   88500.00  26
#> 23816  200000.00  30
#> 23833   60000.00  23
#> 23834   40000.00  24
#> 23836   48000.00  26
#> 23839  110000.00  33
#> 23863   60000.00  22
#> 23869   25800.00  34
#> 23871   68500.00  29
#> 23880   36000.00  43
#> 23891   25000.00  22
#> 23913   30000.00  22
#> 23938   75000.00  26
#> 23939   38000.00  34
#> 23969   86807.00  46
#> 23990   89400.00  32
#> 24012   69000.00  28
#> 24019   65000.00  24
#> 24028   36000.00  22
#> 24044   33276.00  21
#> 24051   37440.00  40
#> 24057   35000.00  23
#> 24075   56004.00  23
#> 24084   31200.00  24
#> 24092   60000.00  21
#> 24095   78300.00  29
#> 24099   69204.00  34
#> 24101   90000.00  27
#> 24125   36000.00  23
#> 24220   26000.00  36
#> 24253   37500.00  26
#> 24260   45000.00  30
#> 24296  165000.00  25
#> 24304   75000.00  53
#> 24340   60000.00  29
#> 24344   30000.00  31
#> 24366   30000.00  23
#> 24378   33996.00  22
#> 24390  122000.00  25
#> 24404   40000.00  29
#> 24429   60000.00  34
#> 24456   46585.00  23
#> 24465   35004.00  34
#> 24478  100000.00  23
#> 24489   47000.00  22
#> 24505   44160.00  24
#> 24506   51852.00  23
#> 24546  130000.00  29
#> 24566   93000.00  29
#> 24568   45600.00  22
#> 24584   50000.00  23
#> 24603   60000.00  27
#> 24604   46000.00  42
#> 24605   54000.00  32
#> 24608  108000.00  26
#> 24623   24996.00  22
#> 24628   62366.40  25
#> 24654   41000.00  27
#> 24674   97000.00  22
#> 24676   77000.00  36
#> 24697   36000.00  23
#> 24712   55000.00  24
#> 24720   62000.00  23
#> 24725   54996.00  25
#> 24753   60000.00  21
#> 24756  120000.00  30
#> 24769   87000.00  22
#> 24776   26004.00  26
#> 24779   48000.00  39
#> 24788   54996.00  31
#> 24789   21600.00  21
#> 24798  102000.00  28
#> 24810   94500.00  27
#> 24820   37000.00  23
#> 24821  117000.00  37
#> 24847   30000.00  24
#> 24886   75000.00  26
#> 24895   75000.00  29
#> 24897   85000.00  37
#> 24899   66847.30  36
#> 24909  180000.00  30
#> 24923   32000.00  22
#> 24928  122004.00  32
#> 24940   48000.00  26
#> 24952  100000.00  23
#> 24972   39996.00  21
#> 24973  122000.00  25
#> 25020   73000.00  32
#> 25030   70000.00  24
#> 25046  135000.00  23
#> 25047  135000.00  37
#> 25090   60350.00  46
#> 25111   70000.00  25
#> 25122   46000.00  36
#> 25132   43700.00  23
#> 25134   92004.00  30
#> 25151   83000.00  32
#> 25152   90000.00  25
#> 25165   38000.00  22
#> 25173   76000.00  23
#> 25176   71020.00  27
#> 25202   85000.00  30
#> 25205   85000.00  24
#> 25208   50000.00  26
#> 25216   50000.00  25
#> 25241   75000.00  23
#> 25259  199000.00  28
#> 25264   46000.00  29
#> 25292   50000.00  48
#> 25313   90000.00  24
#> 25337   92000.00  29
#> 25349   56004.00  26
#> 25369   50000.00  29
#> 25371   40000.00  27
#> 25378   40000.00  22
#> 25390   66996.00  23
#> 25392   48000.00  26
#> 25394   45000.00  23
#> 25409   94185.00  36
#> 25411   87000.00  22
#> 25428   65000.00  25
#> 25442   46000.00  27
#> 25508   43000.00  29
#> 25509   37000.00  29
#> 25511   75000.00  32
#> 25516  112000.00  38
#> 25531   53004.00  25
#> 25539   43200.00  22
#> 25546   90000.00  29
#> 25547   82632.00  24
#> 25572   49920.00  22
#> 25582   50000.00  29
#> 25591   72000.00  28
#> 25623   37000.00  41
#> 25661   32004.00  23
#> 25672  100000.00  29
#> 25681   58500.00  30
#> 25693   21000.00  23
#> 25703  175000.00  25
#> 25712   30000.00  28
#> 25717   87204.00  29
#> 25734   43000.00  24
#> 25751   60000.00  24
#> 25763   60000.00  24
#> 25770   38904.00  26
#> 25785   75000.00  22
#> 25796  100000.00  28
#> 25802   75000.00  24
#> 25807   41004.00  23
#> 25812   58000.00  28
#> 25841   41000.00  47
#> 25857   66000.00  23
#> 25863   33996.00  25
#> 25870   66500.00  33
#> 25875   20008.00  22
#> 25884   73000.00  24
#> 25886   55016.00  25
#> 25908  230000.00  28
#> 25917   23700.00  24
#> 25919   84996.00  23
#> 25940   62000.00  22
#> 25955   36000.00  23
#> 25964   75000.00  31
#> 25981   50004.00  31
#> 25993   34000.00  25
#> 25996   67641.60  35
#> 26002   40000.00  28
#> 26022   32890.00  27
#> 26052   62004.00  31
#> 26088   58200.00  22
#> 26090   56000.00  24
#> 26107  135000.00  35
#> 26148   45000.00  35
#> 26194   35004.00  24
#> 26195   90000.00  31
#> 26201   55000.00  32
#> 26203   36000.00  23
#> 26221  125004.00  22
#> 26232   31200.00  27
#> 26236   34000.00  28
#> 26275   35000.00  30
#> 26292   35364.00  25
#> 26303   48000.00  36
#> 26313  180000.00  26
#> 26317   26000.00  24
#> 26318   87996.00  24
#> 26342   45000.00  24
#> 26345   48000.00  23
#> 26349   37800.00  25
#> 26352   75000.00  28
#> 26369  100000.00  35
#> 26384  132000.00  25
#> 26385   60000.00  22
#> 26388   48000.00  22
#> 26410   21000.00  23
#> 26421   47004.00  26
#> 26436   34500.00  22
#> 26458   40000.00  26
#> 26463   50280.00  25
#> 26465  160000.00  36
#> 26483   24000.00  27
#> 26488   37965.24  32
#> 26508   84996.00  33
#> 26512   53000.00  28
#> 26516   55000.00  28
#> 26554   85000.00  29
#> 26555  111150.00  23
#> 26576   57000.00  36
#> 26584   47000.00  24
#> 26586   54480.00  24
#> 26589   28000.00  29
#> 26590   75000.00  23
#> 26594   33500.00  24
#> 26597   85000.00  23
#> 26608   65000.00  25
#> 26615   45000.00  25
#> 26620  102000.00  27
#> 26639   67000.00  44
#> 26654   67000.00  26
#> 26664   50004.00  22
#> 26666   60000.00  24
#> 26670   30000.00  22
#> 26675   72500.00  22
#> 26682   50004.00  24
#> 26696   85000.00  23
#> 26710   54996.00  36
#> 26712   60000.00  23
#> 26719   45000.00  29
#> 26838   40000.00  23
#> 26863   32000.00  37
#> 26872   60000.00  24
#> 26891   65000.00  21
#> 26898   55000.00  22
#> 26913   73524.00  30
#> 26917   68496.00  22
#> 26932   54996.00  22
#> 26935   70000.00  23
#> 26947   48000.00  23
#> 26951   50000.00  27
#> 26963   78996.00  46
#> 26978   60000.00  22
#> 26984   68000.00  26
#> 26989   29760.00  31
#> 27006  112000.00  45
#> 27012   42000.00  28
#> 27021   55000.00  42
#> 27034   30000.00  22
#> 27046   82650.00  23
#> 27058   39996.00  27
#> 27063   50000.00  22
#> 27066   48000.00  23
#> 27102   95000.00  44
#> 27122   76800.00  23
#> 27135   25000.00  25
#> 27138  110000.00  33
#> 27154  120000.00  25
#> 27158   60000.00  31
#> 27173  390000.00  27
#> 27175  140000.00  25
#> 27186   60000.00  25
#> 27192   60000.00  24
#> 27195   45000.00  26
#> 27205   70596.00  34
#> 27206   36000.00  31
#> 27212  130000.00  27
#> 27226   90000.00  26
#> 27249   62000.00  26
#> 27262   45996.00  23
#> 27271   99996.00  22
#> 27294   44000.00  21
#> 27346   27996.00  21
#> 27347   60000.00  23
#> 27350   46000.00  21
#> 27352  175000.00  38
#> 27353   50000.00  26
#> 27354   51000.00  30
#> 27359   85000.00  39
#> 27362   60000.00  23
#> 27365   40000.00  28
#> 27370   66000.00  26
#> 27371   40000.00  29
#> 27377   63000.00  33
#> 27397   33280.00  22
#> 27400   29004.00  46
#> 27409   40000.00  25
#> 27418   37500.00  36
#> 27420  114000.00  25
#> 27470   60000.00  25
#> 27475   91000.00  23
#> 27496   32004.00  22
#> 27512   60000.00  25
#> 27515  120000.00  27
#> 27518   60000.00  29
#> 27522   70000.00  24
#> 27546   55008.00  24
#> 27556  250000.00  24
#> 27559   84996.00  27
#> 27567  100000.00  27
#> 27586   95000.00  22
#> 27587   60000.00  22
#> 27606   50000.00  49
#> 27607   40104.00  23
#> 27612   60000.00  23
#> 27622  100000.00  23
#> 27658   65600.00  25
#> 27666   49304.00  27
#> 27668   82000.00  25
#> 27676   93996.00  22
#> 27681   62004.00  23
#> 27683   41004.00  24
#> 27684   60000.00  36
#> 27687   40000.00  22
#> 27692   63000.00  46
#> 27698   54000.00  25
#> 27700   36000.00  24
#> 27715   62000.00  29
#> 27736   45000.00  30
#> 27879   36933.72  22
#> 27881   58000.00  32
#> 27882  200000.00  37
#> 27891  108000.00  24
#> 28093   90000.00  30
#> 28138   36000.00  22
#> 28139   60000.00  29
#> 28140   65000.00  30
#> 28158  200000.00  32
#> 28168   80000.00  36
#> 28175   34000.00  53
#> 28182  102000.00  32
#> 28184   36252.00  25
#> 28192   67000.00  44
#> 28197   42642.71  25
#> 28208   35665.00  34
#> 28213   50000.00  31
#> 28220   28989.00  23
#> 28233   62200.00  45
#> 28234   38400.00  32
#> 28251  148000.00  30
#> 28255  100000.00  42
#> 28298   48000.00  28
#> 28299   80000.00  22
#> 28312  120000.00  23
#> 28338   46116.00  25
#> 28343   39948.00  22
#> 28346   75555.00  26
#> 28357   65379.00  37
#> 28383   70000.00  26
#> 28402   90000.00  30
#> 28408   58000.00  25
#> 28410   25368.00  29
#> 28430   52000.00  29
#> 28435   33600.00  25
#> 28436   47000.00  31
#> 28443   64000.00  28
#> 28448   37200.00  24
#> 28449   76250.00  26
#> 28451   94000.00  23
#> 28466   66000.00  43
#> 28470   60000.00  27
#> 28498   28600.00  21
#> 28502   24000.00  37
#> 28511  109200.00  23
#> 28521   30000.00  24
#> 28523  117000.00  27
#> 28530   35400.00  31
#> 28533   75000.00  25
#> 28535   65000.00  22
#> 28538   71600.00  26
#> 28543   30000.00  31
#> 28546   38000.00  27
#> 28558   52000.00  23
#> 28562   58000.00  22
#> 28573   25000.00  24
#> 28577   92400.00  24
#> 28601   54996.00  30
#> 28610  115000.00  28
#> 28614   30000.00  33
#> 28620   49600.00  25
#> 28671   45000.00  27
#> 28672   51600.00  22
#> 28691   40000.00  31
#> 28731  120000.00  36
#> 28749   55000.00  34
#> 28754  115500.00  24
#> 28757  165000.00  24
#> 28778   77250.00  28
#> 28785   69600.00  24
#> 28786   78504.00  31
#> 28789   41500.00  27
#> 28801   49500.00  24
#> 28838  107000.00  25
#> 28840   24960.00  23
#> 28850   67000.00  24
#> 28858   36500.00  33
#> 28887   58800.00  26
#> 28911   24000.00  24
#> 28912   72500.00  26
#> 28953   30000.00  24
#> 28954  150000.00  28
#> 28955   85000.00  47
#> 28980   36400.00  22
#> 28996   30000.00  38
#> 29013  120000.00  38
#> 29022  173000.00  26
#> 29050   35000.00  31
#> 29073   27376.00  22
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

