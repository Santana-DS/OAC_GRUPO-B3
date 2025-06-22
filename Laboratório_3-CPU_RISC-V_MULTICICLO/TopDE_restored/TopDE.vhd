library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.riscv_pkg.all;

entity TopDE is
    port (
        CLOCK    : in  std_logic;
        Reset    : in  std_logic;
        Regin    : in  std_logic_vector(4 downto 0);
        PC       : out std_logic_vector(31 downto 0);
        Estado   : out std_logic_vector(3 downto 0);
        DEBUG_INSTR : out std_logic_vector(31 downto 0)
    );
end TopDE;

architecture structure of TopDE is
    component Controlador
        port (
            iCLK          : in  std_logic;
            iRST          : in  std_logic;
            opcode        : in  std_logic_vector(6 downto 0);
            zero          : in  std_logic;
            EscreveIR     : out std_logic;
            IouD          : out std_logic;
            EscrevePCCond : out std_logic;
            EscrevePC     : out std_logic;
            OrigPC        : out std_logic;
            ALUOp         : out std_logic_vector(1 downto 0);
            OrigAULA      : out std_logic;
            OrigBULA      : out std_logic_vector(1 downto 0);
            EscreveReg    : out std_logic;
            Mem2Reg       : out std_logic;
            EscreveMem    : out std_logic;
            EscreveA      : out std_logic;
            EscreveB      : out std_logic;
            EscreveSaidaULA : out std_logic
        );
    end component;

    component Multiciclo
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
    end component;

    signal s_clock_cpu : std_logic;
    signal s_opcode : std_logic_vector(6 downto 0);
    signal s_zero   : std_logic;
    signal s_EscreveIR, s_IouD, s_EscrevePCCond, s_EscrevePC, s_OrigPC : std_logic;
    signal s_EscreveReg, s_Mem2Reg, s_EscreveMem, s_EscreveA, s_EscreveB, s_EscreveSaidaULA : std_logic;
    signal s_ALUOp, s_OrigBULA : std_logic_vector(1 downto 0);
    signal s_OrigAULA : std_logic;

begin
    process(CLOCK)
    begin
        if rising_edge(CLOCK) then
            s_clock_cpu <= not s_clock_cpu;
        end if;
    end process;

    Datapath_inst : Multiciclo
        port map (
            clockCPU => s_clock_cpu, reset => Reset, EscreveIR => s_EscreveIR, IouD => s_IouD,
            EscrevePCCond => s_EscrevePCCond, EscrevePC => s_EscrevePC, OrigPC => s_OrigPC,
            ALUOp => s_ALUOp, OrigAULA => s_OrigAULA, OrigBULA => s_OrigBULA,
            EscreveReg => s_EscreveReg, Mem2Reg => s_Mem2Reg, EscreveMem => s_EscreveMem,
            EscreveA => s_EscreveA, EscreveB => s_EscreveB, EscreveSaidaULA => s_EscreveSaidaULA,
            opcode_out => s_opcode, zero_out => s_zero, PC_out => PC,
            instr_debug_out => DEBUG_INSTR
        );

    Controller_inst : Controlador
        port map (
            iCLK => s_clock_cpu, iRST => Reset, opcode => s_opcode, zero => s_zero,
            EscreveIR => s_EscreveIR, IouD => s_IouD, EscrevePCCond => s_EscrevePCCond,
            EscrevePC => s_EscrevePC, OrigPC => s_OrigPC, ALUOp => s_ALUOp,
            OrigAULA => s_OrigAULA, OrigBULA => s_OrigBULA, EscreveReg => s_EscreveReg,
            Mem2Reg => s_Mem2Reg, EscreveMem => s_EscreveMem, EscreveA => s_EscreveA,
            EscreveB => s_EscreveB, EscreveSaidaULA => s_EscreveSaidaULA
        );
        
    Estado <= (others => '0');

end architecture;