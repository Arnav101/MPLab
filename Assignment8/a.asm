section .data
fd: dq 0
fd1: dq 0
lb: db 0x0A
errm: db "Error opening file",0x0A
cnt: dq 00
cnt1: dq 00
cnt2: dq 00
tmp: db 0

section .bss
cntx resb 1
choice: resb 2
a: resb 3
c: resb 4
buf: resb 1000
buf_len: resq 1
buf_len1: resq 1
ans: resq 1
fname: resb 100
fname1: resb 100

%macro print 3
	mov rax,1
	mov rdi,%1
	mov rsi,%2
	mov rdx,%3
	syscall
%endmacro

%macro read 3
	mov rax,0
	mov rdi,%1
	mov rsi,%2
	mov rdx,%3
	syscall
%endmacro

%macro open 2
	mov rax,2
	mov rdi,%1
	mov rsi,%2
	mov rdx,0x0777
	syscall
%endmacro

%macro close 1
	mov rax,3
	mov rdi,%1
	syscall
%endmacro

%macro delete 1
	mov rax,87
	mov rdi,%1
	syscall
%endmacro

section .text
global _start
_start:
	pop rsi
	pop rsi
	pop rsi
	
	cmp byte[rsi],'t'
	je type
	cmp byte[rsi],'T'
	je type
	cmp byte[rsi],'c'
	je copy
	cmp byte[rsi],'C'
	je copy
	cmp byte[rsi],'d'
	je del
	cmp byte[rsi],'D'
	je del
	
type:
	pop rsi
	mov rdi,fname
	dec rsi
	dec rdi
	typeup:
		inc rsi
		inc rdi
		mov al,byte[rsi]
		mov byte[rdi],al
		cmp byte[rdi],0
		jne typeup
	open fname,2
	bt rax,63
	jc err
	mov qword[fd],rax
	read [fd],buf,1000
	mov qword[buf_len],rax
	print 1,buf,qword[buf_len]
	close [fd]
jmp exit

copy:
	pop rsi
	mov rdi,fname
	dec rsi
	dec rdi
	copyup:
		inc rsi
		inc rdi
		mov al,byte[rsi]
		mov byte[rdi],al
		cmp byte[rdi],0
		jne copyup
	open fname,2
	bt rax,63
	jc err
	mov qword[fd],rax
	read [fd],buf,1000
	mov qword[buf_len],rax
	pop rsi
	mov rdi,fname1
	dec rsi
	dec rdi
	copyup1:
		inc rsi
		inc rdi
		mov al,byte[rsi]
		mov byte[rdi],al
		cmp byte[rdi],0
		jne copyup1
	open fname1,2
	bt rax,63
	jc err
	mov qword[fd1],rax
	print [fd1],buf,qword[buf_len]
	close [fd]
	close [fd1]
jmp exit

del:
	pop rsi
	mov rdi,fname
	dec rsi
	dec rdi
	delup:
		inc rsi
		inc rdi
		mov al,byte[rsi]
		mov byte[rdi],al
		cmp byte[rdi],0
		jne delup
	delete fname
jmp exit
	
err:
	print 1,errm,19
	jmp exit

exit:
	mov rax,60
	mov rdi,0
	syscall
