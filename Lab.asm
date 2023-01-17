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
; ISSUES - Don't use negative or decimal values when inputting numbers. No inputting numbers larger than 19 digits
;
; DESCRIPTION - Simple mathematic algorithms including 
;               factoring, GCD, exponents, finding 
;               digits, printing digits, and counting 
;               digits.
; *******************************************************

global _start                               ;Linker instructions

section .text                               ;Main code


    pnum:                                   ;Number printing function
        POP r15                             ;Saving return adress in r15
        POP r14                             ;Saving number to be printed in r14
        PUSH r14                            ;Saving number to be printed on stack
        call cdigits                        ;Counting digits of number
        POP rbx                             ;Saving number of digits to rbx
        mov r8, 10                          ;Saving 10 to r8
        PUSH r8                             ;Saving 10 to stack
        PUSH rbx                            ;Saving number of digits to stack
        call pow                            ;Getting 10^number of digits, for use in printing function
        POP r8                              ;Saving that number to r8
        mov r9, 10                          ;Saving 10 in r9
        pnumwork:                           ;Looping function for actually printing number
            mov rax, r14                    ;Saving number to print (r14) to rax
            xor rdx, rdx                    ;Making rdx 0, so division doesnt mess up
            div r8                          ;Dividing rax by r8
            mov r10, rax                    ;Saving result to r10
            imul rax, r8                    ;Multiplying result with r8, so we can subtract it from the number we're printing. EG: num is 123, r8 is 100, rax is 1, then subtracting 100 from 123, so we can loop with 23 as num.
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
            mov r8, rax                     ;Making r8 the division result, so when looping we keep up with each digit in the number to print
            mov rax, r14                    ;Moving number to print to rax
            cmp r8, 0                       ;Comparing it with zero
            jnz pnumwork                    ;If it is zero, stop looping, else, loop
        PUSH r15                            ;Pushing return address to top of stack
        ret                                 ;Return to location the function was called from

    cdigits:                                ;Digit counting function
        POP rbx                             ;Saving return adress to rbx
        POP rax                             ;Getting number to count digits of, saving to rax
        mov r8, 10                          ;Making r8 10
        mov r9, 0                           ;Making r9 0
        cdigitswork:                        ;Looping function
            xor rdx, rdx                    ;Making rdx 0
            div r8                          ;Dividing number to count digits of by 10
            inc r9                          ;Incrementing r9 (number of digits counter variable)
            cmp rax, 0                      ;Comparing division result with 0
            jnz cdigitswork                 ;If rax is 0, exit looping function, else, loop.
        PUSH r9                             ;Push result number to stack
        PUSH rbx                            ;Push return adress to stack
        ret                                 ;Return to location the function was called from

    pow:                                    ;Function to get a number to the power of another
        POP r8                              ;Save return adress to r8
        POP r9                              ;Save exponent to r9
        POP r10                             ;Save base to r10
        mov r11, r10                        ;Make r11 equal to r10
        mov rax, r9                         ;Make rax equal r9 for comparison below
        dec r9                              ;Make r9 one smaller for compatibility with looping function
        jnz powwork                         ;If number isn't zero, go to looping function
        jmp powfi                           ;Jump to exit of function if number is zero
        powwork:                            ;Looping function
            imul r10, r11                   ;Multiply base by copy of itself
            dec r9                          ;Decrement loop counter
            mov rax, r9                     ;Make rax equal r9 for comparison below
            jnz powwork                     ;If negative, exit looping function, else, loop
        powfi:                              ;Jump here when done with function, to avoid running powwork
        xor rdx, rdx                        ;Make rdx zero
        mov rax, r10                        ;Make rax equal to result
        div r11                             ;Divide by base
        mov r10, rax                        ;Move result back to r10
        PUSH r10                            ;Push result to stack
        PUSH r8                             ;Push return adress to stack
        ret                                 ;Return to location the function was called from
            

    factors:                                ;Get factors of number (unfinished)
        POP r8                              ;Save return adress to r8
        POP r9                              ;Save number to r9
        PUSH r8                             ;Push return adress back onto stack
        mov rax, 1                          ;Print factors message one
        mov rdi, 1                          ;           |
        mov rsi, factors_msg_1              ;           |
        mov rdx, factors_msg_1_len          ;           |
        syscall                             ;End print factors message one
        PUSH r9                             ;Save number on stack
        PUSH r9                             ;Push number (for printing) on to stack
        call pnum                           ;Print number (issue here)
        mov rax, 1                          ;Print factors message two
        mov rdi, 1                          ;           |
        mov rsi, factors_msg_2              ;           |
        mov rdx, factors_msg_2_len          ;           |
        syscall                             ;End print factors message two
        POP r9                              ;Save number to r9
        mov r8, 1                           ;Move r8, the i in for (int i = 0; etc; etc)
        factorswork:                        ;Looping function
            xor rdx, rdx                    ;Make rdx 0
            mov rax, r9                     ;Make rax r9
            div r8                          ;Rivide rax by r8, to get remainder and check to see if it is a factor
            cmp rdx, 0                      ;Check to see if remainder is zero
            je factorsp                     ;If so, print it
            jmp factorsfi                   ;If not, skip print
            factorsp:                       ;Looping function
                PUSH r8                     ;Save vars on stack, so they aren't overwritten by printing function
                PUSH r9                     ;       |
                PUSH r8                     ;End save vars
                call pnum                   ;Print number
                mov rax, 1                  ;Print factors comma
                mov rdi, 1                  ;           |
                mov rsi, factors_comma      ;           |
                mov rdx, factors_comma_len  ;           |
                syscall                     ;End print factors comma
                POP r9                      ;Recover r9 which was saved on stack
                POP r8                      ;Recover r8
            factorsfi:                      ;Jump here when factorsp shouldent be called
            inc r8                          ;Increment the counter
            cmp r8, r9                      ;Compare it with the number
            jne factorswork                 ;If it is equivilent, exit
        PUSH r9                             ;Push the number to the stack
        call pnum                           ;Print the number
        mov rax, 1                          ;Print factors comma
        mov rdi, 1                          ;           |
        mov rsi, factors_period             ;           |
        mov rdx, factors_period_len         ;           |
        syscall                             ;End print factors comma
        ret                                 ;Return to location the function was called from


    gcd:                                    ;Function to get the greatest common divisor
        POP rax                             ;Save return adress to rax
        POP r8                              ;Save num 1 to r8
        POP r9                              ;Save num 2 to r9
        PUSH rax                            ;Push return adress back onto stak
        mov rax, 1                          ;Print gcd message
        mov rdi, 1                          ;           |
        mov rsi, gcd_msg                    ;           |
        mov rdx, gcd_msg_len                ;           |
        syscall                             ;End print gcd message
        mov r10, 1                          ;Make r10 counter variable, set to one
        mov r11, 0                          ;Make r11 the GCD var, set to zero
        mov r12, r9                         ;Make r12 equal r9
        cmp r8, r9                          ;Compare to see which number is larger
        cmovg r12, r8                       ;If r8 is larger, move it to r12, else keep it at r9
        gcdwork:                            ;Looping function
            xor rdx, rdx                    ;Set rdx to one for division
            mov rax, r8                     ;Set rax to r8 for division
            div r10                         ;Divide r8 by the counter variable
            cmp rdx, 0                      ;Compare the remainder with zero
            jne gcdworkr                    ;If it isn't equal, jump to gcdworkr
            xor rdx, rdx                    ;Set rdx to zero
            mov rax, r9                     ;Set rax to r9
            div r10                         ;Divide r9 by counter
            cmp rdx, 0                      ;Compare remainder with zero
            jne gcdworkr                    ;If it isn't equal, jump to gcdworkr
            mov r11, r10                    ;If both r8%counter and r9%counter are zero, that is a common divisor, so set r11 to that divisor
            gcdworkr:                       ;Function to continue the loop
                cmp r10, r12                ;Compare counter and the larger of the two numbers
                jg gcdfi                    ;If it is greater, jump to gcdfi
                inc r10                     ;Else increment r10
                jmp gcdwork                 ;Jump to gcdwork to loop again
        gcdfi:                              ;Jump here when loop is done
        PUSH r11                            ;Push GCD to stack to be printed
        call pnum                           ;Print gcd
        ret                                 ;Return to location the function was called from



        prime:
            POP rax
            POP r8
            PUSH rax
            mov r9, 2
            mov rax, r8
            mov rbx, 1
            sub rax, rbx
            mov r10, rax
            primeworker:
                cmp r9, r10
                je primeyes
                xor rdx, rdx
                mov rax, r8
                div r9
                cmp rdx, 0
                je primeno
                inc r9
                jmp primeworker
            primeyes:
                mov rax, 1
                mov rdi, 1
                mov rsi, prime_msg_1
                mov rdx, prime_msg_1_len
                syscall
                ret
            primeno:
                mov rax, 1
                mov rdi, 1
                mov rsi, prime_msg_2
                mov rdx, prime_msg_2_len
                syscall
                ret


        power:
            mov rax, 1
            mov rdi, 1
            mov rsi, power_msg
            mov rdx, power_msg_len
            syscall
            POP rax
            POP r9
            POP r8
            PUSH rax
            inc r9
            PUSH r8
            PUSH r9
            call pow
            call pnum
            mov rax, 1
            mov rdi, 1
            mov rsi, factors_period
            mov rdx, factors_period_len
            syscall
            ret


        finddigit:
            POP rax
            POP r8
            POP r9
            PUSH rax
            mov r10, 1
            mov r11, 10
            sub r8, r10
            PUSH r9
            PUSH r11
            PUSH r11
            PUSH r8
            call pow
            POP r8
            POP r10
            POP r9
            mov rax, r9
            xor rdx, rdx
            div r10
            xor rdx, rdx
            div r10
            PUSH rdx
            call pnum
            ret

                


        input:                              ;Number input function
            mov rax, 0                      ;Wait for input into temp_var
            mov rdi, 0                      ;           |
            mov rsi, temp_var_i             ;           |
            mov rdx, temp_var_len_i         ;           |
            syscall                         ;End wait for input
            mov r8, temp_var_i              ;Move input to r8
            mov r9, 0                       ;Make r9 zero - counter variable
            inputcount:                     ;Function to count digits in input - different than integer counting
                cmp byte[r8], 0x0A          ;Compare the first byte of input (first letter) with the newline character
                je inputcountleave          ;If it is the newline character, jump to inputcountleave
                inc r8                      ;Increment r8 - in this case, it's incrementing the location in  memory, to read the next byte (letter)
                inc r9                      ;Increment counter variable
                jmp inputcount              ;Repeat
            inputcountleave:                ;Function to exit loop
            sub r8, r9                      ;Subtract length of input from input adress to return to start of input
            PUSH r8                         ;Save r8 to stack
            PUSH r9                         ;Save r9 to stack
            mov r8, 10                      ;Make r8 10
            PUSH r8                         ;Push r8 to stack
            PUSH r9                         ;Push r9 to stack
            call pow                        ;Get 10^length of input
            POP r9                          ;Save 10^length to r9
            POP r13                         ;Save length of input to r13
            POP r8                          ;Save input to r8
            mov r10, 10                     ;Make r10 10
            mov r11, 0                      ;Make r11 0 - total variable
            mov r12, 0                      ;Make r12 0 - temporary variable
            mov r14, 1                      ;Make r14 1 - counter variable
            mov r15, 48                     ;Make r15 48 - for converting ASCII to integer
            inc r13                         ;Make r13 one larger
            inputint:                       ;Function to convert ASCII to integer
                movzx r12, byte[r8]         ;Make temporary variable equal to first digit of input
                sub r12, r15                ;Subtract 48 from digit to make it an int
                imul r12, r9                ;Multiply it by 10^digit place - eg. 123 -> 1*100 + 2*10 + 3*1
                add r11, r12                ;Add temporary variable to total variable
                xor rdx, rdx                ;Make rdx zero
                mov rax, r9                 ;Make rax equal to 10^length var
                div r10                     ;Divide rax by 10
                mov r9, rax                 ;Make r9 equal to result
                inc r8                      ;Increment adress of input
                inc r14                     ;Input counter variable
                cmp r14, r13                ;Compare counter variable to length of input
                jne inputint                ;If it is equal, exit the loop
            inputfi:                        ;Function to exit the loop
            POP r8                          ;Save return adress to r8
            PUSH r11                        ;Push total to stack
            PUSH r8                         ;Push return adress to top of stack
            ret                             ;Return to where the function was called


    menu:
        mov rax, 1
        mov rdi, 1
        mov rsi, menu_msg
        mov rdx, menu_msg_len
        syscall
        call input
        POP rax
        cmp rax, 0
            je menuexit
        cmp rax, 1
            je menufactors
            jmp menufactorsfi
            menufactors:
                mov rax, 1
                mov rdi, 1
                mov rsi, menu_input_msg
                mov rdx, menu_input_msg_len
                syscall
                call input
                call factors
                jmp menu
            menufactorsfi:
        cmp rax, 2
            je menugcd
            jmp menugcdfi
            menugcd:
                mov rax, 1
                mov rdi, 1
                mov rsi, menu_input_msg
                mov rdx, menu_input_msg_len
                syscall
                call input
                mov rax, 1
                mov rdi, 1
                mov rsi, menu_input_msg_2
                mov rdx, menu_input_msg_len_2
                syscall
                call input
                call gcd
                mov rax, 1
                mov rdi, 1
                mov rsi, dnewline
                mov rdx, dnewlinelen
                syscall
                jmp menu
            menugcdfi:
        cmp rax, 3
            je menuprime
            jmp menuprimefi
            menuprime:
                mov rax, 1
                mov rdi, 1
                mov rsi, menu_input_msg
                mov rdx, menu_input_msg_len
                syscall
                call input
                call prime
                jmp menu
            menuprimefi:
        cmp rax, 4
            je menupower
            jmp menupowerfi
            menupower:
                mov rax, 1
                mov rdi, 1
                mov rsi, menu_input_msg_pow
                mov rdx, menu_input_msg_pow_len
                syscall
                call input
                mov rax, 1
                mov rdi, 1
                mov rsi, menu_input_msg_pow_2
                mov rdx, menu_input_msg_pow_len_2
                syscall
                call input
                call power
                jmp menu
            menupowerfi:
        cmp rax, 5
            je menufinddigit
            jmp menufinddigitfi
            menufinddigit:
                mov rax, 1
                mov rdi, 1
                mov rsi, menu_input_msg
                mov rdx, menu_input_msg_len
                syscall
                call input
                mov rax, 1
                mov rdi, 1
                mov rsi, menu_input_msg_finddigit_2
                mov rdx, menu_input_msg_finddigit_len_2
                syscall
                call input
                call finddigit
                mov rax, 1
                mov rdi, 1
                mov rsi, dnewline
                mov rdx, dnewlinelen
                syscall
                jmp menu
            menufinddigitfi:

        jmp menu
        menuexit:
        ret


    _start:                                 ;Linker instruction, code starts execution here
        call menu
        mov rax, 1
        mov rdi, 1
        mov rsi, quit_msg
        mov rdx, quit_msg_len
        syscall
        ; call input
        ; call pnum
        ; mov rax, 176
        ; PUSH rax                            ;Push rax onto stack, for factoring
        ; call factors                        ;Factor number
        ; mov rax, 20
        ; mov rbx, 15
        ; PUSH rax
        ; PUSH rbx
        ; call gcd



    mov    eax, 60                          ;System exit code
    mov    rdi, 0                           ;Success code
    syscall                                 ;Exit program


