# Requsitos RV32I multiciclo reduzido

## Descrição

Este projeto consiste na implementação de um processador RISC-V RV32I multiciclo com um conjunto reduzido de instruções. O processador será capaz de executar as instruções **add**, **sub**, **and**, **or**, **slt**, **lw**, **sw**, **beq**, **jal**, **jalr** e **addi**. A arquitetura adotada utiliza memórias separadas para instruções e dados, não seguindo o modelo de memória única da arquitetura de Von Neumann. O objetivo é projetar, implementar e validar o funcionamento correto do processador, incluindo o controle de estados, otimização de acesso à memória e análise dos requisitos físicos e temporais.

## Requisitos

- Desenhar a máquina de estados do controlador.

- Alterar o diagrama de estatos para otimizar o acesso da memória do quatus.

- Implementar a máquina de estados do controlador.

- Implementar o multiciclo completo.

- Salvar em imagem os blocos funcionais so 'netlist RTL view'.

- Levantar os requisitos físicos e temporais do processador.

- Fazer simulação por forma de onda funcional e temporal com o programa de1.s mostrando o funcionamento correto da CPU.

- Medir, experimentalmente, a máxima frequência de clock utilizável da CPU apresentando a simulação temporal por forma de onda.
