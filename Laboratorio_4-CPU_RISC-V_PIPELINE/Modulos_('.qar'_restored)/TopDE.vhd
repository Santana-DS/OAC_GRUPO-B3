library ieee;
use ieee.std_logic_1164.all;

entity TopDE is
    port (
        CLOCK         : in  std_logic;
        Reset         : in  std_logic;
        PC_out        : out std_logic_vector(31 downto 0);
        INSTR_debug   : out std_logic_vector(31 downto 0);
        DEBUG_ALU_OUT : out std_logic_vector(31 downto 0);
        DEBUG_WB_DATA : out std_logic_vector(31 downto 0);
        DEBUG_REG_T0  : out std_logic_vector(31 downto 0)
    );
end TopDE;

architecture structure of TopDE is
    attribute noprune : boolean;
    attribute noprune of INSTR_debug   : signal is true;
    attribute noprune of DEBUG_ALU_OUT : signal is true;
    attribute noprune of DEBUG_WB_DATA : signal is true;
    attribute noprune of DEBUG_REG_T0  : signal is true;

    component pipeline is
        port (
            clk              : in  std_logic;
            rst              : in  std_logic;
            pc_out           : out std_logic_vector(31 downto 0);
            instr_debug      : out std_logic_vector(31 downto 0);
            DEBUG_ALU_OUT    : out std_logic_vector(31 downto 0);
            DEBUG_WB_DATA    : out std_logic_vector(31 downto 0);
            DEBUG_REG_T0_OUT : out std_logic_vector(31 downto 0)
        );
    end component;

begin
    Pipeline_Processor_inst : entity work.pipeline(structure)
        port map (
            clk              => CLOCK,
            rst              => Reset,
            pc_out           => PC_out,
            instr_debug      => INSTR_debug,
            DEBUG_ALU_OUT    => DEBUG_ALU_OUT,
            DEBUG_WB_DATA    => DEBUG_WB_DATA,
            DEBUG_REG_T0_OUT => DEBUG_REG_T0
        );
end structure;