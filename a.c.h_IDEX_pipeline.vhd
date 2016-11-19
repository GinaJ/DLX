library IEEE;
use IEEE.std_logic_1164.all; 

entity IDEX_pipeline is
generic (N    :  integer :=32);
Port (		
		CK            :		In	std_logic;
		RESET         :	In	std_logic;
    
    jump_link     : in std_logic;
    stall : in std_logic;
    
    
    --ControlSignal
    WB_controls_in_IDEX    : in std_logic_vector(1 downto 0); --Controls RegWrite, MemToReg
    MEM_controls_in_IDEX    : in std_logic_vector(1 downto 0); --Controls  MemRead, MemWrite
    EXE_controls_in_IDEX    : in std_logic_vector(8 downto 0); --Controls isSigned, RegDst, ALUop1, ALUop2, ALUSrc
    
    --usefull values for EXE stage
    Reg1_in_IDEX  : in std_logic_vector(n-1 downto 0);
    Reg2_in_IDEX  : in std_logic_vector(n-1 downto 0);
    Immediate_in_IDEX  : in std_logic_vector(n-1 downto 0);
    
    --usefull values for Forwarding
    Reg1_Addr_in_IDEX  : in std_logic_vector(4 downto 0);
    Reg2_Addr_in_IDEX  : in std_logic_vector(4 downto 0);
    
    --usefull values for WB stage
    RegDst_1_Addr_in_IDEX  : in std_logic_vector(4 downto 0);
    RegDst_2_Addr_in_IDEX  : in std_logic_vector(4 downto 0);
    
    --ControlSignal
    WB_controls_out_IDEX    : out std_logic_vector(1 downto 0); --Controls RegWrite, MemToReg
    MEM_controls_out_IDEX    : out std_logic_vector(1 downto 0); --Controls  MemRead, MemWrite
    EXE_controls_out_IDEX    : out std_logic_vector(8 downto 0); --Controls RegDst, ALUop1, ALUop2, ALUSrc
    
    --usefull values for Forwarding
    Reg1_Addr_out_IDEX  : out std_logic_vector(4 downto 0);
    Reg2_Addr_out_IDEX  : out std_logic_vector(4 downto 0);
    
    --usefull values for EXE stage
    Reg1_out_IDEX  : out std_logic_vector(n-1 downto 0);
    Reg2_out_IDEX  : out std_logic_vector(n-1 downto 0);
    Immediate_out_IDEX  : out std_logic_vector(n-1 downto 0);
    
    --usefull values for WB stage
    RegDst_1_Addr_out_IDEX  : out std_logic_vector(4 downto 0);
    RegDst_2_Addr_out_IDEX  : out std_logic_vector(4 downto 0)
    );
		
end IDEX_pipeline;


architecture Behavioral of IDEX_pipeline is 

begin


	process(CK)
	begin
	  if CK'event and CK='1' then -- positive edge triggered:
	    if RESET='1' or stall='1' then -- active high reset 
            --ControlSignal
              WB_controls_out_IDEX    <= (others=>'0');
              MEM_controls_out_IDEX   <= (others=>'0');
              EXE_controls_out_IDEX   <= (others=>'0');
              
              --usefull values for EXE stage
              Reg1_out_IDEX  <= (others=>'0');
              Reg2_out_IDEX  <= (others=>'0');
              Immediate_out_IDEX  <= (others=>'0');
              
              --usefull values for Forwarding
                Reg1_Addr_out_IDEX  <= (others=>'0');
                Reg2_Addr_out_IDEX   <= (others=>'0');
              
              --usefull values for WB stage
              RegDst_1_Addr_out_IDEX  <= (others=>'0');
              RegDst_2_Addr_out_IDEX  <= (others=>'0');
	    elsif (jump_link='0') then
          --ControlSignal
          WB_controls_out_IDEX    <= WB_controls_in_IDEX;
          MEM_controls_out_IDEX   <= MEM_controls_in_IDEX;
          EXE_controls_out_IDEX   <= EXE_controls_in_IDEX;
          
          --usefull values for EXE stage
          Reg1_out_IDEX  <= Reg1_in_IDEX;
          Reg2_out_IDEX  <= Reg2_in_IDEX;
          Immediate_out_IDEX  <= Immediate_in_IDEX;
          
          --usefull values for Forwarding
          Reg1_Addr_out_IDEX  <= Reg1_Addr_in_IDEX;
          Reg2_Addr_out_IDEX   <= Reg2_Addr_in_IDEX;
          
          --usefull values for WB stage          
          RegDst_1_Addr_out_IDEX  <= RegDst_1_Addr_in_IDEX;
          RegDst_2_Addr_out_IDEX  <= RegDst_2_Addr_in_IDEX;
          
      else --jump_link='1', we need to store pcnext+4 to Reg31
      --we add +8 to the PC of the Jump&link instruction

      
          --ControlSignal
          WB_controls_out_IDEX    <= WB_controls_in_IDEX;
          MEM_controls_out_IDEX   <= MEM_controls_in_IDEX;
          EXE_controls_out_IDEX   <= EXE_controls_in_IDEX;
          
          --usefull values for EXE stage
          Reg1_out_IDEX  <= Reg1_in_IDEX;
          Reg2_out_IDEX  <= x"00000004";
          Immediate_out_IDEX  <= x"00000004";
          
          --usefull values for Forwarding
          --no need to forward, jump link
          Reg1_Addr_out_IDEX  <= "00000";
          Reg2_Addr_out_IDEX   <= "00000";
          
          --usefull values for WB stage 
          --jump link, store the value on register 31
          RegDst_1_Addr_out_IDEX  <= "11111";
          RegDst_2_Addr_out_IDEX  <= "11111";
      
	    end if;
	  end if;
	end process;
end Behavioral;

configuration CFG_IDEX_pipeline of IDEX_pipeline is
	for Behavioral
	end for;
end CFG_IDEX_pipeline;