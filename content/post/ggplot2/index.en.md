---
title: "Visualizing data layer by layer in R"
author: 'Bongani Ncube : statistical analyst'
date: "July 2023"
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



# background

> Visualisation is the process of representing data graphically and interacting with these representations. The objective is to gain insight into the data.

To work with **ggplot2**\index{ggplot2}, remember that at least your R codes must

-   start with `ggplot()`
-   identify which data to plot `data = Your Data`
-   state variables to plot for example `aes(x = Variable on x-axis, y = Variable on y-axis )` for bivariate
-   choose type of graph, for example `geom_histogram()` for histogram, and `geom_points()` for scatterplots\index{Scatterplot}

# setup

+ installing *tidyverse* package which contains *dplyr* and *ggplot2*


```r
library(tidyverse)
loan_data <- read_csv('loan_data_cleaned.csv')
loan_data <- loan_data |>
  mutate(default=ifelse(loan_status==1,"defaulted","not defaulted")) |> 
  mutate_if(is.character,as.factor)
```

# getting started

+ Calling ggplot() along just creates a blank plot

```r
ggplot()
```

<img src="{{< blogdown/postref >}}index.en_files/figure-html/unnamed-chunk-2-1.png" width="1023.999552" />

# next up

+ I need to tell ggplot what data to use

```r
ggplot(data=loan_data)
```

<img src="{{< blogdown/postref >}}index.en_files/figure-html/unnamed-chunk-3-1.png" width="1023.999552" />

# grammar of graphics

+ And then give it some instructions using the grammar of graphics.
+ Let's build a simple scatterplot with annual income on the x-axis and loan amount on the y axis


```r
ggplot(data=loan_data) +
  geom_point(mapping=aes(x=annual_inc, y=loan_amnt))
```

<img src="{{< blogdown/postref >}}index.en_files/figure-html/unnamed-chunk-4-1.png" width="1023.999552" />

# refining...

+ Let's try representing a different dimension.  
+ What if we want to differentiate public vs. private schools?
+ We can do this using the shape attribute


```r
ggplot(data=loan_data) +
  geom_point(mapping=aes(x=annual_inc, y=loan_amnt, shape=default))
```

<img src="{{< blogdown/postref >}}index.en_files/figure-html/unnamed-chunk-5-1.png" width="1023.999552" />

# not neat!!..try color.

+ That's hard to see the difference.  What if we try color instead?

```r
ggplot(data=loan_data) +
  geom_point(mapping=aes(x=annual_inc, y=loan_amnt, color=default))
```

<img src="{{< blogdown/postref >}}index.en_files/figure-html/unnamed-chunk-6-1.png" width="1023.999552" />

# try size!

+ I can also alter point size.  Let's do that to represent grade

```r
ggplot(data=loan_data) +
  geom_point(mapping=aes(x=annual_inc, y=loan_amnt, color=default, size=grade))
```

<img src="{{< blogdown/postref >}}index.en_files/figure-html/unnamed-chunk-7-1.png" width="1023.999552" />

# transparency

+ And, lastly, let's add some transparency so we can see through those points a bit
+ Experiment with the alpha value a bit.


```r
ggplot(data=loan_data) +
  geom_point(mapping=aes(x=annual_inc, y=loan_amnt, color=default, size=grade), alpha=1)
```

<img src="{{< blogdown/postref >}}index.en_files/figure-html/unnamed-chunk-8-1.png" width="1023.999552" />

# very transparent


```r
ggplot(data=loan_data) +
  geom_point(mapping=aes(x=annual_inc, y=loan_amnt, color=default, size=grade), alpha=1/100)
```

<img src="{{< blogdown/postref >}}index.en_files/figure-html/unnamed-chunk-9-1.png" width="1023.999552" />

# How many people defaulted?


```r
# This calls for a bar graph!
ggplot(data=loan_data) +
  geom_bar(mapping=aes(x=default))
```

<img src="{{< blogdown/postref >}}index.en_files/figure-html/unnamed-chunk-10-1.png" width="1023.999552" />

# Break it out by grade


```r
ggplot(data=loan_data) +
  geom_bar(mapping=aes(x=default, color=grade))
```

<img src="{{< blogdown/postref >}}index.en_files/figure-html/unnamed-chunk-11-1.png" width="1023.999552" />

# Well, that's unsatisfying!  Try fill instead of color


```r
ggplot(data=loan_data) +
  geom_bar(mapping=aes(x=default, fill=grade))
```

<img src="{{< blogdown/postref >}}index.en_files/figure-html/unnamed-chunk-12-1.png" width="1023.999552" />

# How about loan amount by default status?

+ First, I'll use some dplyr to create the right tibble

```r
loan_data %>%
  group_by(default) %>%
  summarize(average_amount=mean(loan_amnt))
#> # A tibble: 2 x 2
#>   default       average_amount
#>   <fct>                  <dbl>
#> 1 defaulted              9389.
#> 2 not defaulted          9619.
```

# And I can pipe that straight into ggplot

+ but this will produce an error


