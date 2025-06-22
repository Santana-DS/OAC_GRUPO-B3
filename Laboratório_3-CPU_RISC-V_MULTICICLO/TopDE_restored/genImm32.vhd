library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.riscv_pkg.all;

entity genImm32 is
    port (
        instr : in  std_logic_vector(31 downto 0);
        imm32 : out std_logic_vector(31 downto 0)
    );
end genImm32;

architecture rtl of genImm32 is
    signal s_imm32_t : signed(31 downto 0);
begin
    -- Decodifica a instrução com base no opcode para gerar o imediato correto
    with instr(6 downto 0) select
        s_imm32_t <= resize(signed(instr(31 downto 20)), 32)                                                  when OPC_ITYPE_L | OPC_ITYPE_I | OPC_ITYPE_J, -- I-Type (lw, addi, jalr)
                     resize(signed(instr(31 downto 25) & instr(11 downto 7)), 32)                                when OPC_STYPE,   -- S-Type (sw)
                     resize(signed(instr(31) & instr(7) & instr(30 downto 25) & instr(11 downto 8) & '0'), 32)  when OPC_BTYPE,   -- B-Type (beq)
                     resize(signed(instr(31) & instr(19 downto 12) & instr(20) & instr(30 downto 21) & '0'), 32) when OPC_JTYPE,   -- J-Type (jal)
                     signed(ZERO32)                                                                             when OPC_RTYPE,   -- R-Type
                     signed(ZERO32)                                                                             when others;

    imm32 <= std_logic_vector(s_imm32_t);

end rtl;