library ieee;
use ieee.std_logic_1164.all;
library work;
use work.riscv_pkg.all;

entity ID_EX_reg is
    port (
        clk             : in  std_logic;
        rst             : in  std_logic;
        flush           : in  std_logic;
        
        -- Entradas do estágio ID
        pc_plus_4_in    : in  std_logic_vector(31 downto 0);
        reg_a_in        : in  std_logic_vector(31 downto 0);
        reg_b_in        : in  std_logic_vector(31 downto 0);
        imm32_in        : in  std_logic_vector(31 downto 0);
        rs1_addr_in     : in  std_logic_vector(4 downto 0);
        rs2_addr_in     : in  std_logic_vector(4 downto 0);
        rd_addr_in      : in  std_logic_vector(4 downto 0);
        funct3_in       : in  std_logic_vector(2 downto 0); -- <<-- Adicionado para a ULAControle
        funct7_bit5_in  : in  std_logic;                    -- <<-- Adicionado para a ULAControle
        control_in      : in  t_control_signals;
        
        -- Saídas para o estágio EX
        pc_plus_4_out   : out std_logic_vector(31 downto 0);
        reg_a_out       : out std_logic_vector(31 downto 0);
        reg_b_out       : out std_logic_vector(31 downto 0);
        imm32_out       : out std_logic_vector(31 downto 0);
        rs1_addr_out    : out std_logic_vector(4 downto 0);
        rs2_addr_out    : out std_logic_vector(4 downto 0);
        rd_addr_out     : out std_logic_vector(4 downto 0);
        funct3_out      : out std_logic_vector(2 downto 0); -- <<-- Adicionado
        funct7_bit5_out : out std_logic;                    -- <<-- Adicionado
        control_out     : out t_control_signals
    );
end ID_EX_reg;

architecture rtl of ID_EX_reg is
begin
    process(clk)
    begin
        if (rising_edge(clk)) then
            if (rst = '1' or flush = '1') then
                pc_plus_4_out   <= ZERO32;
                reg_a_out       <= ZERO32;
                reg_b_out       <= ZERO32;
                imm32_out       <= ZERO32;
                rs1_addr_out    <= (others => '0');
                rs2_addr_out    <= (others => '0');
                rd_addr_out     <= (others => '0');
                funct3_out      <= (others => '0');      -- Limpa no flush/reset
                funct7_bit5_out <= '0';                 -- Limpa no flush/reset
                control_out     <= DEFAULT_CONTROL;
            else
                pc_plus_4_out   <= pc_plus_4_in;
                reg_a_out       <= reg_a_in;
                reg_b_out       <= reg_b_in;
                imm32_out       <= imm32_in;
                rs1_addr_out    <= rs1_addr_in;
                rs2_addr_out    <= rs2_addr_in;
                rd_addr_out     <= rd_addr_in;
                funct3_out      <= funct3_in;        -- Captura o valor
                funct7_bit5_out <= funct7_bit5_in;   -- Captura o valor
                control_out     <= control_in;
            end if;
        end if;
    end process;
end rtl;