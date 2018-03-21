section .data
lb: db 0x0A
s: db " : "
cnt: db 00
cnt1: db 00
cnt2: db 00
cnt3: db 00

inv: db "Invalid",0x0A
linv: equ $-inv
msg: db "Inv",0x0A
menu: db 0x0A, "  Menu", 0x0A
	  db "1) Successive Addition", 0x0A
	  db "2) Add and Shift", 0x0A
	  db "3) Exit", 0x0A
len: equ $-menu


section .bss
choice: resb 2
a: resb 3
c: resb 4

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
print menu,len
	read choice,2
	cmp byte[choice],0x31
	je sa
	cmp byte[choice],0x32
	je aas
	cmp byte[choice],0x33
	je exit
	print inv,linv
	jmp _start
	
sa:
	read a,3
	call atoh
	mov bx,0
	mov bx,ax
	read a,3
	call atoh
	mov cx,0
	sa_up:
		add cx,ax
		dec bx
	jnz sa_up
	call htoa
	print c,4
jmp _start

aas:
	mov bx,0
	mov dx,0
	mov word[a],0
	read a,3
	call atoh
	mov bx,ax
	read a,3
	call atoh
	mov dx,ax
	mov cx,0
	mov byte[cnt2],8
	cmp dx,bx
	
	asd:
		aas_up:
			shr bx,1
			jnc aas_next
			add cx,dx
			aas_next: shl dx,1
			dec byte[cnt2]
			jnz aas_up
	call htoa
	print c,4
jmp _start

atoh:
	mov ax,0
	mov rdi,a
	mov byte[cnt2],2
	up:
		rol ax,4
		mov dl,byte[rdi]
		cmp dl,0x39
		jbe next
		sub dl,7
		next: sub dl,0x30
		add al,dl
		inc rdi
		dec byte[cnt2]
	jnz up
ret

htoa:
	mov rdi,c
	mov byte[cnt],4
	up2:
		rol cx,4
		mov dl,cl
		and dl,0x0F
		cmp dl,09
		jbe next2
		add dl,07
		next2: add dl,0x30
		mov byte[rdi],dl
		inc rdi
		dec byte[cnt]
		jnz up2
ret

exit:
	mov rax,60
	mov rdi,0
	syscall
