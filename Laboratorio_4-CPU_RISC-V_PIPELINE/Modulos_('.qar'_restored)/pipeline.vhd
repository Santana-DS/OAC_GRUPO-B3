library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.riscv_pkg.all;

entity pipeline is
    port (
        clk             : in  std_logic;
        rst             : in  std_logic;
        pc_out          : out std_logic_vector(31 downto 0);
        instr_debug     : out std_logic_vector(31 downto 0);
        -- Saídas de Debug Finais
        DEBUG_ALU_OUT    : out std_logic_vector(31 downto 0);
        DEBUG_WB_DATA    : out std_logic_vector(31 downto 0);
        DEBUG_REG_T0_OUT : out std_logic_vector(31 downto 0)
    );
end pipeline;

architecture structure of pipeline is

    -- Sinais de Controle do Pipeline
    signal s_pc_write_en, s_if_id_write_en, s_id_ex_flush, s_if_id_flush, s_pc_src_sel : std_logic;
    signal s_forward_a, s_forward_b : std_logic_vector(1 downto 0);
    
    -- Sinais do Datapath
    signal s_pc_current, s_pc_next, s_pc_plus_4, s_branch_target_addr, s_instr_from_mem, s_if_id_pc_plus_4, s_if_id_instr, s_id_rega_data, s_id_regb_data, s_id_imm32, s_id_ex_pc_plus_4, s_id_ex_rega, s_id_ex_regb, s_id_ex_imm32, s_ex_forward_a_out, s_ex_alu_src_b_out, s_ex_forward_b_out, s_ex_alu_out, s_ex_mem_alu_out, s_ex_mem_regb, s_mem_read_data, s_mem_wb_mem_read_data, s_mem_wb_alu_out, s_wb_write_data, s_debug_t0_data : std_logic_vector(31 downto 0);
    signal s_id_control, s_id_ex_control, s_ex_mem_control, s_mem_wb_control : t_control_signals;
    signal s_id_ex_rd_addr, s_id_ex_rs1_addr, s_id_ex_rs2_addr, s_ex_mem_rd_addr, s_mem_wb_rd_addr : std_logic_vector(4 downto 0);
    signal s_id_ex_funct3 : std_logic_vector(2 downto 0);
    signal s_id_ex_funct7_bit5 : std_logic;
    signal s_ex_alu_control : std_logic_vector(3 downto 0);
    signal s_ex_alu_zero, s_ex_mem_alu_zero : std_logic;

