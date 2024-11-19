Boolean Algebra Toolbox Ver. 2.2
================================
Date: 2002-11-29
Author: B. Rasmus Anthin.



WHAT IS IT
----------

This toolbox contains the following functions:
These are not for use with the BOOL-class:

* B2H
   same as DEC2HEX(BIN2DEC(FLIPLR(BIN))), where BIN is a string of ones
   and zeroes. However the input to B2H is a numeric array of
   ones and zeroes.

* GRAYC2
   returns a gray-code matrix.

* BTAB2
   writes out a neat truth-table.

* EVALB
   evaluates boolean expressions. Actually it converts nonzero
   elements in an array into ones. Output is a row-vector.

* NBC2
   returns a natural-binary-code matrix.

This is some notes about the BOOL-class:

The bool class supports many different kinds of operations, such as comparison, easier handling of boolean operators and displaying the boolean strings/variables.
You can easily convert a boolean variable by using the DOUBLE converter, which converts any boolean string into a double precision array:

» a=bool([1 0 1 1 0 1 0 0])

a =

     1011 0100  

» double(a)

ans =

     1     0     1     1     0     1     0     0


you can also easily show the corresponding decimal or hexadecimal value with either B2D or B2H. The flip function flips the boolean string of a variable.
LENGTH shows the number of bits in the variable. You can also concatenate boolean variables/strings:

» [a 1 0 1]

ans =

     1011 0100  101

As one can see, the DISPLAY routine makes appropriate separations in order to easier see how the bit field is grouped into nibbles and bytes etc...
Boolean operators are:
 * and
 & and
 + or
 | or
 ~ not
 ' not
 / xor

so we have some syntactic sugar here.
You can easily generate binary code for the BOOL-class with either NBC or GRAYC, by eg typing:

» [x y z]=nbc(3)

x =

     0101 0101  


y =

     0011 0011  


z =

     0000 1111  


which is good to use for generating expressions:

» f=x*y'+z/x

f =

     0101 1110  

which then can be displayed as a truth table:

» btab(f,x,y,z)

 x  y  z   f(*)
________________________
 0  0  0   0
 1  0  0   1
 0  1  0   0
 1  1  0   1
 0  0  1   1
 1  0  1   1
 0  1  1   1
 1  1  1   0

Enjoy!...



INSTALLATION
------------

0. UNINSTALLATION: If you already have one of the earlier distributions,
then the best thing would be if you could remove the earlier archive and
then go proceed to the next step (2) below. To remove the archive simply
enter the "bool" directory and in Unix/Linux write "rm -rf". Please be
sure that you REALLY are in the current directory or else other valuable
files may be lost FOREVER! So use "rm -rf" with great caution!!! You
should not have any of your own files located in this directory if you are
running Matlab under Unix/Linux!
If you are running Matlab under Windows then use either "Windows
Commander" or the Windows built in "File Explorer" in order to delete the
earier installed archive.

1. Enter your matlab directory or the directory where you want to put the
toolbox.

2. Place the bool.#.#.tar.gz archive file in this directory.

3. Linux/Unix: Install by writing "gtar -xvzf bool.#.#.tar.gz" (you can
also use "gnutar" or "tar").
   Windows: Copy the entire archive to the directory using
Windows Commander available from "http://www.ghisler.com".
You should then end up with a file structure like this:
/bool/
  evalb.m
  nbc.m
  .
  .

4. Update your matlab path using the command "pathtool" or "editpath" if
you have not done this already.

If you would encounter any problems during the above steps, the please
contact me "e8rasmus@etek.chalmers.se" and I'll do my best to help you
through.



GETTING STARTED
---------------

Just three words: Trial and error.
If you ecounter any problems, do not hesitate mailning me.



UPDATES AND VERSIONS
--------------------

Ver 1.0:
Nothing is updated. Everything is unchanged.

Ver 2.0:
Added the bool-class for easier handling of boolean expressions.

Ver 2.1:
Fixed the bug with GRAYC which called for GRAYB rather than GRAYC2.
Beautified the truthtable BTAB.

Ver 2.2:
BTAB had an alignment bug: fixed.
BOOL constructor couldn't have bool objects as input: fixed.
NBC and GRAYC generated cell output even if N=1 : fixed.
Added some functions for flipping nibbles and bytes, internal bits
 and overall placing.
HORZCAT had a minor bug due to BOOL bug, fixed.
DISPLAY only showed grouping in nibbles rather than in bigger quantities:
 fixed.



EOF.