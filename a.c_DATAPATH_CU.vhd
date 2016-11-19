library ieee;
use ieee.std_logic_1164.all;

entity Datapath_CU is
  generic (
    FUNC_SIZE          :     integer := 11;  -- Func Field Size for R-Type Ops
    OP_CODE_SIZE       :     integer := 6;  -- Op Code Size
    ALU_OPC_SIZE       :     integer := 6;  -- ALU Op Code Size
    n     : integer := 32;
    nAddr : integer := 5);
  port (
    Clk : in std_logic;
    Rst : in std_logic;
    
    
    --input from IRAM and DRAM
    instr_fetched : in std_logic_vector(n-1 downto 0);
    data_from_dram : in std_logic_vector(n-1 downto 0);
    
    exception : out std_logic;
    
    
    --output to IRAM and dram
    addr_to_iram  :out std_logic_vector(n-1 downto 0);
    
    data_to_dram : out std_logic_vector(n-1 downto 0);
    req_to_dram : out std_logic;
    read_notWrite : out std_logic;
    addr_to_dataRam : out std_logic_vector(n-1 downto 0)
    );
end Datapath_CU;

architecture struct of Datapath_CU is

component FETCH is
generic (
    N : integer :=32);
Port (
    --FROM TOP-LEVEL DLX
    CK:	In	std_logic;
		RESET:	In	std_logic;
    
    --FROM HAZARD_UNIT
    Stall: in std_logic;
    
    --From decode stage
    target_jump : in std_logic_vector(n-1 downto 0);
    
    --from execute
    mux_pc : in std_logic;
        
    --output to instr_mem
    PC_from_FETCH_to_iram : out std_logic_vector(n-1 downto 0);
    
		
    --output to IFID pipeline register
		PC_out_to_IFID:	Out	std_logic_vector(n-1 downto 0));
		
end component;

component decode is
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
    --Reg1_check_beq:	in	std_logic_vector(n-1 downto 0);
    Reg1_RF :	in	std_logic_vector(n-1 downto 0);
    Reg1_MEM :	in	std_logic_vector(n-1 downto 0);
    Reg1_WB :	in	std_logic_vector(n-1 downto 0);
    
    --From cu Forward
    ForwardC : in	std_logic_vector(1 downto 0);
    
    --from cu branch, to evaluate target branch
    --choose between offset[16,0] or offset (26,0) to add to nextPC 
    Jump_inst : in std_logic;
    
    --select regA or PC+4+offser as target 
    Jump_reg: in std_logic;
    
    --isSigned signal
    isSigned: in std_logic;
    
    --For EXE stage
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
end component decode;

component IFID_pipeline is
generic (N    :  integer :=32);
Port (		
		CK            :		In	std_logic;
		RESET         :	In	std_logic;
    stall         : in std_logic;
    PC_in_IFID    : in std_logic_vector(n-1 downto 0);
    Instr_in_IFID : in std_logic_vector(n-1 downto 0);
    bubble        : in std_logic;
    Jump_link : in std_logic;
		
    PC_out_IFID    : out std_logic_vector(n-1 downto 0);
    Instr_out_IFID : out std_logic_vector(n-1 downto 0)
    );
		
end component IFID_pipeline;

