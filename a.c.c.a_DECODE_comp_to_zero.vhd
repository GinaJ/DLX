library IEEE;
use IEEE.std_logic_1164.all; 
use IEEE.numeric_std.all;
use ieee.std_logic_misc.all;

entity compare_to_zero is
generic (Nbit : integer :=32);
Port (
		registerA     :	In	std_logic_vector(nbit-1 downto 0);
    equal_to_zero :	Out	std_logic);
end compare_to_zero;


architecture beh of compare_to_zero is
begin
  equal_to_zero<=nor_reduce(registerA);
end beh;



configuration CFG_compare_to_zero of compare_to_zero is
	for Beh
	end for;
end CFG_compare_to_zero;


