library IEEE;
use IEEE.std_logic_1164.all; 
use IEEE.numeric_std.all;

entity accumulator is
generic (Nbit : integer :=32);
Port (
    Reset: in std_logic;
    Stall   : in std_logic;
		PC_IN_acc:	In	std_logic_vector(nbit-1 downto 0);
		PC_out_acc:	Out	std_logic_vector(nbit-1 downto 0));
end accumulator;


architecture beh of accumulator is 
begin
  process (PC_IN_acc, Reset, Stall)
  begin
    if reset='1' then
    PC_Out_acc <=X"00000004";
    elsif reset='Z' then
    PC_Out_acc <=(others=>'Z');
    elsif reset='0' and stall='0' then
    PC_Out_acc    <= std_logic_vector(to_unsigned(to_integer(unsigned(PC_In_acc)) +4, 32));
    elsif  reset='0' and stall='1' then PC_Out_acc  <= PC_In_acc;
    end if;
  end process;
end beh;



configuration CFG_accumulator of accumulator is
	for Beh
	end for;
end CFG_accumulator;


