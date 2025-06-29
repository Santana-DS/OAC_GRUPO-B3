library ieee;
use ieee.std_logic_1164.all;

entity ForwardingUnit is
    port (
        EX_MEM_rd_addr   : in  std_logic_vector(4 downto 0);
        EX_MEM_reg_write : in  std_logic;
        MEM_WB_rd_addr   : in  std_logic_vector(4 downto 0);
        MEM_WB_reg_write : in  std_logic;
        ID_EX_rs1_addr   : in  std_logic_vector(4 downto 0);
        ID_EX_rs2_addr   : in  std_logic_vector(4 downto 0);
        ForwardA         : out std_logic_vector(1 downto 0);
        ForwardB         : out std_logic_vector(1 downto 0)
    );
end ForwardingUnit;

architecture rtl of ForwardingUnit is
begin
    process(EX_MEM_rd_addr, EX_MEM_reg_write, MEM_WB_rd_addr, MEM_WB_reg_write, ID_EX_rs1_addr, ID_EX_rs2_addr)
    begin
        if (EX_MEM_reg_write = '1') and (EX_MEM_rd_addr /= "00000") and (EX_MEM_rd_addr = ID_EX_rs1_addr) then
            ForwardA <= "01";
        elsif (MEM_WB_reg_write = '1') and (MEM_WB_rd_addr /= "00000") and (MEM_WB_rd_addr = ID_EX_rs1_addr) then
            ForwardA <= "10";
        else
            ForwardA <= "00";
        end if;
        if (EX_MEM_reg_write = '1') and (EX_MEM_rd_addr /= "00000") and (EX_MEM_rd_addr = ID_EX_rs2_addr) then
            ForwardB <= "01";
        elsif (MEM_WB_reg_write = '1') and (MEM_WB_rd_addr /= "00000") and (MEM_WB_rd_addr = ID_EX_rs2_addr) then
            ForwardB <= "10";
        else
            ForwardB <= "00";
        end if;
    end process;
end rtl;