#!usr/bin/tclsh

#this function writes the given data in the given file
proc write_data { file_name output_data } {
        set fp [open $file_name w+]
        puts $fp $output_data
        close $fp
}
#this function reads data from the given file and returns that
proc read_data { file_name } {
        set fp [open $file_name]
        set file_data [read $fp]
        close $fp
        return $file_data
}


#this function deletes the generated files
proc clean_files {} {
        file delete -force "output.txt"
        file delete -force "result.txt"
}


#this function reads the matrix from the given file and returns it
proc read_matrix { input_file } {
        set input [open $input_file r]
	#set rows [gets $input]
	while { [gets $input line] >= 0 } {
    		lappend matrix [split $line " "]
	}
	close $input
	return $matrix
}

#this function checks whether all the inputs in the input_file are real numbers
#if they are, the function returns true, and returns false otherwise
proc check_input {} {
        set m [read_matrix "input.txt"]
	if {![string is int [lindex $m 0]]} {
		return false
	}
	set rows [lindex $m 0]
	for {set i 1} {$i < $rows} {incr i} {
		for {set j 0} {$j < $rows} {incr j} {
			if {![string is double [lindex $m $i $j]]} {
				return false
			}
                }
	}
        return true
}


#this function adds the i-th row d*(j-th row)
proc  mull_add { matrix rows i j d } {
        for {set k 0} {$k < $rows + 1} {incr k} {
                set t [expr {$d * [lindex $matrix $j $k]}]
                lset matrix $i $k [expr {[lindex $matrix $i $k] + $t}]
        }
	return $matrix
}


proc swap_with_nonzero_row { matrix i rows} {
        for {set j [expr $i +1]} {$j < $rows} {incr j} {
        	if { [lindex $matrix $i $j] != 0 } {
                        for {set k 0} {$k < [expr $rows + 1]} {incr k} {
                                set temp [lindex $matrix $i $k]
				lset $matrix $i $k [lindex $matrix $j $k]
				lset $matrix $j $k $temp
                        }
                        break
                }
        }
	return $matrix
}


#this function returns true if there are more than <n> digits after the point in the <num>
proc precision { num n } {
        set p 1
        for {set i 0} {$i<$n} {incr i} {
                set p [expr {$p*10}]
        }
        #p=10^n
        set d [expr {$num * $p }]
        if { [expr {abs($d)}] > [expr {abs(int($d))}] } {
                return true
        } else { return false }
}



#this function corrects the numeric data so that we don't have num.0
#and if the number of digits after the point are more than 4(in this case)
#the function sets its precision to 4
proc correct_data { res } {
        #to avoid the num.0 case
        if { $res == [expr int($res)]} { return [expr int($res)]}
        #setting the precision if it is necessary
        if { [precision $res 4] } {
                return [format {%.4f} $res]
        }
        return $res
}

#this function receives the matrix as a parameter and performs gauss forward elimination
proc gauss_forward { matrix } {
        set rows [lindex $matrix 0 0]
        for {set j 1} {$j < [expr {$rows - 1}]} {incr j} {
                if {[lindex $matrix $j [expr $j - 1]] != 0} {
                        for {set i [expr {$j +1}]} {$i <= $rows} {incr i} {
                                set m  [expr -[lindex $matrix $i [expr $j - 1]]]
                                set d  [expr {1.0 * $m / [lindex $matrix $j [expr $j - 1]]}]
                                set matrix [mull_add $matrix $rows $i $j $d]

                        }
                } else { set matrix [swap_with_nonzero_row $matrix $j $rows] }
        }
        return $matrix
}



#this function receives the matrix, performs gauss backward elimination
#and returns the array of the solutions
proc gauss_backward { matrix } {
        set rows [lindex $matrix 0 0]
        for {set i 0} {$i < $rows} {incr i} {
                lappend solutions 0
        }
	for {set i $rows} {$i > 0} {incr i -1} {
                set sum 0.0
		for {set j $i} {$j < $rows } {incr j} {
			set sum [expr $sum + 1.0 * [lindex $matrix $i $j] * [lindex $solutions $j]]
			# puts $sum

                }
		set p [expr 1.0 *  [lindex $matrix $i $rows] - $sum]
		lset solutions [expr $i - 1] [correct_data [expr 1.0* $p / [expr 1.0 * [lindex $matrix $i [expr $i - 1]]]]]
        }
	return $solutions
}


proc gauss { matrix } {
	set matrix [gauss_forward $matrix]
	return [gauss_backward $matrix]
}






