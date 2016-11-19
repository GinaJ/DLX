
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity alu is
generic (n : integer :=32);
port (
  OP1         : in std_logic_vector(n-1 downto 0);
  OP2         : in std_logic_vector(n-1 downto 0);
  isSigned    : in std_logic;
  alu_opcode  : in std_logic_vector(5 downto 0);
  alu_out     : out std_logic_vector(n-1 downto 0);
  exception   : out std_logic
);
end alu;

architecture Behavioral of alu is

component MUX1 is
	Port (	
		A:		In	std_logic;
		B:		In	std_logic;
		SEL:	In	std_logic;
		Y:		Out	std_logic);
	end component;
  
  
component not_generic is
generic (nbit : natural :=32);
	Port (	A:	In	std_logic_vector(nbit-1 downto 0);
		Y:	Out	std_logic_vector(nbit-1 downto 0));
end component not_generic; 

component nor_generic is
  generic (N : natural := 32);
  port(
    input   : in  std_logic_vector(N - 1 downto 0);
    Nor_out  : out std_logic
  );
end component nor_generic;

component logical_T2 is
generic (nbit : natural :=32);
	Port (
    selectors  :	In	std_logic_vector(3 downto 0);
    op1        :	In	std_logic_vector(nbit-1 downto 0);
    op2        :	In	std_logic_vector(nbit-1 downto 0);
    not_op1    :	In	std_logic_vector(nbit-1 downto 0);
    not_op2    :	In	std_logic_vector(nbit-1 downto 0);
		Y          :	Out	std_logic_vector(nbit-1 downto 0));
end component logical_T2;

component P4adder is 
	generic (N : 	natural := 32;
		 PowerN:natural := 5);
	Port (	A:	In	std_logic_vector(N-1 downto 0);
		B:	In	std_logic_vector(N-1 downto 0);
		Ci:	In	std_logic;
		S:	Out	std_logic_vector(N-1 downto 0);
    OverfSigned:	Out	std_logic;
		Overf:	Out	std_logic
		);
end component P4adder; 

component comparator_1output is
	Generic (N: integer:= 32 );
	Port (	
    overflow_signed: in std_logic;
    isSigned : in std_logic;
    zeros         : in std_logic;
		cout          :	In	std_logic;		
    sel_comp      : in std_logic_vector(2 downto 0); --tell me what comparison it wants
    result_comp   : out std_logic);
	end component;
  
  
component SHIFTER_GENERIC is
	generic(N: integer :=32);
	port(	A: in std_logic_vector(N-1 downto 0);
		B: in std_logic_vector(4 downto 0);--how much i should shift
		LOGIC_ARITH: in std_logic;	-- 1 = logic, 0 = arith
		LEFT_RIGHT: in std_logic;	-- 1 = left, 0 = right
		SHIFT_ROTATE: in std_logic;	-- 1 = shift, 0 = rotate
		OUTPUT: out std_logic_vector(N-1 downto 0)
	);

end component SHIFTER_GENERIC;

component MUX21_GENERIC is
	Generic (N: integer:= 8);
	Port (	A:	In	std_logic_vector(N-1 downto 0) ;
		B:	In	std_logic_vector(N-1 downto 0);
		SEL:	In	std_logic;
		Y:	Out	std_logic_vector(N-1 downto 0));
	end component;
  
  component MUX41_GENERIC is
	Generic (N: integer:= 8);
	Port (	
    A:	In	std_logic_vector(N-1 downto 0) ;
		B:	In	std_logic_vector(N-1 downto 0);
    C:	In	std_logic_vector(N-1 downto 0) ;
		D:	In	std_logic_vector(N-1 downto 0);
		SEL:	In	std_logic_vector(1 downto 0);
		Y:	Out	std_logic_vector(N-1 downto 0));
	end component;

signal not_op1, not_op2 : std_logic_vector(n-1 downto 0);
signal operand2_to_adder : std_logic_vector(n-1 downto 0);
signal logic_out, add_out, comp_out_ext, shift_out : std_logic_vector(n-1 downto 0);
signal cout, op1op2equal, comp_out : std_logic;
signal overflow_signed, RealOvf : std_logic;
signal zeros : std_logic_vector(n-2 downto 0) :=(others=>'0');
signal exceptionSigned, exceptionUnsigned : std_logic;
begin

neg_op1 : not_generic
          generic map(n)
          port map(op1, not_op1);
          
neg_op2 : not_generic
          generic map(n)
          port map(op2, not_op2);
          
logic_alu : logical_T2
            generic map(n)
            port map(alu_opcode(3 downto 0), op1, op2, not_op1, not_op2, logic_out);
          
select_op2 :  mux21_generic
              generic map(n)
              port map (op2, not_op2, alu_opcode(0), operand2_to_adder);
              
add_alu : P4adder
          generic map(n, 5)
          port map(op1, operand2_to_adder, alu_opcode(0), add_out, overflow_signed, cout);
    
          
mux_ovf :  mux1
             port map (cout, overflow_signed, isSigned, RealOvf);
              
              
op1_equal_op2 : nor_generic
                generic map(n)
                port map(add_out, op1op2equal);
                
alu_compare : comparator_1output
              generic map(n)
              port map(overflow_signed, isSigned, op1op2equal, cout, alu_opcode(3 downto 1), comp_out);
              
              comp_out_ext<= zeros & comp_out;
              
alu_shift : shifter_generic
            generic map(n)
            port map(op1, op2(4 downto 0), alu_opcode(2), alu_opcode(1), alu_opcode(0), shift_out);
            
select_out : MUX41_GENERIC
              generic map(n)
              port map(logic_out, add_out, comp_out_ext, shift_out, alu_opcode(5 downto 4), alu_out);
              

exception <= RealOvf and alu_opcode(4) and (not alu_opcode(5));

end Behavioral;

configuration CFG_ExecuteALU_struct of alu is
	for Behavioral
      for neg_op1 : not_generic
      use configuration work.cfg_not_gen_arch1;
      end for;
      
      for neg_op2 : not_generic
      use configuration work.cfg_not_gen_arch1;
      end for;
      
      for logic_alu : logical_T2
      use configuration work.CFG_logical_T2_struct;
      end for;
      
      for select_op2 :  mux21_generic
      use configuration work.cfg_mux21_gen_structural;
      end for;
      
      for mux_ovf :  mux1
      use configuration work.CFG_MUX21_STRUCTURAL;
      end for;
      
      for add_alu : P4adder
      use configuration work.cfg_p4adder_structural;
      end for;

      for op1_equal_op2 : nor_generic
      use configuration work.cfg_nor_generic_beh;
      end for;
      
      
      
      for alu_compare : comparator_1output
      use configuration work.CFG_COMP_1out_GEN_STRUCTURAL;
      end for;
      
      for alu_shift : shifter_generic
      use configuration work.CFG_Shifter_gen_BEH;
      end for;
      
      for select_out : MUX41_GENERIC
      use configuration work.cfg_mux41_gen_behavioral;
      end for;
	end for;
end CFG_ExecuteALU_struct;
