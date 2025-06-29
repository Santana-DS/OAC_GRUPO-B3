library ieee;
use ieee.std_logic_1164.all;

package riscv_pkg is
  constant OPC_RTYPE   : std_logic_vector(6 downto 0) := "0110011";
  constant OPC_ITYPE_L : std_logic_vector(6 downto 0) := "0000011";
  constant OPC_ITYPE_I : std_logic_vector(6 downto 0) := "0010011";
  constant OPC_ITYPE_J : std_logic_vector(6 downto 0) := "1100111";
  constant OPC_STYPE   : std_logic_vector(6 downto 0) := "0100011";
  constant OPC_BTYPE   : std_logic_vector(6 downto 0) := "1100011";
  constant OPC_JTYPE   : std_logic_vector(6 downto 0) := "1101111";

  constant ALU_ADD  : std_logic_vector(3 downto 0) := "0000";
  constant ALU_SUB  : std_logic_vector(3 downto 0) := "0001";
  constant ALU_AND  : std_logic_vector(3 downto 0) := "0010";
  constant ALU_OR   : std_logic_vector(3 downto 0) := "0011";
  constant ALU_SLT  : std_logic_vector(3 downto 0) := "0100";
  constant ALU_NOP  : std_logic_vector(3 downto 0) := "1111";

  constant ZERO32   : std_logic_vector(31 downto 0) := x"00000000";
  constant NOP_INSTRUCTION : std_logic_vector(31 downto 0) := x"00000013";

  type t_control_signals is record
    ALUSrc      : std_logic;
    ALUOp       : std_logic_vector(1 downto 0);
    Branch      : std_logic;
    MemRead     : std_logic;
    MemWrite    : std_logic;
    RegWrite    : std_logic;
    MemtoReg    : std_logic;
  end record t_control_signals;

  constant DEFAULT_CONTROL : t_control_signals := (
    ALUSrc => '0', ALUOp => "00", Branch => '0', MemRead => '0',
    MemWrite => '0', RegWrite => '0', MemtoReg => '0'
  );
end package riscv_pkg;