library IEEE;
use IEEE.std_logic_1164.all;

entity MUX1 is
	Port (	
		A:		In	std_logic;
		B:		In	std_logic;
		SEL:	In	std_logic;
		Y:		Out	std_logic);
	end entity;



architecture BEHAVIORAL of MUX1 is

begin
	Y <= B when SEL='1' else A;
end BEHAVIORAL;


architecture STRUCTURAL of MUX1 is

	signal Y1: std_logic;
	signal Y2: std_logic;
	signal SA: std_logic;
	signal i : integer;
  
	component ND2
	Port (	
    A:	In	std_logic;
		B:	In	std_logic;
		Y:	Out	std_logic);
	end component;
	
	component IV
	
	Port (	A:	In	std_logic;
		Y:	Out	std_logic);
	end component;
	
begin
	UIV : IV
	Port Map ( SEL, SA);

	UND1 : ND2
	Port Map ( B, SEL, Y1);

	UND2 : ND2
	Port Map ( A, SA, Y2);

	UND3 : ND2
	Port Map ( Y1, Y2, Y);

end STRUCTURAL;


configuration CFG_MUX21_BEHAVIORAL of MUX1 is
	for BEHAVIORAL
	end for;
end CFG_MUX21_BEHAVIORAL;


configuration CFG_MUX21_STRUCTURAL of MUX1 is
	for STRUCTURAL
		for UIV : IV
			use configuration WORK.CFG_IV_BEHAVIORAL;
		end for;
		
		
    for all : ND2
      use configuration WORK.CFG_ND2_ARCH2;
    end for;
	
	end for;
end CFG_MUX21_STRUCTURAL;