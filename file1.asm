
extern	far_proc		; [ FAR PROCRDURE
					;   USING EXTERN DIRECTIVE ]

global	filehandle, char, buf, abuf_len

%include	"macro.asm"


section .data
	nline		db	10
	nline_len	equ	$-nline

	fmsg db 10,"enter file name ",10
	fmsg_len equ $-fmsg

	charmsg	db	10,"Enter character to search	: "
	charmsg_len	equ	$-charmsg

	errmsg	db	10,"ERROR in opening File...",10
	errmsg_len	equ	$-errmsg

	exitmsg	db	10,10,"Exit from program...",10,10
	exitmsg_len	equ	$-exitmsg

       filename db "textfile.txt",0

section .bss
	buf			resb	4096
	buf_len		equ	$-buf		

	char			resb	2

	filehandle		resq	1

	abuf_len		resq	1		


section .text
	global _start

_start:
		
		

		print	charmsg,charmsg_len
		read char,2

		fopen filename	; on succes returns handle
		cmp	rax,-1H			
		jle	Error
		mov	[filehandle],rax

		fread	[filehandle],buf, buf_len
		mov	[abuf_len],rax

		call	far_proc
		jmp	Exit

Error:	print	errmsg, errmsg_len

Exit:		print	exitmsg,exitmsg_len
		exit
;--------------------------------------------------------------------------------

