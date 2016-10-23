library IEEE;
use IEEE.std_logic_1164.all;

entity MUX21_GENERIC is
	Generic (N: integer:= 8);
	Port (	
		A:		In	std_logic_vector(N-1 downto 0);
		B:		In	std_logic_vector(N-1 downto 0);
		SEL:	In	std_logic;
		Y:		Out	std_logic_vector(N-1 downto 0));
	end entity;

architecture BEHAVIORAL of MUX21_Generic is
begin
	Y <= B when SEL='1' else A;
end BEHAVIORAL;


architecture STRUCTURAL of MUX21_GENERIC is

	signal Y1: std_logic_vector(N-1 downto 0);
	signal Y2: std_logic_vector(N-1 downto 0);
	signal SA: std_logic;
	signal i : integer;
	component ND2
	
	Port (	A:	In	std_logic;
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


	all_mux : for i in N-1 downto 0 generate
	
	UND1 : ND2
	Port Map ( B(i), SEL, Y1(i));

	UND2 : ND2
	Port Map ( A(i), SA, Y2(i));

	UND3 : ND2
	Port Map ( Y1(i), Y2(i), Y(i));
	end generate;


end STRUCTURAL;


configuration CFG_MUX21_GEN_BEHAVIORAL of MUX21_GENERIC is
	for BEHAVIORAL
	end for;
end CFG_MUX21_GEN_BEHAVIORAL;


configuration CFG_MUX21_GEN_STRUCTURAL of MUX21_GENERIC is
	for STRUCTURAL
		for all : IV
			use configuration WORK.CFG_IV_BEHAVIORAL;
		end for;
		
		for all_mux
			for all : ND2
				use configuration WORK.CFG_ND2_ARCH2;
			end for;
		end for;
	end for;
end CFG_MUX21_GEN_STRUCTURAL;


