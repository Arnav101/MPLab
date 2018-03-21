section .data
fd: dq 0
fd1: dq 0
lb: db 0x0A
fname: db 'file.txt',0
fname1: db 'sorted.txt',0
errm: db "Error opening file",0x0A
cnt: dq 00
cnt1: dq 00
cnt2: dq 00
tmp: db 0

inv: db "Invalid",0x0A
linv: equ $-inv
msg: db "Inv",0x0A
menu: db 0x0A, "  Menu", 0x0A
	  db "1) Ascending", 0x0A
	  db "2) Descending", 0x0A
	  db "3) Exit", 0x0A
len: equ $-menu

section .bss
cntx resb 1
choice: resb 2
a: resb 3
c: resb 4
buf: resb 1000
buf_len: resq 1
buf_len1: resq 1
ans: resq 1

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

section .text
global _start
_start:
	open fname,2
	bt rax,63
	jc err
	mov qword[fd],rax
	open fname1,2
	bt rax,63
	jc err
	mov qword[fd1],rax
	print 1,menu,len
	read 1,choice,2
	cmp byte[choice],0x31
	je asc
	cmp byte[choice],0x32
	je des
	cmp byte[choice],0x33
	je exit
	print 1,inv,linv
	jmp _start
	
asc:
	read [fd],buf,1000
	mov qword[buf_len1],rax
	dec qword[buf_len1]
		cmp byte[tmp],0
		jne ascfront
		mov byte[tmp],1
		mov rax,qword[buf_len1]
		mov qword[buf_len],rax
	ascfront:
	print 1,buf,qword[buf_len]
	print 1,lb,1
	mov rsi,buf
	mov rcx,qword[buf_len]
	mov qword[cnt],rcx
	ascup1:
		mov rdi,rsi
		mov rcx,qword[cnt]
		mov qword[cnt1],rcx
		dec qword[cnt1]
		jz ascend
		inc rdi
		ascup2:
			mov cl,byte[rdi]
			cmp byte[rsi],cl
			jbe ascnext
			call swap
			ascnext:
				inc rdi
				dec qword[cnt1]
				jnz ascup2
		inc rsi
		dec qword[cnt]
		jnz ascup1
	ascend:
	print 1,buf,qword[buf_len]
	print [fd],buf,qword[buf_len]
	print [fd],lb,1
	close [fd]
	close [fd1]
jmp _start

des:
	read [fd],buf,1000
	mov qword[buf_len1],rax
	dec qword[buf_len1]
		cmp byte[tmp],0
		jne desfront
		mov byte[tmp],1
		mov rax,qword[buf_len1]
		mov qword[buf_len],rax
	desfront:
	print 1,buf,qword[buf_len]
	print 1,lb,1
	mov rsi,buf
	mov rcx,qword[buf_len]
	mov qword[cnt],rcx
	desup1:
		mov rdi,rsi
		mov rcx,qword[cnt]
		mov qword[cnt1],rcx
		dec qword[cnt1]
		jz desend
		inc rdi
		desup2:
			mov cl,byte[rdi]
			cmp byte[rsi],cl
			jae desnext
			call swap
			desnext:
				inc rdi
				dec qword[cnt1]
				jnz desup2
		inc rsi
		dec qword[cnt]
		jnz desup1
	desend:
	print 1,buf,qword[buf_len]
	print [fd],buf,qword[buf_len]
	print [fd],lb,1
	close [fd]
	close [fd1]
jmp _start
	
err:
	print 1,errm,19
	jmp exit
	
swap:
	mov cl,byte[rsi]
	mov bl,byte[rdi]
	mov byte[rsi],bl
	mov byte[rdi],cl
ret

exit:
	mov rax,60
	mov rdi,0
	syscall
