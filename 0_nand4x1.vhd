library IEEE;
use IEEE.std_logic_1164.all; 

entity nand4x1_generic is
generic (nbit : natural :=32);
	Port (
    op1     :	In	std_logic_vector(nbit-1 downto 0);
    op2     :	In	std_logic_vector(nbit-1 downto 0);
    op3     :	In	std_logic_vector(nbit-1 downto 0);
    op4     :	In	std_logic_vector(nbit-1 downto 0);
		Y       :	Out	std_logic_vector(nbit-1 downto 0));
end nand4x1_generic;


architecture struct of nand4x1_generic is

begin
 y<= not(op1 and op2 and op3 and op4);
end struct;

configuration CFG_nand4x1_gen_struct of nand4x1_generic is
	for struct
	end for;
end CFG_nand4x1_gen_struct;