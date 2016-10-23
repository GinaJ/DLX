
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Forward_unit is
port (

      --reg1 from FETCH, from IFID pipeline. Need this value to forward in case of branch/Jump
      reg1_add_Branch_Decode : in std_logic_vector(4 downto 0); 
      
      --input from decode stage, coming from the IDEX pipeline register
			reg1_add: in std_logic_vector(4 downto 0); 
			reg2_add: in std_logic_vector(4 downto 0);
      sw_inst: in std_logic; --if it is a store instruction
      
      --input from EXEcute stage
      regEXE_wb : in std_logic; --Control signal: it tells us if this instruction has to write back
			regEXE_add: in std_logic_vector(4 downto 0); --rd register from the EXE_MEM pipeline
			
      --input from Memory stage
      regMEM_wb : in std_logic; --Control signal: it tells us if this instruction has to write back
			regMEM_add: in std_logic_vector(4 downto 0);  --rd register from the MEM-WB pipeline
      
      --output to MUX
			ForwardA: out std_logic_vector(1 downto 0);--forward for reg1 in EXE stage
			ForwardB: out std_logic_vector(1 downto 0);--forward for reg2 in EXE stage
      ForwardC: out std_logic_vector(1 downto 0); --forward for reg1 Branch in decode
      Forward_sw1: out std_logic;--forward register's value for sw from last instruction
      Forward_sw2: out std_logic --forward register's value for sw from second last instruction
      );
end Forward_unit;

architecture Behavioral of Forward_unit is

begin
  process( reg1_add, reg2_add, regEXE_add, regMEM_add, regEXE_wb, regMEM_wb, reg1_add_Branch_Decode, sw_inst )
  begin
  
    --Check Reg1 for Branch in decode
    --check MEM hazard 
    --if it REALLY has to write back, and regEXE_add/=reg1_add, and the addresses match, then forward
    -- when regEXE_add=reg1_add, we need to forward from EXE stage because it is more recent
    if (regMEM_wb='1' and regMEM_add /= "00000" and regEXE_add /= reg1_add_Branch_Decode and regMEM_add = reg1_add_Branch_Decode) then
        ForwardC<="01";
         --check EXE hazard 
        elsif (regEXE_wb='1' and regEXE_add /= "00000"  and regEXE_add = reg1_add_Branch_Decode) then
        ForwardC<="10";
        else ForwardC<="00";       
    end if;
    
    --INPUT 1
    --check MEM hazard 
    --if it REALLY has to write back, and regEXE_add/=reg1_add, and the addresses match, then forward
    -- when regEXE_add=reg1_add, we need to forward from EXE stage because it is more recent
    if (regMEM_wb='1' and regMEM_add /= "00000" and regEXE_add /= reg1_add and regMEM_add = reg1_add) then
        ForwardA<="01";
         --check EXE hazard 
        elsif (regEXE_wb='1' and regEXE_add /= "00000"  and regEXE_add = reg1_add) then
        ForwardA<="10";
        else ForwardA<="00";       
    end if;
    
    --INPUT 2
    --check MEM hazard 
    --if it REALLY has to write back, and regEXE_add/=reg1_add, and the addresses match, then forward
    -- when regEXE_add=reg2_add, we need to forward from EXE stage because it is more recent
    if (regMEM_wb='1' and regMEM_add /= "00000" and regEXE_add /= reg2_add and regMEM_add = reg2_add) then
        ForwardB<="01";
         --check EXE hazard 
        elsif (regEXE_wb='1' and regEXE_add /= "00000"  and regEXE_add = reg2_add) then
        ForwardB<="10";
        else ForwardB<="00";       
    end if;
    
    --Store the value of reg2
    --"sw immediate(reg1), reg2"
    --We need to forward the value reg2
    
    --check if reg2 is computed in the second-last instruction
    --if it REALLY has to write back, and regEXE_add/=reg1_add, and the addresses match, then forward
    -- when regEXE_add=reg2_add, we need to forward from EXE stage because it is more recent
    if (sw_inst='1' and regMEM_wb='1' and regMEM_add /= "00000" and regEXE_add /= reg2_add and regMEM_add = reg2_add) then
        Forward_sw2<='1';
        Forward_sw1<='0'; 
         --check if reg2 comes from the previous instruction
        elsif (sw_inst='1' and regEXE_wb='1' and regEXE_add /= "00000"  and regEXE_add = reg2_add) then
        Forward_sw1<='1';
        Forward_sw2<='0'; 
        else 
        Forward_sw1<='0';   
        Forward_sw2<='0';           
    end if;
    
    
		end process;
end Behavioral;

configuration CFG_cu_forwarding of Forward_unit is
	for Behavioral
	end for;
end CFG_cu_forwarding;

