section .data
lb: db 0x0A
s: db 0x20
p: db "."
rad: dq 4.00
mul: dq 100

section .bss
mean: resd 1
var: resd 1
sd: resd 1
buf: resb 10
cnt: resb 1
ans: resb 2
cnt1: resb 1

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
	finit
	fldz
	fldpi
	fmul qword[rad]
	fmul qword[rad]
	call disp
	
exit:
	mov rax,60
	mov rdi,0
	syscall
	
	
disp:
	fimul dword[mul]
	fbstp tword[buf]
	mov rsi,buf
	add rsi,9
	mov byte[cnt],9
	dispup:
		mov cl,byte[rsi]
		push rsi
		call htoa
		pop rsi
		dec rsi
		dec byte[cnt]
		jnz dispup
		print p,1
		mov cl,byte[buf]
		call htoa
		print lb,1
ret

htoa:
	mov rdi,ans
	mov byte[cnt1],2
	htoaup:
		rol cl,4
		mov dl,cl
		and dl,0x0F
		cmp dl,9
		jbe htoanext
		add dl,7
		htoanext: add dl,0x30
		mov byte[rdi],dl
		inc rdi
		dec byte[cnt1]
		jnz htoaup
		print ans,2
ret