```r
loan_data %>%
  group_by(default) %>%
  summarize(average_amount=mean(loan_amnt)) %>%
  ggplot() +
  geom_bar(mapping=aes(x=default, y=average_amount))
```

# use geom_col() instead

+ But I need to use a column graph instead of a bar graph to specify my own y


```r
loan_data %>%
  group_by(default) %>%
  summarize(average_amount=mean(loan_amnt)) %>%
  ggplot() +
  geom_col(mapping=aes(x=default, y=average_amount))
```

<img src="{{< blogdown/postref >}}index.en_files/figure-html/unnamed-chunk-15-1.png" width="1023.999552" />

# Histograms

+ Let's look at annual income
+ Histograms can help us by binning results


```r
ggplot(data=loan_data) +
  geom_histogram(mapping=aes(x=annual_inc), origin=0)
```

<img src="{{< blogdown/postref >}}index.en_files/figure-html/unnamed-chunk-16-1.png" width="1023.999552" />

# What if we want fewer groups? Let's ask for 4 bins


```r
ggplot(data=loan_data) +
  geom_histogram(mapping=aes(x=annual_inc), bins=4, origin=0)
```

<img src="{{< blogdown/postref >}}index.en_files/figure-html/unnamed-chunk-17-1.png" width="1023.999552" />

# Or 10 bins.


```r
ggplot(data=loan_data) +
  geom_histogram(mapping=aes(x=annual_inc), bins=10, origin=0)
```

<img src="{{< blogdown/postref >}}index.en_files/figure-html/unnamed-chunk-18-1.png" width="1023.999552" />

# Or we can specify the width of the bins instead


```r
ggplot(data=loan_data) +
  geom_histogram(mapping=aes(x=annual_inc), binwidth=1000, origin=0)
```

<img src="{{< blogdown/postref >}}index.en_files/figure-html/unnamed-chunk-19-1.png" width="1023.999552" />

# large binwidth


```r
ggplot(data=loan_data) +
  geom_histogram(mapping=aes(x=annual_inc), binwidth=10000, origin=0)
```

<img src="{{< blogdown/postref >}}index.en_files/figure-html/unnamed-chunk-20-1.png" width="1023.999552" />

# changing background

## Change the plot background color

```r
ggplot(data=loan_data) +
  geom_bar(mapping=aes(x=loan_status, fill=home_ownership)) +
  theme(plot.background=element_rect(fill='purple'))
```

<img src="{{< blogdown/postref >}}index.en_files/figure-html/unnamed-chunk-21-1.png" width="1023.999552" />

# Change the panel background color


```r
ggplot(data=loan_data) +
  geom_bar(mapping=aes(x=loan_status, fill=home_ownership)) +
  theme(panel.background=element_rect(fill='purple'))
```

<img src="{{< blogdown/postref >}}index.en_files/figure-html/unnamed-chunk-22-1.png" width="1023.999552" />

# Let's be minimalist and make both backgrounds disappear

```r
ggplot(data=loan_data) +
  geom_bar(mapping=aes(x=loan_status, fill=home_ownership)) +
  theme(panel.background=element_blank()) +
  theme(plot.background=element_blank())
```

<img src="{{< blogdown/postref >}}index.en_files/figure-html/unnamed-chunk-23-1.png" width="1023.999552" />

# Add grey gridlines

```r
ggplot(data=loan_data) +
  geom_bar(mapping=aes(x=loan_status, fill=home_ownership)) +
  theme(panel.background=element_blank()) +
  theme(plot.background=element_blank()) +
  theme(panel.grid.major=element_line(color="grey"))
```

<img src="{{< blogdown/postref >}}index.en_files/figure-html/unnamed-chunk-24-1.png" width="1023.999552" />

# Only show the y-axis gridlines

```r
ggplot(data=loan_data) +
  geom_bar(mapping=aes(x=loan_status, fill=home_ownership)) +
  theme(panel.background=element_blank()) +
  theme(plot.background=element_blank()) +
  theme(panel.grid.major.y=element_line(color="grey"))+
  scale_fill_manual(values=c("orange","blue","green","blue4"))
```

<img src="{{< blogdown/postref >}}index.en_files/figure-html/unnamed-chunk-25-1.png" width="864" />

```r
library(ggthemes)
ggplot(data=loan_data) +
  geom_bar(mapping=aes(x=loan_status, fill=home_ownership)) +
  theme(panel.background=element_blank()) +
  theme(plot.background=element_blank()) +
  theme(panel.grid.major.y=element_line(color="grey"))+
  scale_fill_manual(values=c("orange","blue","green","blue4"))+
  theme_solarized()+
  theme_wsj()
```

<img src="{{< blogdown/postref >}}index.en_files/figure-html/unnamed-chunk-26-1.png" width="1023.999552" />


```r
ggplot(data=loan_data, aes(x = loan_status)) + 
  geom_bar(fill = "chartreuse") + 
  theme(axis.text.x = element_text(angle = 90))
```

<img src="{{< blogdown/postref >}}index.en_files/figure-html/unnamed-chunk-27-1.png" width="1023.999552" />

