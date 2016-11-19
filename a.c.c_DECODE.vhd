library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity decode is
generic(n: integer := 32;
        nAddr : integer :=5);
port (
    
    ck : in std_logic;
    rst : in std_logic;
    
    --from reg_pipeline
    NextPC_in_decode:	in	std_logic_vector(n-1 downto 0);
		Instr_in_decode:	in	std_logic_vector(n-1 downto 0);
    
    --from reg_file, EXMEM pipeline, MEMWB pipeline.
    --Check the value to be used for Branch evaluated in decode
    Reg1_RF :	in	std_logic_vector(n-1 downto 0);
    Reg1_MEM :	in	std_logic_vector(n-1 downto 0);
    Reg1_WB :	in	std_logic_vector(n-1 downto 0);
    
    --From cu Forward
    ForwardC : in	std_logic_vector(1 downto 0);
    
    --from cu branch, to evaluate target branch
    --choose between offset[16,0] or offset (26,0) to add to nextPC 
    Jump_inst : in std_logic;
    
    --select regA or PC+4+offet as target 
    Jump_reg: in std_logic;
    
    --select if signed or unsigned
    isSigned: in std_logic;
    
    --For EXE stage
    --reg1_value_to_IDEX :	out	std_logic_vector(n-1 downto 0);
    --reg2_value_to_IDEX :	out	std_logic_vector(n-1 downto 0);
    offset_to_IDEX :	out	std_logic_vector(n-1 downto 0);
    
    --For forwarding, and for reading the values in RF
    reg1_Addr_from_decode :	out	std_logic_vector(nAddr-1 downto 0);
    reg2_Addr_from_decode :	out	std_logic_vector(nAddr-1 downto 0);
    
    
    --for mux regDst
    regDst1_addr_to_IDEX :	out	std_logic_vector(nAddr-1 downto 0);
    regDst2_addr_to_IDEX :	out	std_logic_vector(nAddr-1 downto 0);
    
   
    target_jump : out	std_logic_vector(n-1 downto 0);
    isZero : out std_logic
);
end decode;

architecture Behavioral of decode is

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
	Generic (N: integer:= 32);
	Port (	
		A:		In	std_logic_vector(N-1 downto 0) ;
		B:		In	std_logic_vector(N-1 downto 0);
		SEL:	In	std_logic;
		Y:		Out	std_logic_vector(N-1 downto 0));
	end component;
  
component sign_extend_26to32 is
Port (	
      immediate_offset : in std_logic_vector(25 downto 0);
      sign_extended   : out std_logic_vector(31 downto 0)
      );
end component sign_extend_26to32;
  
component extend_16to32 is
Port (	
      immediate_offset : in std_logic_vector(15 downto 0);
      isSigned: in std_logic;
      extended   : out std_logic_vector(31 downto 0)
      );
end component extend_16to32;

component compare_to_zero is
generic (Nbit : integer :=32);
Port (
		registerA     :	In	std_logic_vector(nbit-1 downto 0);
    equal_to_zero :	Out	std_logic);
end component compare_to_zero;

component adderJump is
generic (Nbit : integer :=32);
Port (
    Reset: in std_logic;
		NextPC_IN_adder:	In	std_logic_vector(nbit-1 downto 0);
    offset_IN_adder:	In	std_logic_vector(nbit-1 downto 0);
		targetJump_out_adder:	Out	std_logic_vector(nbit-1 downto 0));
end component adderJump;


  
  signal Reg1_check_beq : std_logic_vector(n-1 downto 0);
  signal offset_sign_ext : std_logic_vector(n-1 downto 0);
  signal offset_jump_sign_ext : std_logic_vector(n-1 downto 0);
  signal offset_to_jump_temp : std_logic_vector(n-1 downto 0);
  signal target_Jump_temp : std_logic_vector(n-1 downto 0);
  
begin
    reg1_Addr_from_decode <=Instr_in_decode(25 downto 21);
    reg2_Addr_from_decode <=Instr_in_decode(20 downto 16);
    
    
    --for mux regDst
    regDst1_addr_to_IDEX  <=Instr_in_decode(20 downto 16);
    regDst2_addr_to_IDEX  <=Instr_in_decode(15 downto 11);
    
    
    mux_value_R1 : MUX3_1_GENERIC
                   generic map (n)
                   port map( Reg1_RF, Reg1_WB, Reg1_MEM, ForwardC, Reg1_check_beq);
    
    sign_ext1 : extend_16to32
    port map (Instr_in_decode(15 downto 0), isSigned, offset_sign_ext);
    
    sign_ext2 : sign_extend_26to32
    port map (Instr_in_decode(25 downto 0), offset_jump_sign_ext);
    
    offset_to_IDEX <= offset_sign_ext;
    
    mux_offset_branch : MUX21_GENERIC
                      generic map (n)
                      port map(offset_sign_ext, offset_jump_sign_ext,
                      Jump_inst, offset_to_jump_temp
                      );
    
    
    evaluate_jump_target : adderJump
    generic map(n)
    port map(rst, NextPC_in_decode, offset_to_jump_temp, target_Jump_temp); --pc+ offset_(lower 16 or 26 bits)
    
    --if it is a Jump_reg, choose the register. else chose the target_jump_temp evaluated
    mux_target : MUX21_GENERIC
                      generic map (n)
                      port map(target_Jump_temp, Reg1_check_beq,
                      Jump_reg, target_Jump
                      );
 
    --check if regA is equal to Zero (used for beq and bnez instructions)
    check_beq : compare_to_zero
    generic map(n)
    port map(Reg1_check_beq,isZero);
    
end Behavioral;

configuration CFG_Decode of decode is
	for BEHavioral

      for sign_ext1 : extend_16to32
      use configuration WORK.CFG_extend_16to32_BEH;
      end for;
      
      for sign_ext2 : sign_extend_26to32
      use configuration WORK.CFG_sign_extend_26to32_BEH;
      end for;
      
      for evaluate_jump_target : adderJump
      use configuration WORK.CFG_adderJump;
      end for;
      
      for check_beq : compare_to_zero
      use configuration WORK.CFG_compare_to_zero;
      end for;
    
	end for;
end CFG_Decode;