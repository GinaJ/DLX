library IEEE;
use IEEE.std_logic_1164.all; 

entity AND_2 is
	Port (	A:	In	std_logic;
		B:	In	std_logic;
		Y:	Out	std_logic);
end AND_2;


architecture ARCH1 of AND_2 is

begin
	Y <=( A and B);

end ARCH1;

architecture ARCH2 of AND_2 is

begin

	P1: process(A,B) 
	begin
	  if (A='1') and (B='1') then
	    Y <='1';
	  elsif (A='0') or (B='0') then 
	    Y <='0';
	  end if;
	end process;

end ARCH2;


configuration CFG_AND2_ARCH1 of AND_2 is
	for ARCH1
	end for;
end CFG_AND2_ARCH1;

configuration CFG_AND2_ARCH2 of AND_2 is
	for ARCH2
	end for;
end CFG_AND2_ARCH2;

