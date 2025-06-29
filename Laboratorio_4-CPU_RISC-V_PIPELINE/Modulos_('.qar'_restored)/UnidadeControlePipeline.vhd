library ieee;
use ieee.std_logic_1164.all;
library work;
use work.riscv_pkg.all;

entity UnidadeControlePipeline is
    port (
        opcode      : in  std_logic_vector(6 downto 0);
        control_out : out t_control_signals
    );
end UnidadeControlePipeline;

architecture rtl of UnidadeControlePipeline is
    signal s_ctrl : t_control_signals;
begin
    process(opcode)
    begin
        s_ctrl <= DEFAULT_CONTROL;
        case opcode is
            when OPC_RTYPE =>
                s_ctrl.RegWrite <= '1';
                s_ctrl.ALUOp    <= "10";
            when OPC_ITYPE_L =>
                s_ctrl.RegWrite <= '1';
                s_ctrl.ALUSrc   <= '1';
                s_ctrl.MemRead  <= '1';
                s_ctrl.MemtoReg <= '1';
            when OPC_ITYPE_I =>
                s_ctrl.RegWrite <= '1';
                s_ctrl.ALUSrc   <= '1';
                s_ctrl.ALUOp    <= "00";
            when OPC_STYPE =>
                s_ctrl.ALUSrc   <= '1';
                s_ctrl.MemWrite <= '1';
            when OPC_BTYPE =>
                s_ctrl.Branch   <= '1';
                s_ctrl.ALUOp    <= "01";
            when others => s_ctrl <= DEFAULT_CONTROL;
        end case;
    end process;
    control_out <= s_ctrl;
end rtl;