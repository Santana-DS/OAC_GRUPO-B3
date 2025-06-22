.data
    newline: .asciz "\n"
    msg_f1:  .asciz "f1 instructions: "
    msg_f2:  .asciz "f2 instructions: "
    msg_f3:  .asciz "f3 instructions: "
    msg_f4:  .asciz "f4 instructions: "
    msg_f5:  .asciz "f5 instructions: "
    msg_f6:  .asciz "f6 instructions: "
    msg_result_f1: .asciz "Resultado f1: "
    msg_result_f2: .asciz "Resultado f2: "
    msg_result_f3: .asciz "Resultado f3: "
    msg_result_f4: .asciz "Resultado f4: "
    msg_result_f5: .asciz "Resultado f5: "
    msg_result_f6: .asciz "Resultado f6: "
    x_value: .word 5
    .double_4: .double 4.0

.text
.globl main

main:
    # === f1 ===	return 4*x
    lw a0, x_value
    la a1, msg_f1
    jal print_msg
    jal measure_f1
    jal print_result

    la a1, msg_result_f1
    jal print_msg
    lw a0, x_value
    jal compute_f1
    jal print_result

    # === f2 ===	return x << 2
    lw a0, x_value
    la a1, msg_f2
    jal print_msg
    jal measure_f2
    jal print_result

    la a1, msg_result_f2
    jal print_msg
    lw a0, x_value
    jal compute_f2
    jal print_result

    # === f3 ===	return x + x + x + x
    lw a0, x_value
    la a1, msg_f3
    jal print_msg
    jal measure_f3
    jal print_result

    la a1, msg_result_f3
    jal print_msg
    lw a0, x_value
    jal compute_f3
    jal print_result

    # === f4 ===	return 3*x+x
    lw a0, x_value
    la a1, msg_f4
    jal print_msg
    jal measure_f4
    jal print_result

    la a1, msg_result_f4
    jal print_msg
    lw a0, x_value
    jal compute_f4
    jal print_result

    # === f5 ===	return 2*x+2*x
    lw a0, x_value
    la a1, msg_f5
    jal print_msg
    jal measure_f5
    jal print_result

    la a1, msg_result_f5
    jal print_msg
    lw a0, x_value
    jal compute_f5
    jal print_result

    # === f6 ===	return pow(2,2)*x
    lw a0, x_value
    la a1, msg_f6
    jal print_msg
    jal measure_f6
    jal print_result

    la a1, msg_result_f6
    jal print_msg
    lw a0, x_value
    jal compute_f6
    jal print_result

    # Exit
    li a7, 10
    ecall

# ===== Measure Functions =====
measure_f1:
    rdcycle t2
    li t1, 4
    mul a0, a0, t1
    rdcycle t3
    sub a0, t3, t2
    ret

measure_f2:
    rdcycle t2
    slli a0, a0, 2
    rdcycle t3
    sub a0, t3, t2
    ret

measure_f3:
    rdcycle t2
    add a0, a0, a0
    add a0, a0, a0
    rdcycle t3
    sub a0, t3, t2
    ret

measure_f4:
    rdcycle t2
    li t1, 3
    mul t1, a0, t1
    add a0, t1, a0
    rdcycle t3
    sub a0, t3, t2
    ret

measure_f5:
    rdcycle t3
    li t1, 2
    mul t4, a0, t1
    add a0, t4, t4
    rdcycle t5
    sub a0, t5, t3
    ret

measure_f6:
    rdcycle t2
    fcvt.d.w fa0, a0
    la t1, .double_4
    fld fa1, 0(t1)
    fmul.d fa0, fa0, fa1
    fcvt.w.d a0, fa0, rtz
    rdcycle t3
    sub a0, t3, t2
    ret


# ===== Compute Value Functions =====
compute_f1:
    li t1, 4
    mul a0, a0, t1
    ret

compute_f2:
    slli a0, a0, 2
    ret

compute_f3:
    add a0, a0, a0
    add a0, a0, a0
    ret

compute_f4:
    li t1, 3
    mul t1, a0, t1
    add a0, t1, a0
    ret

compute_f5:
    li t1, 2
    mul t2, a0, t1
    add a0, t2, t2
    ret

compute_f6:
    fcvt.d.w fa0, a0            # int ? double
    la t1, .double_4            # endereco do 4.0
    fld fa1, 0(t1)              # carrega double 4.0
    fmul.d fa0, fa0, fa1        # x * 4.0
    fcvt.w.d a0, fa0, rtz       # double ? int
    ret


# ===== Helper Functions =====
print_msg:
    li a7, 4
    mv a0, a1
    ecall
    ret

print_result:
    li a7, 1
    ecall
    li a7, 4
    la a0, newline
    ecall
    ret

