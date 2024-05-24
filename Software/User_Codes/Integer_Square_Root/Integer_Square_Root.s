main:
    li      t0,     16
    li      t1,       1

sqrt_loop:
    blt     t1,    t0,    sqrt_check
    li      t1,     0
    j sqrt_done

sqrt_check:
    rem     t3,   t0,     t1
    beqz    t3,   sqrt_check2
    addi    t1,   t1,     1
    j sqrt_loop

sqrt_check2:
    div     t4,   t0,     t1
    beq     t4,   t1,     sqrt_done
    addi    t1,   t1,     1
    j sqrt_loop

sqrt_done:
    mv  t5, t1
    ebreak


