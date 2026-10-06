.global print_progress
    .align 2

/* 
 * Arguments:
 * w0 = row
 * w1 = column
 * x2 = address of label (message)
 * w3 = percent
 * w4 = width
 */
print_progress:
    // Save x29, x30, and registers we plan to use (x19-x26)
    stp     x29, x30, [sp, -80]!
    mov     x29, sp
    stp     x19, x20, [sp, 16]
    stp     x21, x22, [sp, 32]
    stp     x23, x24, [sp, 48]
    stp     x25, x26, [sp, 64]

    // Save arguments into preserved registers before making function calls
    mov     w22, w0       // w22 = row
    mov     w23, w1       // w23 = column
    mov     x25, x2       // x25 = address of label
    mov     w26, w3       // w26 = percent
    mov     w24, w4       // w24 = width

    // Print the message using print_to()
    // w0, w1, and x2 already hold row, column, and label address
    bl      print_to

    // If percent is above 100 then return 1 (error)
    cmp     w26, 100
    b.hi    .return_with_error

    // Calculate the number of '=' to draw: (percent * width) / 100
    mul     w19, w26, w24     // w19 = percent * width
    mov     w9, 100           // w9 = 100 (temporary register)
    udiv    w19, w19, w9      // w19 = count of '='

    // Call strlen() on label address
    mov     x0, x25           // x0 = address of label
    bl      strlen
    mov     w20, w0           // w20 = length of label string

    // Put '=' in a local variable (w21)
    mov     w21, 61           // 61 is ASCII for '='

.loop_start:
    // If count of equal signs (in w19) is zero, put ' ' (space) in w21
    cmp     w19, 0
    b.ne    .skip_space       // Skip if not zero (leave as '=' or space if already changed)
    mov     w21, 32           // 32 is ASCII for ' '

.skip_space:
    // If width is 0, return
    cmp     w24, 0
    b.eq    .return_ok

    // Call putc_to to print the "=" (or the space)
    mov     w0, w22           // argument 0: row
    add     w1, w23, w20      // argument 1: column + length of label string
    mov     w2, w21           // argument 2: character ('=' or ' ')
    bl      putc_to

    // Update variables
    add     w23, w23, 1       // increment column by 1
    sub     w19, w19, 1       // decrement count of equal signs by 1
    sub     w24, w24, 1       // decrement width by 1

    // End loop
    b       .loop_start

.return_with_error:
    mov     w0, 1             // Error code 1
    b       .done

.return_ok:
    mov     w0, 0             // Success code 0

.done:
    // Clean up the stack and restore registers
    ldp     x25, x26, [sp, 64]
    ldp     x23, x24, [sp, 48]
    ldp     x21, x22, [sp, 32]
    ldp     x19, x20, [sp, 16]
    ldp     x29, x30, [sp], 80
    ret
