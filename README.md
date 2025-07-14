# UnB – Organização e Arquitetura de Computadores – 2025/1 – Grupo B3

## Trabalhos do Grupo B3 - Laboratórios de OAC (CIC0099 - UnB 2025/1)

**Desenvolvedores:** Lucas Santana - Matrícula: 211028097 e Gabriel Castro - Matrícula: 202066571

## Descrição do Projeto

Este projeto da disciplina de Organização e Arquitetura de Computadores (OAC) da Universidade de Brasília no semestre 2025/1 consiste na implementação e teste de componentes fundamentais da arquitetura de computadores: um **uniciclo**, um **multiciclo** e um **pipeline**. Todas as implementações foram desenvolvidas e rigorosamente testadas utilizando a plataforma **Quartus**, e a arquitetura de conjunto de instruções utilizada é **RISC-V RV32**. O objetivo principal foi aprofundar a compreensão sobre as diferentes metodologias de execução de instruções em um processador, desde a abordagem mais simples do uniciclo até a otimização proporcionada pelo pipeline.

Este repositório contém os arquivos desenvolvidos para os laboratórios da disciplina de Organização e Arquitetura de Computadores (OAC) da Universidade de Brasília no semestre 2025/1.

## Conteúdo do Repositório

[**Liste aqui os principais arquivos e diretórios presentes neste repositório e explique brevemente a função de cada um.** Por exemplo:]

* `uniciclo/`: Contém os arquivos VHDL para a implementação do uniciclo.
* `multiciclo/`: Contém os arquivos VHDL para a implementação do multiciclo.
* `pipeline/`: Contém os arquivos VHDL para a implementação do pipeline.
* `README.md`: Este arquivo com a descrição do projeto.

## Como Executar os Projetos e Testes no Quartus

Todos os componentes foram desenvolvidos e testados utilizando o software Quartus. Para visualizar o código, simular e analisar os resultados, siga os passos gerais abaixo:

1.  **Clone o repositório:** Comece clonando este repositório para o seu ambiente local.
2.  **Abra os arquivos no Quartus:** Abra o projeto Quartus correspondente para cada componente (uniciclo, multiciclo e pipeline). Os arquivos principais de implementação estarão nas pastas correspondentes (`uniciclo/`, `multiciclo/`, `pipeline/`).
3.  **Análise e Síntese:** Execute a análise e síntese do projeto no Quartus para garantir que não há erros de código.
4.  **Simulação Funcional:**
    * **Teste de1s:** Foi criado um teste de1s para cada implementação. O objetivo deste teste foi avaliar o desempenho e a corretude da execução em um cenário temporal específico.
    * Utilize a ferramenta de simulação do Quartus para executar a simulação funcional com os testbenches fornecidos, incluindo o teste de1s.
    * Analise as waveforms geradas durante a simulação para verificar se o comportamento de cada componente (uniciclo, multiciclo e pipeline) corresponde ao esperado para a arquitetura RISC-V RV32 durante o período de teste.
5.  **Comparação com o RARS:** O mesmo teste de1s criado para o Quartus também foi executado em nosso simulador **RARS (RISC-V Assembly and Runtime Simulator)**. Os resultados da execução neste simulador foram cuidadosamente comparados com os resultados obtidos na simulação do Quartus para verificar a consistência e a corretude das implementações em diferentes ambientes de simulação. Esta comparação é detalhada nos relatórios.

**Observação:** Os detalhes específicos sobre os arquivos de projeto do Quartus (.qar, arquivos VHDL, etc.) e os arquivos de teste para o RARS (estrão dentro das pastas correspondentes a cada componente. Consulte os relatórios para informações mais detalhadas sobre a estrutura do projeto, os resultados dos testes e a análise comparativa entre o Quartus e o RARS.

## Observações

Este projeto demonstra a implementação e o teste de conceitos fundamentais de organização e arquitetura de computadores utilizando a ferramenta Quartus e a arquitetura RISC-V RV32. A criação e execução de um teste de1s, tanto no Quartus quanto no simulador RARS, e a subsequente comparação dos resultados, reforçam a validade e a robustez das implementações desenvolvidas.
