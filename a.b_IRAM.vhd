library ieee;
use ieee.std_logic_1164.all;
use IEEE.NUMERIC_STD.all;
use std.textio.all;
use ieee.std_logic_textio.all;


-- Instruction memory for DLX
-- Memory filled by a process which reads from a file
entity IRAM is
  generic (    
    RAM_DEPTH : integer := 128;
    I_SIZE : integer := 32); 
  port (
    ck   : in std_logic;
    Rst  : in  std_logic;
    Addr : in  std_logic_vector(I_SIZE - 1 downto 0);
    Dout : out std_logic_vector(I_SIZE - 1 downto 0)
    );

end IRAM;

architecture IRam_Bhe of IRAM is

  type RAMtype is array (0 to RAM_DEPTH - 1) of std_logic_vector(I_SIZE - 1 downto 0);
  signal IRAM_mem : RAMtype;

begin  
 Dout <= IRAM_mem(to_integer (unsigned (Addr (31 downto 2))));
 
  -- purpose: This process is in charge of filling the Instruction RAM with the firmware
  -- type   : combinational
  -- inputs : Rst
  -- outputs: IRAM_mem
  FILL_MEM_P: process (rst)
  file mem_fp: text;
  variable file_line : line;
  variable index : integer := 0; 
  variable tmp_data_hex : std_logic_vector(I_SIZE-1 downto 0);
    
  begin  -- process FILL_MEM_P
    if (Rst = '1') then
      --file_open(mem_fp,"test_arithmetic_ovf.asm.mem",READ_MODE);
      file_open(mem_fp,"branch_mem.asm.mem",READ_MODE);
      while (not endfile(mem_fp)) loop
        readline(mem_fp,file_line);
        hread(file_line,tmp_data_hex);
        IRAM_mem(index)  <= tmp_data_hex;          
        index := index + 1;
      end loop;
      file_close(mem_fp);
    end if;
  index := 0;
  end process FILL_MEM_P;

end IRam_Bhe;

configuration CFG_Instr_Memory of IRAM is
	for IRam_Bhe
	end for;
end CFG_Instr_Memory;
