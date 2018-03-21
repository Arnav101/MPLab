section .data
lb: db 0x0A

mode1: db "Protected Mode", 0x0A
mode1l: equ $-mode1

mode2: db "Real Mode",0x0A
mode2l: equ $-mode2

mswm: db "MSW:    "
mswml: equ $-mswm

ldtm: db "LDTR:   "
ldtml: equ $-ldtm

gdtm: db "    GDTR:-",0x0A
gdtml: equ $-gdtm

lim: db "Limit:  "
liml: equ $-lim

ba: db "Base Address: "
bal: equ $-ba

idtm: db "    IDTR:-",0x0A
idtml: equ $-idtm

trm: db "TR:     "
trml: equ $-trm

section .bss
g: resb 6
l: resq 1
cnt: resb 1
la: resq 1

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


;MSW	
	smsw eax
	call htoa_32
	BT eax,0
	jc next
	print mode2,mode2l
	jmp cont
	next: print mode1,mode1l
	print lb,1
	cont:
	print mswm,mswml
	print la,8
	print lb,1
	print lb,1
	
;LDT
	print lb,1
	sldt ax
	call htoa_16
	print ldtm,ldtml
	print la,4
	print lb,1
	print lb,1


;GDTR
	mov qword[l],0
	sgdt [l]
	mov eax,dword[l+2]
	rol eax,16
	call htoa_32
	print gdtm,gdtml
	print ba,bal
	print la,8
	print lb,1
	print lim,liml
	mov ax,word[l]
	call htoa_16
	print la,4
	print lb,1
	print lb,1
	
;IDTR
	mov qword[l],0
	sidt [l]
	mov eax,dword[l+2]
	rol eax,16
	call htoa_32
	print idtm,idtml
	print ba,bal
	print la,8
	print lb,1
	print lim,liml
	mov ax,word[l]
	call htoa_16
	print la,4
	print lb,1
	print lb,1

;TR
	str ax
	call htoa_16
	print trm,trml
	print la,4
	print lb,1
	print lb,1
	
exit:
	mov rax,60
	mov rdi,0
	syscall
	
htoa_32:
	mov rdi,la
	mov byte[cnt],8
	htoa32up:
		rol eax,4
		mov cl,al;
		and cl,0FH
		cmp cl,9
		jbe htoa32next
		add cl,7
		htoa32next:
		add cl,0x30
		mov byte[rdi],cl
		inc rdi
		dec byte[cnt]
		jnz htoa32up
ret

htoa_16:
	mov rdi,la
	mov byte[cnt],4
	hto16up:
		rol ax,4
		mov cl,al;
		and cl,0FH
		cmp cl,9
		jbe htoa16next
		add cl,7
		htoa16next:
		add cl,0x30
		mov byte[rdi],cl
		inc rdi
		dec byte[cnt]
		jnz hto16up
ret
