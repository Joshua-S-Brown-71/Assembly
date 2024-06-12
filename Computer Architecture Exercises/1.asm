#Written by Josh Brown for CS2340.006, assignment 1, starting 9/2/22.
#NetID: JSB220001
    
		.data	
output:		.asciiz "Enter an integer: \n"
sum:		.asciiz "\nThe sum is "
counter:	.asciiz "\nThe number of integers entered was " 
		.text
		li 	$t0, 0		#sum=0                        use li, move $t0,$0(register always contains zero)  not la 
		li	$t1, 0 		#counter=0
loop:
		la 	$a0, output 	#load output: to $a0          correct use of la
		
		li	$v0, 4
		syscall 		#print output:
		
		li 	$v0, 5
		syscall 		#get integer
		
		beqz 	$v0, end	#branch to end: if integer=0
		
		add	$t0, $t0,$v0	#add integer to sum
		addi 	$t1, $t1,1	#add integer to sum           should us addi because 1 is in instruction not already in an address
		
		b 	loop		#branch to loop:
end:
		la 	$a0, sum	#load sum: to $a0
		li	$v0, 4
		syscall 		#print sum:
		
		la 	$a0, ($t0) 	#load sum value to $a0
		li	$v0, 1
		syscall 		#print sum value
		
					
		la 	$a0, counter 	#load counter: to $a0
		li	$v0, 4
		syscall 		#print counter:
		
		la 	$a0, ($t1) 	#load counter value to $a0
		li	$v0, 1
		syscall 		#print counter value
		
		li	$v0, 10		#end program
		syscall 				
		
		
