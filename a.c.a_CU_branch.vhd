library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity cu_branch is
generic (n : integer := 32);
port (

    jump_instr  : in std_logic;
    branch_instr: in std_logic;
    bnez_notBeq : in std_logic;
    isZero      : in std_logic;
    stall       : in std_logic;
    
    jump        : out std_logic
    
    ); 
end cu_branch;    
 
architecture Behavioral of cu_branch  is

  begin
  --We have to jump if we have ((jump instruction OR branch is true) AND we don't have any hazard)
    jump<= (jump_instr or 
         
          (branch_instr and (isZero xor bnez_notBeq))) and (not (stall));
   
end behavioral;

configuration CFG_cu_branch of cu_branch is
	for Behavioral
	end for;
end CFG_cu_branch;