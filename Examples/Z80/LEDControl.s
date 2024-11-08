    OUTPUT rotaryencoderledcontrol2.z80

; On the RC2014 Classic 2 running from BASIC the Z80
; code runs from address $9000. 
    ORG $9000

; The input and output ports to use.
INPUT_PORT  EQU $D7
OUTPUT_PORT EQU $00

; The input bits from the rotary encoder.
CLK1    EQU %00000001
DT1     EQU %00000010
SW1     EQU %00000100

; show the inital led value
    ld  a,(output)
    out (OUTPUT_PORT),a

loop:
; load the last clk value into register b
    ld  a,(lastclk)
    ld  b,a

; read the input port and store in "input"
    in  a,(INPUT_PORT)
    ld  (input),a

; now check if the switch on first rotary encode has been
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

; we must be turning right so rotate the output to the right
; and store it before going back to the start of the loop.
right:
    ld  a,(output)
    rrca
    out (OUTPUT_PORT),a
    ld  (output),a

    jr  loop

; we must be turning left so rotate the output to the left
; and store it before going back to the start of the loop.
left:
    ld  a,(output)
    rlca
    out (OUTPUT_PORT),a
    ld  (output),a

    jp  loop

; the switch has been pressed, so we clear the output
; and exit.
end:
    ld  a,0
    out (OUTPUT_PORT),a

    ret

input:
    db  0
output:
    db  %00000001
lastclk:
    db  0
