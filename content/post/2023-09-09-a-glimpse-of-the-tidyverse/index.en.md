---
title: A glimpse of the tidyverse
author: Bongani Ncube
date: '2023-09-09'
slug: a-glimpse-of-the-tidyverse
categories:
  - dplyr
  - datascience
  - Rstats
tags: []
subtitle: ''
summary: ''
authors: []
lastmod: '2023-09-09T13:44:42+02:00'
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
### Goal for Today

*Introduce you to R and Rstudio.*
  
  
# What Are R and Rstudio?

### What Is R?

R is an open source programming language with origins in C and FORTRAN. Advantages:
  
  - Flexibility
- It's free (and open source)!
- Ease of handling advanced computational models
- Ease of handling multiple data sets in one session
- Higher demand in industries.

But more importantly, it's free.

### What Is R?

Some disadvantages:
  
  - "Bleeding" edge? (Even then...)
- Higher learning curve
- A "programming language" and not a "program."

Rstudio will help with the learning curve component.

## Getting Started in R and Rstudio
### Getting Started in R and Rstudio

Let's get started in Rstudio first. Select "Tools" in the menu.

- Scroll to "Global Options" (should be at the bottom)
- On the pop-up, select "pane layout."
- Rearrange so that "Source" is top left, "Console" is top right", and the files/plots/packages/etc. is the bottom right.
- Save

###

![](rstudio-global-options.png)


### Getting Started in R and Rstudio

