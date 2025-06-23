library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use std.textio.all;	
use work.riscv_pkg.all;

entity mux2_1jalr is
	port (
		Sel: 	in std_logic;
		A: 	in std_logic_vector(4 downto 0);
		B:		in std_logic_vector(4 downto 0);
		R:		out std_logic_vector(4 downto 0)
	);
end mux2_1jalr;

architecture MUX_arch  of mux2_1jalr is
begin
	R <= A when (Sel = '0') else B;
end MUX_arch;