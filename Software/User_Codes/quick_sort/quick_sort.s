    .data
array:  .word 9, 4, 7, 3, 2, 8, 5, 1, 6
length: .word 9

    .text
    .globl _start
_start:
    la t0, array           # Load address of array
    lw t1, length          # Load length of array
    addi t1, t1, -1        # Calculate the last index (length-1)
    call quicksort         # Call quicksort(array, 0, length-1)

    # Exit (using ecall)
    li a7, 93              # ecall for exit
    ecall

# quicksort(array, low, high)
quicksort:
    bge a1, a2, qs_return  # if low >= high, return
    mv t3, a1              # t3 = low
    mv t4, a2              # t4 = high
    mv a0, t0              # a0 = array
    call partition         # partition(array, low, high)
    mv t5, a0              # t5 = pivot index

    mv a1, t3              # low
    addi a2, t5, -1        # high = pivot_index - 1
    call quicksort         # quicksort(array, low, pivot_index-1)

    addi a1, t5, 1         # low = pivot_index + 1
    mv a2, t4              # high
    call quicksort         # quicksort(array, pivot_index+1, high)

qs_return:
    ret

# partition(array, low, high) -> returns pivot index
partition:
    mv t1, a1              # t1 = low
    mv t2, a2              # t2 = high
    slli t3, t2, 2         # t3 = high * 4 (word size)
    add t3, t3, t0         # t3 = array + high * 4
    lw t4, 0(t3)           # t4 = array[high] (pivot)

    addi t5, t1, -1        # t5 = low - 1

partition_loop:
    addi t2, t2, -1        # high--
    blt t2, t1, partition_end # if high < low, break

    slli t3, t2, 2         # t3 = high * 4
    add t3, t3, t0         # t3 = array + high * 4
    lw t6, 0(t3)           # t6 = array[high]

    bge t6, t4, partition_loop # if array[high] >= pivot, continue

    addi t5, t5, 1         # low++
    slli t7, t5, 2         # t7 = low * 4
    add t7, t7, t0         # t7 = array + low * 4
    lw t8, 0(t7)           # t8 = array[low]
    sw t8, 0(t3)           # array[high] = array[low]
    sw t6, 0(t7)           # array[low] = array[high]

    j partition_loop

partition_end:
    addi t5, t5, 1         # low++
    slli t3, t5, 2         # t3 = low * 4
    add t3, t3, t0         # t3 = array + low * 4
    lw t6, 0(t3)           # t6 = array[low]
    sw t4, 0(t3)           # array[low] = pivot
    mv a0, t5              # return low (pivot index)
    ret
