#Written by Josh Brown for CS2340.006, assignment 2, starting 9/13/22.
#NetID: JSB220001
#Written to convert ASCII digits to binary digits and calculate the sum, the number of correct 
#inputs and the number of incorrect inputs                      

    	.include	"SysCalls.asm"
	.data	
buffer:	.space	256
output:	.asciiz 	"Enter an number: \n"
em:	.asciiz 	"\nError, Invalid input\n"
sum:	.asciiz 	"\nThe sum of the numbers entered is: "                                          
enm:	.asciiz	"\nThe total number of errors entered is: "
vnm:	.asciiz 	"\nThe total number of valid numbers entered is: "

	.text
	li	$t0,0		#sum=0        	                   
	li	$t2,0 		#num errors=0 
	li	$t3,0 		#num valids=0
	li	$t8,0		#string holder	
	li	$t9,0		#character holder
redo:	
	li	$t1,0 		#accumulator=0
	li	$t4,1		#first char indicator=1
	li 	$t5,0		#negative indicator=0
	
	la 	$a0,output 	#load output: to $a0         
	li	$v0,SysPrintString
	syscall 			#print output:
	la 	$a0,buffer
	li 	$a1,256
	li 	$v0,SysReadString
	syscall 			#get String	
	move 	$t8, $a0		#load input to $t8(input)	
next:					
	lbu	$t9,($t8) 	#load char to $t9  		
	bne 	$t9,'-',nonegtv	#if char($t9) not equal to '-'($t5) jump to nonegtv:
	beq 	$t4,0,error	#if first char indicator($t4)=0 branch to error:
	li	$t5,1		#change negative indicator($t5) to 1
	addi	$t8,$t8,1		#increment pointer forward 1
	lbu	$t9,($t8) 	#load char to $t9	
nonegtv:
	beq 	$t9,'\n',nwln	#if char($t9) equal to '\n' ($t4) branch to nwln:
	li 	$t4,0		#change first char indicator($t4) to 0	
	blt 	$t9,'0',error	#if char($t9) less than '0' ($t4) branch to error:
	bgt 	$t9,'9',error	#if char($t9) greater than '9' ($t4) branch to error:
	b 	good		#branch to good:
error:				
	la 	$a0,em		#load em: to $a0
	li	$v0,SysPrintString
	syscall 			#print em:
	addi	$t2,$t2,1		#add 1 to num errors($t2)
	b 	redo		#branch to redo:		
good:
	subi   	$t9,$t9,'0'	#convert char to char num($t9)
	bne  	$t1,0,accum	#if accumulator($t1) !=0 branch to accum:
	add 	$t1,$t1,$t9	#add char num($t9) to accumulator($t1)
	addi	$t8,$t8,1		#increment pointer forward 1
	b 	next		#branch to next:
accum:
	mul 	$t1,$t1,10	#multiply accumulator($t1) by 10
	add 	$t1,$t1,$t9	#add char num($t9) to accumulator($t1)
	addi	$t8,$t8,1		#increment pointer forward 1
	b 	next		#branch to next:	
nwln:				
	beq 	$t4,1,exit	#if first char indicator($t4)=1 branch to exit
	addi	$t3,$t3,1		#add 1 to num valids($t3)
	beq  	$t5,1,negtv	#if negative indicator($t5)=1 branch to negtv:
	add 	$t0,$t0,$t1	#add accumulator($t1) to sum($t0)
	b 	redo		#branch to redo:
negtv:
	mul	$t1,$t1,-1	#multiply accumulator($t1) by -1	
	add 	$t0,$t0,$t1	#add accumulator($t1) to sum($t0)
	b 	redo		#branch to redo:
exit:		
	la 	$a0,sum		#load sum: to $a0
	li	$v0,SysPrintString
	syscall 			#print sum:	
	la 	$a0,($t0) 	#load sum value to $a0
	li	$v0,SysPrintInt
	syscall 			#print sum value
	la 	$a0,vnm		#load vnm: to $a0
	li	$v0,SysPrintString
	syscall 			#print vnm:
	la 	$a0,($t3) 	#load valid value to $a0
	li	$v0,SysPrintInt
	syscall 			#print valid value
	la 	$a0,enm		#load enm: to $a0
	li	$v0,SysPrintString
	syscall 			#print enm:
	la 	$a0,($t2) 	#load error value to $a0
	li	$v0,SysPrintInt
	syscall 			#print error value
	li	$v0,SysExit	#end program
	syscall 	

