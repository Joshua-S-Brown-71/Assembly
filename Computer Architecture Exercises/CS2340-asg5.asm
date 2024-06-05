#Written by Josh Brown for CS2340.006, assignment 5, started 10/26/22.
#NetID: JSB220001
#Written to take multiple floating point inputs, sort them from smallest to largest, 
#	and calculate and output the count of inputs, sum, and average
	
    	.include	"SysCalls.asm"
	.eqv	var1	0
	.eqv	var2	8
	.eqv 	forward	8
	.eqv	asize	800	
	.data
getinput:	.asciiz 	"Enter an a double precision number\n"
newline:	.asciiz 	"\n"
size:	.asciiz	"Count of numbers entered: "
sum:	.asciiz	"Sum: "
average:	.asciiz	"Average: "
	.text	
main:
	la 	$t0,($zero) 	#holder address1($t0)=0
	la 	$t1,($zero) 	#holder address2($t1)=0
	la 	$t2,($zero) 	#size.w($t2)=0
	la	$t3,($zero)	#counter($t3)=0
	la	$t7,($zero)	#sortflag($t7)=0, 0=not sorted, 1=sorted without swap, 2=sorted with swap
	mtc1.d   	$zero,$f30	#zero holder($f30)=0
	mtc1.d	$zero,$f28 	#sum($f28)=0
	mtc1.d 	$zero,$f26 	#average($f26)=0	
	mtc1.d 	$zero,$f24 	#size.d($f24)=0
	mtc1.d 	$zero,$f22	#temp1($f22)=0
	mtc1.d 	$zero,$f20	#temp2($f20)=0
	mtc1.d  	$zero,$f18	#temp3($f18)=0
	
	la 	$a0,asize		#load asize(800) to SysAlloc call
	li	$v0,SysAlloc	
	syscall			#call SysAlloc to allocate space	
	la	$t0,($v0)		#holder address1($t0)=address of allocated memory 
	add	$t1,$t0,$zero	#holder address2($t1)=address of allocated memory  
loop:
    	la 	$a0,getinput 	#load getinput: to $a0         
	li	$v0,SysPrintString
	syscall 			#print getinput:
  	li 	$v0, SysReadDouble
   	syscall			#get double precision input 
   	c.eq.d  	1,$f0,$f30 	
   	bc1t   	1,done		#if double precision input=zero holder($f30) branch to done:
   	sdc1	$f0,0($t0)  	#store double precision input into holder address1($t0)
   	addi 	$t0,$t0, forward  	#move holder address1($t0) pointer forward 8 bytes
	add.d   	$f28,$f28,$f0	#sum($f28)+=double precision input
  	addi 	$t2,$t2,1   	#size.w($t2)+=1
 	b 	loop		#branch to loop:
done:
	mtc1.d 	$t2,$f24 		#size.d($f24)=size.w($t2)
	cvt.d.w 	$f24,$f24		#convert size.d($f24) from word to double
	div.d 	$f26,$f28,$f24	#average($f26)=sum($f28)/size.d($f24)
	add	$t0,$t1,$zero	#set holder address1($t0) pointer to beginning
	move 	$a0,$t2		#argument($a0)=size.w($t2) 
	jal	Sorting		#jump to Sorting: 
	move 	$a0,$t2		#argument($a0)=size.w($t2)		
	jal	Printing		#jump to Printing:
exit:	
	li	$v0,SysExit	#end program
	syscall 	
	
Sorting:	
	move 	$t2,$a0		#size.w($t2)=argument($a0)			
startover:
	beq  	$t7,1,done2	#if sortflag($t7)=1 branch to done2: 
	li	$t3,2		#counter($t3)=2
	li	$t7,0		#sortflag($t7)=0
	add	$t0,$t1,$zero	#set holder address1($t0) pointer to beginning
loop2:
	bgt  	$t3,$t2,startover	#if counter($t3)>size.w($t2)
	ldc1   	$f22,var1($t0)	#temp1($f22)=double precision input 
	ldc1  	$f20,var2($t0)	#temp2($f20)=double precision input
	c.lt.d    1,$f20,$f22 	
   	bc1t   	1,swap		#if temp2($f20)<temp1($f22) then branch to swap:
   	beq 	$t7,2,increment	#if sortflag($t7)=2 branch to increment:
	li	$t7,1		#sortflag($t7)=1
	b	increment		#branch to increment:
swap:
	li	$t7,2		#sortflag($t7)=2
	mov.d    	$f18,$f22		#temp3($f18)=temp1($f22)
	mov.d	$f22,$f20		#temp1($f22)=temp2($f20)
	mov.d	$f20,$f18		#temp2($f20)=temp3($f18)
	sdc1	$f22,var1($t0)  	#store temp1($f22) into holder address1($t0)
	sdc1 	$f20,var2($t0)  	#store temp2($f20) into holder address1($t0)
increment:
	add  	$t0,$t0,forward	#move holder address1($t0) pointer forward 8 bytes
	addi	$t3,$t3,1		#counter($t3)+=1
	b 	loop2		#branch to loop2:
done2:
	add	$t0,$t1,$zero	#set holder address1($t0) pointer to beginning
	li	$t3,0		#counter($t3)=0
	jr	$ra
	
Printing:	
	move 	$t2,$a0		#size.w($t2)=argument($a0)		
loop3:
	bge  	$t3,$t2,done3	#if counter($t3)>=size.w($t2) branch to done3:	
	la 	$a0,newline 	#load newline: to $a0         
	li	$v0,SysPrintString
	syscall 			#print newline:	
	ldc1	$f12,0($t1)  	#load double precision input to $f12
  	li 	$v0,SysPrintDouble
   	syscall			#print double precision input
  	addi 	$t3,$t3,1   	#counter++
  	addi 	$t1,$t1,forward  	#move holder address2($t1) pointer forward 8 bytes	
 	b 	loop3		#branch to loop3:
done3:
	la 	$a0,newline 	#load newline: to $a0         
	li	$v0,SysPrintString
	syscall 			#print newline	
	la 	$a0,size		#load size: to $a0
	li	$v0,SysPrintString
	syscall 			#print size:	
	la 	$a0,($t2) 	#load size.w($t2) to $a0
	li	$v0,SysPrintInt
	syscall 			#print size.w($t2)
	la 	$a0,newline 	#load newline: to $a0         
	li	$v0,SysPrintString
	syscall 			#print newline
	la 	$a0,sum		#load sum: to $a0
	li	$v0,SysPrintString
	syscall 			#print sum:	
	mov.d 	$f12,$f28  	#load sum($f28) to $f12
  	li 	$v0, SysPrintDouble
   	syscall			#print sum($f28)			
	la 	$a0,newline 	#load newline: to $a0         
	li	$v0,SysPrintString
	syscall 			#print newline
	la 	$a0,average	#load average: to $a0
	li	$v0,SysPrintString
	syscall 			#print average:	
	mov.d 	$f12,$f26  	#load average($f26) to $f12
  	li 	$v0, SysPrintDouble
   	syscall			#print average($f26)	
	jr	$ra
	

	


