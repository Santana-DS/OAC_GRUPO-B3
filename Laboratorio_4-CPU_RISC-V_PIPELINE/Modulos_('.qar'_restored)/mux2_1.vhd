library ieee;
use ieee.std_logic_1164.all;

entity mux2_1 is
    generic ( WSIZE : natural := 32 );
    port (
        sel : in  std_logic;
        A   : in  std_logic_vector(WSIZE-1 downto 0);
        B   : in  std_logic_vector(WSIZE-1 downto 0);
        Z   : out std_logic_vector(WSIZE-1 downto 0)
    );
end mux2_1;

architecture rtl of mux2_1 is
begin
    Z <= B when sel = '1' else A;
end rtl;