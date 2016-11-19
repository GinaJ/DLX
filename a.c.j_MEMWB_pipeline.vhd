library IEEE;
use IEEE.std_logic_1164.all; 

entity MEMWB_pipeline is
generic (N    :  integer :=32);
Port (		
		CK            :		In	std_logic;
		RESET         :	In	std_logic;
    
    --ControlSignal
    WB_controls_in_MEMWB    : in std_logic; --Controls RegWrite
    
    --usefull values for WB stage
    DataFromMem_in_MEMWB    : in std_logic_vector(n-1 downto 0);
    RegDst_Addr_in_MEMWB    : in std_logic_vector(4 downto 0);
    
    --ControlSignal
    writeback    : out std_logic; --Controls RegWrite, MemToReg
    
    --usefull values for WB stage
    RegDst_Addr_out_MEMWB  : out std_logic_vector(4 downto 0);
    Data_to_RF  : out std_logic_vector(n-1 downto 0)
    );
		
end MEMWB_pipeline;
 
architecture Behavioral of MEMWB_pipeline is 

begin
          
	process(CK)
	begin
	  if CK'event and CK='1' then -- positive edge triggered:
	    if RESET='1' then -- active high reset 
          --ControlSignal
          Writeback    <= '0';
          
          --usefull values for WB stage
          Data_to_RF<= (others=>'0');
          RegDst_Addr_out_MEMWB  <= (others=>'0');
          
          elsif WB_controls_in_MEMWB='0' then --if you don't need to write into rf, set rDst to "00000"
          RegDst_Addr_out_MEMWB  <= (others=>'0');
          Writeback    <= WB_controls_in_MEMWB;
          Data_to_RF <= DataFromMem_in_MEMWB;
          
          else 
          --ControlSignal
          Writeback   <= WB_controls_in_MEMWB;
         
         --usefull values for WB stage
          Data_to_RF  <= DataFromMem_in_MEMWB;
          RegDst_Addr_out_MEMWB  <= RegDst_Addr_in_MEMWB;
      
	    end if;
    end if;
	end process;
end Behavioral;

configuration CFG_MEMWB_pipeline of MEMWB_pipeline is
	for Behavioral
	end for;
end CFG_MEMWB_pipeline;

