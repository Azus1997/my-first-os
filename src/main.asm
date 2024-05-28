org 07xC00
bits 16
; LEGENDARIUM:
;  Directives: give assembler clues that will affect how the program is compiled.
;              These are not translated to machine code, as they are not instructions,
;              they are indications for program interpretation.

; Instructions: These are executable orders that are translated to machine code and
;               executed by the cpu.



; main OS code section tells is to do nothing :)
main:
    hlt

; halt jumper in case of computer reboot to prevent pc looping boots
.halt:
    jmp .halt

; sector padding to comply with 144Mbs standard "floppy disk" size 16 bits OS
; providing OS signature (sector finishing in 0xAA55)
; looping ("times" directive) write bite ("db" directive) until desired memory location is obtained.
