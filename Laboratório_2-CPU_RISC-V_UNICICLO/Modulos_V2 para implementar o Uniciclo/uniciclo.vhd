library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.riscv_pkg.all;

entity Uniciclo is
    port (
        clockCPU : in  std_logic;
        clockMem : in  std_logic;
        reset    : in  std_logic;
        PC       : out std_logic_vector(31 downto 0);
        Instr    : out std_logic_vector(31 downto 0);
        regin    : in  std_logic_vector(4 downto 0);
        regout   : out std_logic_vector(31 downto 0)
    );
end Uniciclo;

architecture Behavioral of Uniciclo is

    -- Sinais internos
    signal PC_internal      	 : std_logic_vector(31 downto 0) := x"00400000";
    signal Instr_internal   	 : std_logic_vector(31 downto 0) := (others => '0');
	 signal regin_internal		 : std_logic_vector(4 downto 0);
    signal regout_internal  	 : std_logic_vector(31 downto 0) := (others => '0');
    signal SaidaULA          	 : std_logic_vector(31 downto 0);
    -- signal Leitura2         : std_logic_vector(31 downto 0);
    signal MemData             : std_logic_vector(31 downto 0);
    signal EscreveMem        	 : std_logic;
    signal mem2reg_internal    : std_logic;
	 signal memRead_internal  	 : std_logic := '0';
	 signal branch_internal   	 : std_logic;
	 signal ALUOp_internal 	  	 : std_logic_vector(1 downto 0);
	 signal ALUSrc_internal  	 : std_logic;
	 signal regWrite_internal	 : std_logic;
	 signal jal_internal 	  	 : std_logic;
	 signal jalr_internal 	  	 : std_logic;
	 signal selectDado_internal : std_logic;
	 signal memData_internal  	 : std_logic_vector(31 downto 0);
	 signal oRegA_internal 	    : std_logic_vector(31 downto 0);
	 signal oRegB_internal 	  	 : std_logic_vector(31 downto 0);
	 signal imm32_internal 	  	 : std_logic_vector(31 downto 0);
	 signal ulaCntr_internal  	 : std_logic_vector(4 downto 0);
	 signal ulaB_internal	  	 : std_logic_vector(31 downto 0);
	 signal PCMux_selector    	 : std_logic;
	 signal ULAZero_internal  	 : std_logic;

begin
    -- Atribuição das saídas
    PC     <= PC_internal;
    Instr  <= Instr_internal;
    regout <= regout_internal;
	
	 
	 PCMux_selector <= (branch_internal and ULAZero_internal) or jal_internal;
    -- Processo para atualização do PC
    process(clockCPU, reset)
    begin
        if reset = '1' then
            PC_internal <= x"00400000";
        elsif rising_edge(clockCPU) then
				if (jalr_internal = '1') then
					PC_internal <= SaidaULA;
				elsif (PCMux_selector = '1') then 
					PC_internal <= std_logic_vector(unsigned(PC_internal) + unsigned(imm32_internal));
				else
					PC_internal <= std_logic_vector(unsigned(PC_internal) + 4);
				end if;
        end if;
    end process;
    
    -- Atribuições contínuas
    -- EscreveMem <= '0';
    -- SaidaULA   <= (others => '0'); -- TODO: Retirar quando instanciar a ULA
    
    -- Instanciação da memória de instruções
    MemC : entity work.ramI 
        port map (
            address => PC_internal(11 downto 2),
            clock   => clockMem,
            data    => (others => '0'),
            wren    => '0',
            q       => Instr_internal
        );
    
    -- Instanciação da memória de dados
	 
    MemD : entity work.ramD
        port map (
            address => SaidaULA(11 downto 2),
            clock   => clockMem,
            data    => oRegB_internal,
            wren    => EscreveMem,
            q       => MemData
        );
    
    -- Seu código do processador viria aqui
	
	 
	  -- Unidade de controle
	  memRead_internal <= '0';
	 cntrl : entity work.unidadeDeControle(arc)
		port map (
			opcode     => Instr_internal(6 downto 0),			
			Mem2Reg    => mem2reg_internal,
			LeMem      => memRead_internal,		
			Branch     => branch_internal,	
			ALUop      => ALUOp_internal, 
			EscreveMem => EscreveMem,		
			OrigULA    => ALUSrc_internal,	
			EscreveReg => regWrite_internal,		
			JAL        => jal_internal,
			JALR       => jalr_internal,
			SelectDado => selectDado_internal
		);
	 
	 -- conexão com o banco de registradores
	 regin_internal <= regin;
	 memData_internal <= std_logic_vector(unsigned(PC_internal) + 4) when (selectDado_internal = '1') else
								MemData when (mem2reg_internal = '1' and selectDado_internal = '0') else 
								SaidaULA;
	 Xregs : entity work.xregs(rtl)
		port map(
			iCLK		=> clockCPU,
			iRST		=> reset,
			iWREN		=> regWrite_internal, -- sinal de escrita no registrador
			iRS1		=> Instr_internal(19 downto 15),
			iRS2		=> Instr_internal(24 downto 20),
			iRD		=> Instr_internal(11 downto 7),
			iDATA		=> memData_internal,
			oREGA 	=> oRegA_internal,
			oREGB 	=> oRegB_internal,
			iDISP		=> regin_internal,
			oREGD		=> regout_internal
		);
		
	GerImm : entity work.genImm32(rtl)
		port map (
			instr => Instr_internal,
			imm32 => imm32_internal
	);
	
	ULA_cntr : entity work.ULAControle(arc)
    port map (
			ALUop 			=> ALUOp_internal,
			funct3 			=> Instr_internal(14 downto 12),
			funct7			=> Instr_internal(30),
			controleULA 	=> ulaCntr_internal
	);
	
	ulaB_internal <= imm32_internal when (ALUSrc_internal = '1') else oRegB_internal;
	ULA : entity work.ALU(Behavioral)
    port map(
        iControl  => ulaCntr_internal,
        iA        => oRegA_internal,
        iB        => ulaB_internal,
        oResult   => SaidaULA, 
		  zero	   => ULAZero_internal
    );
    
end Behavioral;