    OUTPUT LCDScroll2.z80

    ORG $9000

ROTARYENCODER EQU $D7
LCD_R   EQU 218
LCD_D   EQU 219

; The input bits from the rotary encoder.
CLK1    EQU %00000001
DT1     EQU %00000010
SW1     EQU %00000100

; show the inital first 4 lines on the LCD.
    call setup_LCD

    ld hl,puff
    ld (puffpointer),hl
    call show_four_lines

loop:
; load the last clk value into register b
    ld  a,(lastclk)
    ld  b,a

; read the input port and store in "input"
    in  a,(ROTARYENCODER)
    ld  (input),a

; now check if the switch on first rotary encoder has been
; pressed. If it has jump to end
    and SW1
    cp  SW1
    jr  z, end

; now see if clk1 matches the lastclk. If it does loop
    ld  a,(input)
    and CLK1
    ld  (lastclk),a
    cp  b
    jr  z, loop

; now work out what direction we are moving.
; if CLK1 is 1 then we can can check DT1 to get the
; direction of rotation. If it's 0, we need to go 
; back to the start of the loop.
    ld  a,(input)          
    and CLK1
    cp  CLK1 
    jr  nz, loop            

; this is where we check DT1. If 1 we are turning left.
    ld  a, (input)
    and DT1
    cp  0 
    jr  nz, left

; we must be turning right, so we need to advance 
; our text. We see if we are at the maximum, and
; if not we advance a line and display.
right:
    or a
    ld de,maxpuff
    ld hl,(puffpointer)
    sbc hl, de
    add hl, de
    jp z,loop

    ld hl,(puffpointer)
    ld bc,20
    add hl,bc
    ld (puffpointer),hl
    call show_four_lines

    jr  loop

; we must be turning left, so we need to go
; back. We see if we are at the start of the 
; text and if not we go back a line and display.
left:
    or a
    ld de,puff
    ld hl,(puffpointer)
    sbc hl, de
    add hl, de
    jp z,loop

    ld hl,(puffpointer)
    ld bc,20
    sub hl,bc
    ld (puffpointer),hl
    call show_four_lines

    jp  loop

; the switch has been pressed, so we clear the output
; and exit.
end:
    call clear_screen

    ret


; Sends a command byte to the LCD.
; A - Command in
; A, C registers used.
send_command:
    out (LCD_R),a
.lcd_busy:
    in a,(LCD_R)
    rlca
    jr c,.lcd_busy
    ret

; Sends a data byte to the LCD
; A - Byte in
; A, C registers used.
send_data:
    out (LCD_D),a
.lcd_busy:
    in a,(LCD_R)
    rlca
    jr c,.lcd_busy
    ret

; setup the LCD screen
setup_LCD:
    ld a,56         ; Function 8 bit, 2 lines, 5x8 dot font
    call send_command
    ld a,12         ; Display on, cursor off, no blink
    call send_command

    call clear_screen

    ret

; clear the LCD screen
clear_screen:
    ld a,1          ; clear the display
    call send_command
    ret

; send a line of text to the LCD screen.
; HL - address of text to display on the LCD.
send_line:
    ld b,20
.lineloop:
    ld a,(hl)
    inc hl
    call send_data
    djnz .lineloop
    ret

; Display 4 lines of consecutive text on the LCD
; lines are shown 1-20,41-60,21-40,61-80 so we 
; need to jump around to display in order.
; HL - address of text to display on the LCD
; A, B, C, D, E, H, L registers used.
show_four_lines:

; send the first line
    call send_line

; jump forward 20 characters, and show
    ld de,20
    add hl,de
    call send_line

; jump back 40 characters, and show
    ld de,40
    sub hl,de
    call send_line

; jump forward 20 characters, and show
    ld de,20
    add hl,de
    call send_line

    ret      


; stores the current input from the rotary encode.
input:
    db  0
; stores the last value of CLK1.
lastclk:
    db  0

; the text to show, each line must be 20 bytes long.
puff:
    db "Puff the fractal    "
    db "dragon was written  "
    db "in C,               "
    db "And frolicked while "
    db "processes switched  "
    db "in mainframe memory."
    db "                    "
    db "No plain fanfold    "
    db "paper could hold    "
    db "that fractal Puff   "
    db "                    "
    db "He grew so fast no  "
    db "plotting pack could "
    db "shrink him far      "
    db "enough.             "
    db "Compiles and        "
    db "simulations grew so "
    db "quickly tame        "
    db "And swapped out all "
    db "their data space    "
    db "when Puff pushed    "
    db "his stack frame.    "
    db "                    "
    db "Puff the fractal    "
    db "dragon was written  "
    db "in C,               "
    db "And frolicked while "
    db "processes switched  "
    db "in mainframe memory."
    db "Puff the fractal    "
    db "dragon was written  "
    db "in C,               "
    db "And frolicked while "
    db "processes switched  "
    db "in mainframe memory."
    db "                    "
    db "Puff, he grew so    "
    db "quickly, while      "
    db "others moved like   "
    db "snails              "
    db "And mini-Puffs      "
    db "would perch         "
    db "themselves on his   "
    db "gigantic tail.      "
    db "All the student     "
    db "hackers loved that  "
    db "fractal Puff        "
    db "But DCS did not     "
    db "like Puff, and      "
    db "finally said,       "
    db "\"Enough!\"           "
    db "                    "
    db "Puff the fractal    "
    db "dragon was written  "
    db "in C,               "
    db "And frolicked while "
    db "processes switched  "
    db "in mainframe memory."
    db "Puff the fractal    "
    db "dragon was written  "
    db "in C,               "
    db "And frolicked while "
    db "processes switched  "
    db "in mainframe memory."
    db "                    "
    db "Puff used more      "
    db "resources than DCS  "
    db "could spare.        "
    db "The operator killed "
    db "Puff's job -- he    "
    db "didn't seem to care."
    db "A gloom fell on the "
    db "hackers; it seemed  "
    db "to be the end,      "
    db "But Puff trapped    "
    db "the exception, and  "
    db "grew from naught    "
    db "again!              "
    db "                    "
    db "Puff the fractal    "
    db "dragon was written  "
    db "in C,               "
    db "And frolicked while "
    db "processes switched  "
    db "in mainframe memory."
    db "Puff the fractal    "
    db "dragon was written  "
    db "in C,               "
    db "And frolicked while "
    db "processes switched  "
    db "in mainframe memory."
puffend:
maxpuff EQU puffend - 80

; stores a pointer to our current position in the text.
puffpointer:
    dw  puff

