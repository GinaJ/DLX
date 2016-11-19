library ieee; 
use ieee.std_logic_1164.all; 
use ieee.std_logic_unsigned.all;

entity P4adder is 
	generic (N : 	natural := 32;
		 PowerN:natural := 5);
	Port (	A:	In	std_logic_vector(N-1 downto 0);
		B:	In	std_logic_vector(N-1 downto 0);
		Ci:	In	std_logic;
		S:	Out	std_logic_vector(N-1 downto 0);
    OverfSigned:	Out	std_logic;
		Overf:	Out	std_logic
		);
end P4adder; 

architecture STRUCTURAL of P4adder is

component  RCA_generic is 
	generic (N : integer :=8);
	Port (	
		A:	In	std_logic_vector(N-1 downto 0);
		B:	In	std_logic_vector(N-1 downto 0);
		Ci:	In	std_logic;
		S:	Out	std_logic_vector(N-1 downto 0);
		Co:	Out	std_logic);
end component  RCA_generic; 

 component sparce_tree is 
	generic (POWER : 	natural := 5);
	Port (	A:	In	std_logic_vector((2**POWER) downto 1);
		B:	In	std_logic_vector((2**POWER) downto 1);
		Ci:	In	std_logic;
		Cout:	Out	std_logic_vector((2**(POWER-2)) downto 0)
		);
  end component;  

  component Sum_generator is 
	generic (Nbit : 	natural := 16;
	         Nblock : 	natural := 4);
	Port (	A:	In	std_logic_vector(Nbit-1 downto 0);
		B:	In	std_logic_vector(Nbit-1 downto 0);
		Ci:	In	std_logic_vector(Nblock-1 downto 0);
		S:	Out	std_logic_vector(Nbit-1 downto 0)
		);
  end component; 

  constant NCout: integer := N/4;
  signal sCout : std_logic_vector(NCout downto 0);
  signal sum_delete : std_logic_vector(2 downto 0);
  signal previous_cout : std_logic;

begin
	Usparce_tree: sparce_tree 
	   generic map (PowerN) 
	   port map (A, B, Ci, sCout);

	USum_generator: Sum_generator 
	   generic map (N, Ncout) 
	   port map (A, B, sCout(NCout-1 downto 0), S);
	
  RCA : RCA_generic
  generic map (3)
	Port map(A(n-2 downto n-4), B(n-2 downto n-4), sCout(NCout-1), sum_delete, previous_cout);

  OverfSigned<=sCout(NCout) xor previous_cout;
	Overf <= sCout(NCout);

end STRUCTURAL;


configuration CFG_P4adder_STRUCTURAL of P4adder is
  for STRUCTURAL 
    for Usparce_tree: sparce_tree
      use configuration WORK.CFG_sparce_tree_STRUCTURAL;
    end for;

    for USum_generator: Sum_generator
      use configuration WORK.CFG_Sum_generator_STRUCTURAL;
    end for;

  end for;
end CFG_P4adder_STRUCTURAL;