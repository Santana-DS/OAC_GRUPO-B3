library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.riscv_pkg.all;

entity ALU is
    port (
        iControl : in  std_logic_vector(3 downto 0);
        iA       : in  std_logic_vector(31 downto 0);
        iB       : in  std_logic_vector(31 downto 0);
        oResult  : out std_logic_vector(31 downto 0);
        zero     : out std_logic
    );
end ALU;

architecture rtl of ALU is
    signal s_result : std_logic_vector(31 downto 0);
begin
    process (iControl, iA, iB)
    begin
        case iControl is
            when ALU_ADD =>
                s_result <= std_logic_vector(signed(iA) + signed(iB));
            when ALU_SUB =>
                s_result <= std_logic_vector(signed(iA) - signed(iB));
            when ALU_AND =>
                s_result <= iA and iB;
            when ALU_OR =>
                s_result <= iA or iB;
            when ALU_SLT =>
                if signed(iA) < signed(iB) then
                    s_result <= std_logic_vector(to_signed(1, 32));
                else
                    s_result <= (others => '0');
                end if;
            when others =>
                s_result <= (others => '0');
        end case;
    end process;
    
    oResult <= s_result;
    zero <= '1' when s_result = ZERO32 else '0';

end rtl;