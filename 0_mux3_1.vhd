library IEEE;
use IEEE.std_logic_1164.all; 

entity MUX3_1_GENERIC is
	Generic (N: integer:= 32);
	Port (	
    A:	In	std_logic_vector(N-1 downto 0);
		B:	In	std_logic_vector(N-1 downto 0);
    C:  in  std_logic_vector(N-1 downto 0);
 		SEL:	In	std_logic_vector(1 downto 0);
		Y:	Out	std_logic_vector(N-1 downto 0));
	end entity;

architecture BEHAVIORAL of MUX3_1_Generic is
begin       
       process (a,b,c,sel)
        begin
          case SeL is
                when "00" => Y <= A;
                when "01" => Y <= B;
                when "10" => Y <= C;
                when others => Y<=(others =>'Z');
            end case;
        end process;

end BEHAVIORAL;

configuration CFG_MUX3_1_GEN_BEHAVIORAL of MUX3_1_GENERIC is
	for BEHAVIORAL
	end for;
end CFG_MUX3_1_GEN_BEHAVIORAL;