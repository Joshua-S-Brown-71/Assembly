#Written by Josh Brown for CS2340.006, assignment 6, started 11/19/22.
#NetID: JSB220001
#Written to encrypt and decrypt files
	
    	.include	"SysCalls.asm"
	.data
	.eqv 	sizefn 	255
	.eqv 	sizek 	60
	.eqv	bufsize	1024
	
menu:	.asciiz	"\n1: Encrypt the file.\n2: Decrypt the file.\n3: Exit\n"
getfn:	.asciiz 	"\nEnter a filename\n"
errorfn:	.asciiz 	"\nError file does not exist\n"
getk:	.asciiz 	"\nEnter a key\n"
errork:	.asciiz 	"\nError key not valid\n"

filename:	.space	sizefn
regfn:	.space	sizefn
encrypfn:	.space	sizefn
decrypfn:	.space	sizefn
key:	.space	sizek
readbuf:	.space	bufsize
	.text			
dispmenu:
	li	$t1,0		#counter2($t1)=0
unfill:
	sb 	$zero,regfn($t1)	#regfn: + counter2($t1) = 0
	sb 	$zero,encrypfn($t1)	#encrypfn: + counter2($t1) = 0
	sb 	$zero,decrypfn($t1)	#decrypfn: + counter2($t1) = 0
	sb 	$zero,key($t1)	#decrypfn: + counter2($t1) = 0
	addi	$t1,$t1,1		#counter2($t1)+=1
	blt	$t1,$t0,unfill	#if counter2($t1)<counter($t0) branch to unfill:
	
	li	$t0,0		#counter($t0)=0
	li	$t2,0		#counter3($t2)=0	
	li	$t3,0		#holder1($t3)=0
	li	$t4,0		#holder2($t4)=0
	li	$t5,0		#integer input($t5)=0
	li	$t6,0		#descriptor1($t6)=0
	li	$t7,0		#descriptor2($t7)=0
	li	$t8,0		#numbytesread($t8)=0
		
    	la 	$a0,menu 		#load menu: to $a0         
	li	$v0,SysPrintString
	syscall 			#print menu:
	li 	$v0, SysReadInt
   	syscall			#get integer input 
   	move	$t5,$v0		#integer input($t5)=$v0 
   	beq  	$t5,3,exit	#if integer input($t5)==3, branch to exit:
   	beq 	$t5,1,checkfn	#if integer input($t5)==1, branch to checkfn:	
   	beq 	$t5,2,checkfn	#if integer input($t5)==2, branch to checkfn:
   	j  	dispmenu		#jump to dispmenu: 	
exit:
  	li	$v0,10		
	syscall			#exit
#_____________________________________________________________________________________________________________________	
checkfn:
	la 	$a0,getfn 	#load getfn: to $a0         
	li	$v0,SysPrintString
	syscall 			#print getfn:
	la	$a0,filename
	li	$a1,sizefn
	li	$v0,SysReadString
	syscall			#get filename:
fillfn:	
	lb	$t3,filename($t0)	#holder1($t3)=filename: + counter($t0)
	beq 	$t3,'\n',fullfn	#if holder1($t3)=='\n' brnach to fullfn:
	sb 	$t3,regfn($t0)	#regfn: + counter($t0) = holder1($t3)
	sb 	$t3,encrypfn($t0)	#encrypfn: + counter($t0) = holder1($t3)
	sb 	$t3,decrypfn($t0)	#decrypfn: + counter($t0) = holder1($t3)
	addi	$t0,$t0,1		#counter($t0)+=1
	j	fillfn		#jump to fillfn:	
fullfn:
	la	$a0,regfn	
	li	$a1,0
	li	$a2,0
	li	$v0,SysOpenFile
	syscall 			#open regfn: to read
	move	$t6,$v0		#descriptor1($t6)=regfn: file descriptor	
	bgez      $t6,checkk	#if descriptor1($t6)>=0, branch to checkk:		
	la 	$a0,errorfn 	#load errorfn: to $a0         
	li	$v0,SysPrintString
	syscall 			#print errorfn:
	j 	dispmenu		#jump to dispmenu:
#_____________________________________________________________________________________________________________________	
checkk:
	la 	$a0,($t6)		
	li	$v0, SysCloseFile		
	syscall			#close regfn:	
	la 	$a0,getk	 	#load getk: to $a0         
	li	$v0,SysPrintString
	syscall 			#print getk:	
	la	$a0,key
	li	$a1,sizek
	li	$v0,SysReadString
	syscall			#get key:	
	lb	$t4,key($zero)
	bne 	$t4,'\n',cryption	#if key(0)!='\n' branch to cryption
	la 	$a0,errork	#load errork: to $a0         
	li	$v0,SysPrintString
	syscall 			#print errork:	
	j  	dispmenu		#jump to dispmenu:	
#_____________________________________________________________________________________________________________________	
cryption:
	beq 	$t5,2,de		#if integer input($t5)==2, branch to de:
en:	
	la  	$t1,($t0)		#counter2($t1)=counter($t0)
enchangefn:	
	lb 	$t3,encrypfn($t1)	#holder1($t3)=encrypfn: + counter2($t1)
	subi	$t1,$t1,1		#counter2($t1)-=1
	bne 	$t3,'.',enchangefn	#if holder1($t3)=='.', branch to changefn:
	addi	$t1,$t1,2		#counter2($t1)+=2
	li	$t3,'e'		#holder1($t3)='e'
	sb	$t3,encrypfn($t1)	#encrypfn: + counter2($t1)=holder1($t3)
	addi	$t1,$t1,1		#counter2($t1)+=1
	li	$t3,'n'		#holder1($t3)='n'
	sb	$t3,encrypfn($t1)	#encrypfn: + counter2($t1)=holder1($t3)
	addi	$t1,$t1,1		#counter2($t1)+=1
	li	$t3,'c'		#holder1($t3)='c'
	sb	$t3,encrypfn($t1)	#encrypfn: + counter2($t1)=holder1($t3)	
	la	$a0,regfn		
	li	$a1,0
	li	$a2,0
	li	$v0,SysOpenFile
	syscall 			#open regfn: to read 
	move	$t6,$v0		#descriptor1($t6)=regfn: file descriptor	
	la	$a0,encrypfn	
	li	$a1,1
	li	$a2,0
	li	$v0,SysOpenFile
	syscall 			#open encrypfn: to write
	move	$t7,$v0		#descriptor2($t7)=encrypfn: file descriptor
