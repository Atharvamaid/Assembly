section .data

msg1 db 10,"enter a number "
msg1_len equ $-msg1

msg2 db 10,"output is :"
msg2_len equ $-msg2

msg3 db 10,"enter valid inputs"
msg3_len equ $-msg3

%macro print 2
mov rax,1
mov rdi,1
mov rsi,%1
mov rdx,%2
syscall 
%endmacro

%macro read 2
mov rax,0
mov rdi,0
mov rsi,%1
mov rdx,%2
syscall
%endmacro

%macro exit 0
mov rax,60
mov rdi,0
syscall
%endmacro

section .bss

buf resb 5
char_ans resb 4

section .text

global _start

_start:
	print msg1,msg1_len
	call accept
	print msg2,msg2_len
	mov ax,bx
	call display
	exit

accept:
read buf,5
mov rsi,buf
mov rcx,4
mov bx,0

next_byte:
shl bx,4
mov al,[rsi]
cmp al,'0'
jb error
cmp al,'9'
jbe sub_30

cmp al,'A'
jb error
cmp al,'F'
jbe sub_37

cmp al,'a'
jb error
cmp al,'f'
jbe sub_57
cmp al,'f'
ja error


sub_57:sub al,20h
sub_37:sub al,07h
sub_30:sub al,30h

add bx,ax
inc rsi
dec rcx
jnz next_byte
ret

error:
print msg3,msg3_len
jmp accept


display:
mov rbx,10
mov rcx,4
mov rsi,char_ans+3

cnt:
mov rdx,0
div rbx
cmp dl,09h
jbe add30
add dl,07h
add30:
add dl,30h
mov [rsi],dl
dec rsi
dec rcx
jnz cnt
print char_ans,4
ret


