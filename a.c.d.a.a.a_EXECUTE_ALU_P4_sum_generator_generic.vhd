library ieee; 
use ieee.std_logic_1164.all; 
use ieee.std_logic_unsigned.all;


entity Sum_generator is 
	generic (Nbit : 	natural := 16;
	         Nblock : 	natural := 4);
	Port (	A:	In	std_logic_vector(Nbit-1 downto 0);
		B:	In	std_logic_vector(Nbit-1 downto 0);
		Ci:	In	std_logic_vector(Nblock-1 downto 0);
		S:	Out	std_logic_vector(Nbit-1 downto 0)
		);
end sum_generator; 


architecture STRUCTURAL of Sum_generator is

 component cs_generic is 
	generic (N : integer :=8);
	Port (	
		A:	In	std_logic_vector(N-1 downto 0);
		B:	In	std_logic_vector(N-1 downto 0);
		Ci:	In	std_logic;
		S:	Out	std_logic_vector(N-1 downto 0)
		);
  end component; 

constant Nbit_cs : integer := Nbit/Nblock;
begin

   cs_gen_loop: for I in 1 to Nblock generate
    cs_gen : cs_generic
	  generic map (Nbit_cs)
	  port map (A(((I*Nbit_cs)-1) downto ((I-1)*Nbit_cs)), B(((I*Nbit_cs)-1) downto ((I-1)*Nbit_cs)), Ci(i-1), S(((I*Nbit_cs)-1) downto ((I-1)*Nbit_cs))); 
  end generate;
end STRUCTURAL;

configuration CFG_Sum_generator_STRUCTURAL of Sum_generator is
	for STRUCTURAL
		for cs_gen_loop
			for all : cs_generic
				use configuration WORK.CFG_cs_generic_STRUCTURAL;
			end for;
		end for;

	end for;
end CFG_Sum_generator_STRUCTURAL;
