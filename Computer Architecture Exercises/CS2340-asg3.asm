#Written by Josh Brown for CS2340.006, assignment 3, starting 10/1/22.
#NetID: JSB220001
#Written to find all prime number before and including the input integer

    	.include	"SysCalls.asm"
	.data	
output:	.asciiz 	"Enter an number between 3 and 160,000: \n"
em:	.asciiz 	"\nError, Invalid input\n"
	.text
tryagain:
	li	$t0,0		#counter=0
	li	$t1,0		#modulus=0
	li	$t2,0		#remainder=0
	li 	$t3,0		#bmend=0
	li	$t4,0		#bitmultiple=0
	li        $t5,1		#mask (0000 0001)
	li	$t6,0		#tempholder=0
	li	$t7,0xFF		#0xFF=(1111 1111)
	li	$t8,0		#inputnum=0  
	li	$t9,0		#totaltotalbitholder=0
	
	la 	$a0,output 	#load output: to $a0         
	li	$v0,SysPrintString
	syscall 			#print output:
	li 	$v0,SysReadInt
	syscall 			#get input integer	
	move 	$t8, $v0		#load input integer to inputnum($t8)	
	bgt  	$t8,160000,error	#if inputnum($t8)>160000 branch to error:
	blt 	$t8,3,error	#if inputnum($t8)<2 branch to error:
	b	good		#branch to good:
error:	
	la 	$a0,em		#load em: to $a0
	li	$v0,SysPrintString
	syscall 			#print em: (error message)
	b 	tryagain		#branch to tryagain:
good: 	
	srl 	$t1,$t8,3		#modulus($t1)=inputnum($t8)/8 
	andi 	$t2,$t8,7		#remainder($t2)=AND inputnum($t8) with 7(0111) 
	beq 	$t2,0,divisible8	#if remainder($t2)=0 branch to divisible8:
	addi	$t1,$t1,1		#if remainder($t2)!=0 add 1 to modulus($t1)
divisible8: 
	li 	$t2,0		#remainder($t2)=0
	srl 	$t3,$t8,1		#bmend($t3)=inputnum($t8)/2 
	andi 	$t2,$t8,1		#remainder($t2)=AND inputnum($t8) with 1(0001) 
	beq  	$t2,0,divisible2	#if remainder($t2)=0 then branch to divisible2:
	addi	$t3,$t3,1		#if remainder($t2)!=0 add 1 to bmend($t3)
divisible2: 
	la 	$a0,($t1)		#load modulus($t1) to SysAlloc call
	li	$v0, SysAlloc	
	syscall			#call SysAlloc to allocate space	
	la	$t9,($v0)		#load address of allocated memory to totalbitholder($t9)
fill:	
	sb 	$t7,0($t9)	#store 0xFF($t7) into byte of totalbitholder($t9)
	addi	$t9,$t9,1		#increment pointer forward 1 to next byte
	addi	$t0,$t0,1		#increment counter($t0) 1
	blt  	$t0,$t1,fill	#if counter($t0)<modulus($t1) branch to fill:
	sub	$t9,$t9,$t1	#move pointer back to beginning of totalbitholder($t9)
	li	$t0,2		#counter($t0)=2
	li	$t4,2		#bitmultiple($t4)=2
turnoff:
	li	$t1,0		#modulus($t1)=0
	li	$t2,0		#remainder($t2)=0	
	add	$t0,$t0,$t4	#add bitmultiple($t4) to counter($t0) 
	bgt  	$t0,$t8,add1bm	#if counter($t0)>inputnum($t8) branch to add1bm:
	srl 	$t1,$t0,3		#modulus($t1)=counter($t0)/8  
	andi 	$t2,$t0,7		#remainder($t2)=AND counter($t0) with 7(0111) 
	add 	$t9,$t9,$t1	#move totalbitholder($t9) pointer foward modulus($t1) number of times
	lb 	$t6,0($t9)	#load byte into tempholder($t6)
	sllv 	$t5,$t5,$t2	#shift mask remainder($t2) number of times to the left
	not  	$t5,$t5		#convert mask from 0000 0001 to 1111 1110
	and	$t6,$t6,$t5	#use mask to turn bit off
	not  	$t5,$t5		#convert mask from 1111 1110 to 0000 0001
	srlv	$t5,$t5,$t2  	#shift mask back to original position (0000 0001)
	sb  	$t6,0($t9)	#store byte back into totalbitholder($t9)
	sub 	$t9,$t9,$t1	#move totalbitholder($t9) pointer back to beginning of address
	b	turnoff		#branch to turnoff:
add1bm:	
	addi	$t4,$t4,1		#increment bitmultiple($t4) by 1
	bgt	$t4,$t3,todone	#if bitmultiple($t4)>bmend($t3) branch to todone:
	la	$t0,($t4)		#counter($t0)=bitmultiple($t4)
	b	turnoff		#branch to turnoff:
todone:	
	li	$t0,2		#counter($t0)=2
printprime:
	li	$t1,0		#modulus($t1)=0
	li	$t2,0		#remainder($t2)=0	
	li	$t6,0		#tempholder($t6)=0
	srl 	$t1,$t0,3		#modulus($t1)=counter($t0)/8  
	andi 	$t2,$t0,7		#remainder($t2)=AND counter($t0) with 7(0111) 
	add 	$t9,$t9,$t1	#move totalbitholder($t9) pointer foward modulus($t1) number of times
	lb 	$t6,0($t9)	#load byte into tempholder($t6)
	sllv 	$t5,$t5,$t2	#shift mask remainder($t2) number of times to the left
	and	$t6,$t6,$t5	#use mask to turn bit off
	beqz  	$t6,dontprint	#if tempholder($t6)=0 branch to dontprint:
	la	$a0,($t0)		#load counter($t0) to $a0
	li	$v0,SysPrintInt	
	syscall			#print counter($t0)
	la	$a0,' '		#load space to $a0
	li	$v0,SysPrintChar
	syscall			#print space
dontprint:
	srlv	$t5,$t5,$t2  	#shift mask back to original position (0000 0001)
	sub 	$t9,$t9,$t1	#move totalbitholder pointer back to beginning of address
	addi 	$t0,$t0,1		#increment counter 1	
	bgt	$t0,$t8,exit	#if counter($t0)>inputnum($t8) branc to exit:
	b	printprime	#branch to printprime:	
exit:	
	li	$v0,SysExit	#end program
	syscall 	

