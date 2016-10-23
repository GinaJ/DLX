library IEEE;
use IEEE.std_logic_1164.all;

entity block_g is
	Port (	Pik: 	in	std_logic;
		Gik: 	in	std_logic;
		Gk1j:	in	std_logic;
		Gij:	out	std_logic);
end block_g;

architecture BEHAVIORAL of block_g is

begin
	Gij <= Gik or (Pik and Gk1j); -- Gij <= Gik or Pik and Gk-1j

end BEHAVIORAL;

configuration CFG_block_g_BEHAVIORAL of block_g is
	for BEHAVIORAL
	end for;
end CFG_block_g_BEHAVIORAL;