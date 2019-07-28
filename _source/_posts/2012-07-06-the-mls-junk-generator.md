---
layout: post
title: The MLS Junk Generator
date: 2012-07-06
comments: true
categories: 
 - orms
 - school
 - rstats
 - projects
 - r-package
 - software
image: https://farm7.staticflickr.com/6234/6263696014_0b32db6eba.jpg
image-source: https://www.flickr.com/photos/twindx/6263696014
image-desc: 1970s Random Number Generator
image-credit: https://www.flickr.com/photos/twindx/
image-creator: Irregular Shed
summary: A pseudo-random number generator, featuring VBA and R implementations (including an <a href="https://stevemyles.site/mlsjunkgen/">R package</a>)
---


-[ **background** ]-

I took a course in graduate school ("[Statistical Analysis for Digital Simulation](http://catalog.ttu.edu/preview_course_nopop.php?catoid=2&amp;coid=9253)") at Texas Tech from Dr. Elliot Montes in which we spent a lot of time on the generation and analysis of random numbers.  Here is a simple-yet-powerful (pseudo)random number generator that I learned about in that course.  It is named "The MLS Junk Generator" after [Dr. Milton L. Smith](http://www.depts.ttu.edu/ieweb/faculty/faculty.php?name=Milton%20Smith).  I thought of it recently _[07/2012]_ (not sure why) and decided to share.

_[**Update 02/2015**]_ Now that [I'm learning R](https://stevemyles.site/blog/2015/01/22/data-science-specialization/), I decided to convert the generator to that language and clean-up and post the Excel/VBA versions I already had.

_[**Update 08/2015**]_ This is now available as [an R package](https://stevemyles.site/mlsjunkgen/) ([CRAN](https://cran.r-project.org/web/packages/mlsjunkgen/index.html), [GitHub](https://github.com/scumdogsteev/mlsjunkgen)).

-[ **the mls junk generator** ]-

For any seed values of _w_, _x_, _y_, _z_:

*r<sub>i</sub>* = 5.980217_w_<sup>2</sup> + 9.446377_x_<sup>0.25</sup> + 4.81379_y_<sup>0.33</sup> + 8.91197_z_<sup>0.5</sup>

*r<sub>i</sub>* = _r<sub>i</sub>_ - Int(_r<sub>i</sub>_)

For *r<sub>i+1</sub>*:

_w_ = _x_

_x_ = _y_

_y_ = _z_

_z_ = _r<sub>i</sub>_

-[ **analysis** ]-

This generator tends to do well with various tests for randomness (K-S, Chi Square, test for runs up and down).  It may not perform as well on other tests (e.g., tests for runs above and below the mean), but that could relate to my choice of seeds.  As a point of reference, the period of Excel's built-in random number generator is 16,777,216 (at least in Excel 2003; the algorithm may have changed in Excel 2007 or 2010 _[Edit: this seems to still be the period of Excel's RNG.]_) and the MLS Junk Generator's period is something greater than 9.9 billion (I gave up on trying to calculate it when it reached that point).

-[ **vba code** ]-

Here is an example of VBA code that generates a stream of random numbers in column A in Excel, assuming user-defined values of the parameters _w_, _x_, _y_, _z_,_ _and _n_ (the number of random numbers to generate) in cells C1 to C5.  This can be downloaded in .xlsm or .bas format (see below).

```vb
Option Explicit
 Public Sub MLS_Junk_Generator()
 Dim r, ri, w, x, y, z As Single
 Dim i, n As Integer
  Application.ScreenUpdating = False
   n = Cells(1, 3).Value
   w = Cells(2, 3).Value
   x = Cells(3, 3).Value
   y = Cells(4, 3).Value
   z = Cells(5, 3).Value

   Cells(1, 1).Value = "MLS Junk Generator Stream"

   For i = 1 To n
     r = 5.980217 * (w^2) + 9.446377 * (x^0.25) + 4.81379 * (y^0.33) + 8.91197 * (z^0.5)
     ri = r - Int(r)
     Cells(i + 1, 1).Value = Format(ri, "0.0000")
     w = x
     x = y
     y = z
     z = ri
   Next i
   Application.ScreenUpdating = True
 End Sub
 ```
<a id="rcode"></a>
-[ **r code (aka MLS Junk GeneratR)** ]-

In February 2015, I wrote two R functions with the same user-defined parameters as the VBA code above.  The file (see below) also contains a version of this function that generates a data frame.

-[ **r package ([mlsjunkgen](https://stevemyles.site/mlsjunkgen/))** ]-

**Installation:**

*   mlsjunkgen is available [on CRAN](https://cran.r-project.org/web/packages/mlsjunkgen/index.html) and can be installed accordingly:

```r
   install.packages("mlsjunkgen") 
   library(mlsjunkgen)
```

*   updates to mlsjunkgen can be installed [from GitHub](https://github.com/scumdogsteev/mlsjunkgen) using the devtools package:

```r
   install.packages("devtools")
   library(devtools)
   install_github("scumdogsteev/mlsjunkgen")
   library(mlsjunkgen)
```

**Functions**

The package consists of four functions:

1.  junkgen - generates a pseudo-random number from user-specified seeds
2.  mlsjunkgenv - generates a vector of pseudo-random numbers by calling junkgen a user-specified number of times
3.  mlsjunkgend - generates a data frame of pseudo-random numbers by calling junkgen a user-specified number of times
4.  mlsjunkgenm - generates a user-specified size matrix of pseudo-random numbers by calling mlsjunkgenv and assigning the results to a matrix

**Examples:**

**junkgen** generates a single pseudo-random number based on four user-specified seeds:

```r
w <- 1
x <- 2
y <- 3
z <- 4
junkgen(w = w, x = x, y = y, z = z)
#> [1] 0.9551644
```

**mlsjunkgenv** generates a vector containing a stream of *n* (default = 1) user-specified pseudo-random numbers based on four user-specified seeds rounded to a specified (default = 5) number of decimal places:

```r
mlsjunkgenv(n = 10, w = w, x = x, y = y, z = z, round = 8)
#>  [1] 0.9551644 0.6690774 0.2123540 0.3448801 0.1199463 0.5639798 0.5923515
#>  [8] 0.1143156 0.3352500 0.7027079

## The same example with default rounding:

mlsjunkgenv(n = 10, w = w, x = x, y = y, z = z)
#>  [1] 0.95516 0.66908 0.21235 0.34488 0.11995 0.56398 0.59235 0.11432
#>  [9] 0.33525 0.70271
```

**mlsjunkgend** generates a data frame containing a stream of n user-specified pseudo-random numbers based on four user-specified seeds:

```r
mlsjunkgend(n = 10, w = w, x = x, y = y, z = z, round = 8)
#>           RN
#> 1  0.9551644
#> 2  0.6690774
#> 3  0.2123540
#> 4  0.3448801
#> 5  0.1199463
#> 6  0.5639798
#> 7  0.5923515
#> 8  0.1143156
#> 9  0.3352500
#> 10 0.7027079

## The same example with default rounding:

mlsjunkgend(n = 10, w = w, x = x, y = y, z = z)
#>           RN
#> 1  0.95516
#> 2  0.66908
#> 3  0.21235
#> 4  0.34489
#> 5  0.11995
#> 6  0.56398
#> 7  0.59235
#> 8  0.11432
#> 9  0.33525
#> 10 0.70271
```

**mlsjunkgenm** generates a matrix of user-specified size containing a stream of random numbers based on four user-specified seeds:

```r
mlsjunkgenm(nrow = 5, ncol = 5, w = w, x = x, y = y, z = z, round = 3)
#>       [,1]  [,2]  [,3]  [,4]  [,5]
#> [1,] 0.955 0.564 0.418 0.052 0.020
#> [2,] 0.669 0.592 0.313 0.663 0.110
#> [3,] 0.212 0.114 0.920 0.802 0.685
#> [4,] 0.345 0.335 0.379 0.160 0.286
#> [5,] 0.120 0.703 0.280 0.586 0.452
```

Versions of mlsjunkgen will be named after things related to [Texas Tech University](http://ww.ttu.edu/).

*   [v0.1.1 - Masked Rider](https://github.com/scumdogsteev/mlsjunkgen/releases/tag/v0.1.1)

    *   fix typos in README and vignette
    *   correct README and vignette examples

*   [v0.1.0 - Raider Red](https://github.com/scumdogsteev/mlsjunkgen/releases/tag/v0.1.0)

    *   initial release

-[ **license** ]-

*   All implementations are licensed under the [MIT License](https://github.com/scumdogsteev/mls-junk-generator/blob/master/LICENSE)

-[ **project changelog** ]-

2015-09-07

*   v0.1.1 of R package (Masked Rider) released, see above for package release notes

2015-08-16

*   v0.1.0 of R package (Raider Red) created, see above for package release notes

2015-02-01

*   files posted to GitHub
*   v.0.1.0 of Excel/VBA implementation released
*   R version created

2015-01-31

*   Excel files updated

2012-07-06

*   VBA code sample posted online

Spring 2004

*   VBA code written

-[ **download excel/vba implementation** ]-

[ [releases](https://github.com/scumdogsteev/mls-junk-generator/releases) ]  &#124; [ [all files](https://github.com/scumdogsteev/mls-junk-generator) ]

1.  [mls_junk_generator1.xlsm](https://github.com/scumdogsteev/mls-junk-generator/releases/download/v.0.1.0/mls_junk_generator1.xlsm) - simple Excel implementation
2.  [mls_junk_generator.bas](https://github.com/scumdogsteev/mls-junk-generator/blob/master/mls_junk_generator.bas) - VBA source for #1
3.  [mls_junk_generator2.xlsm](https://github.com/scumdogsteev/mls-junk-generator/releases/download/v.0.1.0/mls_junk_generator2.xlsm) - second Excel implementation (allows for clearing of the RN stream)
4.  [MLSJunkGen.bas](https://github.com/scumdogsteev/mls-junk-generator/blob/master/MLSJunkGen.bas) - VBA module for #3

-[ **download original r implementation** ]-

[ [all files](https://github.com/scumdogsteev/mls-junk-generatR) ]  &#124; [ [r source](https://github.com/scumdogsteev/mls-junk-generatR/blob/master/mlsjunkgen.R) ]

-[ **download/install r package** ]-

*   [package home](http://stevemyles.site/mlsjunkgen/)
*   [mlsjunkgen on CRAN](http://cran.r-project.org/web/packages/mlsjunkgen/index.html)
*   [mlsjunkgen vignette](http://cran.r-project.org/web/packages/mlsjunkgen/vignettes/phonenumber.html)
*   [mlsjunkgen GitHub repository](https://github.com/scumdogsteev/mlsjunkgen)
*   [mlsjunkgen on crantastic](http://crantastic.org/packages/mlsjunkgen)