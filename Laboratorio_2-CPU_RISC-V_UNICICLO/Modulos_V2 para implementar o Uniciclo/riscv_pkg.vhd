library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package riscv_pkg is

  -- Operações da ULA
  constant ZERO32   : std_logic_vector(31 downto 0) := x"00000000";
  constant ZERO     : std_logic_vector(31 downto 0) := x"00000000";
  constant OPAND    : std_logic_vector(4 downto 0)  := "00000";
  constant OPOR     : std_logic_vector(4 downto 0)  := "00001";
  constant OPXOR    : std_logic_vector(4 downto 0)  := "00010";
  constant OPADD    : std_logic_vector(4 downto 0)  := "00011";
  constant OPSUB    : std_logic_vector(4 downto 0)  := "00100";
  constant OPSLT    : std_logic_vector(4 downto 0)  := "00101";
  constant OPSLTU   : std_logic_vector(4 downto 0)  := "00110";
  constant OPSLL    : std_logic_vector(4 downto 0)  := "00111";
  constant OPSRL    : std_logic_vector(4 downto 0)  := "01000";
  constant OPSRA    : std_logic_vector(4 downto 0)  := "01001";
  constant OPLUI    : std_logic_vector(4 downto 0)  := "01010";
  constant OPMUL    : std_logic_vector(4 downto 0)  := "01011";
  constant OPMULH   : std_logic_vector(4 downto 0)  := "01100";
  constant OPMULHU  : std_logic_vector(4 downto 0)  := "01101";
  constant OPMULHSU : std_logic_vector(4 downto 0)  := "01110";
  constant OPDIV    : std_logic_vector(4 downto 0)  := "01111";
  constant OPDIVU   : std_logic_vector(4 downto 0)  := "10000";
  constant OPREM    : std_logic_vector(4 downto 0)  := "10001";
  constant OPREMU   : std_logic_vector(4 downto 0)  := "10010";
  constant OPNULL   : std_logic_vector(4 downto 0)  := "11111";  -- saída ZERO

  -- OpCodes
  constant OPC_LOAD    : std_logic_vector(6 downto 0) := "0000011";
  constant OPC_OPIMM   : std_logic_vector(6 downto 0) := "0010011";
  constant OPC_STORE   : std_logic_vector(6 downto 0) := "0100011";
  constant OPC_RTYPE   : std_logic_vector(6 downto 0) := "0110011";
  constant OPC_BRANCH  : std_logic_vector(6 downto 0) := "1100011";
  constant OPC_JALR    : std_logic_vector(6 downto 0) := "1100111";
  constant OPC_JAL     : std_logic_vector(6 downto 0) := "1101111";

  -- Funct7
  constant FUNCT7_ADD  : std_logic_vector(6 downto 0) := "0000000";
  constant FUNCT7_SUB  : std_logic_vector(6 downto 0) := "0100000";
  constant FUNCT7_SLT  : std_logic_vector(6 downto 0) := "0000000";
  constant FUNCT7_OR   : std_logic_vector(6 downto 0) := "0000000";
  constant FUNCT7_AND  : std_logic_vector(6 downto 0) := "0000000";

  -- Funct3
  constant FUNCT3_LW   : std_logic_vector(2 downto 0) := "010";
  constant FUNCT3_SW   : std_logic_vector(2 downto 0) := "010";
  constant FUNCT3_ADD  : std_logic_vector(2 downto 0) := "000";
  constant FUNCT3_SUB  : std_logic_vector(2 downto 0) := "000";
  constant FUNCT3_SLT  : std_logic_vector(2 downto 0) := "010";
  constant FUNCT3_OR   : std_logic_vector(2 downto 0) := "110";
  constant FUNCT3_AND  : std_logic_vector(2 downto 0) := "111";
  constant FUNCT3_BEQ  : std_logic_vector(2 downto 0) := "000";
  constant FUNCT3_JALR : std_logic_vector(2 downto 0) := "000";

  -- Endereços
  constant TEXT_ADDRESS  : std_logic_vector(31 downto 0) := x"0040_0000";
  constant DATA_ADDRESS  : std_logic_vector(31 downto 0) := x"1001_0000";
  constant STACK_ADDRESS : std_logic_vector(31 downto 0) := x"1001_03FC";
  
  -- Componentes
      -- Declaração do componente ramI
    component ramI
        port (
            address : in  std_logic_vector(9 downto 0);
            clock   : in  std_logic;
            data    : in  std_logic_vector(31 downto 0);
            wren    : in  std_logic := '0';
            q       : out std_logic_vector(31 downto 0)
        );
    end component;
    
    -- Declaração do componente ramD
    component ramD
        port (
            address : in  std_logic_vector(9 downto 0);
            clock   : in  std_logic;
            data    : in  std_logic_vector(31 downto 0);
            wren    : in  std_logic;
            q       : out std_logic_vector(31 downto 0)
        );
    end component;

end package riscv_pkg;
