library ieee; 
use ieee.std_logic_1164.all; 
use ieee.std_logic_unsigned.all;

entity cs_generic is 
	generic (N : integer :=8);
	Port (	
		A:	In	std_logic_vector(N-1 downto 0);
		B:	In	std_logic_vector(N-1 downto 0);
		Ci:	In	std_logic;
		S:	Out	std_logic_vector(N-1 downto 0)
		);
end cs_generic; 

architecture STRUCTURAL of cs_generic is

  component RCA_generic
        generic (N : integer :=8);
	Port (	A:	In	std_logic_vector(N-1 downto 0);
		B:	In	std_logic_vector(N-1 downto 0);
		Ci:	In	std_logic;
		S:	Out	std_logic_vector(N-1 downto 0);
		Co:	Out	std_logic);
  end component;

  component MUX21_GENERIC is
	generic (N: integer:= 8);
	port (	A:	In	std_logic_vector(N-1 downto 0) ;
		B:	In	std_logic_vector(N-1 downto 0);
		SEL:	In	std_logic;
		Y:	Out	std_logic_vector(N-1 downto 0));
  end component;
  
  signal Cout : std_logic;
  signal S1, S2 : std_logic_vector(N-1 downto 0);

begin
	UADDER1: RCA_generic 
	   generic map (N) 
	   port map (A, B, '0', S1, Cout);

	UADDER2: RCA_generic 
	   generic map (N) 
	   port map (A, B, '1', S2, Cout);

	U1 : MUX21_GENERIC
	   generic map (N)
	   port map ( S1, S2, Ci, S); -- when Ci = '1' selects the S2 signal
  

end STRUCTURAL;


configuration CFG_cs_generic_STRUCTURAL of cs_generic is
  for STRUCTURAL 
    for UADDER1: RCA_generic
      use configuration WORK.CFG_RCA_generic_STRUCTURAL;
    end for;

    for UADDER2: RCA_generic
      use configuration WORK.CFG_RCA_generic_STRUCTURAL;
    end for;

    for U1: MUX21_GENERIC
      use configuration WORK.CFG_MUX21_GEN_STRUCTURAL;
    end for;
  end for;
end CFG_cs_generic_STRUCTURAL;