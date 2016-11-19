library IEEE;
use IEEE.std_logic_1164.all; 

entity EXMEM_pipeline is
generic (N    :  integer :=32);

Port (		
		CK            :		In	std_logic;
		RESET         :	In	std_logic;
    
    --ControlSignal
    WB_controls_in_EXMEM    : in std_logic_vector(1 downto 0); --Controls RegWrite, MemToReg
    MEM_controls_in_EXMEM    : in std_logic_vector(1 downto 0); --Controls  MemRead, MemWrite
    Forward_sw1 : in std_logic;
    
    
    --usefull values for MEM stage
    ALUres_MEMaddr_in_EXMEM  : in std_logic_vector(n-1 downto 0);
    DataToMem_in_EXMEM       : in std_logic_vector(n-1 downto 0);
    RegDst_Addr_in_EXMEM    : in std_logic_vector(4 downto 0);
    
    --ControlSignal
    WB_controls_out_EXMEM    : out std_logic_vector(1 downto 0); --Controls RegWrite, MemToReg
    MEM_controls_out_EXMEM    : out std_logic_vector(1 downto 0); --Controls  MemRead, MemWrite
    
    --usefull values for MEM stage
    ALUres_MEMaddr_out_EXMEM  : out std_logic_vector(n-1 downto 0);
    DataToMem_out_EXMEM  : out std_logic_vector(n-1 downto 0);
    RegDst_Addr_out_EXMEM  : out std_logic_vector(4 downto 0);
    Forward_sw1_mux : out std_logic
    );
		
end EXMEM_pipeline;


architecture Behavioral of EXMEM_pipeline is 

begin
  
	process(CK)
	begin
	  if CK'event and CK='1' then -- positive edge triggered:
	    if RESET='1' then -- active high reset 
          --ControlSignal
          WB_controls_out_EXMEM    <= (others=>'0');
          MEM_controls_out_EXMEM   <= (others=>'0');
          
          --usefull values for MEM stage
          ALUres_MEMaddr_out_EXMEM  <= (others=>'0');
          DataToMem_out_EXMEM  <= (others=>'0');
          RegDst_Addr_out_EXMEM  <= (others=>'0');
          Forward_sw1_mux <= '0';
	    else 
          --ControlSignal
          WB_controls_out_EXMEM    <= WB_controls_in_EXMEM;
          MEM_controls_out_EXMEM   <= MEM_controls_in_EXMEM;
          
          
          --usefull values for MEM stage
          ALUres_MEMaddr_out_EXMEM  <= ALUres_MEMaddr_in_EXMEM;
          DataToMem_out_EXMEM  <= DataToMem_in_EXMEM;
          RegDst_Addr_out_EXMEM  <= RegDst_Addr_in_EXMEM;
          Forward_sw1_mux <= Forward_sw1;
      
	    end if;
	  end if;
	end process;
end Behavioral;

configuration CFG_EXMEM_pipeline of EXMEM_pipeline is
	for Behavioral
	end for;
end CFG_EXMEM_pipeline;

