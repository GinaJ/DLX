
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity execute is
generic (n : integer :=32);
port (
      --from IDEX pipeline register
      OP1         : in std_logic_vector(n-1 downto 0);
      OP2         : in std_logic_vector(n-1 downto 0);
      offset_immed: in std_logic_vector(n-1 downto 0);
      
      regDst1     : in std_logic_vector(4 downto 0);
      regDst2     : in std_logic_vector(4 downto 0);
      Exe_controls: in std_logic_vector(8 downto 0);
      
      --from forwarding unit
      OP1_EXMEM   : in std_logic_vector(n-1 downto 0);
      OP1_MEMWB   : in std_logic_vector(n-1 downto 0);
      forwardA    : in std_logic_vector(1 downto 0);
      forwardB    : in std_logic_vector(1 downto 0);
      Forward_sw2 : in std_logic;
      
      Alu_Out     : out std_logic_vector(n-1 downto 0);
      regDst     : out std_logic_vector(4 downto 0);
      
      Reg2_value_to_store : out std_logic_vector(n-1 downto 0);
      Exception : out std_logic
      
      
      
);
end execute;

architecture Behavioral of execute is
component alu is
generic (n : integer :=32);
port (
  OP1         : in std_logic_vector(n-1 downto 0);
  OP2         : in std_logic_vector(n-1 downto 0);
  isSigned    : in std_logic;
  alu_opcode  : in std_logic_vector(5 downto 0);
  alu_out     : out std_logic_vector(n-1 downto 0);
  exception   : out std_logic
);
end component alu;

component MUX3_1_GENERIC is
	Generic (N: integer:= 32);
	Port (	
    A:	In	std_logic_vector(N-1 downto 0);
		B:	In	std_logic_vector(N-1 downto 0);
    C:  in  std_logic_vector(N-1 downto 0);
 		SEL:	In	std_logic_vector(1 downto 0);
		Y:	Out	std_logic_vector(N-1 downto 0));
	end component;
  
component MUX21_GENERIC is
	Generic (N: integer:= 8);
	Port (	
		A:		In	std_logic_vector(N-1 downto 0) ;
		B:		In	std_logic_vector(N-1 downto 0);
		SEL:	In	std_logic;
		Y:		Out	std_logic_vector(N-1 downto 0));
	end component;

signal input1_to_ALU, input2_to_ALU, input2_temp : std_logic_vector(n-1 downto 0);

begin

mux_forwardA : MUX3_1_GENERIC
        generic map (n)
        port map(op1, OP1_MEMWB, op1_EXMEM, forwardA, input1_to_ALU);
        
mux_forwardB : MUX3_1_GENERIC
        generic map (n)
        port map(op2, OP1_MEMWB, op1_EXMEM, forwardB, input2_temp);
        
mux_forward_sw : MUX21_GENERIC --forward the value from the second last instruction
        generic map (n)
        port map(op2, OP1_MEMWB, forward_sw2, Reg2_value_to_store);
        
mux_op2 : MUX21_GENERIC
        generic map(n)
        port map(input2_temp, offset_immed, EXE_Controls(0), input2_to_ALU);
        
mux_regDst : MUX21_GENERIC
            generic map(5)
            port map(regDst1, regDst2, EXE_Controls(7), regDst);
            
EXE_ALU : alu
          generic map(n)
          port map(input1_to_ALU, input2_to_ALU, Exe_controls(8), Exe_controls(6 downto 1), alu_out, Exception);

end Behavioral;


configuration CFG_EXECUTE of execute is
	for Behavioral
      
      for mux_forwardA : MUX3_1_GENERIC
      use configuration work.cfg_mux3_1_gen_behavioral;
      end for;
      
      for mux_forwardB : MUX3_1_GENERIC
      use configuration work.cfg_mux3_1_gen_behavioral;
      end for;
      
      for mux_forward_sw : MUX21_GENERIC
      use configuration work.cfg_mux21_gen_structural;
      end for;
      
      for mux_op2 : MUX21_GENERIC
      use configuration work.cfg_mux21_gen_structural;
      end for;
        
       for mux_regDst : MUX21_GENERIC
      use configuration work.cfg_mux21_gen_structural;
      end for;
      
      
        for EXE_ALU : alu
      use configuration work.CFG_ExecuteALU_struct;
      end for;
	end for;
end CFG_EXECUTE;