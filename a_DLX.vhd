library ieee;
use ieee.std_logic_1164.all;

entity DLX is
  generic (
    FUNC_SIZE          :     integer := 11;  -- Func Field Size for R-Type Ops
    OP_CODE_SIZE       :     integer := 6;  -- Op Code Size
    ALU_OPC_SIZE       :     integer := 6;  -- ALU Op Code Size
    RAM_DEPTH : integer := 128;
    n     : integer := 32;
    nAddr : integer := 5);
  port (
    Clk : in std_logic;
    Rst : in std_logic;
    
    exception : out std_logic
    );
end DLX;

architecture struct of DLX is

component Datapath_CU is
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
end component Datapath_CU;

component Data_Memory is
  generic(
  n : integer := 32
  );
  port (
    Reset : in    std_logic;
    Req   : in    std_logic;
    R_nW  : in    std_logic; 
    Addr  : in    std_logic_vector (n - 1 downto 0);
    Datain  : in std_logic_vector (n - 1 downto 0);
    Dataout : out std_logic_vector (n - 1 downto 0)
  );
end component Data_Memory;

component IRAM is
  generic (
    RAM_DEPTH : integer := 128;
    I_SIZE : integer := 32); 
  port (
    ck   : in std_logic;
    Rst  : in  std_logic;
    Addr : in  std_logic_vector(I_SIZE - 1 downto 0);
    Dout : out std_logic_vector(I_SIZE - 1 downto 0)
    );

end component IRAM;

signal addr_to_iram, addr_to_dataRam, InstrFetched, data_to_dram, data_from_dram : std_logic_vector(n-1 downto 0);
signal req_to_dram, read_notWrite : std_logic;
begin
getInstr: IRAM
          generic map(RAM_DEPTH, n)
          port map(clk, rst, addr_to_iram, InstrFetched);
          
pipeline : Datapath_CU
            generic map (FUNC_SIZE, OP_CODE_SIZE, ALU_OPC_SIZE, n, nAddr)
            port map(clk, rst, InstrFetched, data_from_dram, exception, addr_to_iram,
            data_to_dram, req_to_dram, read_notWrite, addr_to_dataRam
            );
            
DataMem : Data_Memory
          generic map(n)
          port map(
          rst, req_to_dram, read_notWrite, addr_to_dataRam, data_to_dram, data_from_dram);
      
end struct;

configuration CFG_DLX of DLX is
    for struct
    
    	for getInstr: IRAM
      use configuration work.cfg_instr_memory;
      end for;
      
      for pipeline : Datapath_CU
      use configuration work.CFG_Datapath;
      end for;
      
      for DataMem : Data_Memory
      use configuration work.cfg_data_memory;
      end for;
    
    
  end for;
end CFG_DLX;