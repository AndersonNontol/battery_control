       
       
       
 .bss
 .text
 .set ticks_number, 120
 .global entry
entry:
 STAGE_RST
 REG_RD ((((0x3ff48400 + 0x24)) - 0x3ff48000) / 4), ((26) + (1) - 1), (26)
 JUMPS turn_off, 1, EQ
 REG_WR ((((0x3ff48400 + 0x0)) - 0x3ff48000) / 4), ((26) + (1) - 1), (26), ((1) & 0xff)
 JUMP timer
timer:
 STAGE_INC 0.0001
 JUMPS entry, ticks_number, LE
turn_off:
 REG_WR ((((0x3ff48400 + 0x0)) - 0x3ff48000) / 4), ((26) + (1) - 1), (26), ((0) & 0xff)
 JUMP timer
