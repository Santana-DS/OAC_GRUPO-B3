library ieee;
use ieee.std_logic_1164.all;

entity regPC is
    port (
        clk     : in  std_logic;
        wren    : in  std_logic;
        rst     : in  std_logic;
        reg_in  : in  std_logic_vector(31 downto 0);
        reg_out : out std_logic_vector(31 downto 0)
    );
end regPC;

architecture rtl of regPC is
begin
    process (clk)
    begin
        if (rising_edge(clk)) then
            if (rst = '1') then
                reg_out <= x"00400000";
            elsif (wren = '1') then
                reg_out <= reg_in;
            end if;
        end if;
    end process;
end rtl;