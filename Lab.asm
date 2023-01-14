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


    pnum:                                   ;Number printing function
        POP r15                             ;Saving return adress in r15
        POP r14                             ;Saving number to be printed in r14
        PUSH r14                            ;Saving number to be printed on stack
        call cdigits                        ;Counting digits of number
        POP rbx                             ;Saving number of digits to rbx
        dec rbx                             ;Decrementing it, so it functions well with power function
        mov r8, 10                          ;Saving 10 to r8
        PUSH r8                             ;Saving 10 to stack
        PUSH rbx                            ;Saving number of digits to stack
        call pow                            ;Getting 10^number of digits, for use in printing function
        POP r8                              ;Saving that number to r8
        mov r9, 10                          ;Saving 10 in r9
        pnumwork:                           ;Recursive function for actually printing number
            mov rax, r14                    ;Saving number to print (r14) to rax
            xor rdx, rdx                    ;Making rdx 0, so division doesnt mess up
            div r8                          ;Dividing rax by r8
            mov r10, rax                    ;Saving result to r10
            imul rax, r8                    ;Multiplying result with r8, so we can subtract it from the number we're printing. EG: num is 123, r8 is 100, rax is 1, then subtracting 100 from 123, so we can recurse with 23 as num.
            sub r14, rax                    ;Subtracting multiplication result from num
            mov rax, r10                    ;Moving result back to rax
            add rax, 48                     ;Adding 48 to rax for unicode, otherwise, printing, for example, 1, wouldent print one but unicode char with code 1
            mov [temp_var], rax             ;Save result of division to variable, for printing
            mov rax, 1                      ;System write 
            mov rdi, 1                      ;Stdout 
            mov rsi, temp_var               ;Message to be sent
            mov rdx, temp_var_len           ;Message length
            syscall                         ;Printing message
            xor rdx, rdx                    ;Making rdx 0
            mov rax, r8                     ;Making rax r8
            div r9                          ;Dividing r8 by 10
            mov r8, rax                     ;Making r8 the division result, so when recursing we keep up with each digit in the number to print
            mov rax, r14                    ;Moving number to print to rax
            cmp rax, 0                      ;Comparing it with zero
            jnz pnumwork                    ;If it is zero, stop recursing, else, recurse
        PUSH r15                            ;Pushing return address to top of stack
        ret                                 ;Return to location the function was called from

    cdigits:                                ;Digit counting function
        POP rbx                             ;Saving return adress to rbx
        POP rax                             ;Getting number to count digits of, saving to rax
        mov r8, 10                          ;Making r8 10
        mov r9, 0                           ;Making r9 0
        cdigitswork:                        ;Recursing function
            xor rdx, rdx                    ;Making rdx 0
            div r8                          ;Dividing number to count digits of by 10
            inc r9                          ;Incrementing r9 (number of digits counter variable)
            cmp rax, 0                      ;Comparing division result with 0
            jnz cdigitswork                 ;If rax is 0, exit recursive function, else, recurse.
        PUSH r9                             ;Push result number to stack
        PUSH rbx                            ;Push return adress to stack
        ret                                 ;Return to location the function was called from

    pow:                                    ;Function to get a number to the power of another
        POP r8                              ;Save return adress to r8
        POP r9                              ;Save exponent to r9
        dec r9                              ;Decrement exponent, for compatibility with recursive function
        POP r10                             ;Save base to r10
        mov r11, r10                        ;Make r11 equal to r10
        mov rcx, r9                         ;Move rcx to r9 (most likely this is vestigial, im not messing with it just in case.)
        powwork:                            ;Recursive function
            imul r10, r11                   ;Multiply base by copy of itself
            dec r9                          ;Decrement loop counter
            cmp r9, 0                       ;Compare loop counter with zero
            jne powwork                     ;If so, exit recursive function, else, recurse
        PUSH r10                            ;Push result to stack
        PUSH r8                             ;Push return adress to stack
        ret                                 ;Return to location the function was called from
            





    factors:
        mov eax, 1                          ;System write 
        mov edi, 1                          ;Stdout
        mov rsi, factor_start_message_1     ;Message to be sent
        mov edx, factor_start_length_1      ;Message length
        syscall                             ;Print message
        mov r8, 50
        PUSH r8
        call pnum2                          ;Print number in r8
        mov    eax, 1                       
        mov    edi, 1                       
        mov    rsi, factor_start_message_2    
        mov    edx, factor_start_length_2     
        syscall                             ;Print message
        
        PUSH r12
        ret


    _start:                                 ;Linker instruction, code starts execution here
        call factors


;********************************************************
;                       System exit
;********************************************************

    mov    eax, 60                          ;System exit code
    mov    rdi, 0                           ;Success code
    syscall                                 ;Exit program