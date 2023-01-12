; 64-bit "Hello World!" in Linux NASM

global _start            ; global entry point export for ld

section .text

len equ 0xFF
total equ 5

_start:

    ; sys_write(stdout, message, length)

    mov    eax, 1        ; sys_write
    mov    edi, 1        ; stdout
    mov    rsi, message    ; message address
    mov    edx, length    ; message string length
    syscall
    mov    eax, 1        ; sys_write
    mov    edi, 1        ; stdout
    mov    rsi, message2    ; message address
    mov    edx, length2    ; message string length
    syscall
    mov eax, 0      ; rax <- 0 (syscall number for 'read')
    mov edi, 0      ; edi <- 0 (stdin file descriptor)
    mov rsi, stdinres   ; rsi <- address of the buffer.  lea rsi, [rel buffer]
    mov edx, len  ; rdx <- size of the buffer
    syscall           ; execute  read(0, buffer, BUFSIZE)
    mov    eax, 1        ; sys_write
    mov    edi, 1        ; stdout
    mov    rsi, stdinres    ; message address
    mov    edx, len    ; message string length
    syscall
    mov rax, 2 ; first param
    mov rbx, 2 ; second param
    mov rcx, 4 ; loop count
    top:
    imul rbx, rax
    loop top ; loop instruction
    
    mov [rbval], rbx
    mov    rax, 1        ; sys_write
    mov    rdi, 1        ; stdout
    mov    rsi, rbval    ; message address
    mov    rdx, rblen    ; message string length
    syscall
    cmp rbx, 32		;compares a with 2, does effectively a-2 
    jne .else         ;if the result would not be zero, goto .else 
        mov    eax, 1        ; sys_write
        mov    edi, 1        ; stdout
        mov    rsi, message    ; message address
        mov    edx, length    ; message string length
        syscall
        jmp .fi
    .else:
        mov    eax, 1        ; sys_write
        mov    edi, 1        ; stdout
        mov    rsi, message2    ; message address
        mov    edx, length2    ; message string length
        syscall
    .fi:
        
    

    ; sys_exit(return_code)
    mov    eax, 60        ; sys_exit
    mov    rdi, 0            ; return 0 (success)
    syscall

section .data
    rbval: db 0
    rblen: equ $-rbval
    BUFSIZE: db 0xFF
    stdinres: times 0xFF db 0
    message: db 'Hello, world!',0x0A    ; message and newline
    length:    equ    $-message        ; NASM definition pseudo-instruction
    message2: db 'Written in Assembly!',0x0A    ; message and newline
    length2:    equ    $-message        ; NASM definition pseudo-instruction