enread:	
	la	$a0,($t6)		
	la	$a1,readbuf	
	li	$a2, bufsize	
	li	$v0, SysReadFile	
	syscall			#read bufsize number of characters from regfn:
	move	$t8,$v0		#numbytesread($t8)=number of bytes read
	beqz 	$t8,endone	#if numbytesread($t8)==0, branch to endone:	
	li  	$t1,0		#counter2($t1)=0
enkreset:
	li  	$t2,0		#counter3($t2)=0
enadd:	
	lb	$t3,readbuf($t1)	#holder1($t3)=readbuf: + counter2($t1)
	lb	$t4,key($t2)	#holder2($t4)=key: + counter3($t2)
	beq 	$t4,'\n',enkreset	#if holder2($t4)=='\n', branch to enkreset:
	addu 	$t3,$t3,$t4	#holder1($t3)+=holder2($t4)
	sb	$t3,readbuf($t1)	#readbuf: + counter2($t1)=holder1($t3)	
	addi	$t1,$t1,1		#counter2($t1)+=1
	addi	$t2,$t2,1		#counter3($t2)+=1
	blt	$t1,$t8,enadd	#if counter2($t1)<numbytesread($t8), branch to enadd:	
enwrite:	
	la	$a0,($t7)		
	la	$a1,readbuf	
	la	$a2,($t8)	
	li	$v0, SysWriteFile		
	syscall			#write numbytesread($t8) number of characters to encrypfn:
	j 	enread		#jump to enread:
endone:
	la	$a0,($t6)	
	li	$v0, SysCloseFile	
	syscall			#close regfn:
	la	$a0,($t7)	
	li	$v0, SysCloseFile	
	syscall			#close encrypfn:
	j 	dispmenu		#jump to dispmenu:
de:
	la  	$t1,($t0)		#counter2($t1)=counter($t0)
dechangefn:	
	lb 	$t3,decrypfn($t1)	#holder1($t3)=decrypfn: + counter2($t1)
	subi	$t1,$t1,1		#counter2($t1)-=1
	bne 	$t3,'.',dechangefn	#if holder1($t3)=='.', branch to changefn:
	addi	$t1,$t1,2		#counter2($t1)+=2
	li	$t3,'t'		#holder1($t3)='e'
	sb	$t3,decrypfn($t1)	#decrypfn: + counter2($t1)=holder1($t3)
	addi	$t1,$t1,1		#counter2($t1)+=1
	li	$t3,'x'		#holder1($t3)='n'
	sb	$t3,decrypfn($t1)	#decrypfn: + counter2($t1)=holder1($t3)
	addi	$t1,$t1,1		#counter2($t1)+=1
	li	$t3,'t'		#holder1($t3)='c'
	sb	$t3,decrypfn($t1)	#decrypfn: + counter2($t1)=holder1($t3)
	la	$a0,encrypfn		
	li	$a1,0
	li	$a2,0
	li	$v0,SysOpenFile
	syscall 			#open encrypfn: to read 
	move	$t6,$v0		#descriptor1($t6)=encrypfn: file descriptor	
	la	$a0,decrypfn	
	li	$a1,1
	li	$a2,0
	li	$v0,SysOpenFile
	syscall 			#open decrypfn: to write
	move	$t7,$v0		#descriptor2($t7)=decrypfn: file descriptor
deread:	
	la	$a0,($t6)		
	la	$a1,readbuf	
	li	$a2, bufsize	
	li	$v0, SysReadFile	
	syscall			#read bufsize number of characters from encrypfn:
	move	$t8,$v0		#numbytesread($t8)=number of bytes read
	beqz 	$t8,dedone	#if numbytesread($t8)==0, branch to dedone:	
	li  	$t1,0		#counter2($t1)=0
dekreset:
	li  	$t2,0		#counter3($t2)=0
desub:	
	lb	$t3,readbuf($t1)	#holder1($t3)=readbuf: + counter2($t1)
	lb	$t4,key($t2)	#holder2($t4)=key: + counter3($t2)
	beq 	$t4,'\n',dekreset	#if holder2($t4)=='\n', branch to dekreset:
	subu 	$t3,$t3,$t4	#holder1($t3)+=holder2($t4)
	sb	$t3,readbuf($t1)	#readbuf: + counter2($t1)=holder1($t3)	
	addi	$t1,$t1,1		#counter2($t1)+=1
	addi	$t2,$t2,1		#counter3($t2)+=1
	blt	$t1,$t8,desub	#if counter2($t1)<numbytesread($t8), branch to desub:	
dewrite:	
	la	$a0,($t7)		
	la	$a1,readbuf	
	la	$a2,($t8)	
	li	$v0, SysWriteFile		
	syscall			#write numbytesread($t8) number of characters to decrypfn:
	j 	deread		#jump to deread:
dedone:
	la	$a0,($t6)	
	li	$v0, SysCloseFile	
	syscall			#close encrypfn:
	la	$a0,($t7)	
	li	$v0, SysCloseFile	
	syscall			#close decrypfn:
	j 	dispmenu		#jump to dispmenu:

