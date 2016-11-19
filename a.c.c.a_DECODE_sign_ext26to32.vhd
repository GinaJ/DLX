library IEEE;
use IEEE.std_logic_1164.all; 

entity sign_extend_26to32 is
Port (	
      immediate_offset : in std_logic_vector(25 downto 0);
      sign_extended   : out std_logic_vector(31 downto 0)
      );
end sign_extend_26to32;


architecture Beh of sign_extend_26to32 is 

begin

sign_extended <= "111111"&immediate_offset when immediate_offset(25)='1' 
                  else "000000"&immediate_offset;
	
end beh;
      
configuration CFG_sign_extend_26to32_BEH of sign_extend_26to32 is
	for BEH
	end for;
end CFG_sign_extend_26to32_BEH;
      
      