;*******************************************************
; PROGRAM NAME - Lab 0010 - Simple Algorithms
;
; PROGRAMMER - David Weir
;
; COMPILE - nasm -f elf64 -F dwarf -g Lab.asm
;           ld -m elf_x86_64 -o lab Lab.o
;
; SYSTEM - Replit
;
; DATE - Started Jan. 12, 2023
;
; ISSUES - Don't use negative or decimal values when inputting numbers.
;
; DESCRIPTION - Simple mathematic algorithms including 
;               factoring, GCD, exponents, finding 
;               digits, printing digits, and counting 
;               digits.
; *******************************************************

global _start                               ;Linker instructions

section .data                               ;Data for use in program

temp_var: times 256 db 0                    ;Save number printing variable with a buffer
temp_var_len: equ $-temp_var                ;Save the length of temp_var
factor_start_message_1: db 0x0A, 'The factors of '
factor_start_length_1: equ $-factor_start_message_1
factor_start_message_2: db ' are', 0x3A, ' ', 0x0A
factor_start_length_2: equ $-factor_start_message_2

section .text                               ;Main code


    pnum2:
        POP r15
        call cdigits
        POP rbx
        mov r8, 10
        PUSH r8
        PUSH rbx
        call pow
        POP r8
        mov rax, 60
        mov rdi, r8
        syscall




    pnum:                                   ;Integer printing function. POP rdx as number to print
        POP rbx                             ;Save return adress in rbx
        call cdigits
        POP rax
        mov rbx, 10
        PUSH rax
        PUSH rbx
        call pow
        mov rax, 60
        POP rdi
        syscall
        POP r9
        mov eax, 60
        POP r8
        mov rdi, r8
        syscall
        pnumwork:                           ;Looping function, to prevent POP rbx from looping
            POP rax                         ;Get integer from the stack
            mov rdx, 0                      ;Clear rdx
            mov r10, 10
            div r9                          ;Divide rax by r8, remainder goes into rdx, quotient into rax
            add rdx, 48                     ;Add 48 to remainder so the number will function with 
            PUSH rax                        ;Save rax to the stack so it isn't overwritten by printing function
            mov [temp_var], rdx             ;Save remainder of division to variable, for printing
            mov rax, 1                      ;System write 
            mov rdi, 1                      ;Stdout 
            mov rsi, temp_var               ;Message to be sent, in this case, rdx
            mov rdx, temp_var_len           ;Message length
            syscall                         ;Print message
            POP rax                         ;Retrieve saved quotient
            mov r8, rax                     ;Save rax to r8
            PUSH r8                         ;Save r8 on stack
            mov rdx, 0
            mov rax, r9
            div r10
            mov r9, rax
            POP rax
            mov r8, rax
            PUSH r8
            cmp rax, 0                      ;Compare rax with zero
            jnz pnumwork                    ;Repeat at pnumwork if rax isn't zero
        PUSH rbx                            ;Save return adress to stack
        ret                                 ;Return to call location

    cdigits:
        POP rbx
        POP rax
        mov r8, 10
        mov r9, 0
        mov r10, 0
        cdigitswork:
            mov rdx, 0
            div r8
            inc r9
            cmp rax, r10
            jnz cdigitswork
        PUSH r9
        PUSH rbx
        ret

    pow:
        POP r8  ;ret
        POP r9  ;pow
        POP r10 ;num
        mov rax, 60
        mov rdi, r10
        syscall
        mov r11, r10
        mov rcx, r9
        powwork:
            imul r10, r11
            dec r9
            jnz powwork
        PUSH r8
        ret
            





    factors:
        mov eax, 1                          ;System write 
        mov edi, 1                          ;Stdout
        mov rsi, factor_start_message_1     ;Message to be sent
        mov edx, factor_start_length_1      ;Message length
        syscall                             ;Print message
        mov r8, 234
        PUSH r8
        call pnum                           ;Print number in r8
        mov    eax, 1                       
        mov    edi, 1                       
        mov    rsi, factor_start_message_2    
        mov    edx, factor_start_length_2     
        syscall                             ;Print message
        
        PUSH r12
        ret


    _start:                                 ;Linker instruction, code starts execution here
        mov rax, 123
        PUSH rax
        call pnum2
        ; call factors


;********************************************************
;                       System exit
;********************************************************

    mov    eax, 60                          ;System exit code
    mov    rdi, 0                           ;Success code
    syscall                                 ;Exit program