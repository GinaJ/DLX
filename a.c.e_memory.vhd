library IEEE;
use IEEE.std_logic_1164.all;

entity Memory_stage is
  generic (n : integer :=32);
  port ( 
  data_from_dram        : in std_logic_vector(n-1 downto 0);
  data_to_dram_temp     : in std_logic_vector(n-1 downto 0); --after execute stage
  data_to_RF_from_WB    : in std_logic_vector(n-1 downto 0); --from writeback stage
  Forward_sw1_mux       : in std_logic;
  load                  : in std_logic;
  Addr_alu              : in std_logic_vector(n-1 downto 0);
  mem_controls          : in std_logic_vector(1 downto 0);
  
  
  req             : out std_logic;
  read_notWrite   : out std_logic;
  Addr_to_Dram    : out std_logic_vector(n-1 downto 0);
  data_to_dram    : out std_logic_vector(n-1 downto 0);
  data_to_mem_wb  : out std_logic_vector(n-1 downto 0)
  );
end memory_stage;
         
architecture Behavioral of memory_stage is
begin 
  process (mem_controls, load, addr_alu, data_to_dram_temp, data_to_RF_from_WB, Forward_sw1_mux, data_from_dram)
    begin
    if Forward_sw1_mux='1' then
      data_to_dram<=data_to_RF_from_WB;
      else data_to_dram<=data_to_dram_temp;
      end if;
    if mem_controls(1)='1' then
        req <='1';
        read_notWrite<='1';
        Addr_to_Dram <=Addr_alu;
    elsif 
        mem_controls(0)='1' then
        req <='1';
        read_notWrite<='0';
        Addr_to_Dram <=Addr_alu;
    else
        req <='0';
    end if; 
    if load='1' then data_to_mem_wb<=data_from_dram;
    else data_to_mem_wb<=addr_alu;
    end if;
    end process;
end Behavioral; 

configuration CFG_Memory_stage of memory_stage is
	for Behavioral
	end for;
end CFG_Memory_stage;
  
  