library IEEE;
use IEEE.std_logic_1164.all; --  libreria IEEE con definizione tipi standard logic

entity logical_T2 is
generic (nbit : natural :=32);
	Port (
    selectors  :	In	std_logic_vector(3 downto 0);
    op1        :	In	std_logic_vector(nbit-1 downto 0);
    op2        :	In	std_logic_vector(nbit-1 downto 0);
    not_op1    :	In	std_logic_vector(nbit-1 downto 0);
    not_op2    :	In	std_logic_vector(nbit-1 downto 0);
		Y          :	Out	std_logic_vector(nbit-1 downto 0));
end logical_T2;


architecture struct of logical_T2 is

component nand_enabled_generic is
generic (nbit : natural :=32);
	Port (
    enable  :	In	std_logic;
    op1     :	In	std_logic_vector(nbit-1 downto 0);
    op2     :	In	std_logic_vector(nbit-1 downto 0);
		Y       :	Out	std_logic_vector(nbit-1 downto 0));
end component nand_enabled_generic;

component nand4x1_generic is
generic (nbit : natural :=32);
	Port (
    op1     :	In	std_logic_vector(nbit-1 downto 0);
    op2     :	In	std_logic_vector(nbit-1 downto 0);
    op3     :	In	std_logic_vector(nbit-1 downto 0);
    op4     :	In	std_logic_vector(nbit-1 downto 0);
		Y       :	Out	std_logic_vector(nbit-1 downto 0));
end component nand4x1_generic;

signal L0, L1, L2, L3 : std_logic_vector(nbit-1 downto 0);
begin

nand0 : nand_enabled_generic
generic map(nbit)
	Port map(selectors(3), not_op1, not_op2, L0);
  
  nand_1 : nand_enabled_generic
generic map(nbit)
	Port map(selectors(2), not_op1, op2, L1);
  
  nand_2 : nand_enabled_generic
generic map(nbit)
	Port map(selectors(1), op1, not_op2, L2);
  
  nand_3 : nand_enabled_generic
generic map(nbit)
	Port map(selectors(0), op1, op2, L3);
  
  nand4x1 : nand4x1_generic
  generic map(nbit)
  port map(L0, L1, L2, L3, Y );

end struct;

configuration CFG_logical_T2_struct of logical_T2 is
	for struct
      for nand_1 : nand_enabled_generic
      use configuration work.CFG_nand_enabled_gen_Beh;
      end for;
      
      for nand_2 : nand_enabled_generic
      use configuration work.CFG_nand_enabled_gen_Beh;
      end for;
      
      for nand_3 : nand_enabled_generic
      use configuration work.CFG_nand_enabled_gen_Beh;
      end for;
      
      for nand4x1 : nand4x1_generic
      use configuration work.CFG_nand4x1_gen_struct;
      end for;
	end for;
end CFG_logical_T2_struct;






