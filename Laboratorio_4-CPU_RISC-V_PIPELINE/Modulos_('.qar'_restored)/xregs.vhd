library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.riscv_pkg.all;

entity xregs is
    port (
        iCLK        : in  std_logic;
        iRST        : in  std_logic;
        iWREN       : in  std_logic;
        iRS1        : in  std_logic_vector(4 downto 0);
        iRS2        : in  std_logic_vector(4 downto 0);
        iRD         : in  std_logic_vector(4 downto 0);
        iDATA       : in  std_logic_vector(31 downto 0);
        oREGA       : out std_logic_vector(31 downto 0);
        oREGB       : out std_logic_vector(31 downto 0);
        -- Adicionando porta de leitura para debug
        iDISP_addr  : in  std_logic_vector(4 downto 0);
        oDISP_data  : out std_logic_vector(31 downto 0)
    );
end xregs;

architecture rtl of xregs is
    type t_banco_regs is array (31 downto 0) of std_logic_vector(31 downto 0);
    signal s_banco_regs : t_banco_regs;
    constant c_gpr_addr : integer := 3;
    constant c_spr_addr : integer := 2;
begin
    oREGA <= ZERO32 when iRS1 = "00000" else s_banco_regs(to_integer(unsigned(iRS1)));
    oREGB <= ZERO32 when iRS2 = "00000" else s_banco_regs(to_integer(unsigned(iRS2)));
    -- Lógica para a porta de debug
    oDISP_data <= ZERO32 when iDISP_addr = "00000" else s_banco_regs(to_integer(unsigned(iDISP_addr)));

    process(iCLK)
    begin
        if rising_edge(iCLK) then
            if iRST = '1' then
                s_banco_regs(c_gpr_addr) <= x"10010000";
                s_banco_regs(c_spr_addr) <= x"100103FC";
            elsif iWREN = '1' then
                if iRD /= "00000" then
                    s_banco_regs(to_integer(unsigned(iRD))) <= iDATA;
                end if;
            end if;
        end if;
    end process;
end rtl;