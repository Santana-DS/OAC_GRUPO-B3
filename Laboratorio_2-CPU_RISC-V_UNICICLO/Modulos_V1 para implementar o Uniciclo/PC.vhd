library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.riscv_pkg.all;

entity PC is
    port (
			clk:		in std_logic;
			PCin: 	in std_logic_vector(9 downto 0);
			PCout: 	out std_logic_vector(9 downto 0)
    );
end PC;