org 0x7C00
bits 16
; LEGENDARIUM:
;  Directives: give assembler clues that will affect how the program is compiled.
;              These are not translated to machine code, as they are not instructions,
;              they are indications for program interpretation.

; Instructions: These are executable orders that are translated to machine code and
;               executed by the cpu.



; main OS code section tells it to do nothing :)
main:
    hlt

; halt jumper in case of computer reboot to prevent pc looping boots
.halt:
    jmp .halt

; providing OS signature (OS program first sector last two bits must be AA55) required by BIOS
; looping ("times" directive) define constant bite ("db" directive) until desired memory location is obtained.
; sector padding will comply with 144Mbs standard "floppy disk" size 16 bits OS where first sector is 512 bites
; following code will loop the defining of a constant byte (510 - [size of the current program]) times
; $: symbol equal to the memory offset of the current line
; $$: symbol equal to the memory offset of the current section
; ($-$$) returns length of current section ::SO FAR:: in bytes
times 510-($-$$) db 0
; up to here the code's size is 510 bytes

; define word ("dw" directive) will emit a word (IE, a two byte constant)
dw 0AA55h
; now code fills the required first sections 512 bytes
