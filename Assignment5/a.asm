section .data
global fd, cnt, cnt1, cnt2, ans
fd: dq 0
lb: db 0x0A
fname: db 'file.txt',0
errm: db "Error opening file",0x0A
cnt: dq 00
cnt1: dq 00
cnt2: dq 00

inv: db "Invalid",0x0A
linv: equ $-inv
msg: db "Inv",0x0A
menu: db 0x0A, "  Menu", 0x0A
	  db "1) Spaces", 0x0A
	  db "2) Line Breaks", 0x0A
	  db "3) Character", 0x0A
	  db "4) Exit", 0x0A
len: equ $-menu


section .bss
cntx resb 1
choice: resb 2
a: resb 3
c: resb 4
buf: resb 1000
buf_len: resq 1
ans: resq 1

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
	extern proc_spf, proc_lbf, proc_charf, htoa
	
cont:
	open fname,0
	bt rax,63
	jc err
	mov qword[fd],rax
	print menu,len
	read choice,2
	cmp byte[choice],0x31
	je sf
	cmp byte[choice],0x32
	je lbf
	cmp byte[choice],0x33
	je charf
	cmp byte[choice],0x34
	je exit
	print inv,linv
	jmp _start
	
sf:
	mov qword[cnt],0
	call proc_spf
	mov rax,qword[cnt]
	call htoa
	close [fd]
	jmp cont
	
lbf:
	mov byte[cnt1],0
	call proc_lbf
	mov rax,qword[cnt1]
	call htoa
	close [fd]
	jmp cont
	
charf:
	mov byte[cnt2],0
	call proc_charf
	mov rax,qword[cnt2]
	call htoa
	close [fd]
	jmp cont

err:
	print errm,19
	jmp exit
	
exit:
	mov rax,60
	mov rdi,0
	syscall
