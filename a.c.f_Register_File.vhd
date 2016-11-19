library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Register_File is
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
end Register_File;

architecture Behavioral of Register_File is


  -- The register bank
  type      Reg_t is array (0 to 31) of std_logic_vector (31 downto 0);
  signal    RegBank     : Reg_t;


  signal    Rs_AddrInt  : natural range 0 to 31;  -- To index the register bank
  signal    Rt_AddrInt  : natural range 0 to 31;  -- To index the register bank
  signal    Rd_AddrInt  : natural range 0 to 31;  -- To index the register bank

begin

  Rs_AddrInt  <=  to_integer (unsigned (Rs_Addr));
  Rt_AddrInt  <=  to_integer (unsigned (Rt_Addr));
  Rd_AddrInt  <=  to_integer (unsigned (Rd_Addr));


  WriteOp : process  (reset, ck)
  
  begin
  
    if (Reset = '1') then
       -- Initialize all registers to 0
      RegBank   <=  (others => (others => '0'));

    elsif req_Write='1' then 
                if (Rd_AddrInt /= 0) then -- Check that it is not Register R0
                  RegBank (Rd_AddrInt)  <=  Rd_Data;
                end if;
    end if;
    
  end process;

      --Read operation
      Rs_Data <=  RegBank (Rs_AddrInt);
      Rt_Data <=  RegBank (Rt_AddrInt);

end Behavioral;

configuration CFG_RegisterFile of Register_File is
	for Behavioral
  end for;
end CFG_RegisterFile;