---
layout: post
title: Tic Tac Toe
date: 2006-07-10
categories:
  - projects
  - software
  - school
comments: true
image: https://farm4.staticflickr.com/3071/3065172664_933faf5786.jpg
image-source: https://www.flickr.com/photos/cainnmosni/3065172664
image-desc: Diptych 2b by Denise Wong
image-credit: https://www.flickr.com/photos/cainnmosni/
image-creator: Denise Wong
summary: A tic tac toe game I coded for my Cognitive Engineering class in graduate school
---

-[ **background** ]-

For a class I took during the Spring of 2004, I had to write a program that plays tic tac toe. Technically, I should say “we,” since I had a partner, but I wrote the program and he did the manual enumeration of a tic tac toe decision tree. I think I picked the easier half of the assignment. If you want to see the tree, you’ll have to do that part of the assignment yourself.

The class was “Cognitive Engineering;” it was all about [Turing machines](http://en.wikipedia.org/wiki/Turing_machine) and [Turing tests](http://en.wikipedia.org/wiki/Turing_test) and such. This assignment related to the cognitive aspects of problem solving and whether or not a machine could duplicate them. It’s a very (extremely amazingly ultra) simple AI.

-[ **actual assignment** ]-

> _PART A_
> 
> Draw the state transition tree for playing tic-tac-toe. This diagram should outline all of the possible states of the game; starting with a blank diagram and moving to all possible ends. Note that who goes first (X or O) doesn’t really matter because when we get done, we can just replace all X’s with O’s and O’s with X’s to get the other tree. Because your program (see below) will have X go first, do this tree. Also, when making your tree realize that many different configurations are the same. For instance, there are only 3 possible initial moves (middle, side or corner) even though there are 9 spaces. If you can rotate the game to get an identical configuration, these are the same in terms of strategy (i.e. if you are playing tic-tac-toe, nobody cares if you rotate the paper before making your move).
> 
> _PART B_
> 
> Design and construct a computer program to play tic-tac-toe. Assume that ‘X’ always goes first, and that your opponent can be either ‘X’ or ‘O’. You may use any computer language you wish, within reason.
> 
> **Material turned in for this assignment should include:** an enumeration of the problem space; a written verbal description of your computer algorithm, and a disk containing your program.

-[ **algorithm** ]-

 From the document we turned in:

> This tic tac toe program was written in Turbo Pascal for Windows version 1.5. The algorithm that the program uses to play tic tac toe is rather simple. First, the program allows the user to choose if s/he wants to be play as X or O. If the user chooses O (and thus chooses to allow the computer to play first), the computer’s first move is to randomly select one of the corners. If the user chooses X (and thus, chooses to go first him/herself), the program chooses a space based on the user’s choice. If the user has selected a corner, the program chooses the middle. Otherwise, the program chooses a corner at random. After the first turn, the program is designed to play strategically.
>  The strategy employed by the program is used until a winner is determined. The program is designed to first try to win. It examines all of the squares, and if it is capable of winning (having three X’s or O’s in a row, depending on whether it is X or O), it does so. If it cannot win, it again examines all nine squares and attempts to block the user from winning. If the user has two in a row and can win on the next turn, the program will block the user. If the program cannot win or block, it will attempt to play offensively. If either pair of side squares is free (e.g. above and below the middle or to the left and right of the middle), it will randomly pick one of these free sides. If no pair of side squares is free, it will try to take the middle square. If the middle square has already been taken, it will randomly choose a free corner. If no corner is free, it will randomly choose a free side.
>  The program allows the user to play multiple times without exiting. Additionally, it keeps track of how many times it has won, how many times the user has won, and how many tie (or cat) games there have been. For more detail about how the program works, please see the source code.

-[ **notes** ]-

 This was written in Turbo Pascal, for that ultra-retro feel (actually, because that was the only compiler I had at the time), but the executable file should work on most (all?) Win32 installations. All ASCII art included is believed to be in the public domain. If you use the code for anything, please let me know by leaving a comment. Thanks.

This needs work, but it can beat me. Of course, I always sucked at tic tac toe. According to the professor, there’s a flaw in the logic that allows the user to always win. I’ve been unable to find it, though. Please let me know if you find it.

We got a 100 on this project, despite the “flaw,” in case you’re wondering. I still got a B in the class, though.

-[ **license **]-

*   Licensed under the [MIT License](https://github.com/scumdogsteev/tic-tac-toe/blob/master/LICENSE) as of 2015/02/04.

-[ **download** ]-

[ [releases](https://github.com/scumdogsteev/tic-tac-toe/releases) ] &#124; [ [all files](https://github.com/scumdogsteev/tic-tac-toe) ] &#124; [ [source](https://github.com/scumdogsteev/tic-tac-toe/blob/master/ttt.pas "ttt.pas") ] &#124; [ [binary](https://github.com/scumdogsteev/tic-tac-toe/releases/download/v.0.5b/ttt.exe "ttt.exe") ] &#124; [ [source + binary (.zip)](https://github.com/scumdogsteev/tic-tac-toe/archive/refs/tags/v.0.5b.zip "ttt.zip") ]