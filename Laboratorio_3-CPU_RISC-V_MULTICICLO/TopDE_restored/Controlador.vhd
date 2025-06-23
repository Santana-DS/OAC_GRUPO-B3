library ieee;
use ieee.std_logic_1164.all;
library work;
use work.riscv_pkg.all;

entity Controlador is
    port (
        iCLK          : in  std_logic;
        iRST          : in  std_logic;
        opcode        : in  std_logic_vector(6 downto 0);
        zero          : in  std_logic;
        EscreveIR     : out std_logic;
        IouD          : out std_logic;
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
        EscreveSaidaULA : out std_logic;
        -- A porta EscrevePCCond não é mais necessária nesta lógica otimizada
        EscrevePCCond : out std_logic
    );
end Controlador;

architecture fsm_corrected of Controlador is
    type state_type is (
        ST_FETCH_1, ST_FETCH_2, ST_DECODE, 
        ST_EXEC_R, ST_ALU_WB,
        ST_MEM_ADDR, ST_MEM_READ_1, ST_MEM_READ_2, ST_MEM_WB,
        ST_MEM_WRITE_1, ST_MEM_WRITE_2,
        ST_BEQ_EXEC, ST_JUMP_EXEC,
        ST_ADDR_CALC, ST_PC_UPDATE
    );
    signal pr_state, nx_state : state_type;

begin
    process(iCLK, iRST)
    begin
        if (iRST = '1') then
            pr_state <= ST_FETCH_1;
        elsif (rising_edge(iCLK)) then
            pr_state <= nx_state;
        end if;
    end process;

    process(pr_state, opcode, zero)
    begin
        EscreveIR <= '0'; IouD <= '0'; EscrevePC <= '0'; EscrevePCCond <= '0';
        OrigPC <= '0'; ALUOp <= "00"; OrigAULA <= '0'; OrigBULA <= "00";
        EscreveReg <= '0'; Mem2Reg <= '0'; EscreveMem <= '0';
        EscreveA <= '0'; EscreveB <= '0'; EscreveSaidaULA <= '0';
        nx_state <= ST_FETCH_1;

        case pr_state is
            when ST_FETCH_1 =>
                IouD <= '0';
                nx_state <= ST_FETCH_2;

            when ST_FETCH_2 =>
                EscreveIR <= '1';
                EscrevePC <= '1'; OrigPC <= '0';
                OrigAULA <= '0'; OrigBULA <= "01"; ALUOp <= "00";
                EscreveSaidaULA <= '1';
                nx_state <= ST_DECODE;

            when ST_DECODE =>
                EscreveA <= '1'; EscreveB <= '1';
                case opcode is
                    when OPC_RTYPE | OPC_ITYPE_I => nx_state <= ST_EXEC_R;
                    when OPC_ITYPE_L | OPC_STYPE => nx_state <= ST_MEM_ADDR;
                    when OPC_BTYPE => nx_state <= ST_BEQ_EXEC;
                    when OPC_JTYPE | OPC_ITYPE_J => nx_state <= ST_JUMP_EXEC;
                    when others => nx_state <= ST_FETCH_1;
                end case;

            when ST_EXEC_R =>
                OrigAULA <= '1'; ALUOp <= "10";
                if (opcode = OPC_RTYPE) then
                    OrigBULA <= "00";
                else
                    OrigBULA <= "10";
                end if;
                EscreveSaidaULA <= '1';
                nx_state <= ST_ALU_WB;
            
            when ST_ALU_WB =>
                EscreveReg <= '1'; Mem2Reg <= '0';
                nx_state <= ST_FETCH_1;

            when ST_MEM_ADDR =>
                OrigAULA <= '1'; OrigBULA <= "10"; ALUOp <= "00";
                EscreveSaidaULA <= '1';
                if (opcode = OPC_ITYPE_L) then
                    nx_state <= ST_MEM_READ_1;
                else
                    nx_state <= ST_MEM_WRITE_1;
                end if;
            
            when ST_MEM_READ_1 =>
                IouD <= '1'; nx_state <= ST_MEM_READ_2;
            
            when ST_MEM_READ_2 =>
                nx_state <= ST_MEM_WB;
                
            when ST_MEM_WB =>
                EscreveReg <= '1'; Mem2Reg <= '1';
                nx_state <= ST_FETCH_1;
                
            when ST_MEM_WRITE_1 =>
                IouD <= '1'; EscreveMem <= '1'; nx_state <= ST_MEM_WRITE_2;
                
            when ST_MEM_WRITE_2 =>
                nx_state <= ST_FETCH_1;

            when ST_BEQ_EXEC =>
                OrigAULA <= '1'; OrigBULA <= "00"; ALUOp <= "01";
                if (zero = '1') then
                    nx_state <= ST_ADDR_CALC;
                else
                    nx_state <= ST_FETCH_1;
                end if;
            
            when ST_JUMP_EXEC =>
                EscreveReg <= '1'; Mem2Reg <= '0';
                nx_state <= ST_ADDR_CALC;

            when ST_ADDR_CALC =>
                if (opcode = OPC_ITYPE_J) then -- JALR
                    OrigAULA <= '1';
                else -- BEQ, JAL
                    OrigAULA <= '0';
                end if;
                OrigBULA <= "10"; ALUOp <= "00";
                EscreveSaidaULA <= '1';
                nx_state <= ST_PC_UPDATE;
                
            when ST_PC_UPDATE =>
                EscrevePC <= '1'; OrigPC <= '1';
                nx_state <= ST_FETCH_1;
                
        end case;
    end process;
end fsm_corrected;