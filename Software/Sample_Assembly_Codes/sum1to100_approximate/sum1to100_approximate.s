        li      x1, 0xFFFFFF81
        addi    x12,    x0,    6
        add     x13,    x0,    x0 
        add     x14,    x0,     x0 
LOOP:   mul     x14,    x13,    x14
        addi    x13,    x13,    1
        blt     x13,    x12,    LOOP
        sw      x14,    100(x0)
        ebreak