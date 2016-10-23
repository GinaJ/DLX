library IEEE;
use IEEE.std_logic_1164.all;

entity MUX41_GENERIC is
	Generic (N: integer:= 8);
	Port (	
    A:	In	std_logic_vector(N-1 downto 0) ;
		B:	In	std_logic_vector(N-1 downto 0);
    C:	In	std_logic_vector(N-1 downto 0) ;
		D:	In	std_logic_vector(N-1 downto 0);
   SEL:	In	std_logic_vector(1 downto 0);
		Y:	Out	std_logic_vector(N-1 downto 0));
	end entity;



architecture BEHAVIORAL of MUX41_Generic is

begin 
process (a,b,c,d,sel)
begin
  case SeL is
        when "00" => Y <= A;
        when "01" => Y <= B;
        when "10" => Y <= C;
        when "11" => Y <= D;
        when others => Y<=(others =>'Z');
    end case;
end process;
end BEHAVIORAL;

configuration CFG_MUX41_GEN_BEHAVIORAL of MUX41_GENERIC is
	for BEHAVIORAL
	end for;
end CFG_MUX41_GEN_BEHAVIORAL;