section .data                               ;Data for use in program

newline: db 0x0A
newlinelen: equ $-newline
dnewline: db 0x0A, 0x0A
dnewlinelen: equ $-dnewline
temp_var: times 64 db 0                     ;Save number printing variable with a buffer
temp_var_len: equ $-temp_var                ;Save the length of temp_var
temp_var_i: times 64 db 0                   ;Save number input variable with a buffer
temp_var_len_i: equ $-temp_var_i            ;Save the length of temp_var_i
factors_msg_1: db 0x0A, 'The factors of '
factors_msg_1_len: equ $-factors_msg_1
factors_msg_2: db ' are', 0x3A, ' '
factors_msg_2_len: equ $-factors_msg_2
factors_comma: db ', '
factors_comma_len: equ $-factors_comma
factors_period: db '.', 0x0A, 0x0A
factors_period_len: equ $-factors_period
gcd_msg: db 'The GCD is', 0x3A, ' '
gcd_msg_len: equ $-gcd_msg
prime_msg_1: db 'The number is prime.', 0x0A, 0x0A
prime_msg_1_len: equ $-prime_msg_1
prime_msg_2: db 'The number is not prime.', 0x0A, 0x0A
prime_msg_2_len: equ $-prime_msg_2
power_msg: db 'The value is', 0x3A, ' '
power_msg_len: equ $-power_msg
finddigit_msg: db 'The digit is', 0x3A, ' '
finddigit_msg_len: equ $-finddigit_msg

