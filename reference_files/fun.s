        .data
ddd:    .4byte   1234
fred:   .4byte   1
        .4byte   80
stuff:  .4byte   0
        .4byte   0

        .text
        .global _start



_start: lw  a1,  fred+4     # put 10 in register a1
        li  a0,0            # start it at zero
reloop: addi  a0, a0, 0x20  # put 0 in a0
incit:  addi    a0, a0, 1   # increment a0
        sb  a0,16(a0)       # hope this works
        lw  a2,13(a0)       # More fun stuff...
        blt a0,a1,incit     # loop if less than a1
        andi a0, a0, 0xf0   # remove low part
        beq a0,a0,reloop    # never ends...

