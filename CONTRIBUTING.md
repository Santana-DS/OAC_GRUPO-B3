# Guia de Contribuição para Projetos VHDL

## Estrutura de Arquivos

- Use nomes descritivos para seus arquivos VHDL
- Mantenha um arquivo por entidade/componente

## Estilo de Código

### Nomenclatura

- Use nomes significativos em inglês
- Para sinais: `signal_name`
- Para constantes: `CONSTANT_NAME`
- Para componentes: `ComponentName`
- Para entidades: `EntityName`

### Formatação

- Indente com 2 ou 4 espaços (seja consistente)
- Alinhe declarações de sinais e ports
- Use comentários para explicar funcionalidades complexas
- Adicione espaços após vírgulas e em torno de operadores

### Exemplo de Formatação

```vhdl
component Multiciclo is
    Port (
        clockCPU : in std_logic;
        clockMem : in std_logic;
        reset    : in std_logic;
        PC       : out std_logic_vector(31 downto 0);
        Instr    : out std_logic_vector(31 downto 0);
        regin    : in std_logic_vector(4 downto 0);
        regout   : out std_logic_vector(31 downto 0);
        estado   : out std_logic_vector(3 downto 0)
    );
end component;
```

## Commits e Pull Requests

1. Use mensagens de commit descritivas:

   ```text
   feat: Adiciona novo módulo multiplicador
   fix: Corrige timing no registrador de deslocamento
   docs: Atualiza documentação do ALU
   ```

2. Faça commits pequenos e focados
3. Teste suas mudanças antes do commit
4. Atualize a documentação quando necessário

## Revisão de Código

- Use self-review antes de submeter PRs (Pull Requests)

## Documentação

- Mantenha o README atualizado
- Documente interfaces e protocolos
- Inclua diagramas quando necessário
- Documente dependências e requisitos

## Fluxo de Trabalho

1. Clone o repositório
2. Crie uma branch

    ``` bash
    git checkout main
    git checkout -b <Nome-numeroIssue>
    ```

3. Desenvolva e teste suas mudanças
4. Submeta um Pull Request

## Dicas Adicionais

- Mantenha discussões técnicas nos issues
- Reporte bugs com casos de teste reproduzíveis
- Siga as convenções existentes do projeto
