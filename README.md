# Rotary-Encoder-for-RC2014

This is my entry for the Retro Challenge 2024, a Rotary Encoder module for the RC2014 computer.

The module provides interfaces for two rotary encoders, as well as visual feedback and debugging pin headers.

https://www.robertprice.co.uk/robblog/category/rc2024/

## Usage

The Rotary Encoder module has been assigned port D7 (215 in decimal), with A7 as an alernative if this clashes with another module.

The following bits are assigned with reading with an IN command.

| Bit | Port | Input |
|-----|------|-------|
| 0   | 1    | CLK   |
| 1   | 1    | DT    |
| 2   | 1    | SW    |
| 3   | 2    | CLK   |
| 4   | 2    | DT    |
| 5   | 2    | SW    |
| 6   | X    | X     |
| 7   | X    | X     | 

Bits 6 and 7 are unassigned.

When the encoder is turning the CLK and DT pins with pulse high, the order in which they pulse can determine if the rotary encoder is being turned left or right. When the encoder is pressed down the SW bit will go high.

There are examples in BASIC and Z80 machine code. 

* Example1.basic - this prints if the encoder is being turned left or right.
* LEDExample.basic - if you have the DigitalIO module, this will move the LEDS depending on how the rotary encoder is being turned.
* LEDControl.s - a Z80 assembly version of the LED control program.
* LCDScroller.s - if you have a 4x20 LCD module, this will display a poem and allow you to scroll through it.

## PCB

The Gerber files, BOM, and schematic (created using EasyEDA) to build your own module can be found in the PCB folder.

The debug port is optional, only fit this if you want access to see the values going into the RC2014.

The LEDs are also optional. If you don't want these, they can be left out along with the resistor array (R3) next to them.

## Where to buy a suitable rotary encoder

Rotary encoders can be purchased on Amazon, eBay, AliExpress, or your favourite electronics provider.

Here's an AliExpress affiliate link for a suitable rotary encoder if you aren't sure what to buy.
https://s.click.aliexpress.com/e/_DdCUkGz

## Copyright

This module is Copyright 2024 Robert Price and released under the MIT license.
