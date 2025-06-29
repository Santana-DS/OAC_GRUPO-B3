.data 0x10010000
    test_data: .word 0x12345678
    result:    .word 0

.text 0x00400000
main:
    # ===== TESTE LW =====
    # A instrução seguinte (addi) escreve em t0, não lê. Sem hazard aqui.
    lw t0, 0(gp)

    # ===== TESTE ADDI =====
    # A instrução seguinte (addi) não depende de t0. Sem hazard aqui.
    addi t0, zero, 1

    # ===== TESTE ADD/SUB =====
    addi t1, zero, 5
    nop                          # HAZARD: 'add' precisa ler t1, que 'addi' acabou de definir.
    nop                          # Stall de 3 ciclos para garantir que WB de 'addi' termine
    nop                          # antes do ID de 'add'.
    add t0, t0, t1               # t0 = 6
    nop                          # HAZARD: 'sub' precisa ler t0 e t1, que 'add' acabou de definir.
    nop                          # Stall de 3 ciclos para RAW.
    nop
    sub t0, t0, t1               # t0 = 1

    # ===== TESTE AND/OR =====
    addi t0, zero, 0xF0          
    addi t1, zero, 0x0F
    nop                          # HAZARD: 'and' precisa de t0 e t1 das instruções 'addi' anteriores.
    nop
    nop
    and t0, t0, t1               # t0 = 0x00
    nop                          # HAZARD: 'or' precisa de t0, que 'and' acabou de definir.
    nop
    nop
    or t0, t0, t1                # t0 = 0x0F

    # ===== TESTE SLT =====
    addi t0, zero, 5             
    addi t1, zero, 10
    nop                          # HAZARD: 'slt' precisa de t0 e t1 das instruções 'addi' anteriores.
    nop
    nop
    slt t0, t0, t1               # t0 = 1

    # ===== TESTE SW =====
    addi t0, zero, 0x55
    nop                          # HAZARD: 'sw' precisa ler t0 para saber o que armazenar.
    nop
    nop
    sw t0, 4(gp)                 # MEM[gp+4] = 0x55
    
    # LW-use hazard. O 'addi' seguinte não depende do resultado do 'lw', então está ok.
    lw t0, 4(gp)

    # ===== TESTE BEQ =====
    addi t0, zero, 10            
    addi t1, zero, 10
    nop                          # HAZARD: 'beq' precisa de t0 e t1 das instruções 'addi' anteriores.
    nop
    nop
    beq t0, t1, branch_ok
    nop                          # Bolha para resolver o hazard de controle (branch delay slot).
    addi t0, zero, 0x66         # Não deve executar
branch_ok:
    addi t0, zero, 1

    # ===== TESTE JAL =====
    jal t1, jal_test
    nop                          # Bolha para resolver o hazard de controle.
    addi t0, zero, 0x66         # Não deve executar
jal_test:
    addi t0, zero, 2

    # ===== TESTE JALR =====
    # 'jal' escreveu o endereço de retorno em t1. A instrução 'addi' abaixo precisa ler t1.
    nop
    nop
    nop
    addi t1, t1, 0x14
    nop                          # HAZARD: 'jalr' precisa do novo valor de t1.
    nop
    nop
    jalr ra, t1, 0
    nop                          # Bolha para resolver o hazard de controle.
    addi t0, zero, 0x66         # Não deve executar
jair_target:
    addi t0, zero, 3

    # ===== FINALIZAÇÃO =====
    addi t0, zero, 0xFF
    ebreak