library IEEE;
use IEEE.std_logic_1164.all; 

entity nand_enabled_generic is
generic (nbit : natural :=32);
	Port (
    enable  :	In	std_logic;
    op1     :	In	std_logic_vector(nbit-1 downto 0);
    op2     :	In	std_logic_vector(nbit-1 downto 0);
		Y       :	Out	std_logic_vector(nbit-1 downto 0));
end nand_enabled_generic;


architecture beh of nand_enabled_generic is

begin
  process(enable, op1, op2)
  begin
	if enable='1' then y<=op1 nand op2;
  else y<=(others=>'1');
  end if;
  end process;
end beh;

configuration CFG_nand_enabled_gen_Beh of nand_enabled_generic is
	for beh
	end for;
end CFG_nand_enabled_gen_Beh;