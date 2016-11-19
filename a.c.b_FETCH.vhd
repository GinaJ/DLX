library IEEE;
use IEEE.std_logic_1164.all; 
use IEEE.numeric_std.all;

entity FETCH is
generic (
    N : integer :=32);
Port (
    --FROM TOP-LEVEL DLX
    CK:	In	std_logic;
		RESET:	In	std_logic;
    
    --FROM HAZARD_UNIT
    Stall: in std_logic;
        
    --From decode stage
    target_jump : in std_logic_vector(n-1 downto 0);
    
    --from decode stage (not execute
    mux_pc : in std_logic;
    
    
    --output to instr_mem
    PC_from_FETCH_to_iram : out std_logic_vector(n-1 downto 0);
    
    --output to IFID pipeline register
		PC_out_to_IFID:	Out	std_logic_vector(n-1 downto 0));
		
end FETCH;


architecture struct of FETCH is 

component accumulator is
generic (Nbit : integer :=32);
Port (		
    Reset: in std_logic;
    Stall    : in std_logic;
		PC_IN_acc:	In	std_logic_vector(nbit-1 downto 0);
		PC_out_acc:	Out	std_logic_vector(n-1 downto 0));
end component accumulator;
 
component Program_counter is
generic (Nbit : integer :=32);
Port (		
    CK            :	In	std_logic;
		RESET         :	In	std_logic;
    Stall         : in std_logic;
   	PC            :	In	std_logic_vector(nbit-1 downto 0);
		PC_out        :	Out	std_logic_vector(n-1 downto 0));
end component Program_counter;


component MUX21_GENERIC is
	Generic (N: integer:= 8);
	Port (	
		A:		In	std_logic_vector(N-1 downto 0);
		B:		In	std_logic_vector(N-1 downto 0);
		SEL:	In	std_logic;
		Y:		Out	std_logic_vector(N-1 downto 0));
	end component;


signal actual_pc  : std_logic_vector(N-1 downto 0);
signal next_pc    : std_logic_vector(N-1 downto 0);
signal real_next_pc    : std_logic_vector(N-1 downto 0);


begin
  PC_plus4 : accumulator
  generic map(N)
  Port map(	RESET, Stall, actual_pc, next_pc);

  PC_reg : Program_counter
  generic map(N)
  Port map(	CK,	RESET, Stall, real_next_pc, actual_pc);

  mux_NextPC : MUX21_GENERIC
  generic map(n)
  port map(next_pc, target_jump, mux_pc, real_next_pc);
 
  PC_out_to_IFID<=next_pc;
  PC_from_FETCH_to_iram<=actual_pc;
end struct;

configuration CFG_FETCH of fetch is
	for struct
  
      for PC_plus4 : accumulator
      use configuration work.CFG_accumulator;
      end for;
           
      for mux_NextPC : MUX21_GENERIC
      use configuration work.cfg_mux21_gen_structural;
      end for;
      
	end for;
end CFG_FETCH;