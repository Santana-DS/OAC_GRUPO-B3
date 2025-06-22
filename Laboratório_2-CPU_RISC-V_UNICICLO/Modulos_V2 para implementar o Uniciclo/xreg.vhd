-- Quartus II VHDL Template
-- Basic Shift Register

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.riscv_pkg.all;

entity xregs is
	generic (
		SIZE : natural := 32;
		ADDR : natural := 5
	);
	port 
	(
		iCLK		: in  std_logic;
		iRST		: in  std_logic; -- sinal de reset
		iWREN		: in  std_logic; -- sinal de escrita no registrador
		iRS1		: in  std_logic_vector(ADDR-1 downto 0);
		iRS2		: in  std_logic_vector(ADDR-1 downto 0);
		iRD		: in  std_logic_vector(ADDR-1 downto 0);
		iDATA		: in  std_logic_vector(SIZE-1 downto 0);
		oREGA 	: out std_logic_vector(SIZE-1 downto 0);
		oREGB 	: out std_logic_vector(SIZE-1 downto 0);
		
		iDISP		: in  std_logic_vector(ADDR-1 downto 0) := (others => '0');
		oREGD		: out std_logic_vector(SIZE-1 downto 0) := (others => '0')
	);
end entity;

architecture rtl of xregs is

type banco is array (31 downto 0) of std_logic_vector(31 downto 0);
constant ZERO32 : std_logic_vector(31 downto 0) := X"00000000";
constant GPR : natural := 3;
constant SPR : natural := 2;

signal xreg32: banco;

begin
	oREGA <= ZERO32 when (iRS1="00000") else xreg32(to_integer(unsigned(iRS1)));
	oREGB <= ZERO32 when (iRS2="00000") else xreg32(to_integer(unsigned(iRS2)));
	oREGD <= ZERO32 when (iRS2="00000") else xreg32(to_integer(unsigned(iDISP)));
	process (iCLK)
	begin
		if (rising_edge(iCLK)) then
			if (iRST = '1') then 
					xreg32 <= (others => (others => '0'));
					xreg32(SPR) <= STACK_ADDRESS;
					xreg32(GPR) <= DATA_ADDRESS;
			elsif (iWREN = '1') then
				xreg32(to_integer(unsigned(iRD))) <= iDATA;
			end if;
		end if;
	end process;
end rtl;
