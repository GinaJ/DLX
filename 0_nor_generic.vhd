library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_misc.all;

entity nor_generic is
  generic (N : natural := 32);
  port(
    input   : in  std_logic_vector(N - 1 downto 0);
    Nor_out  : out std_logic
  );
end nor_generic;

architecture Behavioral of nor_generic is
begin
  Nor_out <= NOR_REDUCE(input);
end Behavioral;

configuration CFG_nor_generic_BEH of nor_generic is
	for Behavioral
	end for;
end CFG_nor_generic_BEH;