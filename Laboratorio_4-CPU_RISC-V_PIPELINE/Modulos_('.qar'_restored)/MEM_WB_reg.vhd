library ieee;
use ieee.std_logic_1164.all;
library work;
use work.riscv_pkg.all;

entity MEM_WB_reg is
    port (
        clk              : in  std_logic;
        rst              : in  std_logic;
        mem_read_data_in : in  std_logic_vector(31 downto 0);
        alu_result_in    : in  std_logic_vector(31 downto 0);
        rd_addr_in       : in  std_logic_vector(4 downto 0);
        control_in       : in  t_control_signals;
        mem_read_data_out : out std_logic_vector(31 downto 0);
        alu_result_out    : out std_logic_vector(31 downto 0);
        rd_addr_out       : out std_logic_vector(4 downto 0);
        control_out       : out t_control_signals
    );
end MEM_WB_reg;

architecture rtl of MEM_WB_reg is
begin
    process(clk)
    begin
        if (rising_edge(clk)) then
            if (rst = '1') then
                mem_read_data_out <= ZERO32;
                alu_result_out    <= ZERO32;
                rd_addr_out       <= (others => '0');
                control_out       <= DEFAULT_CONTROL;
            else
                mem_read_data_out <= mem_read_data_in;
                alu_result_out    <= alu_result_in;
                rd_addr_out       <= rd_addr_in;
                control_out       <= control_in;
            end if;
        end if;
    end process;
end rtl;