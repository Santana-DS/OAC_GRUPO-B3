library ieee;
use ieee.std_logic_1164.all;
library work;
use work.riscv_pkg.all;

entity EX_MEM_reg is
    port (
        clk             : in  std_logic;
        rst             : in  std_logic;
        alu_result_in   : in  std_logic_vector(31 downto 0);
        reg_b_in        : in  std_logic_vector(31 downto 0);
        rd_addr_in      : in  std_logic_vector(4 downto 0);
        alu_zero_in     : in  std_logic;
        control_in      : in  t_control_signals;
        alu_result_out  : out std_logic_vector(31 downto 0);
        reg_b_out       : out std_logic_vector(31 downto 0);
        rd_addr_out     : out std_logic_vector(4 downto 0);
        alu_zero_out    : out std_logic;
        control_out     : out t_control_signals
    );
end EX_MEM_reg;

architecture rtl of EX_MEM_reg is
begin
    process(clk)
    begin
        if (rising_edge(clk)) then
            if (rst = '1') then
                alu_result_out <= ZERO32;
                reg_b_out      <= ZERO32;
                rd_addr_out    <= (others => '0');
                alu_zero_out   <= '0';
                control_out    <= DEFAULT_CONTROL;
            else
                alu_result_out <= alu_result_in;
                reg_b_out      <= reg_b_in;
                rd_addr_out    <= rd_addr_in;
                alu_zero_out   <= alu_zero_in;
                control_out    <= control_in;
            end if;
        end if;
    end process;
end rtl;