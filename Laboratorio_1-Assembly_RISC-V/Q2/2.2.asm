.data
v: .word 9,2,5,1,8,2,4,3,6,7,10,2,32,54,2,12,6,3,1,78,54,23,1,54,2,65,3,6,55,31
novaLinha: .asciz "\n"
espaco: .asciz " "

.text
main:
    addi s1, zero, 30       # s1 = tamanho do vetor
    la s2, v                # s2 = endereço base do vetor
    jal show                # Mostra vetor desordenado
    jal sort
    jal show                # Mostra vetor ordenado
    j fim

sort:
    li t0, 1                # i = 1
    la t1, v                # t1 = endereço base do vetor
    
for1:
    bge t0, s1, end_sort    # if i >= tamanho -> fim
    slli t4, t0, 2          # offset = i * 4
    add t4, t1, t4          # endereço de v[i]
    lw t2, 0(t4)            # chave = v[i]
    addi t3, t0, -1         # j = i - 1

for2:
    blt t3, zero, fimFor2 # se j < 0 -> fim loop interno
    slli t4, t3, 2          # offset = j * 4
    add t5, t1, t4          # endereço de v[j]
    lw t6, 0(t5)            # t6 = v[j]
    ble t6, t2, fimFor2   # se v[j] <= chave -> fim loop
    sw t6, 4(t5)            # v[j+1] = v[j]
    addi t3, t3, -1         # j--
    j for2

fimFor2:
    addi t4, t3, 1          # j + 1
    slli t4, t4, 2          # offset
    add t4, t1, t4          # endereço v[j+1]
    sw t2, 0(t4)            # v[j+1] = chave
    addi t0, t0, 1          # i++
    j for1

end_sort:
    ret

show:
    li t0, 0                # t0 = contador
    la t1, v                # t1 = endereço base do vetor
    
loopShow:
    beq t0, s1, fimShow
    lw a0, 0(t1)
    li a7, 1
    ecall
    la a0, espaco
    li a7, 4
    ecall
    addi t1, t1, 4          # Próximo elemento
    addi t0, t0, 1          # Incrementa contador
    j loopShow
    
fimShow:
    la a0, novaLinha
    li a7, 4
    ecall
    ret
    
fim:
    li a7, 10
    ecall
