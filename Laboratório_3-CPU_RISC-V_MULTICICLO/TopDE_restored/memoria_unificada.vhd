library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library altera_mf;
use altera_mf.altera_mf_components.all;

entity memoria_unificada is
    port (
        clock      : in  std_logic;
        addr_instr : in  std_logic_vector(31 downto 0);
        addr_data  : in  std_logic_vector(31 downto 0);
        IouD       : in  std_logic;
        wren       : in  std_logic;
        data_in    : in  std_logic_vector(31 downto 0);
        data_out   : out std_logic_vector(31 downto 0)
    );
end entity;

architecture rtl of memoria_unificada is
    signal mux_addr : std_logic_vector(31 downto 0);
    signal q_ram    : std_logic_vector(31 downto 0);
begin
    mux_addr <= addr_data when IouD = '1' else addr_instr;
    data_out <= q_ram;

    ram_inst : altsyncram
        generic map (
            init_file                  => "de1_text.mif",
            intended_device_family     => "Cyclone IV E",
            lpm_type                   => "altsyncram",
            numwords_a                 => 1024,
            operation_mode             => "SINGLE_PORT",
            outdata_aclr_a             => "NONE",
            outdata_reg_a              => "UNREGISTERED",
            power_up_uninitialized     => "FALSE",
            widthad_a                  => 10,
            width_a                    => 32,
            width_byteena_a            => 1
        )
        port map (
            clock0     => clock,
            address_a  => mux_addr(11 downto 2),
            data_a     => data_in,
            wren_a     => wren,
            q_a        => q_ram
        );
end architecture;