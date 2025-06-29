library ieee;
use ieee.std_logic_1164.all;
library work;
use work.riscv_pkg.all;

entity IF_ID_reg is
    port (
        clk             : in  std_logic;
        rst             : in  std_logic;
        flush           : in  std_logic;
        write_en        : in  std_logic;
        pc_plus_4_in    : in  std_logic_vector(31 downto 0);
        instr_in        : in  std_logic_vector(31 downto 0);
        pc_plus_4_out   : out std_logic_vector(31 downto 0);
        instr_out       : out std_logic_vector(31 downto 0)
    );
end IF_ID_reg;

architecture rtl of IF_ID_reg is
begin
    process(clk)
    begin
        if (rising_edge(clk)) then
            if (rst = '1') then
                pc_plus_4_out <= ZERO32;
                instr_out     <= NOP_INSTRUCTION;
            elsif (flush = '1') then
                pc_plus_4_out <= ZERO32;
                instr_out     <= NOP_INSTRUCTION;
            elsif (write_en = '1') then
                pc_plus_4_out <= pc_plus_4_in;
                instr_out     <= instr_in;
            end if;
        end if;
    end process;
end rtl;