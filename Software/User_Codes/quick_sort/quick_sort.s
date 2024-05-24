main:
    # Create stack
    li      sp, 0xffc
    addi    sp, sp, -48
    sw      s0, 44(sp)
    addi    s0, sp, 48

    # Initialize arr[] to memory
    li      a5, 3
    sw      a5, -48(s0)
    li      a5, 5
    sw      a5, -44(s0)
    li      a5, 1
    sw      a5, -40(s0)
    li      a5, 2
    sw      a5, -36(s0)
    li      a5, 4
    sw      a5, -32(s0)

    # Initialize low and high
    li      a1, 0             # low = 0
    li      a2, 4             # high = 4 (index of last element)

    # Compute base address of array
    addi    a0, s0, -48       # a0 = base address of arr

    # Call quicksort
    j       quicksort

main_return:
    # Return
    li      a5, 0
    mv      a0, a5
    lw      s0, 44(sp)
    addi    sp, sp, 48
    j       end

# Swap function: void swap(int *a, int *b)
swap:
    lw      t0, 0(a0)             # Load value at a0 into t0
    lw      t1, 0(a1)             # Load value at a1 into t1
    sw      t1, 0(a0)             # Store t1 at a0
    sw      t0, 0(a1)             # Store t0 at a1
    j       main_return           # Return from function

# Partition function: int partition(int arr[], int low, int high)
partition:
    add     t0, a1, zero          # t0 = low
    slli    t3, a2, 2             # t3 = high * 4
    add     t3, t3, a0            # t3 = base + high * 4
    lw      t1, 0(t3)             # t1 = arr[high]
    addi    t2, a1, -1            # t2 = low - 1

.partition_loop:
    blt     t0, a2, .partition_check  # if t0 < high, check
    j       .partition_end            # else, end partition

.partition_check:
    slli    t3, t0, 2             # t3 = t0 * 4
    add     t4, a0, t3            # t4 = base + t0 * 4
    lw      t5, 0(t4)             # t5 = arr[t0]

    blt     t5, t1, .partition_if  # if arr[t0] < pivot, swap

    addi    t0, t0, 1             # t0++
    j       .partition_loop       # Continue loop

.partition_if:
    addi    t2, t2, 1             # t2++
    slli    t3, t2, 2             # t3 = t2 * 4
    add     t4, a0, t3            # t4 = base + t2 * 4
    mv      a3, t4                # a3 = &arr[t2]
    slli    t3, t0, 2             # t3 = t0 * 4
    add     t4, a0, t3            # t4 = base + t0 * 4
    mv      a4, t4                # a4 = &arr[t0]
    j       swap                  # swap(&arr[t2], &arr[t0])

.partition_end:
    addi    t2, t2, 1             # t2++
    slli    t3, t2, 2             # t3 = t2 * 4
    add     t4, a0, t3            # t4 = base + t2 * 4
    mv      a3, t4                # a3 = &arr[t2]
    slli    t3, a2, 2             # t3 = high * 4
    add     t4, a0, t3            # t4 = base + high * 4
    j       swap                  # swap(&arr[t2], &arr[high])

# Quick Sort function: void quicksort(int arr[], int low, int high)
quicksort:
    bge     a1, a2, quicksort_end # if low >= high, return

    mv      a3, a0               # a3 = arr
    mv      a4, a1               # a4 = low
    mv      a5, a2               # a5 = high
    j       partition            # pivot = partition(arr, low, high)

quicksort_end:
    j       main_return           # Return from function

# End of program
end:
    ebreak