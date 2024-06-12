#Written by Josh Brown for CS2340.006, assignment 3, starting 10/1/22.
#NetID: JSB220001
#Written to find all prime number before and including the input integer
	
    	.include	"SysCalls4.asm"
	.data

buffer:	.space	ssize
output:	.asciiz 	"Enter an a string\n"
palin:	.asciiz 	"\nThe string is a palindrome\n"
nonpalin:	.asciiz 	"\nThe string is not a palindrome\n"
	.text
	.globl 	main
	li	$t0,0		#removal string($t0)=0
	li	$t1,0		#conversion string($t1)=0
	li	$t2,0		#counter($t2)=0
	li	$t3,0		#counter stop($t3)=0
	li	$t5,0		#character holder 1($t5)=0
	li	$t6,0		#character holder 2($t6)=0
	li	$t7,0		#ch2 get($t7)
	li	$t8,0		#validcharcount($t8)=0
	li	$t9,0		#string holder($t9)=0
main:	
	la 	$a0,output 	#load output: to $a0         
	li	$v0,SysPrintString
	syscall 			#print output:
	la 	$a0,buffer
	li 	$a1,ssize
	li 	$v0,SysReadString
	syscall 			#get String
	move 	$t9,$a0		#put string into string holder($t9)
	lbu	$t5,0($t9)	#character holder 1($t5)=string holder($t9) byte 
	beq	$t5,'\n',exit	#if character holder 1($t5)='\n' branch to exit:
	jal	palindrome	#jump to palindrome: 
exit:	
	li	$v0,SysExit	#end program
	syscall 	
	
palindrome:	
	subi 	$sp, $sp,sf1	
	sw	$ra, $r1($sp)	

	jal	removal		#jump to removal:
	
	srl 	$t3,$t8,1		#counter stop($3)=validcharcount($t8)/2
	sub	$t7,$t8,$t2	#ch2 get($t7)=validcharcount($t8)-counter($t2)
loop:
	add  	$t1,$t1,$t2	#move string pointer($t1) forward counter($t2) times
	lbu	$t5,0($t1)	#character holder 1($t5)=conversion string($t1) byte 
	sub 	$t1,$t1,$t2	#move string pointer($t1) backward counter($t2) times
	
	add 	$t1,$t1,$t7	#move string pointer($t1) forward ch2 get($t7) times
	lbu	$t6,0($t1)	#character holder 2($t6)=conversion string($t1) byte 
	sub 	$t1,$t1,$t7	#move string pointer($t1) backward ch2 get($t7) times
	
	bne 	$t5,$t6,donenp	#if character holder 1($t5)!=character holder 2($t6) branch to donenp:
	
	addi 	$t2,$t2,1		#counter($t2)+=1
	subi	$t7,$t7,1		#ch2 get($t7)-=1

	ble  	$t2,$t3,loop	#if counter($t2)<counter stop($3) branch to loop:
	
	la 	$a0,palin 	#load palin: to $a0         
	li	$v0,SysPrintString
	syscall 			#print output:
	b 	done		#branch to done:
donenp:
	la 	$a0,nonpalin 	#load nonpalin: to $a0         
	li	$v0,SysPrintString
	syscall 			#print output:
done:
	lw	$ra, $r1($sp)
	addi	$sp, $sp, sf1
	jr	$ra

