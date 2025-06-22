-- Copyright (C) 2025  Altera Corporation. All rights reserved.
-- Your use of Altera Corporation's design tools, logic functions 
-- and other software and tools, and any partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Altera Program License 
-- Subscription Agreement, the Altera Quartus Prime License Agreement,
-- the Altera IP License Agreement, or other applicable license
-- agreement, including, without limitation, that your use is for
-- the sole purpose of programming logic devices manufactured by
-- Altera and sold by Altera or its authorized distributors.  Please
-- refer to the Altera Software License Subscription Agreements 
-- on the Quartus Prime software download page.

-- *****************************************************************************
-- This file contains a Vhdl test bench with test vectors .The test vectors     
-- are exported from a vector file in the Quartus Waveform Editor and apply to  
-- the top level entity of the current Quartus project .The user can use this   
-- testbench to simulate his design using a third-party simulation tool .       
-- *****************************************************************************
-- Generated on "06/22/2025 19:38:34"
                                                             
-- Vhdl Test Bench(with test vectors) for design  :          TopDE
-- 
-- Simulation tool : 3rd Party
-- 

LIBRARY ieee;                                               
USE ieee.std_logic_1164.all;                                

ENTITY TopDE_vhd_vec_tst IS
END TopDE_vhd_vec_tst;
ARCHITECTURE TopDE_arch OF TopDE_vhd_vec_tst IS
-- constants                                                 
-- signals                                                   
SIGNAL CLOCK : STD_LOGIC;
SIGNAL DEBUG_INSTR : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL Estado : STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL PC : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL Regin : STD_LOGIC_VECTOR(4 DOWNTO 0);
SIGNAL Reset : STD_LOGIC;
COMPONENT TopDE
	PORT (
	CLOCK : IN STD_LOGIC;
	DEBUG_INSTR : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
	Estado : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
	PC : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
	Regin : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
	Reset : IN STD_LOGIC
	);
END COMPONENT;
BEGIN
	i1 : TopDE
	PORT MAP (
-- list connections between master ports and signals
	CLOCK => CLOCK,
	DEBUG_INSTR => DEBUG_INSTR,
	Estado => Estado,
	PC => PC,
	Regin => Regin,
	Reset => Reset
	);

-- CLOCK
t_prcs_CLOCK: PROCESS
BEGIN
LOOP
	CLOCK <= '0';
	WAIT FOR 10000 ps;
	CLOCK <= '1';
	WAIT FOR 10000 ps;
	IF (NOW >= 3000000 ps) THEN WAIT; END IF;
END LOOP;
END PROCESS t_prcs_CLOCK;

-- Reset
t_prcs_Reset: PROCESS
BEGIN
	Reset <= '0';
	WAIT FOR 10000 ps;
	Reset <= '1';
	WAIT FOR 70000 ps;
	Reset <= '0';
WAIT;
END PROCESS t_prcs_Reset;
END TopDE_arch;
