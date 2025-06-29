library ieee;
use ieee.std_logic_1164.all;

entity HazardUnit is
    port (
        ID_EX_mem_read   : in  std_logic;
        ID_EX_rd_addr    : in  std_logic_vector(4 downto 0);
        IF_ID_rs1_addr   : in  std_logic_vector(4 downto 0);
        IF_ID_rs2_addr   : in  std_logic_vector(4 downto 0);
        ID_branch        : in  std_logic;
        EX_MEM_zero      : in  std_logic;
        pc_write_en      : out std_logic;
        if_id_write_en   : out std_logic;
        id_ex_flush      : out std_logic;
        if_id_flush      : out std_logic
    );
end HazardUnit;

architecture rtl of HazardUnit is
    signal s_lw_stall     : std_logic;
    signal s_branch_taken : std_logic;
begin
    s_lw_stall <= '1' when (ID_EX_mem_read = '1') and (ID_EX_rd_addr /= "00000") and
                           (ID_EX_rd_addr = IF_ID_rs1_addr or ID_EX_rd_addr = IF_ID_rs2_addr) else '0';
    s_branch_taken <= ID_branch and EX_MEM_zero;
    pc_write_en    <= '1' when s_lw_stall = '0' else '0';
    if_id_write_en <= '1' when s_lw_stall = '0' else '0';
    id_ex_flush    <= s_lw_stall or s_branch_taken;
    if_id_flush    <= '0'; -- Let software NOP handle this
end rtl;