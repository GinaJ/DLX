library IEEE;
use IEEE.std_logic_1164.all; 
use IEEE.numeric_std.all;
use work.myTypes.all;

-- Control Unit
  entity dlx_cu is
  generic (
    ALU_OPC_SIZE       :     integer := 6  -- ALU Op Code Word Size
    );  
  port (
    Clk                : in  std_logic;  
    Rst                : in  std_logic;  -- Reset:Active-high
    opcode_in_cu       : in  std_logic_vector(5 downto 0);
    func_in_cu         : in  std_logic_vector(10 downto 0);
    
    --signals for branch unit
    jump            :out std_logic;
    jump_reg        :out std_logic;
    jump_link       :out std_logic;
    jump_branch     :out std_logic;
    bnez_notBeq     :out std_logic;
    
    --controls for decode stage
    Alu_src : out std_logic; --Second register or immediate
    Reg_dst : out std_logic; --the address of regDst in the instruction fetched is different when we have rtype or immediate
     
    --controls for execute stage 
    ALU_OPCODE         : out std_logic_vector(ALU_OPC_SIZE -1 downto 0);
    isSigned           : out  std_logic;
    
    --Control Signals for memory stage
    mem_read : out std_logic;
    mem_write : out std_logic;
 
    --Control signals for writeback stage
    Mem_to_reg             : out std_logic;  -- Data comes from memory or alu output
    Reg_write              : out std_logic);  -- Register File Write Enable

  end dlx_cu;
  
  architecture beh of dlx_cu is


