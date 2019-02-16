---
layout: post
title: Survey Analysis in R with the Likert and NPS Packages
date: 2017-11-25
comments: true
categories: 
  - rstats
  - visualization
summary: Using the Likert and NPS packages to visualize survey data
always_allow_html: yes
output:
  md_document:
    variant: markdown_github
    preserve_yaml: true
---

**Navigate:**  [ [background](#background) ] &#124; [ [survey data](#data) ] &#124; [ [analysis](#analysis) ] &#124; [ 
[satisfaction analysis](#sat) ] &#124; [ [recommendation analysis](#rec) ] &#124; [ [summary](#summary) ] <br /> [ [Rmd source for this post](https://github.com/scumdogsteev/scumdogsteev.github.io/blob/master/_source/_posts_Rmd/2017-11-25-survey-analysis.Rmd) ]

---

<a name="background"></a>
-[ **background** ]-

Recently, I did a survey analysis as part of my board service for [Young Guns](http://www.ttuyoungguns.com/).  I 
wanted to end up with something along the lines of the picture 
[here](https://www.tableau.com/solutions/survey-analysis).  In case it might help someone else, here's how I 
approximated this in R.  Thankfully, there are some great packages that facilitated this 
([likert](http://jason.bryer.org/likert/) and [NPS](https://CRAN.R-project.org/package=NPS)). 

This post:

* does not cover how to create or deliver a survey 
    - [Google Forms](https://www.google.com/forms/about/) and [SurveyMonkey](https://www.surveymonkey.com/) offer
      free platforms that allow for survey setup/delivery within minutes
        - [this 
          guide](https://www.techrepublic.com/blog/google-in-the-enterprise/use-google-forms-to-create-a-survey/) can 
          get you started with a Google Forms survey
    - both output to formats that are straightforward to import into R  
* provides a simple example that might help you along
* is not a comprehensive guide
* assumes you're working with numeric (ordinal) survey data and *does not cover text mining or sentiment analysis*
* quite possibly includes code that could be optimized 
    - if you have suggestions for optimizing the code, please [leave a comment](#comments) and let me know so I can 
      update the post

<a name="data"></a>
-[ **survey data** ]-

First, you'll need survey data.  I assume that if you're planning to analyze a survey, you've already conducted 
one. I also assume that you know how to import data into R. (If not, [this is a good resource](https://www.r-bloggers.com/importing-data-to-r/).)

Here's an example survey of 10 questions (5 related to satisfaction and 5 measuring likelihood to recommend) for 
various aspects of XYZ Corp's business.  All questions are on an 11-point 
[Likert scale](https://en.wikipedia.org/wiki/Likert_scale) where 0 is the worst response and 10 is the best.

1. Satisfaction Question #1
2. Satisfaction Question #2
3. Satisfaction Question #3
4. Satisfaction Question #4
5. Satisfaction Question #5
6. Recommendation Question #1
7. Recommendation Question #2
8. Recommendation Question #3
9. Recommendation Question #4
10. Recommendation Question #5

For the purposes of this post, I'm assuming your survey results have already been imported into an R data frame.  

In this example, I've randomly generated 1,000 survey responses to each of the above 10 questions using the
[mlsjunkgen package](http://s.mylesandmyles.info/mlsjunkgen/) (I may be biased in my choice of RNG).
I have arbitrarily chosen 1, 9, 2, and 3 as the seeds:


```r
require(mlsjunkgen)
survey_data <- as.data.frame(mlsjunkgenm(1000, 10, 1, 9, 2, 3, 1) * 10)
```

Here are the first few responses:

<table class="table table-striped table-hover table-condensed table-responsive" style="width: auto !important; margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:right;"> V1 </th>
   <th style="text-align:right;"> V2 </th>
   <th style="text-align:right;"> V3 </th>
   <th style="text-align:right;"> V4 </th>
   <th style="text-align:right;"> V5 </th>
   <th style="text-align:right;"> V6 </th>
   <th style="text-align:right;"> V7 </th>
   <th style="text-align:right;"> V8 </th>
   <th style="text-align:right;"> V9 </th>
   <th style="text-align:right;"> V10 </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:right;"> 8 </td>
   <td style="text-align:right;"> 6 </td>
   <td style="text-align:right;"> 7 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 10 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 7 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 7 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 8 </td>
   <td style="text-align:right;"> 6 </td>
   <td style="text-align:right;"> 6 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 1 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 8 </td>
   <td style="text-align:right;"> 5 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 5 </td>
   <td style="text-align:right;"> 9 </td>
   <td style="text-align:right;"> 6 </td>
   <td style="text-align:right;"> 7 </td>
   <td style="text-align:right;"> 7 </td>
   <td style="text-align:right;"> 1 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 3 </td>
   <td style="text-align:right;"> 8 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 8 </td>
   <td style="text-align:right;"> 6 </td>
   <td style="text-align:right;"> 8 </td>
   <td style="text-align:right;"> 7 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 4 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 3 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 5 </td>
   <td style="text-align:right;"> 3 </td>
   <td style="text-align:right;"> 5 </td>
   <td style="text-align:right;"> 8 </td>
   <td style="text-align:right;"> 7 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 9 </td>
   <td style="text-align:right;"> 5 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 3 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 8 </td>
   <td style="text-align:right;"> 9 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 10 </td>
   <td style="text-align:right;"> 7 </td>
   <td style="text-align:right;"> 5 </td>
  </tr>
</tbody>
</table>

Of course, this assumes that all respondents answered all questions.  [That is fairly 
unlikely](https://www.surveymonkey.com/curiosity/survey_completion_times/), so I've randomly replaced an arbitrary
7.5% of responses with NAs based on [this stackoverflow
response](https://stackoverflow.com/questions/27454265/r-randomly-insert-nas-into-dataframe-proportionaly).


```r
survey_data <- as.data.frame(lapply(survey_data, function(cc) cc[ sample(c(TRUE, NA), prob = c(0.925, 0.075), 
                                                                         size = length(cc), replace = TRUE) ]))
```

Here are the first few responses again:
<table class="table table-striped table-hover table-condensed table-responsive" style="width: auto !important; margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:right;"> V1 </th>
   <th style="text-align:right;"> V2 </th>
   <th style="text-align:right;"> V3 </th>
   <th style="text-align:right;"> V4 </th>
   <th style="text-align:right;"> V5 </th>
   <th style="text-align:right;"> V6 </th>
   <th style="text-align:right;"> V7 </th>
   <th style="text-align:right;"> V8 </th>
   <th style="text-align:right;"> V9 </th>
   <th style="text-align:right;"> V10 </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:right;"> 8 </td>
   <td style="text-align:right;"> 6 </td>
   <td style="text-align:right;"> 7 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 10 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 7 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 7 </td>
   <td style="text-align:right;"> NA </td>
   <td style="text-align:right;"> 8 </td>
   <td style="text-align:right;"> 6 </td>
   <td style="text-align:right;"> 6 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 1 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 8 </td>
   <td style="text-align:right;"> 5 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 5 </td>
   <td style="text-align:right;"> 9 </td>
   <td style="text-align:right;"> 6 </td>
   <td style="text-align:right;"> 7 </td>
   <td style="text-align:right;"> 7 </td>
   <td style="text-align:right;"> 1 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 3 </td>
   <td style="text-align:right;"> 8 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 8 </td>
   <td style="text-align:right;"> 6 </td>
   <td style="text-align:right;"> 8 </td>
   <td style="text-align:right;"> 7 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 4 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 3 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 5 </td>
   <td style="text-align:right;"> 3 </td>
   <td style="text-align:right;"> 5 </td>
   <td style="text-align:right;"> 8 </td>
   <td style="text-align:right;"> 7 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 9 </td>
   <td style="text-align:right;"> 5 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 3 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 8 </td>
   <td style="text-align:right;"> 9 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 10 </td>
   <td style="text-align:right;"> 7 </td>
   <td style="text-align:right;"> 5 </td>
  </tr>
</tbody>
</table>

Now, I've given the columns descriptive names:


```r
names(survey_data) <- c("Satisfaction Q1", "Satisfaction Q2", "Satisfaction Q3", "Satisfaction Q4", "Satisfaction Q5",
               "Recommendation Q1", "Recommendation Q2", "Recommendation Q3", "Recommendation Q4", "Recommendation Q5")
```
<table class="table table-striped table-hover table-condensed table-responsive" style="width: auto !important; margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:right;"> Satisfaction Q1 </th>
   <th style="text-align:right;"> Satisfaction Q2 </th>
   <th style="text-align:right;"> Satisfaction Q3 </th>
   <th style="text-align:right;"> Satisfaction Q4 </th>
   <th style="text-align:right;"> Satisfaction Q5 </th>
   <th style="text-align:right;"> Recommendation Q1 </th>
   <th style="text-align:right;"> Recommendation Q2 </th>
   <th style="text-align:right;"> Recommendation Q3 </th>
   <th style="text-align:right;"> Recommendation Q4 </th>
   <th style="text-align:right;"> Recommendation Q5 </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:right;"> 8 </td>
   <td style="text-align:right;"> 6 </td>
   <td style="text-align:right;"> 7 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 10 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 7 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 7 </td>
   <td style="text-align:right;"> NA </td>
   <td style="text-align:right;"> 8 </td>
   <td style="text-align:right;"> 6 </td>
   <td style="text-align:right;"> 6 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 1 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 8 </td>
   <td style="text-align:right;"> 5 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 5 </td>
   <td style="text-align:right;"> 9 </td>
   <td style="text-align:right;"> 6 </td>
   <td style="text-align:right;"> 7 </td>
   <td style="text-align:right;"> 7 </td>
   <td style="text-align:right;"> 1 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 3 </td>
   <td style="text-align:right;"> 8 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 8 </td>
   <td style="text-align:right;"> 6 </td>
   <td style="text-align:right;"> 8 </td>
   <td style="text-align:right;"> 7 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 4 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 3 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 5 </td>
   <td style="text-align:right;"> 3 </td>
   <td style="text-align:right;"> 5 </td>
   <td style="text-align:right;"> 8 </td>
   <td style="text-align:right;"> 7 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 9 </td>
   <td style="text-align:right;"> 5 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 3 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 8 </td>
   <td style="text-align:right;"> 9 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 10 </td>
   <td style="text-align:right;"> 7 </td>
   <td style="text-align:right;"> 5 </td>
  </tr>
</tbody>
</table>

This now looks more like real survey data.

<a name="analysis"></a>
-[ **analysis** ]-

Now that I have data, I can begin the analysis.

First, I've determined the number of responses and the average score for each question:


```r
## calculate number of responses
num_responses <- sapply(survey_data, function(x) sum(!is.na(x)))

## calculate the avg. of non-na rows for each question
avg <- colMeans(survey_data, na.rm = TRUE)
```

Here is a summary so far:

<table class="table table-striped table-hover table-condensed table-responsive" style="width: auto !important; margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:left;">   </th>
   <th style="text-align:left;"> Satisfaction Q1 </th>
   <th style="text-align:left;"> Satisfaction Q2 </th>
   <th style="text-align:left;"> Satisfaction Q3 </th>
   <th style="text-align:left;"> Satisfaction Q4 </th>
   <th style="text-align:left;"> Satisfaction Q5 </th>
   <th style="text-align:left;"> Recommendation Q1 </th>
   <th style="text-align:left;"> Recommendation Q2 </th>
   <th style="text-align:left;"> Recommendation Q3 </th>
   <th style="text-align:left;"> Recommendation Q4 </th>
   <th style="text-align:left;"> Recommendation Q5 </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Number of Responses </td>
   <td style="text-align:left;"> 934 </td>
   <td style="text-align:left;"> 938 </td>
   <td style="text-align:left;"> 928 </td>
   <td style="text-align:left;"> 923 </td>
   <td style="text-align:left;"> 924 </td>
   <td style="text-align:left;"> 935 </td>
   <td style="text-align:left;"> 925 </td>
   <td style="text-align:left;"> 925 </td>
   <td style="text-align:left;"> 923 </td>
   <td style="text-align:left;"> 925 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Average Response </td>
   <td style="text-align:left;"> 5.14 </td>
   <td style="text-align:left;"> 4.83 </td>
   <td style="text-align:left;"> 5.06 </td>
   <td style="text-align:left;"> 5.06 </td>
   <td style="text-align:left;"> 4.78 </td>
   <td style="text-align:left;"> 5.01 </td>
   <td style="text-align:left;"> 4.99 </td>
   <td style="text-align:left;"> 5.04 </td>
   <td style="text-align:left;"> 5.02 </td>
   <td style="text-align:left;"> 4.98 </td>
  </tr>
</tbody>
</table>

All questions' averages are around 5.  That doesn't look good for XYZ Corp. (Given that the data was randomly 
generated, though, it makes sense.)

<a name="sat"></a>
-[ **satisfaction analysis** ]-

I've now separated the satisfaction questions into their own data frame for simplicity.  I'll come back to the 
recommendation questions later.

To keep this simple, here are the assumed ranges for the satisfaction questions:

* 9-10 = Satisfied (SAT)
* 5-8 = Neutral
* 0-4 = Dissatisfied (DSAT)

Using these criteria, I've determined the percentage of customers who are satisfied, dissatisfied, etc.


```r
## separate satisfaction questions
sat_num <- survey_data[,1:5]

## calculate percentage sAT
per_sat <- sapply(sat_num, function(x) sum(x[!is.na(x)] >= 9)) / num_responses[1:5]

## calculate percentage neutral
neutral <- sapply(sat_num, function(x) sum(x[!is.na(x)] < 9 & x[!is.na(x)] > 4 )) / num_responses[1:5]

## calculate percentage DSAT
dsat <- sapply(sat_num, function(x) sum(x[!is.na(x)] <= 4)) / num_responses[1:5]

## format percentages
percent <- function(x, digits = 2, format = "f", ...) {
  paste0(formatC(100 * x, format = format, digits = digits, ...), "%")
}

## combine results
sat_results <- as.data.frame(rbind(num_responses[1:5], sprintf("%.2f", round(avg[1:5], 1)), percent(per_sat), 
                                   percent(neutral), percent(dsat)))
names(sat_results) <- names(sat_num)
row.names(sat_results) <- c("n", "Avg. Satisfaction", "SAT %", "Neutral %", "DSAT %")
```

This table tells the story:  XYZ Corp. has a problem with customer satisfaction.

<table class="table table-striped table-hover table-condensed table-responsive" style="width: auto !important; margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:left;">   </th>
   <th style="text-align:left;"> Satisfaction Q1 </th>
   <th style="text-align:left;"> Satisfaction Q2 </th>
   <th style="text-align:left;"> Satisfaction Q3 </th>
   <th style="text-align:left;"> Satisfaction Q4 </th>
   <th style="text-align:left;"> Satisfaction Q5 </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> n </td>
   <td style="text-align:left;"> 934 </td>
   <td style="text-align:left;"> 938 </td>
   <td style="text-align:left;"> 928 </td>
   <td style="text-align:left;"> 923 </td>
   <td style="text-align:left;"> 924 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Avg. Satisfaction </td>
   <td style="text-align:left;"> 5.10 </td>
   <td style="text-align:left;"> 4.80 </td>
   <td style="text-align:left;"> 5.10 </td>
   <td style="text-align:left;"> 5.10 </td>
   <td style="text-align:left;"> 4.80 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> SAT % </td>
   <td style="text-align:left;"> 16.06% </td>
   <td style="text-align:left;"> 15.57% </td>
   <td style="text-align:left;"> 13.90% </td>
   <td style="text-align:left;"> 13.76% </td>
   <td style="text-align:left;"> 14.72% </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Neutral % </td>
   <td style="text-align:left;"> 41.11% </td>
   <td style="text-align:left;"> 35.93% </td>
   <td style="text-align:left;"> 42.03% </td>
   <td style="text-align:left;"> 41.39% </td>
   <td style="text-align:left;"> 36.90% </td>
  </tr>
  <tr>
   <td style="text-align:left;"> DSAT % </td>
   <td style="text-align:left;"> 42.83% </td>
   <td style="text-align:left;"> 48.51% </td>
   <td style="text-align:left;"> 44.07% </td>
   <td style="text-align:left;"> 44.85% </td>
   <td style="text-align:left;"> 48.38% </td>
  </tr>
</tbody>
</table>

I'd like to see something more visual, though.  That is where the [likert package](http://jason.bryer.org/likert/) is 
useful.  It removes the need to go through many of the steps above (calculating SAT %, DSAT %, etc.).  It 
also provides a lot of options for visualization that are beyond the scope of what I'm trying to do here.

[likert](http://jason.bryer.org/likert/) requires a character data frame, so I've created one and
filled it with "SAT," "Neutral," and "DSAT" based on the above definitions.


```r
## satisfaction classification function
sat_type <- function(elem) {
  if (is.numeric(elem)) { 
    ifelse(elem >= 9, "SAT", ifelse(elem <= 4, "DSAT", "Neutral"))
  } 
  else { stop("Invalid input.  Please ensure numeric input.") }
}

## apply satisfaction type to sat_num
sat <- as.data.frame(lapply(sat_num, sat_type), check.names = FALSE)
```

To plot this data, I've created a likert data element.  I've also added the number of responses to each question, so
the plot will contain all relevant data:


```r
## add number of responses to the names of the sat data frame so they will appear on the plot
names(sat) <- lapply(seq_along(sat), function(x) paste0(names(survey_data[x]), " (n = ", num_responses[x], ")"))

## load the likert package
require(likert)

## create a likert data element
sat_likert <- likert(sat, nlevels = 3)

## plot sat_likert
plot(sat_likert)
```

{::nomarkdown}<img src="https://s.mylesandmyles.info/img/2017-11-25-survey-analysis/plot-satisfaction-1.png" class="img-responsive" title="plot of chunk plot-satisfaction" alt="plot of chunk plot-satisfaction" style="display: block; margin: auto;" />{:/}

That's a good start, but there are a few things I would like to change:

1. The questions are not displayed in their original order
2. The scale is -100% to 100%; 0% to 100% makes sense for satisfaction
3. XYZ Corp. wants to see red/yellow/green for DSAT/Neutral/SAT

These can be addressed easily:

1. Add `group.order = names(sat)` to the plot call
2. Add `centered = FALSE` to the plot call
3. Define `low.color`, `neutral.color`, and `high.color` as desired.


```r
## plot sat_likert with questions in original order, changing colors to red/yellow/green and making the range
## 0%-100%
plot(sat_likert, group.order = names(sat), centered = FALSE, low.color = "red", neutral.color = "yellow", 
     high.color = "green")  
```

{::nomarkdown}<img src="https://s.mylesandmyles.info/img/2017-11-25-survey-analysis/plot-satisfaction-2-1.png" class="img-responsive" title="plot of chunk plot-satisfaction-2" alt="plot of chunk plot-satisfaction-2" style="display: block; margin: auto;" />{:/}

That's much closer to the desired plot.  Average satisfaction is still missing, though.  The easiest way I've 
found to add that is annotation. (The likert package extends the functionality of [ggplot2](http://ggplot2.org/), so 
its features are available.)  I've already calculated average satisfaction, so annotating the plot with it is
straightforward.


```r
## create avg. satisfaction labels
avg_sat_label <- paste0("Avg. Satisfaction = ", sprintf("%.2f", round(avg[1:5], 1)))

## plot sat_likert, adding avg. satisfaction labels 
plot(sat_likert, group.order = names(sat), centered = FALSE, low.color = "red", neutral.color = "yellow", 
     high.color = "green") + 
  annotate("text", x = 5, y = 50, label = avg_sat_label[1], size = 4, alpha = 0.75) + 
  annotate("text", x = 4, y = 50, label = avg_sat_label[2], size = 4, alpha = 0.75) + 
  annotate("text", x = 3, y = 50, label = avg_sat_label[3], size = 4, alpha = 0.75) + 
  annotate("text", x = 2, y = 50, label = avg_sat_label[4], size = 4, alpha = 0.75) +
  annotate("text", x = 1, y = 50, label = avg_sat_label[5], size = 4, alpha = 0.75)
```

{::nomarkdown}<img src="https://s.mylesandmyles.info/img/2017-11-25-survey-analysis/plot-satisfaction-3-1.png" class="img-responsive" title="plot of chunk plot-satisfaction-3" alt="plot of chunk plot-satisfaction-3" style="display: block; margin: auto;" />{:/}

(Note that the x positions of the labels were determined through trial and error and that `y = 50` is the 
*horizontal* center of the plot; if this were a -100% to 100% plot, `y = 0` would center the annotation.)

This is very close to the desired plot.  The labels could stand out a little more, though, so I've added white
boxes around them.  I've also added a centered title to the plot so XYZ Corp.'s management knows exactly
what they are seeing at a glance. 


```r
## plot sat_likert, adding boxes around avg. satisfaction labels
plot(sat_likert, group.order = names(sat), centered = FALSE, low.color = "red", neutral.color = "yellow", 
     high.color = "green") + 
  geom_rect(aes(xmin = 4.90, xmax = 5.07, ymin = 40, ymax = 60), fill = "#FFFFFF") +
  annotate("text", x = 5, y = 50, label = avg_sat_label[1], size = 4, alpha = 0.75) + 
  geom_rect(aes(xmin = 3.90, xmax = 4.07, ymin = 40, ymax = 60), fill = "#FFFFFF") +
  annotate("text", x = 4, y = 50, label = avg_sat_label[2], size = 4, alpha = 0.75) + 
  geom_rect(aes(xmin = 2.90, xmax = 3.07, ymin = 40, ymax = 60), fill = "#FFFFFF") +
  annotate("text", x = 3, y = 50, label = avg_sat_label[3], size = 4, alpha = 0.75) + 
  geom_rect(aes(xmin = 1.90, xmax = 2.07, ymin = 40, ymax = 60), fill = "#FFFFFF") +
  annotate("text", x = 2, y = 50, label = avg_sat_label[4], size = 4, alpha = 0.75) +
  geom_rect(aes(xmin = 0.90, xmax = 1.07, ymin = 40, ymax = 60), fill = "#FFFFFF") +
  annotate("text", x = 1, y = 50, label = avg_sat_label[5], size = 4, alpha = 0.75) +
  theme(plot.title = element_text(hjust = 0.5)) + ggtitle("Satisfaction with XYZ")
```

{::nomarkdown}<img src="https://s.mylesandmyles.info/img/2017-11-25-survey-analysis/plot-satisfaction-4-1.png" class="img-responsive" title="plot of chunk plot-satisfaction-4" alt="plot of chunk plot-satisfaction-4" style="display: block; margin: auto;" />{:/}
(Again, the size and positions of the boxes were determined through trial and error.)

This looks almost like the desired plot, but I want to see whether the "avg. satisfaction" boxes would look
better at their relative positions on the horizontal axis.


```r
## calculate avg * 10 for positioning as the plot's scale is 0-100 and avg's scale is 0-10
avg10 <- avg * 10

## plot sat_likert, moving avg. satisfaction boxes to their relative positions
plot(sat_likert, group.order = names(sat), centered = FALSE, low.color = "red", neutral.color = "yellow", 
     high.color = "green") + 
  geom_rect(aes(xmin = 4.90, xmax = 5.07, ymin = avg10[1] - 10, ymax = avg10[1] + 10), fill = "#FFFFFF") +
  annotate("text", x = 5, y = avg10[1], label = avg_sat_label[1], size = 4, alpha = 0.75) + 
  geom_rect(aes(xmin = 3.90, xmax = 4.07, ymin = avg10[2] - 10, ymax = avg10[2] + 10), fill = "#FFFFFF") +
  annotate("text", x = 4, y = avg10[2], label = avg_sat_label[2], size = 4, alpha = 0.75) + 
  geom_rect(aes(xmin = 2.90, xmax = 3.07, ymin = avg10[3] - 10, ymax = avg10[3] + 10), fill = "#FFFFFF") +
  annotate("text", x = 3, y = avg10[3], label = avg_sat_label[3], size = 4, alpha = 0.75) + 
  geom_rect(aes(xmin = 1.90, xmax = 2.07, ymin = avg10[4] - 10, ymax = avg10[4] + 10), fill = "#FFFFFF") +
  annotate("text", x = 2, y = avg10[4], label = avg_sat_label[4], size = 4, alpha = 0.75) +
  geom_rect(aes(xmin = 0.90, xmax = 1.07, ymin = avg10[5] - 10, ymax = avg10[5] + 10), fill = "#FFFFFF") +
  annotate("text", x = 1, y = avg10[5], label = avg_sat_label[5], size = 4, alpha = 0.75) +
  theme(plot.title = element_text(hjust = 0.5)) + ggtitle("Satisfaction with XYZ")
```

{::nomarkdown}<img src="https://s.mylesandmyles.info/img/2017-11-25-survey-analysis/plot-satisfaction-5-1.png" class="img-responsive" title="plot of chunk plot-satisfaction-5" alt="plot of chunk plot-satisfaction-5" style="display: block; margin: auto;" />{:/}

While this is closer to the desired plot, I'm undecided as to  whether this looks better than the plot above.  If the 
data were real and not randomly generated (and thus less likely to all be centered around 5), there might be more 
differentiation in the placement of the labels and this might look better.

<a name="rec"></a>
-[ **recommendation analysis** ]-

I underwent basically the same process for the recommendation questions.  For those, I've used the standard criteria 
for calculating [Net Promoter Score](http://www.medallia.com/net-promoter-score/) (NPS):

* 9-10 = promoters
* 7-8 = passives
* 0-6 = detractors

If one is just looking for NPS (% Promoters - % Detractors), the [NPS](https://CRAN.R-project.org/package=NPS) 
package facilitates this, as it calculates NPS without the interim step of calculating % promoters and % 
detractors.

Apparently, [there is some debate](http://businessoverbroadway.com/the-best-likelihood-to-recommend-metric) about 
whether the average score or NPS is a better indicator of customers' likelihood to recommend a brand.  As such, 
I've included both here.


```r
## require NPS package and calculate NPS
require(NPS)
rec_num <- as.data.frame(survey_data[,6:10])
rec_nps <- sapply(rec_num, function(x) nps(x[!is.na(x)]))
```

Here are the outputs of the `nps` function from the [NPS](https://CRAN.R-project.org/package=NPS) 
package for XYZ's recommendation questions:

<table class="table table-striped table-hover table-condensed table-responsive" style="width: auto !important; margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:left;">   </th>
   <th style="text-align:right;"> x </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Recommendation Q1 </td>
   <td style="text-align:right;"> -0.5283422 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Recommendation Q2 </td>
   <td style="text-align:right;"> -0.4800000 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Recommendation Q3 </td>
   <td style="text-align:right;"> -0.4886486 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Recommendation Q4 </td>
   <td style="text-align:right;"> -0.4897075 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Recommendation Q5 </td>
   <td style="text-align:right;"> -0.4951351 </td>
  </tr>
</tbody>
</table>

Since NPS is measured on a scale of -100 to +100, I've multiplied by 100.  I've also calculated % promoters, % 
passives, and % detractors and put everything into a table, similar to the satisfaction table above because if
there's one thing that XYZ Corp.'s management values, it's uniformity.


```r
## multiply NPS * 100
rec_nps <- sapply(rec_num, function(x) nps(x[!is.na(x)])) * 100

## calculate percentage promoters
promoters <- sapply(rec_num, function(x) sum(x[!is.na(x)] >= 9)) / num_responses[6:10]

## calculate percentage passives
passives <- sapply(rec_num, function(x) sum(x[!is.na(x)] < 9 & x[!is.na(x)] > 6 )) / num_responses[6:10]

## calculate percentage promoters
detractors <- sapply(rec_num, function(x) sum(x[!is.na(x)] <= 6)) / num_responses[6:10]

## combine results
rec_results <- as.data.frame(rbind(num_responses[6:10], sprintf("%.2f", round(avg[6:10], 2)), sprintf("%.2f", round(rec_nps, 2)), percent(promoters), percent(passives), percent(detractors)))
```

This table tells the recommendation story.  Wow, XYZ Corp. is in trouble:

<table class="table table-striped table-hover table-condensed table-responsive" style="width: auto !important; margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:left;">   </th>
   <th style="text-align:left;"> Recommendation Q1 </th>
   <th style="text-align:left;"> Recommendation Q2 </th>
   <th style="text-align:left;"> Recommendation Q3 </th>
   <th style="text-align:left;"> Recommendation Q4 </th>
   <th style="text-align:left;"> Recommendation Q5 </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> n </td>
   <td style="text-align:left;"> 935 </td>
   <td style="text-align:left;"> 925 </td>
   <td style="text-align:left;"> 925 </td>
   <td style="text-align:left;"> 923 </td>
   <td style="text-align:left;"> 925 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Avg. Likelihood to Recommend </td>
   <td style="text-align:left;"> 5.01 </td>
   <td style="text-align:left;"> 4.99 </td>
   <td style="text-align:left;"> 5.04 </td>
   <td style="text-align:left;"> 5.02 </td>
   <td style="text-align:left;"> 4.98 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> NPS </td>
   <td style="text-align:left;"> -52.83 </td>
   <td style="text-align:left;"> -48.00 </td>
   <td style="text-align:left;"> -48.86 </td>
   <td style="text-align:left;"> -48.97 </td>
   <td style="text-align:left;"> -49.51 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> % Promoters </td>
   <td style="text-align:left;"> 13.58% </td>
   <td style="text-align:left;"> 16.22% </td>
   <td style="text-align:left;"> 15.57% </td>
   <td style="text-align:left;"> 15.17% </td>
   <td style="text-align:left;"> 15.03% </td>
  </tr>
  <tr>
   <td style="text-align:left;"> % Passives </td>
   <td style="text-align:left;"> 20.00% </td>
   <td style="text-align:left;"> 19.57% </td>
   <td style="text-align:left;"> 20.00% </td>
   <td style="text-align:left;"> 20.69% </td>
   <td style="text-align:left;"> 20.43% </td>
  </tr>
  <tr>
   <td style="text-align:left;"> % Detractors </td>
   <td style="text-align:left;"> 66.42% </td>
   <td style="text-align:left;"> 64.22% </td>
   <td style="text-align:left;"> 64.43% </td>
   <td style="text-align:left;"> 64.14% </td>
   <td style="text-align:left;"> 64.54% </td>
  </tr>
</tbody>
</table>

I'd also like to see this visually.  I've skipped the interim steps and am showing only the final two plots.  To 
differentiate visually from the satisfaction results, these plots use the default colors from the likert package.  
Given that the scale of NPS is -100 to +100, I've also used the default scale for the plots.


```r
## create recommendation labels including NPS and avg. likelihood to recommend
rec_label <- paste0("NPS = ", sprintf("%.2f", round(rec_nps)), "\n", "Avg. = ", sprintf("%.2f", round(avg[6:10], 1)))

## promoter/detractor function
rec_type <- function(elem) {
  if (is.numeric(elem)) { 
    ifelse(elem >= 9, "Promoter", ifelse(elem <= 6, "Detractor", "Passive"))
  } 
  else { stop("Invalid input.  Please ensure numeric input.") }
}

## apply recommendation type to rec_num
rec <- as.data.frame(lapply(rec_num, rec_type), check.names = FALSE)

## add number of responses to the names of the sat data frame so they will appear on the plot
names(rec) <- lapply(seq_along(rec), function(x) paste0(names(survey_data[x]), " (n = ", num_responses[x], ")"))

## create likert element
rec_likert <- likert(rec, nlevels = 3)

## plot rec_likert
plot(rec_likert, group.order = names(rec)) + 
  geom_rect(aes(xmin = 4.82, xmax = 5.14, ymin = -10, ymax = 10), fill = "#FFFFFF") +
  annotate("text", x = 5, y = 0, label = rec_label[1], size = 4, alpha = 0.75) + 
  geom_rect(aes(xmin = 3.82, xmax = 4.14, ymin = -10, ymax = 10), fill = "#FFFFFF") +
  annotate("text", x = 4, y = 0, label = rec_label[2], size = 4, alpha = 0.75) + 
  geom_rect(aes(xmin = 2.82, xmax = 3.14, ymin = -10, ymax = 10), fill = "#FFFFFF") +
  annotate("text", x = 3, y = 0, label = rec_label[3], size = 4, alpha = 0.75) + 
  geom_rect(aes(xmin = 1.82, xmax = 2.14, ymin = -10, ymax = 10), fill = "#FFFFFF") +
  annotate("text", x = 2, y = 0, label = rec_label[4], size = 4, alpha = 0.75) +
  geom_rect(aes(xmin = 0.82, xmax = 1.14, ymin = -10, ymax = 10), fill = "#FFFFFF") +
  annotate("text", x = 1, y = 0, label = rec_label[5], size = 4, alpha = 0.75) +
  theme(plot.title = element_text(hjust = 0.5)) + ggtitle("Likelihood to Recommend XYZ Corp.")
```

{::nomarkdown}<img src="https://s.mylesandmyles.info/img/2017-11-25-survey-analysis/plot-recommendation-1.png" class="img-responsive" title="plot of chunk plot-recommendation" alt="plot of chunk plot-recommendation" style="display: block; margin: auto;" />{:/}

Due to the random nature of the data (centered around the midpoint of the range), the labels cover up the % passives. 
Here's one more plot, with the labels in their relative (NPS) positions.


```r
## plot rec_likert, moving labels to their relative positions
plot(rec_likert, group.order = names(rec)) + 
  geom_rect(aes(xmin = 4.82, xmax = 5.14, ymin = rec_nps[1] - 10, ymax = rec_nps[1] + 10), fill = "#FFFFFF") +
  annotate("text", x = 5, y = rec_nps[1], label = rec_label[1], size = 4, alpha = 0.75) + 
  geom_rect(aes(xmin = 3.82, xmax = 4.14, ymin = rec_nps[2] - 10, ymax = rec_nps[2] + 10), fill = "#FFFFFF") +
  annotate("text", x = 4, y = rec_nps[2], label = rec_label[2], size = 4, alpha = 0.75) + 
  geom_rect(aes(xmin = 2.82, xmax = 3.14, ymin = rec_nps[3] - 10, ymax = rec_nps[3] + 10), fill = "#FFFFFF") +
  annotate("text", x = 3, y = rec_nps[3], label = rec_label[3], size = 4, alpha = 0.75) + 
  geom_rect(aes(xmin = 1.82, xmax = 2.14, ymin = rec_nps[4] - 10, ymax = rec_nps[4] + 10), fill = "#FFFFFF") +
  annotate("text", x = 2, y = rec_nps[4], label = rec_label[4], size = 4, alpha = 0.75) +
  geom_rect(aes(xmin = 0.82, xmax = 1.14, ymin = rec_nps[5] - 10, ymax = rec_nps[5] + 10), fill = "#FFFFFF") +
  annotate("text", x = 1, y = rec_nps[5], label = rec_label[5], size = 4, alpha = 0.75) +
  theme(plot.title = element_text(hjust = 0.5)) + ggtitle("Likelihood to Recommend XYZ Corp.")
```

{::nomarkdown}<img src="https://s.mylesandmyles.info/img/2017-11-25-survey-analysis/plot-recommendation 2-1.png" class="img-responsive" title="plot of chunk plot-recommendation 2" alt="plot of chunk plot-recommendation 2" style="display: block; margin: auto;" />{:/}

Much better, but bad news for XYZ Corp.'s management.

<a name="summary"></a>
-[ **summary** ]-

Numeric survey analysis is relatively straightforward in R, particularly when using the [Likert](http://jason.bryer.org/likert/) and [NPS](https://CRAN.R-project.org/package=NPS) packages. 

<a name="comments"></a>
