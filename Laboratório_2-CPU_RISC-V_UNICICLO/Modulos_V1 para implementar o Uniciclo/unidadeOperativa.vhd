library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.riscv_pkg.all;

entity unidadeOperativa is
    port (
        
			Clock: 			in std_logic;				
			Mem2Reg:    	in std_logic;		
			LeMem:      	in std_logic;		
			Branch:     	in std_logic;		
			ALUop:      	in std_logic_vector(1 downto 0); 
			EscreveMem: 	in std_logic;		
			OrigULA:    	in std_logic;		
			EscreveReg: 	in std_logic;		
			JAL:        	in std_logic;		
			JALR:       	in std_logic;
			SelectDado:		in std_logic;
			opcode:     	out std_logic_vector(6 downto 0);
			funct3: 			out std_logic_vector(2 downto 0);
			funct7: 			out std_logic										-- Pegando só o bit mais importate | Assim fica o funct3 e funct7 como saída da unidade operativa, ele sai do controle, coloco entao o controle da ULA como controle geral (uniciclo)
		  
    );
end unidadeOperativa;

architecture arc of unidadeOperativa is

-- 1 	PC
	component PC is
    port (
			clk:				in std_logic;
			PCin: 			in std_logic_vector(9 downto 0);
			PCout: 			out std_logic_vector(9 downto 0)
    );
	 end component;
	 
-- 2 Memória de instruções
	 component ramI IS
		port(
			address: 		IN STD_LOGIC_VECTOR (9 DOWNTO 0);
			clock: 			IN STD_LOGIC  := '1';
			data: 			IN STD_LOGIC_VECTOR (31 DOWNTO 0);
			wren: 			IN STD_LOGIC ;
			q: 				OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
	);
	end component;
	
-- 3 Somador (vamos usar esse somador 2 vezes)
	component somadorDe32Bits is
    port ( 
		num1: 				in  std_logic_vector(31 downto 0);
      num2: 				in  std_logic_vector(31 downto 0);
      soma: 				out  std_logic_vector(31 downto 0)
		);
end component;

-- 4 Banco de registradores
	component xregs is
		port (
		iCLK: 				in  std_logic;
		iRST: 				in  std_logic;
		iWREN: 				in  std_logic;
		iRS1: 				in  std_logic_vector(ADDR-1 downto 0);
		iRS2: 				in  std_logic_vector(ADDR-1 downto 0);
		iRD: 					in  std_logic_vector(ADDR-1 downto 0);
		iDATA: 				in  std_logic_vector(SIZE-1 downto 0);
		oREGA: 				out std_logic_vector(SIZE-1 downto 0);
		oREGB: 				out std_logic_vector(SIZE-1 downto 0);
		iDISP: 				in  std_logic_vector(ADDR-1 downto 0);
		oREGD: 				out std_logic_vector(SIZE-1 downto 0)
		);
end component;

-- 5 Gerador de imediatos
	component genImm32 is 
	port (
		instr: 				in std_logic_vector(31 downto 0);
		imm32: 				out std_logic_vector(31 downto 0)
		);
end component;

-- 6 Mux (Vamos usar o mux que fizemos do jal 4 vezes - uma pro jal e as outras p/ o uniciclo)
	component mux2_1jal is
	port (
		Sel: 					in std_logic;
		A: 					in std_logic_vector(31 downto 0);
		B:						in std_logic_vector(31 downto 0);
		R:						out std_logic_vector(31 downto 0)
		);
end component;

-- 7 Mux do jalr
	component mux2_1jalr is
	port (
		Sel: 					in std_logic;
		A: 					in std_logic_vector(4 downto 0);
		B:						in std_logic_vector(4 downto 0);
		R:						out std_logic_vector(4 downto 0)
	);
end component;

-- 8 ULA
	component ALU is
    Port (
        iControl: 		in  std_logic_vector(4 downto 0);
        iA: 				in  std_logic_vector(31 downto 0);
        iB: 				in  std_logic_vector(31 downto 0);
        oResult: 			out std_logic_vector(31 downto 0)
    );
end component;

-- 9 Memoria de Dados
	component ramD IS
	port(
		address: 			IN STD_LOGIC_VECTOR (9 DOWNTO 0);
		clock: 				IN STD_LOGIC  := '1';
		data: 				IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		wren: 				IN STD_LOGIC ;
		q: 					OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
	);
END component;

-- 10 Porta Or
	component portaOR is
    port (
        A: 					in std_logic;
        B: 					in std_logic;
        Y: 					out std_logic
    );
end component;
	
	-- Sinais de conexão
	signal fioEntradaPc: 	std_logic_vector(9 downto 0);
	signal fioSaidaPc: 		std_logic_vector(9 downto 0);

	
	
begin
-- Vamos andar da esquerda p/ direita

PC_1:		PC port map 
			(
			clk		=> Clock;
			PCin		=> fioEntradaPc;
			PCout		: 	out std_logic_vector(31 downto 0)
			);
end arc;