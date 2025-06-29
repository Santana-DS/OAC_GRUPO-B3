library ieee;
use ieee.std_logic_1164.all;
library altera_mf;
use altera_mf.altera_mf_components.all;

entity ramI is
    port (
        address : in  std_logic_vector(9 downto 0);
        clock   : in  std_logic;
        q       : out std_logic_vector(31 downto 0)
    );
end ramI;

architecture SYN of ramI is
    signal sub_wire0 : std_logic_vector(31 downto 0);
begin
    q <= sub_wire0;

    altsyncram_component : altsyncram
    generic map (
        init_file                  => "de1_text.mif",
        intended_device_family     => "Cyclone IV E",
        lpm_type                   => "altsyncram",
        numwords_a                 => 1024,
        operation_mode             => "SINGLE_PORT",
        outdata_aclr_a             => "NONE",
        outdata_reg_a              => "UNREGISTERED",
        widthad_a                  => 10,
        width_a                    => 32
    )
    port map (
        address_a => address,
        clock0    => clock,
        q_a       => sub_wire0
    );
end SYN;