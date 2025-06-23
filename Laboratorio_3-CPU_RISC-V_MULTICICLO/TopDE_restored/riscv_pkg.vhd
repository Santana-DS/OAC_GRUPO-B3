library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package riscv_pkg is

  -- Opcodes das instruções RISC-V
  constant OPC_RTYPE   : std_logic_vector(6 downto 0) := "0110011"; -- add, sub, and, or, slt
  constant OPC_ITYPE_L : std_logic_vector(6 downto 0) := "0000011"; -- lw
  constant OPC_ITYPE_I : std_logic_vector(6 downto 0) := "0010011"; -- addi
  constant OPC_ITYPE_J : std_logic_vector(6 downto 0) := "1100111"; -- jalr
  constant OPC_STYPE   : std_logic_vector(6 downto 0) := "0100011"; -- sw
  constant OPC_BTYPE   : std_logic_vector(6 downto 0) := "1100011"; -- beq
  constant OPC_JTYPE   : std_logic_vector(6 downto 0) := "1101111"; -- jal

  -- Códigos de operação da ULA (ALU)
  constant ALU_ADD  : std_logic_vector(3 downto 0) := "0000";
  constant ALU_SUB  : std_logic_vector(3 downto 0) := "0001";
  constant ALU_AND  : std_logic_vector(3 downto 0) := "0010";
  constant ALU_OR   : std_logic_vector(3 downto 0) := "0011";
  constant ALU_SLT  : std_logic_vector(3 downto 0) := "0100";
  constant ALU_NOP  : std_logic_vector(3 downto 0) := "1111"; -- Nenhuma operação

  -- Constante de 32 bits para zero
  constant ZERO32   : std_logic_vector(31 downto 0) := x"00000000";

  -- Endereços iniciais
  constant TEXT_ADDRESS  : std_logic_vector(31 downto 0) := x"00400000";
  -- ############# LINHAS ADICIONADAS #############
  constant DATA_ADDRESS  : std_logic_vector(31 downto 0) := x"10010000";
  constant STACK_ADDRESS : std_logic_vector(31 downto 0) := x"100103FC";
  -- ############################################

end package riscv_pkg;