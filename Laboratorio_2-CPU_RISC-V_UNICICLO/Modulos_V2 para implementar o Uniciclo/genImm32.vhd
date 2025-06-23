library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.riscv_pkg.all;

entity genImm32 is 
	port (
		instr : in std_logic_vector(31 downto 0);
		imm32 : out std_logic_vector(31 downto 0));
end genImm32;

architecture rtl of genImm32 is

signal imm32_t: signed(31 downto 0);

begin

with (instr(6 downto 0)) select
	imm32_t <= signed(ZERO32) when OPC_RTYPE, -- Retorna um vetor de 32 bits de zeros quado o OPCODE é do Tipo R, ou seja, não possui imediato
				resize(signed(instr(31 downto 20)), 32) when OPC_LOAD | OPC_OPIMM | OPC_JALR, -- Imediato do tipo I
				resize(signed(instr(31 downto 25)&instr(11 downto 7)), 32) when  OPC_STORE, -- Imediatos do tipo S
				resize(signed(instr(31) & instr(7) & instr(30 downto 25) & instr(11 downto 8) & '0'), 32) when OPC_BRANCH, -- Imediatos do Tipo B
				resize(signed(instr(31) & instr(19 downto 12) & instr(20) & instr(30 downto 21) & '0'), 32) when OPC_JAL, -- Imediato do Tipo J
				signed(ZERO32) when others;
				
	imm32 <= std_logic_vector(imm32_t);

--process (instr) begin
--	case opcode_field is
--	when "0110011" => imm32 <= ZERO32;
--	when "0000011" | "0010011" | "1100111" => imm32 <= resize(signed(instr(31 downto 20), 32));
--	when "0100011" => imm32 <= resize(signed(instr(31 downto 25)&instr(11 downto 7)), 32);
--	when "1100011" => imm32 <= resize(signed(instr(31) & instr(7) & instr(30 downto 25) & instr(11 downto 8) & '0'), 32);
--	when "0110111" => imm32 <= instr(31 downto 12) & X"000";
--	when "1101111" => imm32 <= resize(signed(instr(31) & instr(19 downto 12) & instr(20) & instr(30 downto 21) & '0'), 32);
--	when others => imm32 <= ZERO32;
--	end case;
--end process;

end rtl;
