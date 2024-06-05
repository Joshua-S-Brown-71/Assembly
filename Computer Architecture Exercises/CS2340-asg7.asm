#Written by Josh Brown for CS2340.006, assignment 7, started 11/30/22.
#NetID: JSB220001
#Written to validate passwords
	
    	.include	"SysCalls.asm"
	.data

	.eqv 	sizepw 	100
	.eqv	spacepw	255
	.eqv	reqmax	50
	.eqv	reqmin	12
	
getpw:	 .asciiz	"\nEnter a Password\n"
validate:	 .asciiz 	"\nValid Password\n"
invalidate:.asciiz 	"\nInvalid Password\n"

pw:	.space	spacepw

	.text			
disp:		
	li	$t1,0		#maincounter($t0)=0
unfill:
	sb 	$zero,pw($t1)	
	addi	$t1,$t1,1		#counter2($t1)+=1
	blt	$t1,spacepw,unfill	#if counter2($t1)<counter($t0) branch to unfill:
	
	li	$t0,0		#counter2($t1)=0
	li	$t1,0		#maincounter($t0)=0
	li	$t4,0		#holder1($t4)=0
	li	$t5,0		#upper($t5)=0
	li	$t6,0		#lower($t6)=0
	li	$t7,0		#digit($t7)=0
	li	$t8,0		#special($t8)=0

	
    	la 	$a0,getpw 	#load getpw: to $a0         
	li	$v0,SysPrintString
	syscall 			#print getpw:
	la	$a0,pw
	li	$a1,sizepw
	li 	$v0,SysReadString
   	syscall			#get password 
 
	lb 	$t4,pw		#holder1($t4)=pw(0)
   	beq  	$t4,'\n',exit	#if holder1($t4)=='\n', branch to exit:
   	b  	length		#jump to length: 	
exit:
  	li	$v0,10		
	syscall			#exit
#_____________________________________________________________________________________________________________________	
length:
	lb 	$t4,pw($t1)	#holder1($t4)=pw(counter2($t1)
	addi	$t0,$t0,1		#maincounter($t0)+=1
	addi	$t1,$t1,1		#maincounter($t0)+=1
	bne	$t4,'\n',length	#if maincounter($t0)!='\n', branch to length:
	subi	$t0,$t0,1		#maincounter($t0)+=1
	bgt 	$t0,reqmax,invalid	#required max($t2)
	blt 	$t0,reqmin,invalid	#required min($t3)
#_____________________________________________________________________________________________________________________		
	li	$t1,0		#counter2($t1)=0
check:
	lb 	$t4,pw($t1)	#holder1($t4)=pw(counter2($t1)
	addi	$t1,$t1,1
	jal	upper
	jal	lower
	jal	digit
	jal	special
	jal 	illegal
	blt	$t1,$t0,check
	blt	$t5,1,invalid
	blt	$t6,1,invalid
	blt	$t7,1,invalid
	blt	$t8,1,invalid
	la 	$a0,validate	#load valid: to $a0         
	li	$v0,SysPrintString
	syscall 			#print valid:
	b 	disp
#_____________________________________________________________________________________________________________________		
upper:	
	blt	$t4,'A',doneu
	bgt	$t4,'Z',doneu
	addi	$t5,$t5,1	
doneu:
	jr	$ra
#_____________________________________________________________________________________________________________________		
lower:	
	blt	$t4,'a',donel
	bgt	$t4,'z',donel
	addi	$t6,$t6,1	
donel:
	jr	$ra
#_____________________________________________________________________________________________________________________		
digit:	
	blt	$t4,'0',doned
	bgt	$t4,'9',doned
	addi	$t7,$t7,1	
doned:
	jr	$ra
#_____________________________________________________________________________________________________________________		
special:	
	beq	$t4,'!',adds
	beq	$t4,'@',adds
	beq	$t4,'#',adds
	beq	$t4,'$',adds
	beq	$t4,'%',adds
	beq	$t4,'^',adds
	beq	$t4,'&',adds
	beq	$t4,'(',adds
	beq	$t4,')',adds
	beq	$t4,'[',adds
	beq	$t4,']',adds
	beq	$t4,',',adds
	beq	$t4,'.',adds
	beq	$t4,':',adds
	beq	$t4,';',adds
	b	dones
adds:
	addi	$t8,$t8,1	
dones:
	jr	$ra
#_____________________________________________________________________________________________________________________		
illegal:	
	blt	$t4,'!',invalid
	bgt	$t4,'z',invalid
	beq	$t4,'"',invalid
	beq	$t4,'\'',invalid
	beq	$t4,'*',invalid
	beq	$t4,'+',invalid
	beq	$t4,'-',invalid
	beq	$t4,'/',invalid
	beq	$t4,'<',invalid
	beq	$t4,'=',invalid
	beq	$t4,'>',invalid
	beq	$t4,'?',invalid
	beq	$t4,'\\',invalid
	beq	$t4,'_',invalid
	beq	$t4,'`',invalid
	jr	$ra
#_____________________________________________________________________________________________________________________		
invalid:	
	la 	$a0,invalidate 	#load invalid: to $a0         
	li	$v0,SysPrintString
	syscall 			#print invalid:
	b	disp
