#Written by Josh Brown for CS2340.006, assignment 5, started 10/26/22.
#NetID: JSB220001
#Written to 
	
    	.include	"SysCalls.asm"
	.eqv	var1	0
	.eqv	var2	8
	.eqv 	forward	8
	.eqv	asize	800	
	.data
filename:	.asciiz 	"textfile.txt"
fileoutput:.asciiz  "Testing Testing Testing\n"
fileinput:.space	256
	.text	
main:

	
	
	
	la	$a0,filename 	#open to write
	li	$a1,1
	li	$a2,0
	li	$v0,13
	syscall 
	move	$t1,$v0
	
	move	$a0,$t1		#write fileoutput: to file
	la	$a1,fileoutput
	li	$a2,100
	li	$v0,15
	syscall
	
	move	$a0,$t1		#close file
	li	$v0,16
	syscall
	
	la	$a0,filename	#open to read
	li	$a1,0
	li	$a2,0
	li	$v0,13
	syscall 
	move	$t1,$v0
	
	move	$a0,$t1		#read file and put in fileinput: space
	la	$a1,fileinput
	li	$a2,256
	li	$v0,14
	syscall	
	
	la	$a0,fileinput	#print fileinput: space
	li	$v0,4
	syscall
	
	move	$a0,$t1		#close file
	li	$v0,16
	syscall
	
	li	$v0,10		#exit
	syscall

