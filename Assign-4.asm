section .data
msg1 db 10,"enter first number ",10
msg1_len equ $-msg1

msg2 db 10,"enter second number",10
msg2_len equ $-msg2
imsg db 10," INVALID CHOICE!!"
imsg_len equ $-imsg
msg4 db 10,"your output is ",10
msg4_len equ $-msg4

first db 10," enter first number :",10
first_len equ $-first
second db 10," enter second number :",10
second_len equ $-second

result db 10," Result is :"
result_len equ $-result

msg3 db 10,"type correct input",10
msg3_len equ $-msg3

mmsg db 10," 1- Successive addition",
	  db 10," 2- Add_Shift method",
	  db 10," 3- EXIT",10
	  db 10," Enter your choice :"
mmsg_len equ $-mmsg

%macro	print	2
	 mov rax,1
	 mov rdi,1
         mov rsi,%1
         mov rdx,%2
    syscall
%endmacro

%macro	read	2
	 mov rax,0
	 mov rdi,0
         mov rsi,%1
         mov rdx,%2
    syscall
%endmacro


%macro exit 0
	MOV	RAX,60
        MOV	RDI,0
    syscall
%endmacro

section .bss
	buf  resb 5
	char_ans resb 4
	n1 resw 1
	n2 resw 1
	ansl resw 1
	ansh resw 1
	ans resd 1
	
section .text

global _start

_start:

menu:
	
	MENU:
	print mmsg,mmsg_len
	read buf,2		
	mov	al,[buf]	

c1:	cmp	al,'1'
	jne	c2
	call  succ_add
	jmp	MENU

c2:	cmp	al,'2'
	jne	c3
	call	add_shift
	jmp	MENU

c3:	cmp	al,'3'
	jne	invalid
	exit

invalid:
	print	imsg,imsg_len
	jmp	MENU
	
	
	exit


succ_add:
		mov word[ansh],0
		mov word[ansl],0
		print first,first_len
		call accept_16
		mov [n1],bx
		print second,second_len
		call accept_16
		mov [n2],bx
		mov ax,[n1]
		mov cx,[n2]
		cmp rcx,0
		je final
		
back1:
	add [ansl],ax
	jnc next2
	inc word[ansh]

next2:
	dec cx
	jnz back1
final:
	print result,result_len
	mov ax,[ansh]
	call display_16
	mov ax,[ansl]
	call display_16
	ret



accept_16:
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
	jbe sub30
	
	cmp al,'A'
	jb error
	cmp al,'F'
	jbe sub37
	
	cmp al,'a'
	jb error
	cmp al,'f'
	jbe sub57
	
	sub57:sub al,20h
	sub37:sub al,07h
	sub30:sub al,30h
	
	add bx,ax
	inc rsi
	dec rcx 
	jnz next_byte
ret

error:
	print msg3,msg3_len	
	exit
	
display_16:

	mov rbx,16
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

add_shift:
	mov dword[ans],0
	print msg1,msg1_len
	call accept_16
	mov [n1],bx
	print msg2,msg2_len
	call accept_16
	mov [n2],bx
	
	xor ax,ax
	mov cx,16
	mov ax,[n1]
	mov bx,[n2]
	xor ebp,ebp
	back:
	shl ebp,1
	shl ax,1
	jc next
	jmp next1
	
	next:
	add ebp,ebx
	
	next1:
	dec cx
	jnz back
	
	mov [ans],ebp
	mov eax,[ans]
	
	call display_16
	ret