menu_msg: db 'Please Choose a method', 0x3A, 0x0A, '1. Factors', 0x0A,'2. GCD', 0x0A, '3. Prime', 0x0A, '4. Power', 0x0A, '5. Find Digit', 0x0A, '6. Down Digits, ', 0x0A, '7. Count Digits, ', 0x0A, '0. Quit', 0x0A
menu_msg_len: equ $-menu_msg
menu_input_msg: db 'Input a number ', 0x28, 'int', 0x29, 0x3A, ' '
menu_input_msg_len: equ $-menu_input_msg
menu_input_msg_2: db 'Input another number ', 0x28, 'int', 0x29, 0x3A, ' '
menu_input_msg_len_2: equ $-menu_input_msg_2
quit_msg: db 'Thank you for using my program.', 0x0A
quit_msg_len: equ $-quit_msg
menu_input_msg_pow: db 'Input a number for the base ', 0x28, 'int', 0x29, 0x3A, ' '
menu_input_msg_pow_len: equ $-menu_input_msg_pow
menu_input_msg_pow_2: db 'Input a number for the exponent ', 0x28, 'int', 0x29, 0x3A, ' '
menu_input_msg_pow_len_2: equ $-menu_input_msg_pow_2
menu_input_msg_finddigit_2: db 'Input which digit from the right ', 0x28, 'int', 0x29, 0x3A, ' '
menu_input_msg_finddigit_len_2: equ $-menu_input_msg_finddigit_2