Hit Ctrl-Shift-N (Cmd-Shift-N if you're on a Mac) to open up a new script.

- Minimize the "Environment/History/Connections/Git" pane in the bottom left.
- Adjust the console output to your liking.

This should maximize your Rstudio experience, esp. as you'll eventually start writing documents in Rstudio.


- That should maximize your Rstudio experience, esp. as you begin to write documents in Rstudio as well.


### A Few Commands to Get Started

`getwd()` will spit out your current working directory.


```r
getwd()
```

```
## [1] "D:/MY THESIS/Git/academic-website/content/post/2023-09-09-a-glimpse-of-the-tidyverse"
```

By default, assuming your username is "Bongani":

- Windows: `"D:/"` (notice the forward slashes!)

### Creating Objects

R is an "object-oriented" programming language.

- i.e. inputs create outputs that may be assigned to objects in the workspace.

For example: 


```r
a <- 3
b <- 4 
this_is_a_long_object_name_and_you_should_not_do_this <- 5
d <- pi # notice there are a few built-in functions/objects
```

Sometimes it's useful to see all the mess you've created in your workspace


```r
ls()
```

```
## [1] "a"                                                    
## [2] "b"                                                    
## [3] "d"                                                    
## [4] "this_is_a_long_object_name_and_you_should_not_do_this"
```


### Install Packages

R depends on user-created libraries to do much of its functionality. We're going to start with a few for the sake of this exercise.



```r
# This will take a while, mostly for tidyverse
install.packages(c("tidyverse","devtools"))

# Once it's installed:
library(tidyverse)
library(devtools)
```


### Load Data

You can load data from your hard drive, or even the internet. Some commands:
  
  - `haven::read_dta()` for Stata .dta files
- `haven::read_spss()` for SPSS files
- `read_csv()` for CSV files
- `readxl::read_excel()` for MS Excel spreadsheets
- `read_tsv()`for tab-separated values.

Just make sure to apply it to an object.

\scriptsize

```r
# Note: hypothetical data
Apply <- haven::read_dta("D:\MY THESIS\BONGANIfinalologit.dta")

Cunemp <- read_tsv("D:\MY THESIS\BONGANIfinalla.data.64.County") 
```

\normalsize


### Load Data

Some R packages, like `pharmacoSmoking` package, has built-in data. For example:
  

```r
pwt_sample= pharmacoSmoking |> 
  as.tibble()
```

```
## Warning: `as.tibble()` was deprecated in tibble 2.0.0.
## i Please use `as_tibble()` instead.
## i The signature and semantics have changed, see `?as_tibble`.
## This warning is displayed once every 8 hours.
## Call `lifecycle::last_lifecycle_warnings()` to see where this warning was
## generated.
```

```r
names(pwt_sample)
```

```
##  [1] "id"             "ttr"            "relapse"        "grp"           
##  [5] "age"            "gender"         "race"           "employment"    
##  [9] "yearsSmoking"   "levelSmoking"   "ageGroup2"      "ageGroup4"     
## [13] "priorAttempts"  "longestNoSmoke"
```


## Tidyverse
### Tidyverse

The tidyverse is a suite of functions/packages that totally rethink base R. Some functions we'll discuss:

- `%>%` (the pipe)
- `glimpse()` and `summary()`
- `select()`
- `group_by()`
- `summarize()`
- `mutate()`
- `filter()`

I cannot fully discuss everything from the tidyverse. That's why there's Google/Stackexchange. :P

### `%>%`

The pipe (`%>%`) allows you to chain together a series of tidyverse functions.

- This is especially useful when you're recoding data and you want to make sure you got everything right before saving the data.

You can chain together a host of tidyverse commands within it.

### `glimpse()` and `summary()`

`glimpse()` and `summary()` will get you some basic descriptions of your data. For example:
  

```r
pwt_sample %>% glimpse() # notice the pipe
```

```
## Rows: 125
## Columns: 14
## $ id             <int> 21, 113, 39, 80, 87, 29, 16, 35, 54, 70, 84, 85, 25, 47~
## $ ttr            <int> 182, 14, 5, 16, 0, 182, 14, 77, 2, 0, 12, 182, 21, 3, 1~
## $ relapse        <int> 0, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 0, 1~
## $ grp            <fct> patchOnly, patchOnly, combination, combination, combina~
## $ age            <int> 36, 41, 25, 54, 45, 43, 66, 78, 40, 38, 64, 51, 37, 65,~
## $ gender         <fct> Male, Male, Female, Male, Male, Male, Male, Female, Fem~
## $ race           <fct> white, white, white, white, white, hispanic, black, bla~
## $ employment     <fct> ft, other, other, ft, other, ft, pt, other, ft, ft, oth~
## $ yearsSmoking   <int> 26, 27, 12, 39, 30, 30, 54, 56, 25, 23, 30, 35, 23, 50,~
## $ levelSmoking   <fct> heavy, heavy, heavy, heavy, heavy, heavy, heavy, light,~
## $ ageGroup2      <fct> 21-49, 21-49, 21-49, 50+, 21-49, 21-49, 50+, 50+, 21-49~
## $ ageGroup4      <fct> 35-49, 35-49, 21-34, 50-64, 35-49, 35-49, 65+, 65+, 35-~
## $ priorAttempts  <int> 0, 3, 3, 0, 0, 2, 0, 10, 4, 10, 12, 1, 5, 6, 5, 2, 1, 1~
## $ longestNoSmoke <int> 0, 90, 21, 0, 0, 1825, 0, 15, 7, 90, 365, 7, 1095, 180,~
```

### `glimpse()` and `summary()`

`summary()` is technically not a tidyverse function, but it works within the pipe.


```r
pwt_sample= pharmacoSmoking
pwt_sample %>% summary()
```

```
##        id              ttr            relapse               grp    
##  Min.   :  1.00   Min.   :  0.00   Min.   :0.000   combination:61  
##  1st Qu.: 33.00   1st Qu.:  8.00   1st Qu.:0.000   patchOnly  :64  
##  Median : 67.00   Median : 49.00   Median :1.000                   
##  Mean   : 66.15   Mean   : 77.44   Mean   :0.712                   
##  3rd Qu.: 99.00   3rd Qu.:182.00   3rd Qu.:1.000                   
##  Max.   :130.00   Max.   :182.00   Max.   :1.000                   
##       age           gender         race    employment  yearsSmoking  
##  Min.   :22.00   Female:81   black   :38   ft   :72   Min.   : 9.00  
##  1st Qu.:41.00   Male  :44   hispanic: 8   other:39   1st Qu.:22.00  
##  Median :49.00               other   : 2   pt   :14   Median :30.00  
##  Mean   :48.84               white   :77              Mean   :30.88  
##  3rd Qu.:56.00                                        3rd Qu.:39.00  
##  Max.   :86.00                                        Max.   :56.00  
##  levelSmoking ageGroup2  ageGroup4  priorAttempts     longestNoSmoke  
##  heavy:89     21-49:66   21-34:16   Min.   :   0.00   Min.   :   0.0  
##  light:36     50+  :59   35-49:50   1st Qu.:   1.00   1st Qu.:   7.0  
##                          50-64:48   Median :   2.00   Median :  90.0  
##                          65+  :11   Mean   :  12.68   Mean   : 539.7  
##                                     3rd Qu.:   5.00   3rd Qu.: 365.0  
##                                     Max.   :1000.00   Max.   :6205.0
```

### `select()`

`select()` will grab (or omit) columns from the data.


```r
# grab everything
pwt_sample %>% select(everything()) |> head()
```

```
##    id ttr relapse         grp age gender     race employment yearsSmoking
## 1  21 182       0   patchOnly  36   Male    white         ft           26
## 2 113  14       1   patchOnly  41   Male    white      other           27
## 3  39   5       1 combination  25 Female    white      other           12
## 4  80  16       1 combination  54   Male    white         ft           39
## 5  87   0       1 combination  45   Male    white      other           30
## 6  29 182       0 combination  43   Male hispanic         ft           30
##   levelSmoking ageGroup2 ageGroup4 priorAttempts longestNoSmoke
## 1        heavy     21-49     35-49             0              0
## 2        heavy     21-49     35-49             3             90
## 3        heavy     21-49     21-34             3             21
## 4        heavy       50+     50-64             0              0
## 5        heavy     21-49     35-49             0              0
## 6        heavy     21-49     35-49             2           1825
```

### `select()`


```r
# grab everything, but drop the id variable.
pwt_sample %>% select(-id) 
```

```
##     ttr relapse         grp age gender     race employment yearsSmoking
## 1   182       0   patchOnly  36   Male    white         ft           26
## 2    14       1   patchOnly  41   Male    white      other           27
## 3     5       1 combination  25 Female    white      other           12
## 4    16       1 combination  54   Male    white         ft           39
## 5     0       1 combination  45   Male    white      other           30
## 6   182       0 combination  43   Male hispanic         ft           30
## 7    14       1   patchOnly  66   Male    black         pt           54
## 8    77       1   patchOnly  78 Female    black      other           56
## 9     2       1   patchOnly  40 Female    black         ft           25
## 10    0       1   patchOnly  38   Male    black         ft           23
## 11   12       1   patchOnly  64 Female    black      other           30
## 12  182       0 combination  51   Male    black         ft           35
## 13   21       1   patchOnly  37 Female    white         pt           23
## 14    3       1   patchOnly  65   Male    white      other           50
## 15  170       1   patchOnly  42 Female    white         ft           30
## 16   25       1   patchOnly  40   Male    white      other           22
## 17    4       1   patchOnly  65 Female    white      other           50
## 18  182       0 combination  52 Female    white      other           19
## 19  140       1 combination  43   Male    white         ft           27
## 20   63       1 combination  34 Female    white         ft           18
## 21   15       1 combination  46 Female    white      other           26
## 22  140       1 combination  60   Male    white         ft           42
## 23  110       1 combination  49 Female    white      other           35
## 24  182       0 combination  58 Female    white         ft           38
## 25    0       1   patchOnly  48   Male hispanic      other           33
## 26  182       0 combination  54 Female hispanic      other           38
## 27   15       1   patchOnly  49 Female    black         pt           35
## 28  182       0   patchOnly  55   Male    black         ft           39
## 29    4       1   patchOnly  33   Male    black         ft           12
## 30   56       1 combination  49 Female    black         ft           37
## 31    2       1 combination  46   Male    black         ft           25
## 32   80       1   patchOnly  34 Female    other         ft           18
## 33  182       0 combination  46 Female    white         pt           25
## 34   56       1   patchOnly  52   Male    black      other           25
## 35    0       1   patchOnly  52 Female    black         ft           30
## 36   14       1   patchOnly  48 Female    white         ft           34
## 37   14       1   patchOnly  48 Female    white         ft           39
## 38   28       1   patchOnly  56 Female    white         ft           36
## 39  182       0   patchOnly  58   Male    white      other           41
## 40    6       1   patchOnly  60   Male    white         ft           50
## 41  182       0   patchOnly  55   Male    white         ft           40
## 42   14       1   patchOnly  43 Female    white         ft           28
## 43   15       1   patchOnly  55 Female    white         ft           42
## 44  182       0 combination  70 Female    white      other           52
## 45   75       1 combination  62 Female    white         pt           46
## 46   30       1 combination  86   Male    white      other           40
## 47    4       1 combination  52   Male    white         ft           33
## 48   56       1 combination  27 Female    white         ft           13
## 49  182       0 combination  52   Male    white         ft           35
## 50  182       0 combination  62   Male    white         ft           35
## 51    5       1 combination  57 Female    white         ft           47
## 52    8       1 combination  40   Male    white         ft           27
## 53  140       1 combination  49   Male    white      other           14
## 54   20       1 combination  68 Female    white      other           53
## 55   63       1 combination  47 Female    white         pt           15
## 56   30       1 combination  46 Female    white         ft           34
## 57    8       1 combination  55   Male    white         pt           40
## 58   50       1 combination  29   Male    white         ft           12
## 59   14       1 combination  64 Female    white         pt           45
## 60    0       1 combination  52   Male    white         ft           38
## 61   84       1   patchOnly  38 Female hispanic         ft           10
## 62    0       1   patchOnly  35   Male hispanic      other           20
## 63  105       1   patchOnly  50 Female hispanic      other           33
## 64  182       0 combination  63 Female hispanic      other           45
## 65  182       0   patchOnly  58   Male    black         ft           40
## 66  182       0   patchOnly  56   Male    black         ft           16
## 67    7       1   patchOnly  44 Female    black      other           31
## 68  182       0   patchOnly  34 Female    black         ft           20
## 69    0       1   patchOnly  49 Female    black         ft           36
## 70    8       1   patchOnly  43 Female    black      other           24
## 71    1       1   patchOnly  39 Female    black         ft           27
## 72  182       0 combination  41 Female    black         ft           20
## 73   12       1 combination  46 Female    black      other           30
## 74  182       0 combination  46 Female    black         ft           21
## 75   49       1   patchOnly  53 Female    white         pt           18
## 76  182       0   patchOnly  58   Male    white         ft           46
## 77  182       0   patchOnly  40 Female    white         ft           25
## 78    2       1   patchOnly  62 Female    white      other           49
## 79  182       0   patchOnly  53   Male    white         ft           38
## 80   56       1   patchOnly  44 Female    white         ft           35
## 81  182       0   patchOnly  64 Female    white      other           47
## 82    0       1   patchOnly  50 Female    white         ft           30
## 83   28       1   patchOnly  47   Male    white         ft           22
## 84  155       1   patchOnly  49 Female    white         pt           35
## 85    2       1   patchOnly  51   Male    white      other           36
## 86    0       1   patchOnly  41 Female    white      other           26
## 87    0       1   patchOnly  22 Female    white         pt           10
## 88    1       1   patchOnly  22 Female    white         pt            9
## 89  140       1   patchOnly  34 Female    white         ft           18
## 90    1       1   patchOnly  48 Female    white         ft           30
## 91   28       1   patchOnly  30 Female    white         ft           12
## 92    1       1   patchOnly  31   Male    white         ft           19
## 93  182       0   patchOnly  44 Female    white         ft           30
## 94   77       1   patchOnly  56 Female    white         ft           44
## 95   56       1   patchOnly  29 Female    white         ft           10
## 96  182       0 combination  69   Male    white      other           50
## 97  182       0 combination  41   Male    white         ft           29
## 98  182       0 combination  52 Female    white      other           33
## 99  182       0 combination  52 Female    white         ft           30
## 100 182       0 combination  53   Male    white         ft           30
## 101  21       1 combination  31 Female    white         ft           15
## 102  60       1 combination  70 Female    white      other           54
## 103   0       1 combination  43   Male    white      other           29
## 104 182       0 combination  58 Female    white         ft           36
## 105  65       1 combination  48 Female    white         ft           34
## 106 182       0 combination  72   Male    white      other           55
## 107 182       0 combination  61 Female    white      other           45
## 108 182       0 combination  53 Female    white         ft           41
## 109 182       0 combination  63 Female    other      other           52
## 110   2       1 combination  40 Female hispanic         pt           23
## 111  40       1   patchOnly  39 Female    black         ft           20
## 112 100       1   patchOnly  60 Female    black         ft           20
## 113   1       1   patchOnly  54 Female    black      other           34
## 114  45       1   patchOnly  68 Female    black         ft           25
## 115  14       1   patchOnly  54 Female    black         ft           22
## 116  30       1   patchOnly  51   Male    black      other           30
## 117  42       1 combination  39 Female    black         ft           23
## 118   2       1 combination  47 Female    black         ft           33
## 119 182       0 combination  33 Female    black         ft           10
## 120  60       1 combination  27 Female    black         ft           11
## 121  10       1 combination  45 Female    black         ft           32
## 122   0       1 combination  36 Female    black         ft           20
## 123 170       1 combination  39   Male    black         ft           20
## 124  15       1 combination  56 Female    black      other           39
## 125 182       0 combination  50 Female    black         pt           30
##     levelSmoking ageGroup2 ageGroup4 priorAttempts longestNoSmoke
## 1          heavy     21-49     35-49             0              0
## 2          heavy     21-49     35-49             3             90
## 3          heavy     21-49     21-34             3             21
## 4          heavy       50+     50-64             0              0
## 5          heavy     21-49     35-49             0              0
## 6          heavy     21-49     35-49             2           1825
## 7          heavy       50+       65+             0              0
## 8          light       50+       65+            10             15
## 9          heavy     21-49     35-49             4              7
## 10         light     21-49     35-49            10             90
## 11         heavy       50+     50-64            12            365
## 12         heavy       50+     50-64             1              7
## 13         light     21-49     35-49             5           1095
## 14         heavy       50+       65+             6            180
## 15         heavy     21-49     35-49             5            240
## 16         heavy     21-49     35-49             2              2
## 17         light       50+       65+             1              2
## 18         light       50+     50-64             1              7
## 19         heavy     21-49     35-49             5            120
## 20         heavy     21-49     21-34             8             90
## 21         heavy     21-49     35-49             2             14
## 22         light       50+     50-64             6           2920
## 23         heavy     21-49     35-49            10             60
## 24         heavy       50+     50-64             1              0
## 25         heavy     21-49     35-49             4            120
## 26         light       50+     50-64            30           3650
## 27         light     21-49     35-49             4            540
## 28         heavy       50+     50-64             1             28
## 29         light     21-49     21-34             1            730
## 30         heavy     21-49     35-49             3           2920
## 31         light     21-49     35-49             2           1095
## 32         heavy     21-49     21-34             1            120
## 33         heavy     21-49     35-49             3            365
## 34         light       50+     50-64            10              7
## 35         heavy       50+     50-64             2             42
## 36         heavy     21-49     35-49             6           2555
## 37         heavy     21-49     35-49             1              2
## 38         heavy       50+     50-64             5            180
## 39         light       50+     50-64           100            180
## 40         heavy       50+     50-64             6             30
## 41         heavy       50+     50-64             1            180
## 42         heavy     21-49     35-49             4            365
## 43         heavy       50+     50-64             2             60
## 44         heavy       50+       65+             3              1
## 45         heavy       50+     50-64             8           1095
## 46         light       50+       65+             4           2190
## 47         heavy       50+     50-64             2              2
## 48         light     21-49     21-34             1              7
## 49         heavy       50+     50-64             3            730
## 50         heavy       50+     50-64             1           2555
## 51         heavy       50+     50-64             0              0
## 52         heavy     21-49     35-49             2             90
## 53         heavy     21-49     35-49             0              0
## 54         heavy       50+       65+             0              0
## 55         heavy     21-49     35-49             1             90
## 56         light     21-49     35-49            20             90
## 57         heavy       50+     50-64             6            913
## 58         heavy     21-49     21-34             0              0
## 59         heavy       50+     50-64             4             60
## 60         heavy       50+     50-64             4              7
## 61         heavy     21-49     35-49             2              3
## 62         light     21-49     35-49             2              7
## 63         heavy       50+     50-64             2             30
## 64         heavy       50+     50-64             1             28
## 65         heavy       50+     50-64             0              0
## 66         light       50+     50-64             3            700
## 67         heavy     21-49     35-49             2              2
## 68         heavy     21-49     21-34             5             90
## 69         heavy     21-49     35-49             1           6205
## 70         light     21-49     35-49             2              3
## 71         heavy     21-49     35-49             1              1
## 72         light     21-49     35-49             6            270
## 73         light     21-49     35-49             2             55
## 74         light     21-49     35-49             1           1095
## 75         heavy       50+     50-64             6           3650
## 76         heavy       50+     50-64            10             14
## 77         heavy     21-49     35-49             1           2920
## 78         heavy       50+     50-64             1              8
## 79         heavy       50+     50-64             5           1095
## 80         heavy     21-49     35-49             8            180
## 81         heavy       50+     50-64             4            365
## 82         heavy       50+     50-64             1             90
## 83         heavy     21-49     35-49             3              4
## 84         heavy     21-49     35-49             1           1095
## 85         heavy       50+     50-64             1              5
## 86         heavy     21-49     35-49             1              7
## 87         heavy     21-49     21-34             3              2
## 88         heavy     21-49     21-34             2              3
## 89         light     21-49     21-34             2           2190
## 90         light     21-49     35-49            10           1095
## 91         light     21-49     21-34             0              0
## 92         heavy     21-49     21-34            10            120
## 93         heavy     21-49     35-49             1              3
## 94         heavy       50+     50-64             4           1095
## 95         light     21-49     21-34             8            240
## 96         heavy       50+       65+             6           5475
## 97         heavy     21-49     35-49            20            180
## 98         heavy       50+     50-64             5            270
## 99         heavy       50+     50-64             3           1095
## 100        heavy       50+     50-64             3           3285
## 101        heavy     21-49     21-34             4             90
## 102        heavy       50+       65+             1             90
## 103        heavy     21-49     35-49            12              6
## 104        light       50+     50-64             2             90
## 105        heavy     21-49     35-49          1000            548
## 106        light       50+       65+            30             30
## 107        heavy       50+     50-64             1             60
## 108        heavy       50+     50-64             3             60
## 109        heavy       50+     50-64             2            180
## 110        heavy     21-49     35-49             2              3
## 111        light     21-49     35-49             3            210
## 112        light       50+     50-64             5           1825
## 113        light       50+     50-64             2            365
## 114        light       50+       65+             2              7
## 115        heavy       50+     50-64             5             10
## 116        heavy       50+     50-64             2             30
## 117        light     21-49     35-49             2           1825
## 118        light     21-49     35-49             4            365
## 119        light     21-49     21-34             2              1
## 120        light     21-49     21-34             2             14
## 121        heavy     21-49     35-49             1             75
## 122        heavy     21-49     35-49             1            270
## 123        light     21-49     35-49             3            180
## 124        heavy       50+     50-64             3              7
## 125        heavy       50+     50-64             0              0
```

### `select()`


```r
# grab just these three columns.
pwt_sample %>% select(ttr, grp, gender)
```

```
##     ttr         grp gender
## 1   182   patchOnly   Male
## 2    14   patchOnly   Male
## 3     5 combination Female
## 4    16 combination   Male
## 5     0 combination   Male
## 6   182 combination   Male
## 7    14   patchOnly   Male
## 8    77   patchOnly Female
## 9     2   patchOnly Female
## 10    0   patchOnly   Male
## 11   12   patchOnly Female
## 12  182 combination   Male
## 13   21   patchOnly Female
## 14    3   patchOnly   Male
## 15  170   patchOnly Female
## 16   25   patchOnly   Male
## 17    4   patchOnly Female
## 18  182 combination Female
## 19  140 combination   Male
## 20   63 combination Female
## 21   15 combination Female
## 22  140 combination   Male
## 23  110 combination Female
## 24  182 combination Female
## 25    0   patchOnly   Male
## 26  182 combination Female
## 27   15   patchOnly Female
## 28  182   patchOnly   Male
## 29    4   patchOnly   Male
## 30   56 combination Female
## 31    2 combination   Male
## 32   80   patchOnly Female
## 33  182 combination Female
## 34   56   patchOnly   Male
## 35    0   patchOnly Female
## 36   14   patchOnly Female
## 37   14   patchOnly Female
## 38   28   patchOnly Female
## 39  182   patchOnly   Male
## 40    6   patchOnly   Male
## 41  182   patchOnly   Male
## 42   14   patchOnly Female
## 43   15   patchOnly Female
## 44  182 combination Female
## 45   75 combination Female
## 46   30 combination   Male
## 47    4 combination   Male
## 48   56 combination Female
## 49  182 combination   Male
## 50  182 combination   Male
## 51    5 combination Female
## 52    8 combination   Male
## 53  140 combination   Male
## 54   20 combination Female
## 55   63 combination Female
## 56   30 combination Female
## 57    8 combination   Male
## 58   50 combination   Male
## 59   14 combination Female
## 60    0 combination   Male
## 61   84   patchOnly Female
## 62    0   patchOnly   Male
## 63  105   patchOnly Female
## 64  182 combination Female
## 65  182   patchOnly   Male
## 66  182   patchOnly   Male
## 67    7   patchOnly Female
## 68  182   patchOnly Female
## 69    0   patchOnly Female
## 70    8   patchOnly Female
## 71    1   patchOnly Female
## 72  182 combination Female
## 73   12 combination Female
## 74  182 combination Female
## 75   49   patchOnly Female
## 76  182   patchOnly   Male
## 77  182   patchOnly Female
## 78    2   patchOnly Female
## 79  182   patchOnly   Male
## 80   56   patchOnly Female
## 81  182   patchOnly Female
## 82    0   patchOnly Female
## 83   28   patchOnly   Male
## 84  155   patchOnly Female
## 85    2   patchOnly   Male
## 86    0   patchOnly Female
## 87    0   patchOnly Female
## 88    1   patchOnly Female
## 89  140   patchOnly Female
## 90    1   patchOnly Female
## 91   28   patchOnly Female
## 92    1   patchOnly   Male
## 93  182   patchOnly Female
## 94   77   patchOnly Female
## 95   56   patchOnly Female
## 96  182 combination   Male
## 97  182 combination   Male
## 98  182 combination Female
## 99  182 combination Female
## 100 182 combination   Male
## 101  21 combination Female
## 102  60 combination Female
## 103   0 combination   Male
## 104 182 combination Female
## 105  65 combination Female
## 106 182 combination   Male
## 107 182 combination Female
## 108 182 combination Female
## 109 182 combination Female
## 110   2 combination Female
## 111  40   patchOnly Female
## 112 100   patchOnly Female
## 113   1   patchOnly Female
## 114  45   patchOnly Female
## 115  14   patchOnly Female
## 116  30   patchOnly   Male
## 117  42 combination Female
## 118   2 combination Female
## 119 182 combination Female
## 120  60 combination Female
## 121  10 combination Female
## 122   0 combination Female
## 123 170 combination   Male
## 124  15 combination Female
## 125 182 combination Female
```

### `group_by()`

`group_by()` might be the most powerful function in tidyverse.

- tl;dr: it allows you to perform functions within specific subsets (groups) of the data.


```r
# Notice we can chain some pipes together
pwt_sample %>%
  # group by gender
  group_by(gender) %>%
  # Get me the first observation, by group.
  slice(1)
```

```
## # A tibble: 2 x 14
## # Groups:   gender [2]
##      id   ttr relapse grp           age gender race  employment yearsSmoking
##   <int> <int>   <int> <fct>       <int> <fct>  <fct> <fct>             <int>
## 1    39     5       1 combination    25 Female white other                12
## 2    21   182       0 patchOnly      36 Male   white ft                   26
## # i 5 more variables: levelSmoking <fct>, ageGroup2 <fct>, ageGroup4 <fct>,
## #   priorAttempts <int>, longestNoSmoke <int>
```


### `group_by()`

Notice what would happen in the absence of `group_by()`


```r
pwt_sample %>%
  # Get me the first observation for each gender
  slice(1) #Forgot to group_by()
```

```
##   id ttr relapse       grp age gender  race employment yearsSmoking
## 1 21 182       0 patchOnly  36   Male white         ft           26
##   levelSmoking ageGroup2 ageGroup4 priorAttempts longestNoSmoke
## 1        heavy     21-49     35-49             0              0
```

Caveat: if you're applying a group-specific function (that you need once), it's generally advisable to "ungroup" (i.e. `ungroup()`) the data when you're done.

### `summarize()`

`summarize()` creates condensed summaries of the data, for whatever it is you want.


```r
pwt_sample %>%
    # How many observations are in the data?
    dplyr::summarize(n = n())
```

```
##     n
## 1 125
```

### `summarize()`


```r
# Note: works *wonderfully* with group_by()
pwt_sample %>%
    group_by(gender) %>%
    # Give me the max time to relapse observed in the data.
    dplyr::summarize(maxttr = max(ttr, na.rm=T))
```

```
## # A tibble: 2 x 2
##   gender maxttr
##   <fct>   <int>
## 1 Female    182
## 2 Male      182
```


### `mutate()`

`mutate()` creates new columns while retaining original dimensions of the data (unlike `summarize()`).


```r
pwt_sample %>%
    # Convert rgdpna from real GDP in millions to real GDP in billions
    mutate(ttrmonths = ttr/30)
```

```
##      id ttr relapse         grp age gender     race employment yearsSmoking
## 1    21 182       0   patchOnly  36   Male    white         ft           26
## 2   113  14       1   patchOnly  41   Male    white      other           27
## 3    39   5       1 combination  25 Female    white      other           12
## 4    80  16       1 combination  54   Male    white         ft           39
## 5    87   0       1 combination  45   Male    white      other           30
## 6    29 182       0 combination  43   Male hispanic         ft           30
## 7    16  14       1   patchOnly  66   Male    black         pt           54
## 8    35  77       1   patchOnly  78 Female    black      other           56
## 9    54   2       1   patchOnly  40 Female    black         ft           25
## 10   70   0       1   patchOnly  38   Male    black         ft           23
## 11   84  12       1   patchOnly  64 Female    black      other           30
## 12   85 182       0 combination  51   Male    black         ft           35
## 13   25  21       1   patchOnly  37 Female    white         pt           23
## 14   47   3       1   patchOnly  65   Male    white      other           50
## 15   59 170       1   patchOnly  42 Female    white         ft           30
## 16   63  25       1   patchOnly  40   Male    white      other           22
## 17  102   4       1   patchOnly  65 Female    white      other           50
## 18    3 182       0 combination  52 Female    white      other           19
## 19   15 140       1 combination  43   Male    white         ft           27
## 20   32  63       1 combination  34 Female    white         ft           18
## 21   79  15       1 combination  46 Female    white      other           26
## 22   90 140       1 combination  60   Male    white         ft           42
## 23  110 110       1 combination  49 Female    white      other           35
## 24  127 182       0 combination  58 Female    white         ft           38
## 25  119   0       1   patchOnly  48   Male hispanic      other           33
## 26   33 182       0 combination  54 Female hispanic      other           38
## 27   62  15       1   patchOnly  49 Female    black         pt           35
## 28   67 182       0   patchOnly  55   Male    black         ft           39
## 29  112   4       1   patchOnly  33   Male    black         ft           12
## 30   60  56       1 combination  49 Female    black         ft           37
## 31   93   2       1 combination  46   Male    black         ft           25
## 32  122  80       1   patchOnly  34 Female    other         ft           18
## 33  130 182       0 combination  46 Female    white         pt           25
## 34   19  56       1   patchOnly  52   Male    black      other           25
## 35   65   0       1   patchOnly  52 Female    black         ft           30
## 36    4  14       1   patchOnly  48 Female    white         ft           34
## 37   20  14       1   patchOnly  48 Female    white         ft           39
## 38   22  28       1   patchOnly  56 Female    white         ft           36
## 39   26 182       0   patchOnly  58   Male    white      other           41
## 40   43   6       1   patchOnly  60   Male    white         ft           50
## 41  107 182       0   patchOnly  55   Male    white         ft           40
## 42  111  14       1   patchOnly  43 Female    white         ft           28
## 43  117  15       1   patchOnly  55 Female    white         ft           42
## 44    8 182       0 combination  70 Female    white      other           52
## 45   12  75       1 combination  62 Female    white         pt           46
## 46   13  30       1 combination  86   Male    white      other           40
## 47   23   4       1 combination  52   Male    white         ft           33
## 48   30  56       1 combination  27 Female    white         ft           13
## 49   34 182       0 combination  52   Male    white         ft           35
## 50   36 182       0 combination  62   Male    white         ft           35
## 51   38   5       1 combination  57 Female    white         ft           47
## 52   44   8       1 combination  40   Male    white         ft           27
## 53   61 140       1 combination  49   Male    white      other           14
## 54   68  20       1 combination  68 Female    white      other           53
## 55   69  63       1 combination  47 Female    white         pt           15
## 56   82  30       1 combination  46 Female    white         ft           34
## 57   97   8       1 combination  55   Male    white         pt           40
## 58  106  50       1 combination  29   Male    white         ft           12
## 59  114  14       1 combination  64 Female    white         pt           45
## 60  120   0       1 combination  52   Male    white         ft           38
## 61   40  84       1   patchOnly  38 Female hispanic         ft           10
## 62   49   0       1   patchOnly  35   Male hispanic      other           20
## 63  125 105       1   patchOnly  50 Female hispanic      other           33
## 64  123 182       0 combination  63 Female hispanic      other           45
## 65    7 182       0   patchOnly  58   Male    black         ft           40
## 66    9 182       0   patchOnly  56   Male    black         ft           16
## 67   37   7       1   patchOnly  44 Female    black      other           31
## 68   52 182       0   patchOnly  34 Female    black         ft           20
## 69   86   0       1   patchOnly  49 Female    black         ft           36
## 70   94   8       1   patchOnly  43 Female    black      other           24
## 71  104   1       1   patchOnly  39 Female    black         ft           27
## 72   42 182       0 combination  41 Female    black         ft           20
## 73   75  12       1 combination  46 Female    black      other           30
## 74  100 182       0 combination  46 Female    black         ft           21
## 75    1  49       1   patchOnly  53 Female    white         pt           18
## 76    6 182       0   patchOnly  58   Male    white         ft           46
## 77   11 182       0   patchOnly  40 Female    white         ft           25
## 78   24   2       1   patchOnly  62 Female    white      other           49
## 79   27 182       0   patchOnly  53   Male    white         ft           38
## 80   31  56       1   patchOnly  44 Female    white         ft           35
## 81   56 182       0   patchOnly  64 Female    white      other           47
## 82   72   0       1   patchOnly  50 Female    white         ft           30
## 83   78  28       1   patchOnly  47   Male    white         ft           22
## 84   81 155       1   patchOnly  49 Female    white         pt           35
## 85   83   2       1   patchOnly  51   Male    white      other           36
## 86   88   0       1   patchOnly  41 Female    white      other           26
## 87   91   0       1   patchOnly  22 Female    white         pt           10
## 88   95   1       1   patchOnly  22 Female    white         pt            9
## 89   99 140       1   patchOnly  34 Female    white         ft           18
## 90  101   1       1   patchOnly  48 Female    white         ft           30
## 91  115  28       1   patchOnly  30 Female    white         ft           12
## 92  116   1       1   patchOnly  31   Male    white         ft           19
## 93  124 182       0   patchOnly  44 Female    white         ft           30
## 94  126  77       1   patchOnly  56 Female    white         ft           44
## 95  129  56       1   patchOnly  29 Female    white         ft           10
## 96    2 182       0 combination  69   Male    white      other           50
## 97    5 182       0 combination  41   Male    white         ft           29
## 98   14 182       0 combination  52 Female    white      other           33
## 99   18 182       0 combination  52 Female    white         ft           30
## 100  51 182       0 combination  53   Male    white         ft           30
## 101  57  21       1 combination  31 Female    white         ft           15
## 102  64  60       1 combination  70 Female    white      other           54
## 103  76   0       1 combination  43   Male    white      other           29
## 104  92 182       0 combination  58 Female    white         ft           36
## 105  98  65       1 combination  48 Female    white         ft           34
## 106 103 182       0 combination  72   Male    white      other           55
## 107 105 182       0 combination  61 Female    white      other           45
## 108 121 182       0 combination  53 Female    white         ft           41
## 109  96 182       0 combination  63 Female    other      other           52
## 110  46   2       1 combination  40 Female hispanic         pt           23
## 111  28  40       1   patchOnly  39 Female    black         ft           20
## 112  53 100       1   patchOnly  60 Female    black         ft           20
## 113  55   1       1   patchOnly  54 Female    black      other           34
## 114  73  45       1   patchOnly  68 Female    black         ft           25
## 115  77  14       1   patchOnly  54 Female    black         ft           22
## 116 109  30       1   patchOnly  51   Male    black      other           30
## 117  17  42       1 combination  39 Female    black         ft           23
## 118  45   2       1 combination  47 Female    black         ft           33
## 119  48 182       0 combination  33 Female    black         ft           10
## 120  50  60       1 combination  27 Female    black         ft           11
## 121  74  10       1 combination  45 Female    black         ft           32
## 122  89   0       1 combination  36 Female    black         ft           20
## 123 108 170       1 combination  39   Male    black         ft           20
## 124 118  15       1 combination  56 Female    black      other           39
## 125 128 182       0 combination  50 Female    black         pt           30
##     levelSmoking ageGroup2 ageGroup4 priorAttempts longestNoSmoke  ttrmonths
## 1          heavy     21-49     35-49             0              0 6.06666667
## 2          heavy     21-49     35-49             3             90 0.46666667
## 3          heavy     21-49     21-34             3             21 0.16666667
## 4          heavy       50+     50-64             0              0 0.53333333
## 5          heavy     21-49     35-49             0              0 0.00000000
## 6          heavy     21-49     35-49             2           1825 6.06666667
## 7          heavy       50+       65+             0              0 0.46666667
## 8          light       50+       65+            10             15 2.56666667
## 9          heavy     21-49     35-49             4              7 0.06666667
## 10         light     21-49     35-49            10             90 0.00000000
## 11         heavy       50+     50-64            12            365 0.40000000
## 12         heavy       50+     50-64             1              7 6.06666667
## 13         light     21-49     35-49             5           1095 0.70000000
## 14         heavy       50+       65+             6            180 0.10000000
## 15         heavy     21-49     35-49             5            240 5.66666667
## 16         heavy     21-49     35-49             2              2 0.83333333
## 17         light       50+       65+             1              2 0.13333333
## 18         light       50+     50-64             1              7 6.06666667
## 19         heavy     21-49     35-49             5            120 4.66666667
## 20         heavy     21-49     21-34             8             90 2.10000000
## 21         heavy     21-49     35-49             2             14 0.50000000
## 22         light       50+     50-64             6           2920 4.66666667
## 23         heavy     21-49     35-49            10             60 3.66666667
## 24         heavy       50+     50-64             1              0 6.06666667
## 25         heavy     21-49     35-49             4            120 0.00000000
## 26         light       50+     50-64            30           3650 6.06666667
## 27         light     21-49     35-49             4            540 0.50000000
## 28         heavy       50+     50-64             1             28 6.06666667
## 29         light     21-49     21-34             1            730 0.13333333
## 30         heavy     21-49     35-49             3           2920 1.86666667
## 31         light     21-49     35-49             2           1095 0.06666667
## 32         heavy     21-49     21-34             1            120 2.66666667
## 33         heavy     21-49     35-49             3            365 6.06666667
## 34         light       50+     50-64            10              7 1.86666667
## 35         heavy       50+     50-64             2             42 0.00000000
## 36         heavy     21-49     35-49             6           2555 0.46666667
## 37         heavy     21-49     35-49             1              2 0.46666667
## 38         heavy       50+     50-64             5            180 0.93333333
## 39         light       50+     50-64           100            180 6.06666667
## 40         heavy       50+     50-64             6             30 0.20000000
## 41         heavy       50+     50-64             1            180 6.06666667
## 42         heavy     21-49     35-49             4            365 0.46666667
## 43         heavy       50+     50-64             2             60 0.50000000
## 44         heavy       50+       65+             3              1 6.06666667
## 45         heavy       50+     50-64             8           1095 2.50000000
## 46         light       50+       65+             4           2190 1.00000000
## 47         heavy       50+     50-64             2              2 0.13333333
## 48         light     21-49     21-34             1              7 1.86666667
## 49         heavy       50+     50-64             3            730 6.06666667
## 50         heavy       50+     50-64             1           2555 6.06666667
## 51         heavy       50+     50-64             0              0 0.16666667
## 52         heavy     21-49     35-49             2             90 0.26666667
## 53         heavy     21-49     35-49             0              0 4.66666667
## 54         heavy       50+       65+             0              0 0.66666667
## 55         heavy     21-49     35-49             1             90 2.10000000
## 56         light     21-49     35-49            20             90 1.00000000
## 57         heavy       50+     50-64             6            913 0.26666667
## 58         heavy     21-49     21-34             0              0 1.66666667
## 59         heavy       50+     50-64             4             60 0.46666667
## 60         heavy       50+     50-64             4              7 0.00000000
## 61         heavy     21-49     35-49             2              3 2.80000000
## 62         light     21-49     35-49             2              7 0.00000000
## 63         heavy       50+     50-64             2             30 3.50000000
## 64         heavy       50+     50-64             1             28 6.06666667
## 65         heavy       50+     50-64             0              0 6.06666667
## 66         light       50+     50-64             3            700 6.06666667
## 67         heavy     21-49     35-49             2              2 0.23333333
## 68         heavy     21-49     21-34             5             90 6.06666667
## 69         heavy     21-49     35-49             1           6205 0.00000000
## 70         light     21-49     35-49             2              3 0.26666667
## 71         heavy     21-49     35-49             1              1 0.03333333
## 72         light     21-49     35-49             6            270 6.06666667
## 73         light     21-49     35-49             2             55 0.40000000
## 74         light     21-49     35-49             1           1095 6.06666667
## 75         heavy       50+     50-64             6           3650 1.63333333
## 76         heavy       50+     50-64            10             14 6.06666667
## 77         heavy     21-49     35-49             1           2920 6.06666667
## 78         heavy       50+     50-64             1              8 0.06666667
## 79         heavy       50+     50-64             5           1095 6.06666667
## 80         heavy     21-49     35-49             8            180 1.86666667
## 81         heavy       50+     50-64             4            365 6.06666667
## 82         heavy       50+     50-64             1             90 0.00000000
## 83         heavy     21-49     35-49             3              4 0.93333333
## 84         heavy     21-49     35-49             1           1095 5.16666667
## 85         heavy       50+     50-64             1              5 0.06666667
## 86         heavy     21-49     35-49             1              7 0.00000000
## 87         heavy     21-49     21-34             3              2 0.00000000
## 88         heavy     21-49     21-34             2              3 0.03333333
## 89         light     21-49     21-34             2           2190 4.66666667
## 90         light     21-49     35-49            10           1095 0.03333333
## 91         light     21-49     21-34             0              0 0.93333333
## 92         heavy     21-49     21-34            10            120 0.03333333
## 93         heavy     21-49     35-49             1              3 6.06666667
## 94         heavy       50+     50-64             4           1095 2.56666667
## 95         light     21-49     21-34             8            240 1.86666667
## 96         heavy       50+       65+             6           5475 6.06666667
## 97         heavy     21-49     35-49            20            180 6.06666667
## 98         heavy       50+     50-64             5            270 6.06666667
## 99         heavy       50+     50-64             3           1095 6.06666667
## 100        heavy       50+     50-64             3           3285 6.06666667
## 101        heavy     21-49     21-34             4             90 0.70000000
## 102        heavy       50+       65+             1             90 2.00000000
## 103        heavy     21-49     35-49            12              6 0.00000000
## 104        light       50+     50-64             2             90 6.06666667
## 105        heavy     21-49     35-49          1000            548 2.16666667
## 106        light       50+       65+            30             30 6.06666667
## 107        heavy       50+     50-64             1             60 6.06666667
## 108        heavy       50+     50-64             3             60 6.06666667
## 109        heavy       50+     50-64             2            180 6.06666667
## 110        heavy     21-49     35-49             2              3 0.06666667
## 111        light     21-49     35-49             3            210 1.33333333
## 112        light       50+     50-64             5           1825 3.33333333
## 113        light       50+     50-64             2            365 0.03333333
## 114        light       50+       65+             2              7 1.50000000
## 115        heavy       50+     50-64             5             10 0.46666667
## 116        heavy       50+     50-64             2             30 1.00000000
## 117        light     21-49     35-49             2           1825 1.40000000
## 118        light     21-49     35-49             4            365 0.06666667
## 119        light     21-49     21-34             2              1 6.06666667
## 120        light     21-49     21-34             2             14 2.00000000
## 121        heavy     21-49     35-49             1             75 0.33333333
## 122        heavy     21-49     35-49             1            270 0.00000000
## 123        light     21-49     35-49             3            180 5.66666667
## 124        heavy       50+     50-64             3              7 0.50000000
## 125        heavy       50+     50-64             0              0 6.06666667
```

### `mutate()`

Note: this also works well with `group_by()`


```r
pwt_sample %>%
    group_by(gender) %>%
    # divide ttr over the gender's max, for some reason.
  mutate(ttrprop = ttr/max(ttr, na.rm=T)) |> 
  select(ttrprop) |> 
  head()
```

```
## Adding missing grouping variables: `gender`
```

```
## # A tibble: 6 x 2
## # Groups:   gender [2]
##   gender ttrprop
##   <fct>    <dbl>
## 1 Male    1     
## 2 Male    0.0769
## 3 Female  0.0275
## 4 Male    0.0879
## 5 Male    0     
## 6 Male    1
```


### `filter()`

`filter()` is a great diagnostic tool for subsetting your data to look at specific observations.

- Notice the use of double-equal signs (`==`) for the `filter()` functions.


```r
pwt_sample %>%
  filter(race== "black") |> 
  head()
```

```
##   id ttr relapse         grp age gender  race employment yearsSmoking
## 1 16  14       1   patchOnly  66   Male black         pt           54
## 2 35  77       1   patchOnly  78 Female black      other           56
## 3 54   2       1   patchOnly  40 Female black         ft           25
## 4 70   0       1   patchOnly  38   Male black         ft           23
## 5 84  12       1   patchOnly  64 Female black      other           30
## 6 85 182       0 combination  51   Male black         ft           35
##   levelSmoking ageGroup2 ageGroup4 priorAttempts longestNoSmoke
## 1        heavy       50+       65+             0              0
## 2        light       50+       65+            10             15
## 3        heavy     21-49     35-49             4              7
## 4        light     21-49     35-49            10             90
## 5        heavy       50+     50-64            12            365
## 6        heavy       50+     50-64             1              7
```




### Don't Forget to Assign

When you're done, don't forget to assign what you've done to an object.


```r
pwt_sample %>%
    group_by(gender) %>%
    # divide ttr over the gender's max, for some reason.
  mutate(ttrprop = ttr/max(ttr, na.rm=T)) |> 
  select(ttrprop) |> 
  head() -> NewObjectName
```

```
## Adding missing grouping variables: `gender`
```

tidyverse's greatest feature is the ability to see what you're coding in real time before commiting/overwrting data.
