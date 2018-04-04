section .data
lb: db 0x0A
cnt: dq 0
cnt1: dq 0
msg: db "String is a Palindrome",10
len: equ $-msg
msg2:db "String is not a Palindrome",10
len2: equ $-msg2

section .bss
str: resb 1000
rev: resb 1000

%macro print 2
	mov rax,1
	mov rdi,1
	mov rsi,%1
	mov rdx,%2
	syscall
%endmacro

%macro read 2
	mov rax,0
	mov rdi,1
	mov rsi,%1
	mov rdx,%2
	syscall
%endmacro

section .text
global _start
_start:
	read str,1000
	mov rsi,str
	dec rsi
	up:
		inc rsi
		inc qword[cnt]
		cmp byte[rsi],10
		jne up
		
	dec rsi
	dec qword[cnt]
	mov rax,qword[cnt]
	mov qword[cnt1],rax
	mov rdi,rev
	revup:
		mov cl,byte[rsi]
		mov byte[rdi],cl
		inc rdi
		dec rsi
		dec byte[cnt1]
		jnz revup
	print rev,qword[cnt]
	print lb,1
	mov rsi,str
	mov rdi,rev
	mov rax,qword[cnt]
	mov qword[cnt1],rax
	palup:
		mov cl,byte[rsi]
		cmp byte[rdi],cl
		jne notpal
		dec qword[cnt1]
		jnz palup
	print msg,len
	jmp exit
	notpal:
	print msg2,len2
	
	
	
	
	
	
	
	
	
	
	
	
	
exit:
	mov rax,60
	mov rdi,0
	syscall
