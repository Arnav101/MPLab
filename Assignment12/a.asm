section .data
lb: db 0x0A
s: db 0x20
p: db "."
meanm: db "Mean :- "
meanl: equ $-meanm
varm: db "Variance :- "
varl: equ $-varm
sdm: db "Standard Deviation :- "
sdl: equ $-sdm
arr: dd 123.12, 45.45, 65.44, 87.14, 90.56
acnt: dw 5
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
	mov rsi,arr
	mov byte[cnt],5
	mup:
		fadd dword[rsi]
		add rsi,4
		dec byte[cnt]
		jnz mup
	
	fidiv word[acnt]
	fst dword[mean]
	print meanm,meanl
	call disp
	
	mov rsi,arr
	mov byte[cnt],5
	fldz
	var1:
		fldz
		fadd dword[rsi]
		fsub dword[mean]
		fmul st0
		fadd
		add rsi,4
		dec byte[cnt]
		jnz var1
	fidiv word[acnt]
	fst dword[var]
	print varm,varl
	call disp
	
	fld dword[var]
	fsqrt
	fst dword[sd]
	print sdm,sdl
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
