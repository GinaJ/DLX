library IEEE;
use IEEE.std_logic_1164.all; 

entity Program_counter is
generic (Nbit : integer :=32);
Port (		
    CK:	In	std_logic;
		RESET:	In	std_logic;
    Stall: in std_logic;
		PC:	In	std_logic_vector(nbit-1 downto 0);
		PC_out:	Out	std_logic_vector(nbit-1 downto 0));
end Program_counter;


architecture beh of Program_counter is 
begin
  process (ck)
  begin
        if (reset='1' or reset='Z') then
        PC_out<=(others=>'Z');
        end if;
   if (ck='1' and ck'event and reset='0') then
        if (stall='0') then
        PC_out<=PC;
        end if;

   end if;
  end process;
end beh;



configuration CFG_ProgramCounter of Program_counter is
	for Beh
	end for;
end CFG_ProgramCounter;


