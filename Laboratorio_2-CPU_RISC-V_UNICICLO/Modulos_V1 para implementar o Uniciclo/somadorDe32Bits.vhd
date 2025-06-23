library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity somadorDe32Bits is
    port ( 
		num1 : in  std_logic_vector(31 downto 0);
      num2 : in  std_logic_vector(31 downto 0);
      soma : out  std_logic_vector(31 downto 0)
      );
end somadorDe32Bits;

architecture arc_add of somadorDe32Bits is
begin

    Soma <= std_logic_vector(signed(num1) + signed(num2));

end somadorDe32Bits;