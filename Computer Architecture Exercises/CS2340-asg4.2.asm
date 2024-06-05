#NetID: JSB220001
#Written to finotdigit all prime notuppermber before anotdigit including the input integer
	
    	.include	"SysCalls4.asm"
	.data
	.text
	.globl  removal
	.globl  conversion
removal:	
	subi	$sp, $sp,sf2
	sw	$ra, $r2($sp)	
	
	la 	$a0,ssize		#load ssize(200) to SysAlloc call
	li	$v0,SysAlloc	
	syscall			#call SysAlloc to allocate space	
	la	$t0,($v0)		#load address of allocated memory to removal string($t0)
loop1:
	lbu  	$t5,0($t9)	#character holder 1($t5)=string holder($t9) byte 
	addi 	$t9,$t9,1		#move stringholder($t9) pointer forward 1
	addi 	$t2,$t2,1		#counter($t2)+=1

	blt	$t5,'0',notdigit	#if character holder 1($t5)<'0' branch to notdigit:
	bgt	$t5,'9',notdigit	#if character holder 1($t5)>'9' branch to notdigit:
	sb  	$t5,0($t0)	#removal string($t0)+=character holder 1($t5)
	addi 	$t0,$t0,1		#move removal string($t0) index forward
	addi 	$t8,$t8,1		#add 1 to validcharcount($t8)
	b 	notlower		#branch to notlower:
notdigit:
	blt	$t5,'A',notupper	#if character holder 1($t5)<'A' branch to notupper:
	bgt	$t5,'Z',notupper	#if character holder 1($t5)>'Z' branch to notupper:
	sb 	$t5,0($t0)	#removal string($t0)+=character holder 1($t5)
	addi 	$t0,$t0,1		#move removal string($t0) index forward
	addi 	$t8,$t8,1		#add 1 to validcharcount($t8)
	b 	notlower		#branch to notlower:
notupper:
	blt	$t5,'a',notlower	#if character holder 1($t5)<'a' branch to notlower:
	bgt	$t5,'z',notlower	#if character holder 1($t5)>'z' branch to notlower:
	sb 	$t5,0($t0)	#removal string($t0)+=character holder 1($t5)
	addi 	$t0,$t0,1		#move removal string($t0) index forward
	addi 	$t8,$t8,1		#add 1 to validcharcount($t8)
notlower:
	blt  	$t2,ssize,loop1	#if counter($t2)<ssize(200) branch to loop1:
	
	sub 	$t0,$t0,$t8	#move pointer to begnning of removal string($t0)
	li	$t2,0		#counter($t2)=0
	
	jal 	conversion
	
	li	$t2,0
	lw	$ra, $r2($sp)
	addi	$sp, $sp, sf2
	jr	$ra
conversion:	
	subi	$sp, $sp, sf3
	sw	$ra, $r3($sp)
	
	la 	$a0,ssize		#load ssize(200) to SysAlloc call
	li	$v0,SysAlloc	
	syscall			#call SysAlloc to allocate space	
	la	$t1,($v0)		#load address of allocated memory to conversion string($t1)
loop2:
	lbu 	$t5,0($t0)
	blt	$t5,'a',nextchar	#if character holder 1($t5)<'a' branch to nextchar:
	bgt	$t5,'z',nextchar	#if character holder 1($t5)>'z' branch to nextchar:
	subi   	$t5,$t5,upcon	#character holder 1($t5)-=upcon(32)
	sb 	$t5,0($t1)	#conversion string($t1)+=character holder 1($t5)
	addi 	$t1,$t1,1		#move conversion string($t1) index forward
nextchar:
	addi 	$t0,$t0,1		#move removal string($t0) index forward
	addi 	$t2,$t2,1		#counter($t2)+=1
	blt  	$t2,$t8,loop2	#if counter($t2)<validcharcount($t8) branch to loop2
	
	sub	$t1,$t1,$t8	#move pointer to begnning of conversion string($t1)

	lw	$ra, $r3($sp)
	addi	$sp, $sp, sf3
	jr	$ra
	
