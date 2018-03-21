section .data
lb: db 0x0A
s: db " : "
cnt: db 00
cnt1: db 00
cnt2: db 00
cnt3: db 00
ddd: dd 0x0
c: dd 00

inv: db "Invalid",0x0A
linv: equ $-inv
msg: db "Inv",0x0A
menu: db 0x0A, "  Menu", 0x0A
	  db "1) Hex to Binary", 0x0A
	  db "2) Binary to Hex", 0x0A
	  db "3) Exit", 0x0A
len: equ $-menu


section .bss
choice: resb 2
a: resb 9
b: resb 4


sum resd 1

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
	je htb
	cmp byte[choice],0x32
	je bth
	cmp byte[choice],0x33
	je exit
	print inv,linv
	jmp _start
	
htb:
	read a,5
	mov rax,0
	call atoh
	mov bx,0x0A
	mov dx,0
	d:
		mov dx,0
		div bx
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
	jmp _start

bth:
	read a,9
	call atoh1
	mov dword[ddd],eax
	mov word[sum],0
	and ax,0x000F
	add word[sum],ax

	mov bx,0x000A
	mov eax,dword[ddd]
	ror eax,4
	and ax,0x000F
	mul bx
	adc word[sum],ax

	mov bx,0x0064
	mov eax,dword[ddd]
	ror eax,8
	and ax,0x000F
	mul bx
	adc word[sum],ax

	mov bx,0x03E8
	mov eax,dword[ddd]
	ror eax,12
	and ax,0x000F
	mul bx
	adc word[sum],ax

	mov bx,0x2710
	mov eax,dword[ddd]
	ror eax,16
	and ax,0x000F
	mul bx
	adc word[sum],ax

	mov cx,word[sum]
	call htoa
	print c,4
	print lb,1
	mov ecx,dword[ddd]
jmp _start
	
atoh:
	mov ax,0
	mov rdi,a
	mov byte[cnt2],04H
	up:
		rol ax,04H
		mov dl,byte[rdi]
		cmp dl,39H
		jbe next
		sub dl,07H
		next: sub dl,30H
		add al,dl
		inc rdi
		dec byte[cnt2]
	jnz up
ret

atoh1:
	mov eax,0
	mov rdi,a
	mov byte[cnt2],08H
	up1:
		rol eax,04H
		mov dl,byte[rdi]
		cmp dl,39H
		jbe next1
		sub dl,07H
		next1: sub dl,30H
		add al,dl
		inc rdi
		dec byte[cnt2]
	jnz up1
ret
	
htoa:
	mov rdi,c
	mov byte[cnt],4
	up2:
	rol cx,4
	mov dl,cl
	And dl,0fH
	cmp dl,09
	jbe next2
	add dl,07
	next2:
	add dl,30H
	mov byte[rdi],dl
	inc rdi
	dec byte[cnt]
	jnz up2
ret

exit:
	mov rax,60
	mov rdi,0
	syscall
