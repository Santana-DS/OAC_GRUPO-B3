.eqv N 10 # Substitui N por 10 em todo o código

.data
Vetor:  .word 10,9,8,7,6,5,4,3,2,1

.text	
MAIN:	la a0,Vetor # Carrega o endereço do vetor no registrador a0
	li a1,N # Coloca o valor de 10 no registrador a1
	jal SHOW # Chama a função show p/ mostrar o vetor original

	la a0,Vetor
	li a1,N	
	jal SORT

	la a0,Vetor
	li a1,N
	jal SHOW

	li a7,10 # Finalizo e vou pro swap
	ecall


SWAP:	slli t1,a1,2
	add t1,a0,t1
	lw t0,0(t1)
	lw t2,4(t1)
	sw t2,0(t1)
	sw t0,4(t1)
	ret

SORT:	addi sp,sp,-20
	sw ra,16(sp)
	sw s3,12(sp)
	sw s2,8(sp)
	sw s1,4(sp)
	sw s0,0(sp)
	mv s2,a0
	mv s3,a1
	mv s0,zero
for1:	bge s0,s3,exit1
	addi s1,s0,-1
for2:	blt s1,zero,exit2
	slli t1,s1,2
	add t2,s2,t1
	lw t3,0(t2)
	lw t4,4(t2)
	bge t4,t3,exit2
	mv a0,s2
	mv a1,s1
	jal SWAP
	addi s1,s1,-1
	j for2
exit2:	addi s0,s0,1
	j for1
exit1: 	lw s0,0(sp)
	lw s1,4(sp)
	lw s2,8(sp)
	lw s3,12(sp)
	lw ra,16(sp)
	addi sp,sp,20
	ret

SHOW:	mv t0,a0 # Coloca o vetor no registrador temporário t0
	mv t1,a1 # Coloca 10 no registrador temporário t1
	mv t2,zero #  Igualo o valor do registrador temporário t2 p/ zero

loop1: 	beq t2,t1,fim1 # Verifico se o valor de t2 e t1 são iguais, se forem eu pulo p/ o fim
	li a7,1 # Codigo de syscall para imprimir inteiro
	lw a0,0(t0) # Carrego o primeiro elemento (elemento atual)
	ecall # Imprime
	
	li a7,11  # Códigi p/ imprimir caractere
	li a0,9 # '\t' tubulação
	ecall
	
	addi t0,t0,4 # Passo para o proximo elemento
	addi t2,t2,1 # Incremento o N
	j loop1 # Recomeço o loop, até imprimir os N elementos desorganizados

fim1:	li a7,11 # Código p/ imprimir caractere
	li a0,10 # '\n' 
	ecall
	ret # Retorno pra linha que chamou o show
