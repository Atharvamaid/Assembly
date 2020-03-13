%include "macro.asm"

section .data
msg db 10,"Sorted array is ",10
msg_len equ $-msg
msg1 db 10,"enter file name ",10
msg1_len equ $-msg1

msg2 db 10,"error ",10
msg2_len equ $-msg2

section .bss
  fname resb 50
  abuf_len resq 1
  filehandle resq 1
  buf resb 100
  buf_len equ $-buf  
  n resq 1 
  array resb 100
  
 section .text
       global _start
   _start: 
   execut:     
   
   	print msg1,msg1_len
          read fname,50
          dec rax
          mov byte[fname+rax],0
          
          
          fopen fname
          cmp rax,-1h
          jle error
          mov [filehandle],rax
          
          fread [filehandle],buf,buf_len
          dec rax
          mov [abuf_len],rax
          
         
         call bsort
         exit
         
      error:
            print msg2,msg2_len
           exit
         
            
        bsort:
              call buf_array
                                                             
              xor rax,rax
              mov rbp,[n]
              dec rbp
           
              
                        xor rcx,rcx
                        xor rdx,rdx
                        xor rsi,rsi
                        xor rdi,rdi

                     mov rcx,0
       oloop:
             mov rbx,0
             mov rsi,array
             
       iloop:
             mov rdi,rsi
             inc rdi
             
            mov al,[rsi]
            cmp al,[rdi]
            jae next
            
            mov dl,0
            mov dl,[rdi]
            mov [rdi],al
            mov [rsi],dl
            
       next:
           inc rsi
           inc rbx
           cmp rbx,rbp
           jb iloop
           
           inc rcx
           cmp rcx,rbp
           jb oloop
           
          fwrite [filehandle],msg,msg_len
          fwrite [filehandle],array,[n]
          fclose [filehandle]
          
          print msg,msg_len
          print array,[n]
          
          
          ret
        
     buf_array:
               xor rcx,rcx
               xor rsi,rsi
               xor rdi,rdi
               
               mov rcx,[abuf_len]
               mov rsi,buf
               mov rdi,array
               
        next_num:
                 mov al,[rsi]
                 mov [rdi],al
                 
                 inc rsi
                 inc rsi
                 
                 inc rdi
                 
                 inc byte[n]
                 
                 dec rcx 
                 dec rcx
                 
                 jnz next_num
                  
               ret
              
     
         
