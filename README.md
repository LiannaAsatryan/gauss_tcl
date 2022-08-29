#What this project does
 This project solves the given system of linear equations using Gauss-elimination method

#files
 in this directory there are following files
* input.txt __ it is the file where our matrix example is written like this

	        size
		
	        ________
               |       |
               |matrix |
               |_______|


* golden.txt __ it is the file where our correct answer is located
* gauss_functions.tcl __ this file contains the functions which solve our main problem (gauss_ forward, gauss_backward, gauss and other related functions) 
* gauss_test.tcl __ this file  contains the operation of the testing 
* main.tcl __ this file solves the main problem(without testing)
 the files that will be generated are 
*output.txt__here result-values are written
*result.txt__here test results are written(test passed or not)




#description
My project solves the system of linear equations
If a letter is typed in place of number, or a wrong size is typed the answer is "wrong imput"
And finally, when our system has solution the answer is written like this   "sol1 sol2 sol3 ... soln"
NOTE: in my output and golden files the solutions are written in 4 precision



#to run the main program type in command line
 tclsh main.tcl
to clean the generated files type 
 rm output.txt


#to run the test type in command line
 tclsh gauss_test.tcl
to clean the generated files type 
 rm output.txt result.txt
