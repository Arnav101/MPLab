section .data
lb: db 0x0A
s: db 0x20

a: dq 0x1234123412341234, 0x2345234523452345, 0x9876987698769876, 0x8765876587658765, 0x5433543354335433, 0xABCFABCFABCFABCF, 0x6F7D6F7D6F7D6F7D, 0xAD12AD12AD12AD12, 0x305F305F305F305F, 0x32BA32BA32BA32BA, 0x3412341234123412, 0x12AD12AD12AD12AD, 0x3452345234523452, 0x2AD12AD12AD12AD1
arr: db "0x1234123412341234, 0x2345234523452345, 0x9876987698769876, 0x8765876587658765, 0x5433543354335433, 0xABCFABCFABCFABCF, 0x6F7D6F7D6F7D6F7D, 0xAD12AD12AD12AD12, 0x305F305F305F305F, 0x32BA32BA32BA32BA, 0x3412341234123412, 0x12AD12AD12AD12AD, 0x3452345234523452, 0x2AD12AD12AD12AD1"
larr: equ $-arr

pos: db 0
neg: db 0
c2: db 14

m1: db "Array is: "
l1: equ $-m1

m2: db "Positive: "
l2: equ $-m2

m3: db "Negative: "
l3: equ $-m3



section .text
global _start
_start:
mov rax,1
mov rdi,1
mov rsi,m1
mov rdx,l1
syscall

mov rax,1
mov rdi,1
mov rsi,arr
mov rdx,larr
syscall

mov rax,1
mov rdi,1
mov rsi,lb
mov rdx,1
syscall

mov rsi,a

c:
mov rax,qword[rsi]
BT rax,63
jc n

inc byte[pos]
add rsi,8
dec byte[c2]
jnz c
jmp cont

n: inc byte[neg]
add rsi,8
dec byte[c2]
jnz c

cont:
cmp byte[pos],9
jbe next

add byte[pos],7

next: add byte[pos],0x30

cmp byte[neg],9
jbe next1

add byte[neg],7

next1: add byte[neg],0x30

mov rax,1
mov rdi,1
mov rsi,m2
mov rdx,l2
syscall

mov rax,1
mov rdi,1
mov rsi,pos
mov rdx,1
syscall

mov rax,1
mov rdi,1
mov rsi,lb
mov rdx,1
syscall

mov rax,1
mov rdi,1
mov rsi,m3
mov rdx,l3
syscall

mov rax,1
mov rdi,1
mov rsi,neg
mov rdx,1
syscall

mov rax,1
mov rdi,1
mov rsi,lb
mov rdx,1
syscall

mov rax,60
mov rdi,0
syscall
