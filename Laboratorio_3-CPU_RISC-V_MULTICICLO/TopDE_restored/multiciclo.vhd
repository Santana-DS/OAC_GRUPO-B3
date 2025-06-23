library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.riscv_pkg.all;

entity Multiciclo is
    port (
        clockCPU      : in  std_logic;
        reset         : in  std_logic;
        EscreveIR     : in  std_logic;
        IouD          : in  std_logic;
        EscrevePCCond : in  std_logic;
        EscrevePC     : in  std_logic;
        OrigPC        : in  std_logic;
        ALUOp         : in  std_logic_vector(1 downto 0);
        OrigAULA      : in  std_logic;
        OrigBULA      : in  std_logic_vector(1 downto 0);
        EscreveReg    : in  std_logic;
        Mem2Reg       : in  std_logic;
        EscreveMem    : in  std_logic;
        EscreveA      : in  std_logic;
        EscreveB      : in  std_logic;
        EscreveSaidaULA : in  std_logic;
        opcode_out    : out std_logic_vector(6 downto 0);
        zero_out      : out std_logic;
        PC_out        : out std_logic_vector(31 downto 0);
        instr_debug_out : out std_logic_vector(31 downto 0) 
    );
end Multiciclo;

architecture structure of Multiciclo is
    signal s_pc_current, s_pc_next : std_logic_vector(31 downto 0);
    signal s_instr, s_mem_data, s_write_data_reg : std_logic_vector(31 downto 0);
    signal s_reg_a, s_reg_b, s_rega_out, s_regb_out : std_logic_vector(31 downto 0);
    signal s_imm32, s_alu_a, s_alu_b, s_alu_out, s_ula_out_reg : std_logic_vector(31 downto 0);
    signal s_ula_control : std_logic_vector(3 downto 0);
    signal s_zero_flag : std_logic;

begin
    PC_reg : entity work.regPC(rtl)
        port map (clk => clockCPU, rst => reset, wren => EscrevePC, reg_in => s_pc_next, reg_out => s_pc_current);

    s_pc_next <= s_alu_out when OrigPC = '0' else s_ula_out_reg;
    PC_out <= s_pc_current;

    Memoria_inst : entity work.memoria_unificada(rtl)
        port map (
            clock => clockCPU, addr_instr => s_pc_current, addr_data => s_alu_out,
            IouD => IouD, wren => EscreveMem, data_in => s_reg_b, data_out => s_mem_data
        );
        
    IR_reg : entity work.regWE(rtl)
        port map (clk => clockCPU, we => EscreveIR, reg_in => s_mem_data, reg_out => s_instr);

    opcode_out <= s_instr(6 downto 0);
    instr_debug_out <= s_instr;

    Regs_inst : entity work.xregs(rtl)
        port map (
            iCLK => clockCPU, iRST => reset, iWREN => EscreveReg,
            iRS1 => s_instr(19 downto 15), iRS2 => s_instr(24 downto 20), iRD => s_instr(11 downto 7),
            iDATA => s_write_data_reg, oREGA => s_rega_out, oREGB => s_regb_out
        );
        
    A_reg : entity work.regWE(rtl)
        port map (clk => clockCPU, we => EscreveA, reg_in => s_rega_out, reg_out => s_reg_a);
        
    B_reg : entity work.regWE(rtl)
        port map (clk => clockCPU, we => EscreveB, reg_in => s_regb_out, reg_out => s_reg_b);
        
    s_write_data_reg <= s_ula_out_reg when Mem2Reg = '0' else s_mem_data;

    Imm_gen_inst : entity work.genImm32(rtl)
        port map (instr => s_instr, imm32 => s_imm32);
        
    ULA_ctrl_inst : entity work.ULAControle(rtl)
        port map (ALUOp => ALUOp, funct3 => s_instr(14 downto 12), funct7_bit5 => s_instr(30), controleULA => s_ula_control);

    s_alu_a <= s_pc_current when OrigAULA = '0' else s_reg_a;

    with OrigBULA select
        s_alu_b <= s_reg_b when "00",
                   std_logic_vector(to_unsigned(4, 32)) when "01",
                   s_imm32 when "10",
                   (others => '0') when others;
                   
    ALU_inst : entity work.ALU(rtl)
        port map (iControl => s_ula_control, iA => s_alu_a, iB => s_alu_b, oResult => s_alu_out, zero => s_zero_flag);
        
    zero_out <= s_zero_flag;
    
    ALUOut_reg : entity work.regWE(rtl)
        port map (clk => clockCPU, we => EscreveSaidaULA, reg_in => s_alu_out, reg_out => s_ula_out_reg);
        
end architecture;