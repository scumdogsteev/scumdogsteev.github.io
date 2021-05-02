---
layout: post
title: Stochastic &quot;Inventory Control&quot;
date: 2006-07-12
comments: true
categories:
  - projects
  - software
  - school
  - orms
  - inventory-control
image: https://farm5.staticflickr.com/4060/4602738032_163660bb39.jpg
image-source: https://www.flickr.com/photos/lazzarello/4602738032
image-desc: inventory
image-credit: https://www.flickr.com/photos/lazzarello/
image-creator: Lee
summary: Programs that write one-step transition matrices and compute the equilibrium probabilities of <a href="http://en.wikipedia.org/wiki/Markov_chain">Markov chains</a> using <a href="http://en.wikipedia.org/wiki/Jacobi_method">Jacobi iteration</a>
---

-[ **background** ]-

 In the Spring of 2003, I took a course in [stochastic processes](http://en.wikipedia.org/wiki/Stochastic_process). The second exam was take home and required some coding, which I did in Turbo Pascal, as in the case of my [tic tac toe](http://stevemyles.site/blog/2006/07/10/tic-tac-toe) program one year later (the posting of which reminded me of the code from my stochastic processes class).

-[ **assignment and notes** ]-
> A local store uses an **(s, S)** inventory policy for a particular product. Every Friday evening after the store closes, the inventory level is checked. If the stock level for the product is greater than **s**, no action is taken. Otherwise, if the stock on hand is less than or equal to **s**, an amount **S-s** is procured over the weekend and is available when the store re-opens on Monday morning.
> 
> Let {X<sub>n</sub>, n = 1, 2, …} be the stock on hand when the inventory is checked on Friday evening of week **n** and let {Z<sub>n</sub>, n = 1, 2, …} be the demand for product during week **n**.
> 
> Then for any ω ∈ Ω,
> 
>  X<sub>n+1</sub>(ω) = X<sub>n</sub>(ω) - Z<sub>n+1</sub>(ω)  if s &lt; X<sub>n</sub>(ω), Z<sub>n+1</sub>(ω) ≤ X<sub>n</sub>(ω) 
>
>  X<sub>n+1</sub>(ω) = S - Z<sub>n+1</sub>(ω)  if X<sub>n</sub>(ω) ≤ Z<sub>n</sub>(ω) ≤ S 
>
>  X<sub>n+1</sub>(ω) = 0  otherwise. 
> 
> 
> Let **s** = 3, **S** = 5, X<sub>0</sub> = 0 and assume customers arrive at the store according to a Poisson process with rate λ = 4 per week. (Each customer wants one unit of product.)
> 

Phase I of the exam required the proof that {X<sub>n</sub>, n = 1, 2, …} is a [Markov chain](http://en.wikipedia.org/wiki/Markov_chain) and writing its [transition matrix](http://en.wikipedia.org/wiki/Stochastic_matrix). These are intuitive (or you’re looking for the answers to your exam, assuming the prof. still uses this exam), so I won’t include them here.

Phases II and III of the exam required some coding.

> Phase II
> 
> A) Write a program to generate (i.e., fill in) the one-step transition matrix for a passed value of **S**. Print the one-step matrices for **S** = 4.
> 
> B) Let π<sup>[0]</sup> = (1, 0, …, 0). Write a program to compute the equilibrium probabilities of the Markov chain using [Jacobi iteration](http://en.wikipedia.org/wiki/Jacobi_method).
>  Also, plot π<sub>j</sub><sup>[0]</sup> as a function of n, i.e., the number of Jacobi iterations.
> 
> …
> 
> **Jacobi Iteration.**
> 
> Jacobi Iteration is a simple computational technique for obtaining the equilibrium probabilities of a Markov chain using a series of matrix multiplies rather than solving a system of linear equations.
> 
> Let π<sup>[n]</sup> be the probability row vector representing the probability of occupying a given state after n transitions. That is, π<sub>j</sub><sup>[n]</sup> = P{in state j after n transitions}.
> 
> By conditioning on the state occupied at transition n we have
> 
> π<sup>[n+1]</sup> = π<sup>[n]</sup>**P**  (Eqn 1)
> 
> 
> where **P** is the one-step transition matrix for the Markov chain. In the limit as n goes to ∞, π<sup>[n]</sup> goes to π, the vector of equilibrium probabilities. Depending on the system and the desired accuracy, convergence can be quite rapid.
> 
> To compute the equilibrium probabilities, start with π<sup>[0]</sup>, then compute π<sup>[1]</sup>, then π<sup>[2]</sup> and so on using Equation 1 until π<sup>[n+1]</sup> is “close” to π<sup>[n]</sup>. For this problem, stop iterating when
> 
> Max{|π<sub>j</sub><sup>[n+1]</sup> - π<sub>j</sub><sup>[n]</sup>|, all j in State Space} = 0.0001.
> 
> 
> Computational note: Due to round-off error by the computer, it may be necessary to “re-normalize” π<sup>[n]</sup> every few iterations so that its elements sum to one. To do this, add up the first m-1 elements of the vector π<sup>[n]</sup> (assuming the chain has m states) then set the m<sup>th</sup> element equal to one minus the sum. The elements now sum to one.
> 

The source code and binaries for the solutions to these Phase II questions are linked below. I’m not including Phase III’s code because, unlike Phase II’s, it does not have many possible uses outside the context of this exam. Phase II’s code is relevant because somewhere, someone might want to write a simple program to perform Jacobi iterations or to write one-step transition matrices. This code could easily be extended for other (non-Poisson) arrival distributions and/or for generation of the n-step transition matrix.

-[ **license** ]-

*   Licensed under the [MIT License](https://github.com/scumdogsteev/stochastic-inventory-control/blob/master/LICENSE) as of 2015/02/04

-[ **downloads** ]-

* [ [releases](https://github.com/scumdogsteev/stochastic-inventory-control/releases) ] &#124; [ [all files](https://github.com/scumdogsteev/stochastic-inventory-control) ]
* Phase II, Part A - [ [source](https://github.com/scumdogsteev/stochastic-inventory-control/blob/master/ex2ph2a.pas "ex2ph2a.pas") ] &#124; [ [source + binary (.zip)](https://github.com/scumdogsteev/stochastic-inventory-control/releases/download/v.0.1.0a/ex2ph2a.zip "ex2ph2a.zip") ]
* Phase II, Part B - [ [source](https://github.com/scumdogsteev/stochastic-inventory-control/blob/master/ex2ph2b.pas "ex2ph2b.pas") ] &#124; [ [source + binary (.zip)](https://github.com/scumdogsteev/stochastic-inventory-control/releases/download/v.0.1.0a/ex2ph2b.zip "ex2ph2b.zip") ]