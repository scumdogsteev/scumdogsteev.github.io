---
layout: post
title: phonenumber
date: 2015-07-12
comments: true
categories: 
 - projects
 - software
 - rstats
 - r-package
image: https://farm3.staticflickr.com/2378/1659258787_e70a494b60.jpg
image-source: https://www.flickr.com/photos/tesschamakkala/1659258787
image-desc: New phone...
image-credit: https://www.flickr.com/photos/tesschamakkala/
image-creator: Tessss
summary: <a href="https://s.mylesandmyles.info/phonenumber/">phonenumber</a> is a simple R package that converts English letters to numbers or numbers to English letters as on a telephone keypad
---

-[ **background** ]-

“**[phonenumber](https://s.mylesandmyles.info/phonenumber/)**” is a simple [R](http://www.r-project.org/) package that converts English letters to numbers or numbers to English letters as on a telephone keypad.

When I recently posted some of my [Turbo Pascal Stuff](https://s.mylesandmyles.info/blog/2015/06/19/turbo-pascal-stuff/), I found an incomplete program that was supposed to do this.  I was active on [BBSes](https://en.wikipedia.org/wiki/Bulletin_board_system) and, though I don’t recall the reason, I wanted a way to determine the possible words spelled by the BBS phone numbers (and/or how to determine what phone numbers correspond to words/phrases).  I never got around to finishing the second part (numbers to letters) in Turbo Pascal, though.

I decided to create this functionality in R for three reasons:

1.  to see if I could write the functions
2.  to learn to publish a package to [CRAN](http://cran.r-project.org/)
3.  to serve as a possible pedagogical example for others as it involves working with lists, splitting strings, and the [expand.grid](https://stat.ethz.ch/R-manual/R-devel/library/base/html/expand.grid.html) function.

-[ **telephone keypad** ]-

For purposes of this package, the mapping of numbers to letters on a telephone’s keypad are as follows:

*   _Default behavior_ - if parameter qz is omitted (or has a value other than 0):

    *   2 corresponds to A, B, C
    *   3 corresponds to D, E, F
    *   4 corresponds to G, H, I
    *   5 corresponds to J, K, L
    *   6 corresponds to M, N, O
    *   7 corresponds to P, Q, R, S
    *   8 corresponds to T, U, V
    *   9 corresponds to W, X, Y, Z
    *   0 and 1 have no corresponding letters
*   _Alternate behavior_ - if parameter qz = 0:

    *   2 corresponds to A, B, C
    *   3 corresponds to D, E, F
    *   4 corresponds to G, H, I
    *   5 corresponds to J, K, L
    *   6 corresponds to M, N, O
    *   7 corresponds to P, R, S
    *   8 corresponds to T, U, V
    *   9 corresponds to W, X, Y
    *   0 corresponds to Q, Z
    *   1 has no corresponding letters

-[ **installation** ]-

*   phonenumber is available [on CRAN](http://cran.r-project.org/web/packages/phonenumber/index.html) and can be installed accordingly: 

```r
    install.packages("phonenumber")
    library(phonenumber)
```

*   updates to phonenumber can be installed [from GitHub](https://github.com/scumdogsteev/phonenumber) using the devtools package:

```r
    install.packages("devtools")
    library(devtools)
    install_github("scumdogsteev/phonenumber")
    library(phonenumber)
```

-[ **functions** ]-

phonenumber consists of two functions (that are not limited to any standard length or format of telephone numbers):

1.  **letterToNumber** - converts words/phrases in English letters into the corresponding numbers as on a telephone keypad, returning a character vector containing a number.  Numbers are returned as is.
2.  **numberToLetter** - converts numbers into the corresponding combinations of English letters as on a telephone keypad, returning a character vector containing all possible combinations sorted alphabetically.  Letters are returned as is.

Both functions convert non-alphanumeric characters to dashes (-) as that is the character that usually separates parts of a phone number.

-[ **examples** ]-

**letterToNumber**:

```r
string <- "Texas" 
letterToNumber(string) 
#> [1] "83927"
```

**numberToLetter**:

```r
string <- "22" 
numberToLetter(string) 
#> [1] "AA" "AB" "AC" "BA" "BB" "BC" "CA" "CB" "CC"
```

-[ **license** ]-

*   MIT License

-[ **[releases](https://github.com/scumdogsteev/phonenumber/releases) / [changelog](https://s.mylesandmyles.info/phonenumber/news/index.html)** ]-

For no particular reason, versions of phonenumber will be named after things from the [_Terminator_ universe](https://en.wikipedia.org/wiki/Terminator_(franchise)).

*   [v0.2.2 - machine phase matter](https://github.com/scumdogsteev/phonenumber/releases/tag/v0.2.2)

    *   tweaks to vignette and documentation
*   [v0.2.1 - phased plasma rifle in the 40-watt range](https://github.com/scumdogsteev/phonenumber/releases/tag/v0.2.1)

    *   change for loops to lapply
    *   remove ineffective error-checking
*   [v0.2.0 - memetic polyalloy](https://github.com/scumdogsteev/phonenumber/releases/tag/v0.2.0)

    *   add user determination of whether to map "Q" and "Z" to 7 and 9 or to 0
    *   add additional tests due to new functionality
    *   add comments to existing examples
    *   add additional examples due to new functionality
    *   add package help file
    *   fix typos and add title to vignette
    *   add URLs to DESCRIPTION
    *   updates to README
*   [v0.1.0 - hyperalloy combat chassis](https://github.com/scumdogsteev/phonenumber/releases/tag/v0.1.0)

    *   initial release

-[ **download / install r package** ]-

*   [phonenumber home](https://s.mylesandmyles.info/phonenumber/)
*   [phonenumber on CRAN](http://cran.r-project.org/web/packages/phonenumber/index.html)
*   [phonenumber vignette](http://cran.r-project.org/web/packages/phonenumber/vignettes/phonenumber.html)
*   [phonenumber GitHub repository](https://github.com/scumdogsteev/phonenumber)
*   [phonenumber on crantastic](http://crantastic.org/packages/phonenumber)