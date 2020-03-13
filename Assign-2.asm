section .data
msg1 db 10,"before block transfer:"
msg1_len equ $-msg1

msg2 db 10,"after block transfer:"
msg2_len equ $-msg2

msg3 db 10,"source block:"
msg3_len equ $-msg3

msg4 db 10,"destination block:"
msg4_len equ $msg4

sblock db 10h,12h,14h,16h,18h
dblock db 0h,0h,0h,0h,0h


%macro print 2
	mov rax,1
		mov rdi,1
		mov rsi,%1
		mov rdx,%2
		syscall
%endmacro

%macro exit 0
		mov rax,60
		mov rdi,00
		syscall
%endmacro

section .bss
char_ans resb 2

section .text
     	global _start
     	
     	_start:
     		print msg1,msg1_len
     		print msg3,msg3_len
     		
     		mov rsi,sblock
     		call disp_block
     		
     		print msg4,msg4_len
     		mov rsi,dblock
     		call disp_block
     		
     		print msg2,msg2_len
     		
     		call block_transfer
     		print msg3,msg3_len
     		mov rsi,sblock
     		call disp_block
     		print msg4,msg4_len
     		mov  rsi,dblock-2
     		call disp_block
     		exit
     		
     		disp_block:
     		mov rbp,5
     		
     		next_num:
     		mov al,[rsi]
     		push rsi
     		call display
     		pop rsi
     		inc rsi
     		dec rbp
     		jnz next_num
     		ret
     		
     		block_transfer:
     		mov rsi,sblock+4
     		mov rdi,dblock+2
     		mov rcx,5
     		back:
     		;mov al,[rsi]
     		;mov [rdi],al
     		cld
     		;inc rsi
     		;inc rdi
     		;dec rcx
     		;jnz back
     		rep movsb
     		ret
		
     		
     		display:
		mov rbx,16
		mov rcx,2
		mov rsi,char_ans+1
		
		cnt : mov rdx,0
		div rbx
		cmp dl,09h
		jbe add_30
		add dl,07h

		add_30:
		add dl,30h
		mov [rsi],dl
		dec rsi
		dec rcx
		jnz cnt
		print char_ans,2
	
		ret
