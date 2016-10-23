library IEEE;
use IEEE.std_logic_1164.all;

entity not_generic is
generic (nbit : natural :=32);
	Port (	A:	In	std_logic_vector(nbit-1 downto 0);
		Y:	Out	std_logic_vector(nbit-1 downto 0));
end not_generic;


architecture beh of not_generic is

begin
	Y <= not(A);

end beh;

configuration CFG_not_gen_ARCH1 of not_generic is
	for beh
	end for;
end CFG_not_gen_ARCH1;