section .data
fd: dq 0
fd1: dq 0
lb: db 0x0A
msg: db "Factorial = "
len: equ $-msg
num: dq 00
cnt: dq 0
cnt1: dq 0

section .bss
choice: resb 2
a: resb 100
b: resb 8

%macro print 2
	mov rax,1
	mov rdi,1
	mov rsi,%1
	mov rdx,%2
	syscall
%endmacro

section .text
global _start
_start:
	print msg,len
	pop rsi
	pop rsi
	pop rsi
	mov rbx,0
	mov rax,1
	mov bl,byte[rsi]
	cmp bl,0x39
	jbe numnext
	sub bl,7
	numnext:
	sub bl,0x30
	call fact
	mov rcx,rax
	call htb
	mov rcx,rax
	print lb,1
exit:
	mov rax,60
	mov rdi,0
	syscall
	
atoh:
	mov ax,0
	mov rdi,a
	mov byte[cnt],2
	up:
		rol ax,4
		mov dl,byte[rdi]
		cmp dl,0x39
		jbe next
		sub dl,7
		next: sub dl,0x30
		add al,dl
		inc rdi
		dec byte[cnt]
	jnz up
ret

fact:
	cmp rbx,0
	je factret
	mul rbx
	dec rbx
	call fact
	factret:
ret

htb:
	mov rbx,0x0A
	mov dx,0
	d:
		mov dx,0
		div rbx
		push dx
		inc byte[cnt1]
		cmp ax,0
		jne d
	x:
		pop dx
		add dl,30H
		mov byte[b],dl
		print b,1
		dec byte[cnt1]
	jnz x
ret
