library IEEE;
use IEEE.std_logic_1164.all; --  libreria IEEE con definizione tipi standard logic
use ieee.std_logic_misc.all;

entity comparator_1output is
	Generic (N: integer:= 32 );
	Port (	
    overflow_signed  : in std_logic;
    isSigned        : in std_logic;
    zeros         : in std_logic;
		cout          :	In	std_logic;		
    sel_comp      : in std_logic_vector(2 downto 0); --tell me what comparison it wants
    result_comp   : out std_logic);

	end entity;

  
architecture STRUCTURAL of comparator_1output is

	
  signal neq: std_logic;
  signal smaller: std_logic;
  signal greater: std_logic;
  signal equal: std_logic;
  signal neq_s: std_logic;
  signal smaller_s: std_logic;
  signal greater_s: std_logic;
  signal equal_s: std_logic;
  signal ne_sel : std_logic;


	component AND_2	
	Port (	A:	In	std_logic;
		B:	In	std_logic;
		Y:	Out	std_logic);
	end component;
	
	component IV	
	Port (	A:	In	std_logic;
		Y:	Out	std_logic);
	end component;
	
begin

	--Greater
	AND_1 : AND_2
	Port Map ( Cout, neq, greater);
  
  --equal
  equal<=zeros;
  
  --notEqual
  IV1 : IV
  port map (zeros, neq);
  --not equal selection (when instruction is sne (set not equal);

  
  --if all the selections are zero, we are looking for not equal
    ne_sel<=not(sel_comp(0) or sel_comp(1) or sel_comp(2));
  
  --less
  IV2 : IV
  port map (cout, smaller);
  
  --compare with the signal given by the decode
      AND_great : AND_2
	Port Map ( greater, sel_comp(2), greater_s);
    	AND_equal : AND_2
	Port Map ( equal, sel_comp(1), equal_s);
    	AND_smaller : AND_2
	Port Map ( smaller, sel_comp(0), smaller_s);
    	AND_neq : AND_2
	Port Map ( neq, ne_sel, neq_s);

  result_comp<=greater_s or equal_s or smaller_s or neq_s;
  
end STRUCTURAL;



configuration CFG_COMP_1out_GEN_STRUCTURAL of comparator_1output is
	for STRUCTURAL
  
  			for AND_1 : AND_2
				use configuration WORK.CFG_AND2_ARCH2;
			end for;
      
        			for AND_great : AND_2
				use configuration WORK.CFG_AND2_ARCH2;
			end for;
      
        			for AND_equal : AND_2
				use configuration WORK.CFG_AND2_ARCH2;
			end for;
      
        			for AND_smaller : AND_2
				use configuration WORK.CFG_AND2_ARCH2;
			end for;
      
        			for AND_neq : AND_2
				use configuration WORK.CFG_AND2_ARCH2;
			end for;
      
      
		for IV1 : IV
			use configuration WORK.CFG_IV_BEHAVIORAL;
		end for;
    
    for IV2 : IV
			use configuration WORK.CFG_IV_BEHAVIORAL;
		end for;
           
		end for;
	     
end CFG_COMP_1out_GEN_STRUCTURAL;
