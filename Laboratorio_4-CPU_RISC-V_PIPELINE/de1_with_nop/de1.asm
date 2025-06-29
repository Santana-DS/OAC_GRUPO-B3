.data 0x10010000
    test_data: .word 0x12345678
    result:    .word 0

.text 0x00400000
main:
    # ===== TESTE LW =====
    lw t0, 0(gp)                 # t0 = 0x12345678
    nop                          # HAZARD: Necessário 1 NOP para o caso de lw-use

    # ===== TESTE ADDI =====
    addi t0, zero, 1             # t0 = 1

    # ===== TESTE ADD/SUB =====
    # O forwarding resolve o hazard entre 'addi t1' e 'add'
    addi t1, zero, 5             
    add t0, t0, t1               # t0 = 6
    # O forwarding resolve o hazard entre 'add t0' e 'sub'
    sub t0, t0, t1               # t0 = 1

    # ===== TESTE AND/OR =====
    addi t0, zero, 0xF0          
    addi t1, zero, 0x0F
    # O forwarding resolve os hazards de t0 e t1
    and t0, t0, t1               # t0 = 0x00
    # O forwarding resolve o hazard de t0
    or t0, t0, t1                # t0 = 0x0F

    # ===== TESTE SLT =====
    addi t0, zero, 5             
    addi t1, zero, 10
    # O forwarding resolve os hazards de t0 e t1
    slt t0, t0, t1               # t0 = 1

    # ===== TESTE SW =====
    addi t0, zero, 0x55
    # O forwarding resolve o hazard de t0 para a instrução sw
    sw t0, 4(gp)                 # MEM[gp+4] = 0x55
    lw t0, 4(gp)                 # Carrega o valor de volta
    nop                          # HAZARD: Necessário 1 NOP para o lw-use (verificação)

    # ===== TESTE BEQ =====
    addi t0, zero, 10            
    addi t1, zero, 10
    # O forwarding resolve os hazards de t0 e t1 para o beq
    beq t0, t1, branch_ok
    nop                          # Bolha para o HAZARD DE CONTROLE
    addi t0, zero, 0x66         # Não deve executar
branch_ok:
    addi t0, zero, 1

    # ===== TESTE JAL =====
    jal t1, jal_test
    nop                          # Bolha para o HAZARD DE CONTROLE
    addi t0, zero, 0x66         # Não deve executar
jal_test:
    addi t0, zero, 2

    # ===== TESTE JALR =====
    addi t1, t1, 0x14
    # O forwarding resolve o hazard entre 'addi t1' e 'jalr'
    jalr ra, t1, 0
    nop                          # Bolha para o HAZARD DE CONTROLE
    addi t0, zero, 0x66         # Não deve executar
jair_target:
    addi t0, zero, 3

    # ===== FINALIZAÇÃO =====
    addi t0, zero, 0xFF
    ebreak