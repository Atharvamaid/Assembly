%macro print 2
	mov rax,1
	mov rdi,2
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
	mov rdi,00
syscall
%endmacro

section .data
msg1 db 10,"Real mode",10
msg1_l equ $- msg1	
msg2 db 10,"Protected mode:",10
msg2_l equ $- msg2
colon	db ":"
msg3 db 10,"invalid mode",10
msg3_l equ $- msg3
	
	
section .bss
	
	GDTR resw 3
	LDTR resw 1
	IDTR resw 3
	TR resw 1
	MSW resw 1
	char_ans resb 5
	char_ans_l equ $- char_ans
	buf resb 5
	

section .text
	global _start:
_start:

      SMSW	[MSW]
      mov  ax,[MSW]
	ror rax,1
	jc p_mode

	print	msg1,msg1_l
	jmp next

p_mode:	
	print	msg2,msg2_l

next:
	SGDT	[GDTR]
	SIDT	[IDTR]
	SLDT	[LDTR]
	STR	[TR]
	SMSW	[MSW]

 		
	mov 	ax,[GDTR+4]		
	call 	display_16	
	
	mov 	ax,[GDTR+2]		
	call 	display_16	
		
	print	colon,1
	
	mov 	ax,[GDTR+0]		
	call 	display_16	

exit		

Accept_16:
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
	print msg3,msg3_l	
	exit
	
	
display_16:

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


