library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.riscv_pkg.all;

entity xregs is
    port (
        -- Sinais de controle e clock
        iCLK        : in  std_logic;
        iRST        : in  std_logic;
        iWREN       : in  std_logic; -- Write Enable

        -- Endereços dos registradores
        iRS1        : in  std_logic_vector(4 downto 0); -- Endereço de leitura 1
        iRS2        : in  std_logic_vector(4 downto 0); -- Endereço de leitura 2
        iRD         : in  std_logic_vector(4 downto 0); -- Endereço de escrita

        -- Dados
        iDATA       : in  std_logic_vector(31 downto 0); -- Dado a ser escrito
        oREGA       : out std_logic_vector(31 downto 0); -- Saída da porta de leitura 1
        oREGB       : out std_logic_vector(31 downto 0)  -- Saída da porta de leitura 2
    );
end xregs;

architecture rtl of xregs is

    -- Define um tipo 'array' para representar nosso banco de 32 registradores de 32 bits
    type t_banco_regs is array (31 downto 0) of std_logic_vector(31 downto 0);
    signal s_banco_regs : t_banco_regs;

    -- Converte os endereços de entrada para inteiros para usar como índice do array
    constant c_gpr_addr : integer := 2; -- Endereço do Global Pointer (x2)
    constant c_spr_addr : integer := 3; -- Endereço do Stack Pointer (x3)

begin

    -- Lógica de Leitura (Combinacional)
    -- Se o endereço for "00000", a saída é zero. Senão, lê do banco de registradores.
    oREGA <= ZERO32 when iRS1 = "00000" else s_banco_regs(to_integer(unsigned(iRS1)));
    oREGB <= ZERO32 when iRS2 = "00000" else s_banco_regs(to_integer(unsigned(iRS2)));

    -- Lógica de Escrita (Síncrona)
    process(iCLK)
    begin
        if rising_edge(iCLK) then
            if iRST = '1' then
                -- Inicializa registradores específicos no reset
                s_banco_regs(c_gpr_addr) <= DATA_ADDRESS;  -- Inicializa o gp (x3)
                s_banco_regs(c_spr_addr) <= STACK_ADDRESS; -- Inicializa o sp (x2)
            elsif iWREN = '1' then
                -- Escreve no registrador de destino, mas apenas se não for o registrador x0
                if iRD /= "00000" then
                    s_banco_regs(to_integer(unsigned(iRD))) <= iDATA;
                end if;
            end if;
        end if;
    end process;

end rtl;