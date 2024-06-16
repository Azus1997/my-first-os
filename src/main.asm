org 0x7C00
bits 16
; LEGENDARIUM:
;  Directives: give assembler clues that will affect how the program is compiled.
;              These are not translated to machine code, as they are not instructions,
;              they are indications for program interpretation.

; Instructions: These are executable orders that are translated to machine code and
;               executed by the cpu.


;define macro called ENDL that expands bytes 0x0D and 0x0A
; 0x0D: carriage return, 0x0A: line feed
; this is common use to repsent end of lines in text file in dos and windows systems
%define ENDL 0x0D, 0x0A

; starting function to ensure that main function is first called since
; assembly is a sequential language
start:
    jmp main
; prints S string on screen
; params:
;        -ds:si points to s string
; pointer will print characters until it finds a null char
puts:
    ; save registers that we will modify
        push si
        push ax

; function to loop the loading of single bytes.
.loop:
    ; lodsb: load single byte instruction in al, the least significant byte in EAX register
    lodsb
    ; we create the exit loop condition:
    ; OR [destination, source] performs bitwise inclusive OR operation
    ; stores result in destination
    or al, al
    jz .doneLoop

    ; prepare BIOS interrupt
    mov ah, 0x0e
    ; interrupt BIOS services
    int 0x10
    ; jump to start of function
    jmp .loop
    ; I THINK how this function works is that it will loop the loading of the al byte (by jumping to the beginning of the method unless al is null)
    ; untill it reaches a null value, which is when it uses the OR to evaluate the
    ; value of the al byte and make sure such a value exists.
    ; al being empty, it stores a false value in al (0)
    ; since al is 0, jz ("jump zero" [destination]) calls .doneLoop
    ; which cleans the stack and finally, the method calls the BIOS interrupt


.doneLoop:
    pop ax
    pop si
    ret

; main OS code section
main:
    ; we can't write to segment 0 directly so we use a transit segment "ax"
    mov ax, 0
    mov ds, ax
    mov es, ax

    ; we setup the stack segment and stack pointer:
    ; "ss" for stack segment definition
    ; "sp" for stack pointer definition. It is placed at the BEGINNING of the OS bc
    ; the stack segment grows downwards, if it was placed at the end of the OS segment
    ; the content pushed into the stack would overwrite the OS code in memory
    mov ss, ax
    mov sp, 0x7C00

    ;print message
    mov si, msg_hello
    call puts
    hlt

; halt jumper in case of computer reboot to prevent pc looping boots
.halt:
    jmp .halt

; define msg_hello label, this will be printed on screen with the string message annd will enter a new line
msg_hello: db 'Hello World!', ENDL, 0
; providing OS signature (OS program first sector last two bits must be AA55) required by BIOS
; looping ("times" directive) define constant bite ("db" directive) until desired memory location is obtained.
; sector padding will comply with 144Mbs standard "floppy disk" size 16 bits OS where first sector is 512 bites
; following code will loop the defining of a constant byte (510 - [size of the current program]) times
; $: symbol equal to the memory offset of the current line
; $$: symbol equal to the memory offset of the current section
; ($-$$) returns length of current section /\SO FAR/\ in bytes
times 510-($-$$) db 0
; up to here the code's size is 510 bytes

; define word ("dw" directive) will emit a word (IE, a two byte constant)
dw 0AA55h
; now code fills the required first sections 512 bytes
