library ieee;
use ieee.std_logic_1164.all;
library work;
use work.riscv_pkg.all;

entity ULAControle is
    port (
        ALUOp       : in  std_logic_vector(1 downto 0);
        funct3      : in  std_logic_vector(2 downto 0);
        funct7_bit5 : in  std_logic;
        controleULA : out std_logic_vector(3 downto 0)
    );
end ULAControle;

architecture rtl of ULAControle is
begin
    process (ALUOp, funct3, funct7_bit5)
    begin
        case ALUOp is
            when "00" => controleULA <= ALU_ADD;
            when "01" => controleULA <= ALU_SUB;
            when "10" =>
                case funct3 is
                    when "000" => if funct7_bit5 = '0' then controleULA <= ALU_ADD; else controleULA <= ALU_SUB; end if;
                    when "111" => controleULA <= ALU_AND;
                    when "110" => controleULA <= ALU_OR;
                    when "010" => controleULA <= ALU_SLT;
                    when others => controleULA <= ALU_NOP;
                end case;
            when others => controleULA <= ALU_NOP;
        end case;
    end process;
end rtl;