section .data
extern fd,cnt,cnt1,cnt2,ans
cha: db 0x73
cntx: dq 00
lb: db 0x0A
ms: db "Empty File",0x0A
le: equ $-ms
cme: db "Character is: "
cle: equ $-cme
section .bss
buf: resb 1000
buf_len: resq 1
la: resq 2

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

section .text
global main
main:
	global proc_spf, proc_lbf, proc_charf, htoa
	
	proc_spf:
		read [fd],buf,1000
		mov qword[buf_len],rax
		mov rsi,buf
		cmp qword[buf_len],0
		jne up
		print 1,ms,le
		jmp go
		up:
			cmp byte[rsi],0x20
			jne next
			inc qword[cnt]
			next:
			inc rsi
			dec qword[buf_len]
			jnz up
		go:
	ret
	
	proc_lbf:
		read [fd],buf,1000
		mov qword[buf_len],rax
		mov rsi,buf
		cmp qword[buf_len],0
		jne up1
		print 1,ms,le
		jmp go1
		up1:
			cmp byte[rsi],0x0A
			jne next1
			inc byte[cnt1]
			next1:
			inc rsi
			dec qword[buf_len]
			jnz up1
		go1:
	ret
	
	proc_charf:
		read 0,cha,2
		read [fd],buf,1000
		mov qword[buf_len],rax
		print 1,cme,cle
		print 1,cha,1
		print 1,lb,1
		mov rsi,buf
		cmp qword[buf_len],0
		jne up2
		mov cl,byte[cha]
		print 1,ms,le
		jmp go2
		up2:
			mov cl,byte[cha]
			cmp byte[rsi],cl
			jne next2
			inc byte[cnt2]
			next2:
			inc rsi
			dec qword[buf_len]
			jnz up2
		go2:
	ret
	htoa:
		mov qword[la],0
		mov qword[la+8],0
		mov rdi,la
		mov byte[cntx],16
		htoaup:
			rol rax,4
			mov cl,al;
			and cl,0FH
			cmp cl,9
			jbe htoanext
			add cl,7
			htoanext:
			add cl,0x30
			mov byte[rdi],cl
			inc rdi
			dec byte[cntx]
			jnz htoaup
			print 1,la,16
	ret
