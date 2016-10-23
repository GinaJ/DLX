library IEEE;
use IEEE.std_logic_1164.all;

entity block_pg is
	Port (	Pik:	in	std_logic;
		Pk1j:	in	std_logic;
		Gik:	in	std_logic;
		Gk1j:	in	std_logic;
		Pij:	out	std_logic;
		Gij:	out	std_logic);
end block_pg;

architecture BEHAVIORAL of block_pg is

begin
	Pij <= Pik and Pk1j; -- Pij <= Pik and Pk-1j
	Gij <= Gik or (Pik and Gk1j); -- Gij <= Gik or Pik and Gk-1j

end BEHAVIORAL;

configuration CFG_block_pg_BEHAVIORAL of block_pg is
	for BEHAVIORAL
	end for;
end CFG_block_pg_BEHAVIORAL;