begin
  process (rst, opcode_in_cu, func_in_cu, clk )
    begin
      if (rst='1' ) then 
      mem_read <='0';
      mem_write <='0';
      Mem_to_reg    <='0';
      Reg_write     <='0';
      jump <='0';
      jump_reg <='0';
      jump_link<='0';
      jump_branch <='0';
      bnez_notBeq<='0';
       isSigned<='0';
      elsif  (rst='Z') then 
      mem_read <='0';
      mem_write <='0';
      Mem_to_reg    <='0';
      Reg_write     <='0';
      jump <='0';
      jump_reg <='0';
      jump_link<='0';
      jump_branch <='0';
      bnez_notBeq<='0';
       isSigned<='0';
       else
      case opcode_in_cu is 
      
          when  RTYPE  => --R-Type
          Alu_src <='0';  --second operands is reg2
          Reg_dst <='1';  --rgDst comes from (bits 15:11)
          
          --no access in memory
          mem_read <='0';
          mem_write <='0';
          
          -- WB Control signals
          Mem_to_reg    <='0'; --data comes from ALU output
          Reg_write     <='1'; --write back in RF
          
          --No branch
          jump <='0';
          jump_reg <='0';
          jump_link<='0';
          jump_branch <='0';
          bnez_notBeq<='0';
              case func_in_cu is
              when add_func  => ALU_OPCODE <="010000";
                                isSigned<='1';
              when and_func  => ALU_OPCODE <="000001";
              when or_func   => ALU_OPCODE <="000111";
              when sge_func  => ALU_OPCODE <="101101";
                                isSigned<='1';
              when sle_func  => ALU_OPCODE <="100111";
                                isSigned<='1';
              when sll_func  => ALU_OPCODE <="110111"; --logic, left, shift 
              when sne_func  => ALU_OPCODE <="100001";
                                isSigned<='1';
              when srl_func  => ALU_OPCODE <="110101"; --logic, right, shift 
              when sub_func  => ALU_OPCODE <="010011";
                                isSigned<='1';
              when xor_func  => ALU_OPCODE <="000110";
              when addu_func => ALU_OPCODE <="010000";
                                isSigned<='0';
              when seq_func => ALU_OPCODE <="100101";
              when sgeu_func => ALU_OPCODE <="101101";
                                isSigned<='0';
              when sgt_func => ALU_OPCODE <="101001";
                                isSigned<='1';
              when sgtu_func => ALU_OPCODE <="101001";
                                isSigned<='0';
              when slt_func => ALU_OPCODE <="100011";
                                isSigned<='1';
              when sltu_func => ALU_OPCODE <="100011";
                                isSigned<='0';
              when sra_func => ALU_OPCODE <="110001";--arith,right,shift
              when subu_func => ALU_OPCODE <="010011";
                                isSigned<='0';
    
              --when we have a not recognised alu_opcode, do nothing, do not writeback
              --mem_write signal is already low.
              when others    => Reg_write  <='0'; 
                                ALU_OPCODE <="000001";            
              end case;
              
          
          when addi_op  => 
                Alu_src <='1';  --second operands is immediate
                Reg_dst <='0';  --rgDst comes from (bits 20:16)
                
                --no access in memory
                mem_read <='0';
                mem_write <='0';
                
                -- WB Control signals
                Mem_to_reg    <='0'; --data comes from alu
                Reg_write     <='1'; --write back in RF
                
                --EXE controls
                ALU_OPCODE <="010000";
                isSigned<='1';
                
                --Branch controls
                jump <='0';
                jump_reg <='0';
                jump_link<='0';
                jump_branch <='0';
                bnez_notBeq<='0';
                
          
          when addui_op  => 
                Alu_src <='1';  --second operands is immediate
                Reg_dst <='0';  --rgDst comes from (bits 20:16)
               
               --no access in memory
                mem_read <='0';
                mem_write <='0';

                -- WB Control signals
                Mem_to_reg    <='0'; --data comes from alu
                Reg_write     <='1'; --write back in RF

                --EXE controls
                ALU_OPCODE <="010000";
                isSigned<='0';
                
                --Branch controls
                jump <='0';
                jump_reg <='0';
                jump_link<='0';
                jump_branch <='0';
                bnez_notBeq<='0';
                
          when andi_op  =>  
                Alu_src <='1';  --second operands is immediate
                Reg_dst <='0';  --rgDst comes from (bits 20:16)
                
                --no access in memory
                mem_read <='0';
                mem_write <='0';
                
                -- WB Control signals
                Mem_to_reg    <='0'; --data comes from alu
                Reg_write     <='1'; --write back in RF
                
                --EXE controls
                ALU_OPCODE <="000001";
                
                --branch controls
                jump <='0';
                jump_reg <='0';
                jump_link<='0';
                jump_branch <='0';
                bnez_notBeq<='0';
          

          when beqz_op => 
              --ALU_OPCODE <="XXXXXX";
           --BEQZ, NO MATTER WHAT THE ALU IS DOING,
           --WE DO NOT ACCESS THE RF AND THE DATA MEMORY (IT'S LIKE DOING NOTHIG)
                --Alu_src <='X';  
                --Reg_dst <='X';  
                
                --no access in memory
                mem_read <='0';
                mem_write <='0';
                
                -- WB Control signals
                --Mem_to_reg    <='X';
                Reg_write     <='0'; --write back in RF
                
                --signals for branch unit, it's a beqz
                jump <='0';
                jump_reg <='0';
                jump_link<='0';
                jump_branch <='1';
                bnez_notBeq<='0'; --BEQZ
                
           when bnez_op  => 
              
              --ALU_OPCODE <="XXXXXX";
                --BNEZ NO MATTER WHAT THE ALU IS DOING,
                --WE DO NOT ACCESS THE RF AND THE DATA MEMORY (IT'S LIKE DOING NOTHIG)
                --Alu_src <='X';  
                --Reg_dst <='X';  
                
                --no access in memory
                mem_read <='0';
                mem_write <='0';
                
                -- WB Control signals
                --Mem_to_reg    <='X';
                Reg_write     <='0'; --write back in RF
                
                --signals for branch unit, it's a bnez
                jump <='0';
                jump_reg <='0';
                jump_link<='0';
                jump_branch <='1';
                bnez_notBeq<='1'; --BNEZ
           
           when j_op  => 
           --JUMP, NO MATTER WHAT THE ALU IS DOING,
           --WE DO NOT ACCESS THE RF AND THE DATA MEMORY (IT'S LIKE DOING NOTHIG)
                --Alu_src <='X';  
                --Reg_dst <='X';  
                --ALU_OPCODE <="XXXXXX";
                
                --no access in memory
                mem_read <='0';
                mem_write <='0';
                
                -- WB Control signals
                --Mem_to_reg    <='X';
                Reg_write     <='0'; --write back in RF
                
                --signals for branch unit, it's a jump
                jump <='1';
                jump_reg <='0';
                jump_link<='0';
                jump_branch <='0';
                bnez_notBeq<='0'; 
                
                
                
                
 when jal_op  => 
               --We need to store pc+8
               --we have to do an addition
               ALU_OPCODE <="010000";
               Alu_src <='0';  --second operands is reg2, and it's value will be 4
                               --and first operand is pc+4
                               --the result of the ALU will be pc+8
                
                --no access in memory
                mem_read <='0';
                mem_write <='0';
                
                -- WB Control signals
                Mem_to_reg    <='0'; --data comes from alu
                Reg_write     <='1'; --write back in RF
                
                --signals for branch unit
                jump <='1';
                jump_reg <='0';
                jump_link<='1';
                jump_branch <='0';
                bnez_notBeq<='0'; 
          
           when jalr_op  => 
               --We need to store pc+8
               --we have to do an addition
               ALU_OPCODE <="010000";
               Alu_src <='0';  --second operands is reg2, and it's value will be 4
                               --and first operand is pc+4
                               --the result of the ALU will be pc+8
                
                --no access in memory
                mem_read <='0';
                mem_write <='0';
                
                -- WB Control signals
                Mem_to_reg    <='0'; --data comes from alu
                Reg_write     <='1'; --write back in RF
                
                --signals for branch unit
                jump <='1';
                jump_reg <='1';
                jump_link<='1';
                jump_branch <='0';
                bnez_notBeq<='0';
          
          when jr_op  => 
                --JUMP REGISTER, NO MATTER WHAT THE ALU IS DOING,
                --WE DO NOT ACCESS THE RF AND THE DATA MEMORY (IT'S LIKE DOING NOTHIG)
                --ALU_OPCODE <="XXXXXX";
                --Alu_src <='X';  
                --Reg_dst <='X';  
                
                --no access in memory
                mem_read <='0';
                mem_write <='0';
                
                -- WB Control signals
                --Mem_to_reg    <='X'; 
                Reg_write     <='0'; --write back in RF
                
                --signals for branch unit
                jump <='1';
                jump_reg <='1';
                jump_link<='0';
                jump_branch <='0';
                bnez_notBeq<='0'; 
          
          when lw_op  => 
                Alu_src <='1';  --second operands is immediate
                Reg_dst <='0';  --rgDst comes from (bits 20:16)
                
                -- access in memory, read
                mem_read <='1';
                mem_write <='0';
                
                -- WB Control signals
                Mem_to_reg    <='1'; --data comes from memory
                Reg_write     <='1'; --write back in RF
                
                --EXE signals
                ALU_OPCODE <="010000"; --addition
                isSigned<='1';
                
                --signals for branch unit
                jump <='0';
                jump_reg <='0';
                jump_link<='0';
                jump_branch <='0';
                bnez_notBeq<='0';
                
                
          when nop_op  => -- do nothing, everithing is set to zero
                ALU_OPCODE <="000000"; 
                jump <='0';
                jump_branch <='0';
                bnez_notBeq<='0';
                mem_read <='0';
                mem_write <='0';
                Reg_write     <='0';
                jump <='0';
                jump_reg <='0';
                jump_link<='0';
                jump_branch <='0';
                bnez_notBeq<='0';
    
          when ori_op   => 
                Alu_src <='1';  --second operands is immediate
                Reg_dst <='0';  --rgDst comes from (bits 20:16)
                
                --no access in memory
                mem_read <='0';
                mem_write <='0';
                
                -- WB Control signals
                Mem_to_reg    <='0'; --data comes from alu
                Reg_write     <='1'; --write back in RF
                
                --EXE controls
                ALU_OPCODE <="000111";
                
                --signals for branch unit
                jump <='0';
                jump_reg <='0';
                jump_link<='0';
                jump_branch <='0';
                bnez_notBeq<='0';
                 
          when seqi_op =>
                 
                Alu_src <='1';  --second operands is immediate
                Reg_dst <='0';  --rgDst comes from (bits 20:16)
                
                --no access in memory
                mem_read <='0';
                mem_write <='0';
                
                -- WB Control signals
                Mem_to_reg    <='0'; --data comes from alu
                Reg_write     <='1'; --write back in RF
                
                --EXE controls
                ALU_OPCODE <="100101";
                isSigned<='1';
                
                --signals for branch
                jump <='0';
                jump_reg <='0';
                jump_link<='0';
                jump_branch <='0';
                bnez_notBeq<='0';
                
          when sgei_op  =>  
                Alu_src <='1';  --second operands is immediate
                Reg_dst <='0';  --rgDst comes from (bits 20:16)
                
                --no access in memory
                mem_read <='0';
                mem_write <='0';
                
                -- WB Control signals
                Mem_to_reg    <='0'; --data comes from alu
                Reg_write     <='1'; --write back in RF
                
                --EXE controls
                ALU_OPCODE <="101101";
                isSigned<='1';
                
                --signals for branch unit
                jump <='0';
                jump_reg <='0';
                jump_link<='0';
                jump_branch <='0';
                bnez_notBeq<='0';
                
                
          when sgeui_op  =>  
                Alu_src <='1';  --second operands is immediate
                Reg_dst <='0';  --rgDst comes from (bits 20:16)
                
                --no access in memory
                mem_read <='0';
                mem_write <='0';
                
                -- WB Control signals
                Mem_to_reg    <='0'; --data comes from alu
                Reg_write     <='1'; --write back in RF
                
                --EXE controls
                ALU_OPCODE <="101101";
                isSigned<='0';
                
                --signals for branch unit
                jump <='0';
                jump_reg <='0';
                jump_link<='0';
                jump_branch <='0';
                bnez_notBeq<='0';
                
          when slei_op  => 
                Alu_src <='1';  --second operands is immediate
                Reg_dst <='0';  --rgDst comes from (bits 20:16)
                
                --no access in memory
                mem_read <='0';
                mem_write <='0';
                
                -- WB Control signals
                Mem_to_reg    <='0'; --data comes from alu
                Reg_write     <='1'; --write back in RF
                
                --EXE controls
                ALU_OPCODE <="100111";
                isSigned<='1';
                
                --signals for branch unit
                jump <='0';
                jump_reg <='0';
                jump_link<='0';
                jump_branch <='0';
                bnez_notBeq<='0';
                
                
          when sgti_op =>
                
                Alu_src <='1';  --second operands is immediate
                Reg_dst <='0';  --rgDst comes from (bits 20:16)
                
                --no access in memory
                mem_read <='0';
                mem_write <='0';
                
                -- WB Control signals
                Mem_to_reg    <='0'; --data comes from alu
                Reg_write     <='1'; --write back in RF
                
                --EXE controls
                ALU_OPCODE<="101001";
                isSigned<='1';
                
                --signals for branch unit
                jump <='0';
                jump_reg <='0';
                jump_link<='0';
                jump_branch <='0';
                bnez_notBeq<='0';
                
                
          when sgtui_op =>
                Alu_src <='1';  --second operands is immediate
                Reg_dst <='0';  --rgDst comes from (bits 20:16)
                
                --no access in memory
                mem_read <='0';
                mem_write <='0';
                
                -- WB Control signals
                Mem_to_reg    <='0'; --data comes from alu
                Reg_write     <='1'; --write back in RF
                
                --exe controls
                ALU_OPCODE<="101001";
                isSigned<='0';
                
                --signals for branch unit
                jump <='0';
                jump_reg <='0';
                jump_link<='0';
                jump_branch <='0';
                bnez_notBeq<='0';
                
                
                
          when slti_op =>
                Alu_src <='1';  --second operands is immediate
                Reg_dst <='0';  --rgDst comes from (bits 20:16)
                
                --no access in memory
                mem_read <='0';
                mem_write <='0';
                
                -- WB Control signals
                Mem_to_reg    <='0'; --data comes from alu
                Reg_write     <='1'; --write back in RF
                
                --exe controls
                ALU_OPCODE<="100011";
                isSigned<='1';
                
                --signals for branch unit
                jump <='0';
                jump_reg <='0';
                jump_link<='0';
                jump_branch <='0';
                bnez_notBeq<='0';
                
                
          when sltui_op =>
                
                Alu_src <='1';  --second operands is immediate
                Reg_dst <='0';  --rgDst comes from (bits 20:16)
                
                --no access in memory
                mem_read <='0';
                mem_write <='0';
                
                -- WB Control signals
                Mem_to_reg    <='0'; --data comes from alu
                Reg_write     <='1'; --write back in RF
                
                --EXE controls
                ALU_OPCODE<="100011";
                isSigned<='0';
                
                --signals for branch unit
                jump <='0';
                jump_reg <='0';
                jump_link<='0';
                jump_branch <='0';
                bnez_notBeq<='0';
                
                
          when slli_op  => 
                Alu_src <='1';  --second operands is immediate
                Reg_dst <='0';  --rgDst comes from (bits 20:16)
                
                --no access in memory
                mem_read <='0';
                mem_write <='0';
                
                -- WB Control signals
                Mem_to_reg    <='0'; --data comes from alu
                Reg_write     <='1'; --write back in RF
                
                --exe controls
                ALU_OPCODE <="110111"; --logical,left,shift
                
                --signals for branch unit
                jump <='0';
                jump_reg <='0';
                jump_link<='0';
                jump_branch <='0';
                bnez_notBeq<='0';
                
          when snei_op  =>  
                Alu_src <='1';  --second operands is immediate
                Reg_dst <='0';  --rgDst comes from (bits 20:16)
                
                --no access in memory
                mem_read <='0';
                mem_write <='0';
                
                -- WB Control signals
                Mem_to_reg    <='0'; --data comes from alu
                Reg_write     <='1'; --write back in RF
                
                --exe controls
                ALU_OPCODE <="100001";
                isSigned<='1';
                
                --signals for branch unit
                jump <='0';
                jump_reg <='0';
                jump_link<='0';
                jump_branch <='0';
                bnez_notBeq<='0';
                
                
                
          when  srai_op  => 
                Alu_src <='1';  --second operands is immediate
                Reg_dst <='0';  --rgDst comes from (bits 20:16)
                
                --no access in memory
                mem_read <='0';
                mem_write <='0';
                
                -- WB Control signals
                Mem_to_reg    <='0'; --data comes from alu
                Reg_write     <='1'; --write back in RF
                
                --exe controls
                ALU_OPCODE <="110001"; --arith,right, shift
                
                --signals for branch unit
                jump <='0';
                jump_reg <='0';
                jump_link<='0';
                jump_branch <='0';
                bnez_notBeq<='0';
                
          when srli_op  => 
                Alu_src <='1';  --second operands is immediate
                Reg_dst <='0';  --rgDst comes from (bits 20:16)
                
                --no access in memory
                mem_read <='0';
                mem_write <='0';
                
                -- WB Control signals
                Mem_to_reg    <='0'; --data comes from alu
                Reg_write     <='1'; --write back in RF
                
                --exe controls
                ALU_OPCODE <="110101"; --logical,right,shift
                
                --signals for branch unit
                jump <='0';
                jump_reg <='0';
                jump_link<='0';
                jump_branch <='0';
                bnez_notBeq<='0';
                
          when subi_op  =>  
                Alu_src <='1';  --second operands is immediate
                Reg_dst <='0';  --rgDst comes from (bits 20:16)
                
                --no access in memory
                mem_read <='0';
                mem_write <='0';
                
                -- WB Control signals
                Mem_to_reg    <='0'; --data comes from alu
                Reg_write     <='1'; --write back in RF
                
                --exe controls
                ALU_OPCODE <="010011";
                isSigned<='1';
                
                --signals for branch unit
                jump <='0';
                jump_reg <='0';
                jump_link<='0';
                jump_branch <='0';
                bnez_notBeq<='0';

                
          when subui_op  =>  
                Alu_src <='1';  --second operands is immediate
                Reg_dst <='0';  --rgDst comes from (bits 20:16)
                
                --no access in memory
                mem_read <='0';
                mem_write <='0';
                
                -- WB Control signals
                Mem_to_reg    <='0'; --data comes from alu
                Reg_write     <='1'; --write back in RF
                
                --exe controls
                ALU_OPCODE <="010011";
                isSigned<='0';
                
                --signals for branch unit
                jump <='0';
                jump_reg <='0';
                jump_link<='0';
                jump_branch <='0';
                bnez_notBeq<='0';
                
                
          when sw_op    => 
                Alu_src <='1';  --second operands is immediate
                -- Reg_dst <='0';  --no matter, don't write back
                
                -- access in memory, write
                mem_read <='0';
                mem_write <='1';
                
                -- WB Control signals
                --Mem_to_reg    <='1'; ----no matter, don't write back
                Reg_write     <='0'; --write back in RF
                
                --exe controls
                ALU_OPCODE <="010000"; --addition
                isSigned<='1';
         
                --signals for branch unit
                jump <='0';
                jump_reg <='0';
                jump_link<='0';
                jump_branch <='0';
                bnez_notBeq<='0';
                
          
          when xori_op  =>  
                Alu_src <='1';  --second operands is immediate
                Reg_dst <='0';  --rgDst comes from (bits 20:16)
                
                --no access in memory
                mem_read <='0';
                mem_write <='0';
                
                -- WB Control signals
                Mem_to_reg    <='0'; --data comes from alu
                Reg_write     <='1'; --write back in RF
                
                --exe controls
                ALU_OPCODE <="000110";
                
                --signals for branch unit
                jump <='0';
                jump_reg <='0';
                jump_link<='0';
                jump_branch <='0';
                bnez_notBeq<='0';
                
          when others =>
                Reg_write     <='0';
                mem_read <='0';
                mem_write <='0';
                jump <='0';
                jump_reg <='0';
                jump_link<='0';
                jump_branch <='0';
                bnez_notBeq<='0';
                ALU_OPCODE <="000000";
          
          end case;
      end if;
    end process;

    
end beh;



configuration CFG_dlx_cu_basic of dlx_cu is
	for Beh
	end for;
end CFG_dlx_cu_basic;
