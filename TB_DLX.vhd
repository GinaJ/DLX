 library IEEE;

use IEEE.std_logic_1164.all;
use WORK.all;

entity tb_dlx is
end tb_dlx;

architecture TEST of tb_dlx is

    constant FUNC_SIZE          :     integer := 11;  -- Func Field Size for R-Type Ops
    constant OP_CODE_SIZE       :     integer := 6;  -- Op Code Size
    constant ALU_OPC_SIZE       :     integer := 6;  -- ALU Op Code  Size
    constant RAM_DEPTH : integer := 128;
    constant n     : integer := 32;
    constant nAddr : integer := 5;
    signal Clock: std_logic := '0';
    signal Reset: std_logic := '1';
    signal exception:std_logic;

component DLX is
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
end component DLX;
begin


        -- instance of DLX
	U1: DLX
        Generic Map (FUNC_SIZE, OP_CODE_SIZE, ALU_OPC_SIZE, RAM_DEPTH, N, nAddr)   
	Port Map (Clock, Reset, exception);
	

  PCLOCK : process(Clock)
	begin
		Clock <= not(Clock) after 50 ps;	
	end process;
	
	Reset <= 'Z', '1' after 20 ns, '0' after 40 ns;
       

end TEST;

-------------------------------

configuration AAA_CFG_TB of tb_dlx  is
	for TEST
    	for U1: DLX
      use configuration work.CFG_DLX;
      end for;
	end for;
end AAA_CFG_TB;

