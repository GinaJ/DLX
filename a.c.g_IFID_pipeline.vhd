library IEEE;
use IEEE.std_logic_1164.all; 

entity IFID_pipeline is
generic (N    :  integer :=32);
Port (		
		CK            :		In	std_logic;
		RESET         :	In	std_logic;
    stall         : in std_logic;
    PC_in_IFID    : in std_logic_vector(n-1 downto 0);
    Instr_in_IFID : in std_logic_vector(n-1 downto 0);
    bubble        : in std_logic; --we jump, and we lose 1 cycle
		Jump_link : in std_logic;
     
    PC_out_IFID    : out std_logic_vector(n-1 downto 0);
    Instr_out_IFID : out std_logic_vector(n-1 downto 0)
    );
		
end IFID_pipeline;


architecture Behavioral of IFID_pipeline is 

begin 
	process(CK)
	begin
	  if CK'event and CK='1' then -- positive edge triggered:
    
	    if RESET='1' or (bubble='1' and Jump_link='0') then
      -- active high reset, or flush(bubble) 
      --we flush when we have a jump, and this jump is not Jump&link
      --(jump&Link will always execute the next instruction)
	      PC_out_IFID <= (others =>'0'); 
        Instr_out_IFID <= x"54000000";--nop instruction 
	    
      
      elsif Stall='0' then
       PC_out_IFID <= PC_in_IFID;
       Instr_out_IFID <= Instr_in_IFID;
      end if;
	  end if;
	end process;

end Behavioral;


configuration CFG_IFID_pipeline of IFID_pipeline is
	for Behavioral
	end for;
end CFG_IFID_pipeline;



