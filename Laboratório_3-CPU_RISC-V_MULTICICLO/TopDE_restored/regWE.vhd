library ieee;
use ieee.std_logic_1164.all;

entity regWE is
    generic (
        WSIZE : natural := 32
    );
    port (
        clk     : in  std_logic;
        we      : in  std_logic;
        reg_in  : in  std_logic_vector(WSIZE-1 downto 0);
        reg_out : out std_logic_vector(WSIZE-1 downto 0)
    );
end entity;

architecture rtl of regWE is
begin
    process (clk)
    begin
        if (rising_edge(clk)) then
            if (we = '1') then
                reg_out <= reg_in;
            end if;
        end if;
    end process;
end rtl;