component IDEX_pipeline is
generic (N    :  integer :=32);
Port (		
		CK            :		In	std_logic;
		RESET         :	In	std_logic;
    
    jump_link     : in std_logic;
    stall : in std_logic;
    
    --ControlSignal
    WB_controls_in_IDEX    : in std_logic_vector(1 downto 0); --Controls RegWrite, MemToReg
    MEM_controls_in_IDEX    : in std_logic_vector(1 downto 0); --Controls  MemRead, MemWrite
    EXE_controls_in_IDEX    : in std_logic_vector(8 downto 0); --Controls RegDst, ALUop1, ALUop2, ALUSrc
    
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
		
end component IDEX_pipeline;


component execute is
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
end component execute;

component EXMEM_pipeline is
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
		
end component EXMEM_pipeline;

component Memory_stage is
  generic (n : integer :=32);
  port ( 
  data_from_dram : in std_logic_vector(n-1 downto 0);
  data_to_dram_temp : in std_logic_vector(n-1 downto 0); --after execute stage
  data_to_RF_from_WB   : in std_logic_vector(n-1 downto 0); --from writeback stage
  Forward_sw1_mux : in std_logic;
  load : in std_logic;
  Addr_alu      : in std_logic_vector(n-1 downto 0);
  mem_controls  : in std_logic_vector(1 downto 0);
  
  req           : out std_logic;
  read_notWrite : out std_logic;
  Addr_to_Dram  : out std_logic_vector(n-1 downto 0);
  data_to_dram  : out std_logic_vector(n-1 downto 0);
  data_to_mem_wb: out std_logic_vector(n-1 downto 0)
  );
end component memory_stage;


component MEMWB_pipeline is
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
		
end component MEMWB_pipeline;
  
-- Control Unit
component  dlx_cu is
  generic (
    ALU_OPC_SIZE       :     integer := 6  -- ALU Op Code Word Size
    );  
  port (
    Clk                : in  std_logic;  -- Clock
    Rst                : in  std_logic;  -- Reset:Active-high
    
    --from 32bits instruction
    opcode_in_cu       : in  std_logic_vector(5 downto 0);
    func_in_cu       : in  std_logic_vector(10 downto 0);
    
    --control for btanch
    jump            :out std_logic;
    jump_reg        :out std_logic;
    jump_link       :out std_logic;
    jump_branch     : out std_logic;
    bnez_notBeq     :out std_logic;
    Alu_src : out std_logic; --registerB or immediate
    Reg_dst : out std_logic; --the address of regDst in the instruction fetched is different when rtype or immediate
     
    ALU_OPCODE         : out std_logic_vector(ALU_OPC_SIZE -1 downto 0);
    isSigned : out std_logic;
    mem_read : out std_logic;
    mem_write : out std_logic;
 
 
    -- WB Control signals
    Mem_to_reg             : out std_logic;  -- Write Back MUX Sel, from memory or al output
    Reg_write              : out std_logic);  -- Register File Write Enable

  end component dlx_cu;
  
component Forward_unit is
port (
      --reg1 from FETCH, from IFID pipeline. Need this value to forward in case of branch/Jump
      reg1_add_Branch_Decode : in std_logic_vector(4 downto 0); 
      
      --input from decode stage, coming from the IDEX pipeline register
			reg1_add: in std_logic_vector(4 downto 0); 
			reg2_add: in std_logic_vector(4 downto 0);
      sw_inst: in std_logic;
      
      --input from EXEcute stage
      regEXE_wb : in std_logic; --Control signal: it tells us if this instruction has to write back
			regEXE_add: in std_logic_vector(4 downto 0); --rd register from the EXE_MEM pipeline
			
      --input from Memory stage
      regMEM_wb : in std_logic; --Control signal: it tells us if this instruction has to write back
			regMEM_add: in std_logic_vector(4 downto 0);  --rd register from the MEM-WB pipeline
      
      --output to MUX
			ForwardA: out std_logic_vector(1 downto 0);
			ForwardB: out std_logic_vector(1 downto 0);
      ForwardC: out std_logic_vector(1 downto 0);
      Forward_sw1: out std_logic;
      Forward_sw2: out std_logic
);
end component Forward_unit;

component hazard_detecion is
port (
      --input from if/id pipeline
			reg1_add: in std_logic_vector(4 downto 0); 
			reg2_add: in std_logic_vector(4 downto 0);
      sw_instr: in std_logic;
      
      --input from id/exe pipeline
      reg_dest : in std_logic_vector(4 downto 0);--reg destination of previous instruction
			jump : in std_logic; --when in decode the instruction is jump
      Branch : in std_logic; --when in decode, the instruction is a branch
      memRead : in std_logic; --control signal, previous instruction has to read from memory
			writeReg : in std_logic; --the value has to be written in regDst
      
       --input from exe/mem pipeline -->of the previous (x2) instruction
      reg_dest2 : in std_logic_vector(4 downto 0);--reg destination of previous(x2) instruction
      memRead2 : in std_logic; --control signal, previous instruction has to read from memory
			writeReg2 : in std_logic; --the value has to be written in regDst
      
      --output
      stall : out std_logic
      
);
end component hazard_detecion;

component Register_File is
  generic(n : integer :=32);
  Port ( 
  
    -- From control/DLX
    Ck     : in  std_logic;
    Reset     : in  std_logic;
    
    -- From Decode Unit
    Rs_Addr   : in  std_logic_vector ( 4 downto 0);
    Rt_Addr   : in  std_logic_vector ( 4 downto 0);
    
    --to IDEXE pipeline register
    Rs_Data   : out std_logic_vector (n-1 downto 0);
    Rt_Data   : out std_logic_vector (n-1 downto 0);


    -- From/To WriteBack Unit
    Rd_Addr   : in  std_logic_vector ( 4 downto 0);
    Rd_Data   : in  std_logic_vector (n-1 downto 0);
    Req_Write : in  std_logic
  );
end component Register_File;

component MUX21_GENERIC is
	Generic (N: integer:= 32);
	Port (	
		A:		In	std_logic_vector(N-1 downto 0) ;
		B:		In	std_logic_vector(N-1 downto 0);
		SEL:	In	std_logic;
		Y:		Out	std_logic_vector(N-1 downto 0));
	end component;

component  cu_branch is
generic (n : integer := 32);
port (
    jump_instr  : in std_logic;
    branch_instr: in std_logic;
    bnez_notBeq : in std_logic;
    isZero      : in std_logic;
    stall       : in std_logic;
    
    jump        : out std_logic
 ); 
end component cu_branch; 


signal stall : std_logic;
signal isZero : std_logic; --to CU_branch
signal jump_CU_FET : std_logic; --from CU_branch


--from cu branch to fetch stage
signal target_nextPC :  std_logic_vector(n-1 downto 0);

signal nextPC_FETCH_IFID  :  std_logic_vector(n-1 downto 0);

--signal fetch decode
signal nextPC_IFID_DEC :  std_logic_vector(n-1 downto 0);
signal inst_IFID_DEC :std_logic_vector(n-1 downto 0);
signal reg1_from_RF, reg2_from_RF :std_logic_vector(n-1 downto 0);

--signal decode execute
signal reg1_Addr_from_decode, reg2_Addr_from_decode :std_logic_vector(nAddr-1 downto 0);
signal regDst1_addr_to_IDEX, regDst2_addr_to_IDEX   :std_logic_vector(nAddr-1 downto 0);
signal offset_to_IDEX : std_logic_vector(n-1 downto 0);
signal WB_controls_in_IDEX, WB_controls_in_EXMEM, WB_controls_in_MEMWB : std_logic_vector(1 downto 0);
signal MEM_controls_in_IDEX, MEM_controls_in_EXMEM : std_logic_vector(1 downto 0); 
signal EXE_controls_in_IDEX, EXE_controls_in_EXEcute : std_logic_vector(8 downto 0);


signal reg1_from_mux_rega_pcnex : std_logic_vector(n-1 downto 0);



--signal IDEX- EXE
signal Reg1_Addr_to_exe, Reg2_Addr_to_exe : std_logic_vector(nAddr-1 downto 0);
signal Reg1_Value_to_exe, Reg2_value_to_exe, Reg2_value_to_store : std_logic_vector(n-1 downto 0);

--used for mux regA and pcNext when we have jumpLink
signal Reg1_Value_to_exe_temp  : std_logic_vector(n-1 downto 0);

signal immediate_to_exe  : std_logic_vector(n-1 downto 0);
signal regDst1_addr_to_exe, regDst2_addr_to_exe   :std_logic_vector(nAddr-1 downto 0);

--from exe to exmem
signal Alu_Out_Addr_to_exmem : std_logic_vector(n-1 downto 0);
signal regDst_to_exmem : std_logic_vector(nAddr-1 downto 0);
--Reg2_value_to_exe is used also for data to memory (write mode)

--from exmem to mem
signal MEM_controls_in_MEM : std_logic_vector(1 downto 0); 
signal Alu_Out_Addr_to_mem : std_logic_vector(n-1 downto 0); 
signal data_to_dram_temp : std_logic_vector(n-1 downto 0); 
signal regDst_to_mem : std_logic_vector(nAddr-1 downto 0);

--signal from MEM to memwb
--Alu_Out_Addr_to_mem, is passed directy from exe alu_output
signal data_to_mem_wb: std_logic_vector(n-1 downto 0); 


--signal from memwb to wb
signal DataFromMem_to_WB : std_logic_vector(n-1 downto 0); 
signal RegDst_to_WB  : std_logic_vector(4 downto 0); 
signal writeback : std_logic;


--from wb to rf
signal data_to_RF_from_WB : std_logic_vector(n-1 downto 0); 

--forwarding
signal forwardA, forwardB, ForwardC   : std_logic_vector(1 downto 0);
signal Forward_sw1_mux, Forward_sw1, Forward_sw2: std_logic;
signal alures_memaddr_out_exmem : std_logic_vector(n-1 downto 0);
signal alures_out_memwb : std_logic_vector(n-1 downto 0); 

--signal cu_pipeline and cu_branch
signal jump_temp, bnez_notBeq, branch_temp : std_logic;

--from cu to decode stage. (select regA, if jumpRegister)
signal Jump_reg_temp: std_logic;

--from cu to exe
signal jump_link_temp : std_logic;

--signal exception : std_logic;
          
begin
stageF : FETCH
         generic map(n)
         port map(clk, rst, stall, target_nextPC, jump_CU_FET,
         addr_to_iram, nextPC_FETCH_IFID);

IFID_stage : IFID_pipeline
              generic map(n)
         port map(clk, rst, stall, nextPC_FETCH_IFID, instr_fetched,jump_CU_FET, Jump_link_temp,
                nextPC_IFID_DEC, inst_IFID_DEC);
                
stageD : decode
          generic map(n, nAddr)
          port map(clk, rst, nextPC_IFID_DEC, inst_IFID_DEC, 
          reg1_from_RF, Alu_Out_Addr_to_mem, data_to_RF_from_WB, ForwardC,
          jump_temp, Jump_reg_temp, EXE_controls_in_IDEX(8), offset_to_IDEX,
          reg1_Addr_from_decode, reg2_Addr_from_decode, regDst1_addr_to_IDEX ,
          regDst2_addr_to_IDEX, target_nextPC, isZero);

RegFile_DEC_WB : Register_File
                generic map(n)
                port map( clk, rst,
                reg1_Addr_from_decode, reg2_Addr_from_decode,
                reg1_from_RF, reg2_from_RF,
                RegDst_to_WB, data_to_RF_from_WB, writeback 
                );
                
                
--if it is a Jump_link, propagate pc_next instead of regA to idex pipeline register
--when we have jump and link
    mux_regA_pc : MUX21_GENERIC
                      generic map (n)
                      port map(reg1_from_RF,  nextPC_IFID_DEC,
                      Jump_link_temp, reg1_from_mux_rega_pcnex
                      );
                      
IDEX_Stage   : IDEX_pipeline
            generic map (n) 
            port map(clk, rst, jump_link_temp, --used when jump_link to store the return address
            stall,
            WB_controls_in_IDEX, MEM_controls_in_IDEX, EXE_controls_in_IDEX,
            reg1_from_mux_rega_pcnex, reg2_from_RF, offset_to_IDEX, reg1_Addr_from_decode, 
            reg2_Addr_from_decode, regDst1_addr_to_IDEX, regDst2_addr_to_IDEX,
            WB_controls_in_EXMEM,  MEM_controls_in_EXMEM, EXE_controls_in_EXEcute,
            Reg1_Addr_to_exe, Reg2_Addr_to_exe, --used for forwarding
            Reg1_Value_to_exe, Reg2_value_to_exe,
            immediate_to_exe,
            regDst1_addr_to_exe, regDst2_addr_to_exe
            );
           
           
stageE : execute
          generic map(n)
          port map(Reg1_Value_to_exe, Reg2_value_to_exe, immediate_to_exe,
          regDst1_addr_to_exe, regDst2_addr_to_exe, EXE_controls_in_EXEcute,
          Alu_Out_Addr_to_mem, data_to_RF_from_WB, forwardA, forwardB, Forward_sw2,
          Alu_Out_Addr_to_exmem, regDst_to_exmem, Reg2_value_to_store, exception);
          
          
          
EXMEM_stage : EXMEM_pipeline
          generic map(n)
          port map(clk, rst, WB_controls_in_EXMEM,  MEM_controls_in_EXMEM, Forward_sw1,
          Alu_Out_Addr_to_exmem, Reg2_value_to_store, regDst_to_exmem, WB_controls_in_MEMWB,
          MEM_controls_in_MEM, Alu_Out_Addr_to_mem, data_to_dram_temp, regDst_to_mem, Forward_sw1_mux);
          
          --
          
stageM : memory_stage
          generic map(n)
          port map(data_from_dram,data_to_dram_temp, data_to_RF_from_WB, Forward_sw1_mux, WB_controls_in_MEMWB(0),
          Alu_Out_Addr_to_mem, MEM_controls_in_MEM, req_to_dram, read_notWrite,
          addr_to_dataRam, data_to_dram, data_to_mem_wb);
          
MEMWB_Stage : MEMWB_pipeline
              generic map(n)
              port map(clk, rst, WB_controls_in_MEMWB(1),
              data_to_mem_wb, 
              regDst_to_mem, writeback, RegDst_to_WB, data_to_RF_from_WB);
                         
                         
cu_forward : Forward_unit
              port map(
              reg1_Addr_from_decode, --MEM_controls_in_EXMEM(0) Store
              Reg1_Addr_to_exe, Reg2_Addr_to_exe,MEM_controls_in_EXMEM(0), WB_controls_in_MEMWB(1),  regDst_to_mem,
              writeback, RegDst_to_WB, ForwardA, ForwardB, ForwardC, Forward_sw1, Forward_sw2             
              );

cu_hazard : hazard_detecion 
            port map( reg1_Addr_from_decode, reg2_Addr_from_decode, MEM_controls_in_IDEX(0),
            regDst_to_exmem, Jump_reg_temp, branch_temp, MEM_controls_in_EXMEM(1), WB_controls_in_EXMEM(1),
            regDst_to_mem, MEM_controls_in_MEM(1), WB_controls_in_MEMWB(1),stall
            );
            
cu_pipeline : dlx_cu             
            generic map (ALU_OPC_SIZE )
            port map(clk, rst, inst_IFID_DEC(31 downto 26), inst_IFID_DEC(10 downto 0),
            jump_temp, Jump_reg_temp, Jump_link_temp, branch_temp, bnez_notBeq, 
            EXE_controls_in_IDEX(0),EXE_controls_in_IDEX(7), EXE_controls_in_IDEX(6 downto 1),
            EXE_controls_in_IDEX(8), MEM_controls_in_IDEX(1), MEM_controls_in_IDEX(0),
            WB_controls_in_IDEX(0), WB_controls_in_IDEX(1)            
            );


cu_for_branch : cu_branch
                generic map(n)
                port map(jump_temp, branch_temp, bnez_notBeq, isZero, stall,
                jump_CU_FET
                );      
end struct;



configuration CFG_DATAPATH of Datapath_CU is
	for struct
      
      for stageF : FETCH
      use configuration work.cfg_fetch;
      end for;
      
      for IFID_stage : IFID_pipeline
      use configuration work.cfg_ifid_pipeline;
      end for;
      
      
      for stageD : decode
      use configuration work.cfg_decode;
      end for;
        
       for IDEX_Stage   : IDEX_pipeline
      use configuration work.cfg_idex_pipeline;
      end for;
      
      
        for stageE : execute
      use configuration work.cfg_execute;
      end for;
      
      for EXMEM_stage : EXMEM_pipeline
      use configuration work.cfg_exmem_pipeline;
      end for;
      
      for stageM : memory_stage
      use configuration work.cfg_memory_stage;
      end for;
      
      
      for MEMWB_Stage : MEMWB_pipeline
      use configuration work.cfg_memwb_pipeline;
      end for;

      
      for RegFile_DEC_WB : Register_File
      use configuration work.CFG_RegisterFile;
      end for;
      
      
      for cu_forward : Forward_unit
      use configuration work.CFG_cu_forwarding;
      end for;
      
      for cu_hazard : hazard_detecion
      use configuration work.cfg_cu_hazard;
      end for;
      
      for cu_pipeline : dlx_cu  
      use configuration work.cfg_dlx_cu_basic;
      end for;
      
      
      for cu_for_branch : cu_branch
      use configuration work.cfg_cu_branch;
      end for;
        
      
      
	end for;
end CFG_DATAPATH;






















