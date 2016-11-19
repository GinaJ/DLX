library IEEE;
use IEEE.std_logic_1164.all; 

entity extend_16to32 is
Port (	
      immediate_offset : in std_logic_vector(15 downto 0);
      isSigned: in std_logic;
      extended  : out std_logic_vector(31 downto 0)
      );
end extend_16to32;


architecture Beh of extend_16to32 is 

begin

extended <= X"FFFF"&immediate_offset when (immediate_offset(15)='1' and isSigned='1')
                  else X"0000"&immediate_offset;
	
end beh;
      
configuration CFG_extend_16to32_BEH of extend_16to32 is
	for BEH
	end for;
end CFG_extend_16to32_BEH;
      
      