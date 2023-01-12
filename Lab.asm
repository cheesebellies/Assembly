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
; DESCRIPTION - Simple mathematic algorithms including 
;               factoring, GCD, exponents, finding 
;               digits, printing digits, and counting 
;               digits.
; *******************************************************

global _start               ;Linker instructions

section .data               ;Data for use in program

section .text               ;Main code







;********************************************************
;                       System exit
;********************************************************

    mov    eax, 60          ;System exit code
    mov    rdi, 0           ;Success code
    syscall                 ;Exit program