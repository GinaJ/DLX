library ieee;
use ieee.std_logic_1164.all;

package myTypes is

-- Control unit input sizes
    constant OP_CODE_SIZE : integer :=  6;       -- OPCODE field size
    constant FUNC_SIZE    : integer :=  11;      -- FUNC field size
    
    -------------------------------------------------------------------------------
    --
    --
    --    BASIC VERSION
    --
    --
    -------------------------------------------------------------------------------
    
   -- R-Type instruction -> OPCODE field
    constant RTYPE : std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=  "000000"; 
    constant add_func : std_logic_vector(FUNC_SIZE - 1 downto 0) :=  "00000100000"; 
    constant and_func :  std_logic_vector(FUNC_SIZE - 1 downto 0) :=  "00000100100";
    constant or_func : std_logic_vector(FUNC_SIZE - 1 downto 0) :=  "00000100101";  
    --set greater than or equal
    constant sge_func : std_logic_vector(FUNC_SIZE - 1 downto 0) :=  "00000101101";
    --set less than or equal
    constant sle_func : std_logic_vector(FUNC_SIZE - 1 downto 0) :=  "00000101100"; 
    --shift left logical
    constant sll_func : std_logic_vector(FUNC_SIZE - 1 downto 0) :=  "00000000100";
    --set not equal
    constant sne_func : std_logic_vector(FUNC_SIZE - 1 downto 0) :=  "00000101001"; 
    --shift right logical
    constant srl_func : std_logic_vector(FUNC_SIZE - 1 downto 0) :=  "00000000110"; 
    constant sub_func : std_logic_vector(FUNC_SIZE - 1 downto 0) :=  "00000100010";
    constant xor_func : std_logic_vector(FUNC_SIZE - 1 downto 0) :=  "00000100110";
    
    
    constant addi_op : std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=  "001000";     
    constant andi_op : std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=  "001100";
    constant beqz_op : std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=  "000100";  
    constant bnez_op : std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=  "000101";   
    constant j_op : std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=  "000010";
    constant jal_op : std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=  "000011";
    constant lw_op : std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=  "100011";
    constant nop_op : std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=  "010101"; 
    constant ori_op : std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=  "001101";  
    constant sgei_op : std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=  "011101"; 
    constant slei_op : std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=  "011100";  
    constant slli_op : std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=  "010100";
    constant snei_op : std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=  "011001"; 
    constant srli_op : std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=  "010110";
    constant subi_op : std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=  "001010"; 
    constant sw_op : std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=  "101011"; 
    constant xori_op : std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=  "001110"; 
    
    
    
    -------------------------------------------------------------------------------
    --
    --
    --    VERSION PRO
    --
    --
    -------------------------------------------------------------------------------
    constant addu_func : std_logic_vector(FUNC_SIZE - 1 downto 0) :=  "00000100001"; 
    constant seq_func : std_logic_vector(FUNC_SIZE - 1 downto 0) :=  "00000101000"; 
    constant sgeu_func : std_logic_vector(FUNC_SIZE - 1 downto 0) :=  "00000111101";
    constant sgt_func : std_logic_vector(FUNC_SIZE - 1 downto 0) :=  "00000101011"; 
    constant sgtu_func : std_logic_vector(FUNC_SIZE - 1 downto 0) :=  "00000111011"; 
    constant slt_func : std_logic_vector(FUNC_SIZE - 1 downto 0) :=  "00000101010"; 
    constant sltu_func : std_logic_vector(FUNC_SIZE - 1 downto 0) :=  "00000111010"; 
    constant sra_func : std_logic_vector(FUNC_SIZE - 1 downto 0) :=  "00000000111"; 
    constant subu_func : std_logic_vector(FUNC_SIZE - 1 downto 0) :=  "00000100011";    
    
    constant addui_op : std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=  "001001"; 
    constant jalr_op : std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=  "010011"; 
    constant jr_op : std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=  "010010"; 
    constant lb_op : std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=  "100000"; 
    constant lbu_op : std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=  "100100"; 
    constant lhi_op : std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=  "001111"; 
    constant lhu_op : std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=  "100101";
    constant sb_op : std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=  "101000";  
    constant seqi_op : std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=  "011000"; 
    constant sgeui_op : std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=  "111101"; 
    constant sgti_op : std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=  "011011"; 
    constant sgtui_op : std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=  "111011";   
    constant slti_op : std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=  "011010";
    constant sltui_op : std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=  "111010";   
    constant srai_op : std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=  "010111"; 
    constant subui_op : std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=  "001011"; 
    
    --FLOATING POINT
    constant mult_op : std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=  "001110";   
 
    
end myTypes;

