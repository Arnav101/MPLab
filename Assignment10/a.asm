section .data
lb: db 0x0A
s: db 0x20
ff1: db "%lf + %lf*i",10,0
ff2: db "%lf - %lf*i",10,0
fpf: db "%lf",10,0
fsf: db "%lf",0

cnt: dq 0
four: dq 4
two: dq 2
a: dq 0
b: dq 0
c: dq 0
realn: dq 0
imn: dq 0
bsquare: dq 0
fourac: dq 0
twoa: dq 0
delta: dq 0
root1: dq 0
root2: dq 0
section .bss
%macro scan 1
	mov rdi,fsf
	mov rax,0
	sub rsp,8
	mov rsi,rsp
	call scanf
	mov r8,qword[rsp]
	mov qword[%1],r8
	add rsp,8
%endmacro

%macro print 3
	mov rdi,%1
	sub rsp,8
	movsd xmm0,[%2]
	movsd xmm1,[%3]
	mov rax,2
	call printf
	add rsp,8
	mov rax,1
%endmacro

%macro print1 1
	mov rdi,fpf
	sub rsp,8
	movsd xmm0,[%1]
	mov rax,1
	call printf
	add rsp,8
%endmacro

%macro prints 2
	mov rax,1
	mov rdi,1
	mov rsi,%1
	mov rdx,%2
	syscall
%endmacro

section .text
global main
main:
	extern printf, scanf
	scan a
	scan b
	scan c
	finit
	fldz
	fadd qword[b]
	fmul qword[b]
	fst qword[bsquare]
	fldz
	fild qword[four]
	fmul qword[a]
	fmul qword[c]
	fst qword[fourac]
	fldz
	fild qword[two]
	fmul qword[a]
	fst qword[twoa]
	fldz
	fadd qword[bsquare]
;	print1 bsquare
	fsub qword[fourac]
;	print1 fourac
	fst qword[delta]
;	print1 delta
	
	btr qword[delta],63
	jc img
	fsqrt
	fst qword[delta]
	fldz
	fsub qword[b]
	fadd qword[delta]
	fdiv qword[twoa]
	fst qword[root1]
	fldz
	fsub qword[b]
	fsub qword[delta]
	fdiv qword[twoa]
	fst qword[root2]
	print1 root1
	print1 root2
	
	img:
	fst qword[delta]
	fsub qword[delta]
	fst qword[delta]
;	print1 delta
	fadd qword[fourac]
	fsub qword[bsquare]
	fsqrt
	fdiv qword[twoa]
	fst qword[imn]
	fldz
	fsub qword[b]
	fdiv qword[twoa]
	fst qword[realn]
	print ff1,realn,imn
	print ff2,realn,imn
	
exit:
	mov rax,60
	mov rdi,0
	syscall
