library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity portaOR is
    port (
        A: in std_logic;
        B: in std_logic;
        Y: out std_logic
    );
end portaOR;

architecture comportamento of portaOR is
begin
    Y <= A or B;
end comportamento;