begin

    -- ================== LÓGICA DE HAZARD & FORWARDING ==================
    HazardUnit_inst: entity work.HazardUnit(rtl) port map(ID_EX_mem_read=>s_id_ex_control.MemRead,ID_EX_rd_addr=>s_id_ex_rd_addr,IF_ID_rs1_addr=>s_if_id_instr(19 downto 15),IF_ID_rs2_addr=>s_if_id_instr(24 downto 20),ID_branch=>s_id_control.Branch,EX_MEM_zero=>s_ex_mem_alu_zero,pc_write_en=>s_pc_write_en,if_id_write_en=>s_if_id_write_en,id_ex_flush=>s_id_ex_flush,if_id_flush=>s_if_id_flush);
    ForwardingUnit_inst: entity work.ForwardingUnit(rtl) port map(EX_MEM_rd_addr=>s_ex_mem_rd_addr,EX_MEM_reg_write=>s_ex_mem_control.RegWrite,MEM_WB_rd_addr=>s_mem_wb_rd_addr,MEM_WB_reg_write=>s_mem_wb_control.RegWrite,ID_EX_rs1_addr=>s_id_ex_rs1_addr,ID_EX_rs2_addr=>s_id_ex_rs2_addr,ForwardA=>s_forward_a,ForwardB=>s_forward_b);
    s_pc_src_sel <= s_id_ex_control.Branch and s_ex_alu_zero;

    -- ================== ESTÁGIO 1: IF ==================
    PC_reg: entity work.regPC(rtl) port map(clk=>clk,rst=>rst,wren=>s_pc_write_en,reg_in=>s_pc_next,reg_out=>s_pc_current);
    pc_out <= s_pc_current;
    PC_adder: entity work.ALU(rtl) port map(iControl=>ALU_ADD,iA=>s_pc_current,iB=>std_logic_vector(to_signed(4,32)),oResult=>s_pc_plus_4,zero=>open);
    PC_mux: entity work.mux2_1(rtl) port map(sel=>s_pc_src_sel,A=>s_pc_plus_4,B=>s_branch_target_addr,Z=>s_pc_next);
    Instr_mem: entity work.ramI(SYN) port map(address=>s_pc_current(11 downto 2),clock=>clk,q=>s_instr_from_mem);
    IF_ID_reg_inst: entity work.IF_ID_reg(rtl) port map(clk=>clk,rst=>rst,flush=>s_if_id_flush,write_en=>s_if_id_write_en,pc_plus_4_in=>s_pc_plus_4,instr_in=>s_instr_from_mem,pc_plus_4_out=>s_if_id_pc_plus_4,instr_out=>s_if_id_instr);
    instr_debug <= s_if_id_instr;

    -- ================== ESTÁGIO 2: ID ==================
    Control_inst: entity work.UnidadeControlePipeline(rtl) port map(opcode=>s_if_id_instr(6 downto 0),control_out=>s_id_control);
    Reg_file_inst: entity work.xregs(rtl) -- <<<<< BLOCO CORRIGIDO
        port map (
            iCLK => clk, iRST => rst, iWREN => s_mem_wb_control.RegWrite,
            iRS1 => s_if_id_instr(19 downto 15), iRS2 => s_if_id_instr(24 downto 20),
            iRD => s_mem_wb_rd_addr, iDATA => s_wb_write_data,
            oREGA => s_id_rega_data, oREGB => s_id_regb_data,
            iDISP_addr => "00101", -- Endereço fixo de t0 (x5) para debug
            oDISP_data => s_debug_t0_data
        );
    Imm_gen_inst: entity work.genImm32(rtl) port map(instr=>s_if_id_instr,imm32=>s_id_imm32);
    ID_EX_reg_inst: entity work.ID_EX_reg(rtl) port map(clk=>clk,rst=>rst,flush=>s_id_ex_flush,pc_plus_4_in=>s_if_id_pc_plus_4,reg_a_in=>s_id_rega_data,reg_b_in=>s_id_regb_data,imm32_in=>s_id_imm32,rs1_addr_in=>s_if_id_instr(19 downto 15),rs2_addr_in=>s_if_id_instr(24 downto 20),rd_addr_in=>s_if_id_instr(11 downto 7),funct3_in=>s_if_id_instr(14 downto 12),funct7_bit5_in=>s_if_id_instr(30),control_in=>s_id_control,pc_plus_4_out=>s_id_ex_pc_plus_4,reg_a_out=>s_id_ex_rega,reg_b_out=>s_id_ex_regb,imm32_out=>s_id_ex_imm32,rs1_addr_out=>s_id_ex_rs1_addr,rs2_addr_out=>s_id_ex_rs2_addr,rd_addr_out=>s_id_ex_rd_addr,funct3_out=>s_id_ex_funct3,funct7_bit5_out=>s_id_ex_funct7_bit5,control_out=>s_id_ex_control);
    
    -- ================== ESTÁGIO 3: EX ==================
    with s_forward_a select s_ex_forward_a_out <= s_id_ex_rega when "00", s_ex_mem_alu_out when "01", s_wb_write_data when "10", (others=>'0') when others;
    ALU_b_src_mux: entity work.mux2_1(rtl) port map(sel=>s_id_ex_control.ALUSrc,A=>s_id_ex_regb,B=>s_id_ex_imm32,Z=>s_ex_alu_src_b_out);
    with s_forward_b select s_ex_forward_b_out <= s_ex_alu_src_b_out when "00", s_ex_mem_alu_out when "01", s_wb_write_data when "10", (others=>'0') when others;
    ALU_control_inst: entity work.ULAControle(rtl) port map(ALUOp=>s_id_ex_control.ALUOp,funct3=>s_id_ex_funct3,funct7_bit5=>s_id_ex_funct7_bit5,controleULA=>s_ex_alu_control);
    ALU_inst: entity work.ALU(rtl) port map(iControl=>s_ex_alu_control,iA=>s_ex_forward_a_out,iB=>s_ex_forward_b_out,oResult=>s_ex_alu_out,zero=>s_ex_alu_zero);
    Branch_addr_adder: entity work.ALU(rtl) port map(iControl=>ALU_ADD,iA=>s_id_ex_pc_plus_4,iB=>s_id_ex_imm32,oResult=>s_branch_target_addr,zero=>open);
    EX_MEM_reg_inst: entity work.EX_MEM_reg(rtl) port map(clk=>clk,rst=>rst,alu_result_in=>s_ex_alu_out,reg_b_in=>s_id_ex_regb,rd_addr_in=>s_id_ex_rd_addr,alu_zero_in=>s_ex_alu_zero,control_in=>s_id_ex_control,alu_result_out=>s_ex_mem_alu_out,reg_b_out=>s_ex_mem_regb,rd_addr_out=>s_ex_mem_rd_addr,alu_zero_out=>s_ex_mem_alu_zero,control_out=>s_ex_mem_control);
    
    -- ================== ESTÁGIO 4: MEM ==================
    Data_mem: entity work.ramD(SYN) port map(address=>s_ex_mem_alu_out(11 downto 2),clock=>clk,data=>s_ex_mem_regb,wren=>s_ex_mem_control.MemWrite,q=>s_mem_read_data);
    MEM_WB_reg_inst: entity work.MEM_WB_reg(rtl) port map(clk=>clk,rst=>rst,mem_read_data_in=>s_mem_read_data,alu_result_in=>s_ex_mem_alu_out,rd_addr_in=>s_ex_mem_rd_addr,control_in=>s_ex_mem_control,mem_read_data_out=>s_mem_wb_mem_read_data,alu_result_out=>s_mem_wb_alu_out,rd_addr_out=>s_mem_wb_rd_addr,control_out=>s_mem_wb_control);
    
    -- ================== ESTÁGIO 5: WB ==================
    WB_mux: entity work.mux2_1(rtl) port map(sel=>s_mem_wb_control.MemtoReg,A=>s_mem_wb_alu_out,B=>s_mem_wb_mem_read_data,Z=>s_wb_write_data);

    -- Conexões finais para as portas de debug
    DEBUG_ALU_OUT    <= s_ex_alu_out;
    DEBUG_WB_DATA    <= s_wb_write_data;
    DEBUG_REG_T0_OUT <= s_debug_t0_data;

end structure;