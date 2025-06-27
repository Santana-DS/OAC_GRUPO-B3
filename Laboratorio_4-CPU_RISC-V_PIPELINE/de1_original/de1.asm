.data 0x10010000                  # Memória de dados (endereço fixo para o processador)
    test_data: .word 0x12345678   # Dado padrão para testes
    result:    .word 0            # Espaço para resultados

.text 0x00400000                 # Memória de instruções (endereço fixo)
main:
    # === CONFIGURAÇÃO (remover comentário para RARS) ===
    # li gp, 0x10010000          # No RARS, inicializa gp manualmente

    # ===== TESTE LW (carrega valor inicial) =====
    lw t0, 0(gp)                 # t0 = 0x12345678 (teste LW)

    # ===== TESTE ADDI =====
    addi t0, zero, 1             # t0 = 1 (teste ADDI)

    # ===== TESTE ADD/SUB =====
    addi t1, zero, 5             
    add t0, t0, t1               # t0 = 6 (teste ADD)
    sub t0, t0, t1               # t0 = 1 (teste SUB)

    # ===== TESTE AND/OR =====
    addi t0, zero, 0xF0          
    addi t1, zero, 0x0F          
    and t0, t0, t1               # t0 = 0x00 (teste AND)
    or t0, t0, t1                # t0 = 0x0F (teste OR)

    # ===== TESTE SLT =====
    addi t0, zero, 5             
    addi t1, zero, 10            
    slt t0, t0, t1               # t0 = 1 (teste SLT)

    # ===== TESTE SW =====
    addi t0, zero, 0x55          
    sw t0, 4(gp)                 # MEM[gp+4] = 0x55 (teste SW)
    lw t0, 4(gp)                 # t0 = 0x55 (verifica SW)

    # ===== TESTE BEQ =====
    addi t0, zero, 10            
    addi t1, zero, 10            
    beq t0, t1, branch_ok        # Se t0 == t1, salta (teste BEQ)
    addi t0, zero, 0x66         # Não deve executar
branch_ok:
    addi t0, zero, 1             # t0 = 1 (confirma branch)

    # ===== TESTE JAL =====
    jal t1, jal_test             # Salta e guarda endereço (teste JAL)
    addi t0, zero, 0x66         # Não deve executar
jal_test:
    addi t0, zero, 2             # t0 = 2 (confirma JAL)

    # ===== TESTE JALR =====
    addi t1, t1, 0x14           
    jalr ra, t1, 0               # Salta para jair_target (teste JALR)
    addi t0, zero, 0x66         # Não deve executar
jair_target:
    addi t0, zero, 3             # t0 = 3 (confirma JALR)

    # ===== FINALIZAÇÃO =====
    addi t0, zero, 0xFF          # t0 = 0xFF (marcador de sucesso)
    ebreak                       # Termina execução
