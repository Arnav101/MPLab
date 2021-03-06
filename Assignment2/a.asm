section .data
lb: db 0x0A
s: db " : "
inv: db "Invalid",0x0A
linv: equ $-inv
menu: db "  Menu", 0x0A
	  db "1) Non-overlap, non-string", 0x0A
	  db "2) Overlap, non-string", 0x0A
	  db "3) Non-overlap, string", 0x0A
	  db "4) Overlap, String", 0x0A
	  db "5) Exit", 0x0A
len: equ $-menu

a: dq 0x1CF21CF21CF21CF2, 0x3426342634263426, 0x8654865486548654, 0xB231B231B231B231, 0xDA65DA65DA65DA65
newa: dq 0x20, 0x20, 0x20, 0x20, 0x20

cnt: db 5
cnt2: db 32
cnt7: db 00

section .bss
choice: resb 2
address: resq 16
b: resq 16

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
	je nons
	cmp byte[choice],0x32
	je ons
	cmp byte[choice],0x33
	je nos
	cmp byte[choice],0x34
	je os
	cmp byte[choice],0x35
	je exit
	print inv,linv
	jmp _start
	
nons:
	mov rsi,a
	mov byte[cnt],5

	a1:
		mov rbx,rsi
		push rsi
		call htoa
		print s,3
		pop rsi
		mov rbx,qword[rsi]
		push rsi
		call htoa1
		print lb,1
		pop rsi
		add rsi,8
		dec byte[cnt]
		jnz a1
		
	print lb,1
	print lb,1
	
	mov rsi,a
	mov rdi,a+40
	mov byte[cnt7],5
	
	
		
		
	a2:
		mov rcx,qword[rsi]
		mov qword[rdi],rcx
		add rsi,8
		add rdi,8
		dec byte[cnt7]
		jnz a2
		
		mov rsi,a+40
		mov byte[cnt],5
	
	a3:	
		mov rbx,rsi
		push rsi
		call htoa
		print s,3
		pop rsi
		mov rbx,qword[rsi]
		push rsi
		call htoa1
		print lb,1
		pop rsi
		add rsi,8
		dec byte[cnt]
	jnz a3
	
	jmp _start
		
		
	
ons:

	mov rsi,a
	mov byte[cnt],5
	
	b1:
		mov rbx,rsi
		push rsi
		call htoa
		print s,3
		pop rsi
		mov rbx,qword[rsi]
		push rsi
		call htoa1
		print lb,1
		pop rsi
		add rsi,8
		dec byte[cnt]
		jnz b1
		
	print lb,1
	print lb,1
	
	mov rsi,a
	mov rdi,a+150
	mov byte[cnt],5
		
	b2:
		mov rcx,qword[rsi]
		mov qword[rdi],rcx
		add rsi,8
		add rdi,8
		dec byte[cnt]
		jnz b2
		
		mov rsi,a+150
		mov rdi,a+16
		mov byte[cnt],5
	
	b4:
		mov rcx,qword[rsi]
		mov qword[rdi],rcx
		add rsi,8
		add rdi,8
		dec byte[cnt]
		jnz b4
		
		mov rsi,a+16
		mov byte[cnt],5
	
	b3:	
		mov rbx,rsi
		push rsi
		call htoa
		print s,3
		pop rsi
		mov rbx,qword[rsi]
		push rsi
		call htoa1
		print lb,1
		pop rsi
		add rsi,8
		dec byte[cnt]
	jnz b3
	
	jmp _start
	
	

nos:
	mov rsi,a
	mov byte[cnt],5
	c1:
		mov rbx,rsi
		push rsi
		call htoa
		print s,3
		pop rsi
		mov rbx,qword[rsi]
		push rsi
		call htoa1
		print lb,1
		pop rsi
		add rsi,8
		dec byte[cnt]
		jnz c1
		
	print lb,1
	print lb,1
	
	mov rsi,a
	mov rdi,a+100
	mov byte[cnt],5
	c2:
		movsq
		dec byte[cnt]
		jnz c2
		
	
	mov byte[cnt],5
	mov rsi,a+100
	c3:
		mov rbx,rsi
		push rsi
		call htoa
		print s,3
		pop rsi
		mov rbx,qword[rsi]
		push rsi
		call htoa1
		print lb,1
		pop rsi
		add rsi,8
		dec byte[cnt]
		jnz c3
	
	
	jmp _start

os:
	mov rsi,a
	mov byte[cnt],5
	d1:
		mov rbx,rsi
		push rsi
		call htoa
		print s,3
		pop rsi
		mov rbx,qword[rsi]
		push rsi
		call htoa1
		print lb,1
		pop rsi
		add rsi,8
		dec byte[cnt]
		jnz d1
		
	print lb,1
	print lb,1
	
	mov rsi,a
	mov rdi,a+200
	mov byte[cnt],5
	
	d2:
		movsq
		dec byte[cnt]
		jnz d2
		
	mov rsi,a+200
	mov rdi,a+16
	mov byte[cnt],5
		
	d3:
		movsq
		dec byte[cnt]
		jnz d3
		
		
	mov rsi,a+16
	mov byte[cnt],5
	
	d4:	
		mov rbx,rsi
		push rsi
		call htoa
		print s,3
		pop rsi
		mov rbx,qword[rsi]
		push rsi
		call htoa1
		print lb,1
		pop rsi
		add rsi,8
		dec byte[cnt]
		jnz d4
	jmp _start

htoa:
	mov qword[b],0x00
	mov byte[cnt2],16
	mov rdx,b
upad:
	rol rbx,04
	mov al,bl
	and al,0FH
	cmp al,09
	jbe aad
	add al,07H
aad:
	add al,30H
	mov [rdx],al
	inc dl
	dec byte[cnt2]
	jnz upad
	print b,16
	ret
	
htoa1:
	mov qword[address],0x00
	mov byte[cnt2],16
	mov rdx,address
up1:
	rol rbx,04
	mov al,bl
	and al,0FH
	cmp al,09
	jbe a0
	add al,07H
a0:
	add al,30H
	mov [rdx],al
	inc dl
	dec byte[cnt2]
	jnz up1
	print address,16
	ret

exit:
	mov rax,60
	mov rdi,0
	syscall
