
section .data
	nline		db	10,10
	nline_len:	equ	$-nline

	smsg		db	10,"No. of spaces are	: "
	smsg_len:	equ	$-smsg
	
	nmsg		db	10,"No. of lines are	: "
	nmsg_len:	equ	$-nmsg

	cmsg		db	10,"No. of character occurances are	: "
	cmsg_len:	equ	$-cmsg

;---------------------------------------------------------------------
section .bss

	scount	resq	1
	ncount	resq	1
	ccount	resq	1

	char_ans	resb	16

;---------------------------------------------------------------------
global	far_proc		

extern	filehandle, char, buf, abuf_len

%include	"macro.asm"
;---------------------------------------------------------------------
section .text
	global	_main
_main:

far_proc:          		
	
		xor	rax,rax
		xor	rbx,rbx
		xor	rcx,rcx
		xor	rsi,rsi	

		mov	bl,[char]
		mov	rsi,buf
		mov	rcx,[abuf_len]

again:	mov	al,[rsi]

case_s:	cmp	al,' '		
		jne	case_n
		inc	qword[scount]
		jmp	next

case_n:	cmp	al,10		
		jne	case_c
		inc	qword[ncount]
		jmp	next

case_c:	cmp	al,bl			
		jne	next
		inc	qword[ccount]

next:		inc	rsi
		dec	rcx			
		jnz	again			

		print smsg,smsg_len
		mov	rax,[scount]
		call	display
	
		print nmsg,nmsg_len
		mov	rax,[ncount]
		call	display

		print cmsg,cmsg_len
		mov	rax,[ccount]
		call	display

	fclose	[filehandle]
	ret


display:
	mov 	rsi,char_ans+3	
	mov 	rcx,4			

cnt:	mov 	rdx,0			
	mov 	rbx,10		
	div 	rbx
	cmp 	dl, 09h		
	jbe  	add30
	add  	dl, 07h 
add30:
	add 	dl,30h		
	mov 	[rsi],dl		
	dec 	rsi			

	dec 	rcx			
	jnz 	cnt		
	print char_ans,4		
ret
;----------------------------------------------------------------

