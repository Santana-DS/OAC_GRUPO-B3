library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.riscv_pkg.all;

entity TopDE is
    port (
        CLOCK    : in  std_logic;
        Reset    : in  std_logic;
        Regin    : in  std_logic_vector(4 downto 0);
        ClockDIV : out std_logic;
        PC       : out std_logic_vector(31 downto 0);
        Instr    : out std_logic_vector(31 downto 0);
        Regout   : out std_logic_vector(31 downto 0);
        Estado   : out std_logic_vector(3 downto 0)
    );
end TopDE;

architecture Behavioral of TopDE is
    signal ClockDIV_internal : std_logic := '1';
    
    -- Component declaration for Uniciclo
    component Uniciclo
        port (
            clockCPU : in  std_logic;
            clockMem : in  std_logic;
            reset    : in  std_logic;
            PC       : out std_logic_vector(31 downto 0);
            Instr    : out std_logic_vector(31 downto 0);
            regin    : in  std_logic_vector(4 downto 0);
            regout   : out std_logic_vector(31 downto 0)
        );
    end component;
    
begin
	Estado <= (others => '0');
    -- Clock divider process
    process(CLOCK)
    begin
        if rising_edge(CLOCK) then
            ClockDIV_internal <= not ClockDIV_internal;
        end if;
    end process;
    
    ClockDIV <= ClockDIV_internal;
    
    -- Instantiation of Uniciclo
    UNI1 : Uniciclo
        port map (
            clockCPU => ClockDIV_internal,
            clockMem => CLOCK,
            reset    => Reset,
            PC       => PC,
            Instr    => Instr,
            regin    => Regin,
            regout   => Regout
        );
    
    -- The commented Multiciclo and Pipeline instantiations would go here
    -- but are left out as they were commented in the original Verilog
    
end Behavioral;