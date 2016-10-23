library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_textio.all;
use std.textio.all;

entity Data_Memory is
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
end entity Data_Memory;

architecture Behavioral of Data_Memory is

  type      Mem_t is array            (8  - 1 downto 0) --how many addresses
                  of std_logic_vector (n - 1 downto 0); --number of bits stored in each addresses
  
  signal    Mem   : Mem_t;
  
  
begin  
  process (Req, reset, R_nW, Addr, Datain)
    variable  Index : natural := 0;
  begin
    if reset='1' then 
    Mem<=(others => (others => '0'));
    end if;
    if (Req = '1') then
      Index := to_integer (unsigned (Addr (31 downto 2)));
      
      if (R_nW = '1') then   -- Read mode  
        Dataout        <= Mem (Index);
        
      elsif (R_nW = '0') then  -- Write mode
        Mem (Index) <=  Datain ;
      end if;
      
    elsif (Req = '0') then --no request
      Dataout  <=  (others => 'Z');
    end if;
    
  end process;
  
end architecture Behavioral;

configuration CFG_Data_Memory of data_memory is
	for Behavioral
	end for;
end CFG_Data_Memory;

