library IEEE;
use IEEE.std_logic_1164.all; 
use IEEE.numeric_std.all;

entity adderJump is
generic (Nbit : integer :=32);
Port (
    Reset: in std_logic;
		NextPC_IN_adder:	In	std_logic_vector(nbit-1 downto 0);
    offset_IN_adder:	In	std_logic_vector(nbit-1 downto 0);
		targetJump_out_adder:	Out	std_logic_vector(nbit-1 downto 0));
end adderJump;


architecture beh of adderJump is 
begin
  process (NextPC_IN_adder,offset_IN_adder)
  begin
  if reset='1' then
  targetJump_out_adder <=(others =>'Z');
    
    else                             
    targetJump_out_adder    <= std_logic_vector(to_unsigned(to_integer(unsigned(NextPC_IN_adder)) +
                                to_integer(signed(offset_IN_adder)), 32));
    end if;
  end process;
end beh;



configuration CFG_adderJump of adderJump is
	for Beh
	end for;
end CFG_adderJump;


