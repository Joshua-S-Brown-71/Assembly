#CS2340 Fall 2022
#In-Class Exercise
#Write a program to decompose the parts of a single-precision floating point number and show them as integers.
#Ask the user for a number.  If it is 0, exit.  Otherwise, show the sign (positive or negative, the exponent, whether the exponent is positive or negative, and the fraction.  Use only logical and integer arithmetic operations to do this.  Here is your starting code.

	.include	"SysCalls.asm"
	.data
float:	.float	0			# For saving the input
zero:	.float	0.0			# for comparison
prompt: .asciiz	"Enter a floating-point number or 0 to exit: "
pos:	.asciiz	"Positive\n"
neg:	.asciiz	"Negative\n"
exp:	.asciiz	"Exponent: "
frac:	.asciiz	"Fraction: "
	.text
	.globl	main
main:	la	$a0, prompt		# Ask for a number

	jal	display

	li	$v0, SysReadFloat		# Read a floating-point number
	syscall

	lwc1	$f1, zero			

	c.eq.s	$f0, $f1			# Exit if zero

	bc1t	exit
	swc1 	$f0,float
	lw 	$t0,float
	bltz	$t0,main5
	la 	$a0,pos
	jal	display
	b 	main7


#Fill in your code here

exit:	li	$v0, SysExit
	syscall

display:	li	$v0, SysPrintString
	syscall	

	jr	$ra

