       
       
       
 .bss
 .text
 .set button_pin, 30
 .global entry
entry:
 REG_RD ((((0x3ff48400 + 0x24)) - 0x3ff48000) / 4), ((button_pin) + (1) - 1), (button_pin)
 AND R0, R0, 1
 JUMP entry, eq
 JUMP wake_up
 .global wake_up
wake_up:
 REG_RD ((((0x3ff48000 + 0xc0)) - 0x3ff48000) / 4), ((19) + ((((((((0x1) >> (0)) & 1) + (((0x1) >> (0 + 1)) & 1)) + ((((0x1) >> (0 + 2)) & 1) + (((0x1) >> (0 + 2 + 1)) & 1))) + (((((0x1) >> (0 + 4)) & 1) + (((0x1) >> (0 + 4 + 1)) & 1)) + ((((0x1) >> (0 + 4 + 2)) & 1) + (((0x1) >> (0 + 4 + 2 + 1)) & 1)))) + ((((((0x1) >> (0 + 8)) & 1) + (((0x1) >> (0 + 8 + 1)) & 1)) + ((((0x1) >> (0 + 8 + 2)) & 1) + (((0x1) >> (0 + 8 + 2 + 1)) & 1))) + (((((0x1) >> (0 + 8 + 4)) & 1) + (((0x1) >> (0 + 8 + 4 + 1)) & 1)) + ((((0x1) >> (0 + 8 + 4 + 2)) & 1) + (((0x1) >> (0 + 8 + 4 + 2 + 1)) & 1)))))) - 1), (19)
 AND r0, r0, 1
 JUMP exit, eq
 WAKE
 .global exit
exit:
 HALT
