
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity hazard_detecion is
port (
      --input from if/id pipeline
			reg1_add: in std_logic_vector(4 downto 0); 
			reg2_add: in std_logic_vector(4 downto 0);
      sw_instr: in std_logic;
      
      --input from id/exe pipeline -->of the last instruction
      reg_dest : in std_logic_vector(4 downto 0);--reg destination of previous instruction
			jump : in std_logic; --when in decode we have jumpRegister (need the value of reg1)
      Branch : in std_logic; --when in decode, the instruction is a branch
      memRead : in std_logic; --control signal, previous instruction has to read from memory
			writeReg : in std_logic; --the value has to be written in regDst
      
      --input from exe/mem pipeline -->of the second-last instruction
      reg_dest2 : in std_logic_vector(4 downto 0);--reg destination of second-last instruction
      memRead2 : in std_logic; --control signal, second-last instruction has to read from memory
			writeReg2 : in std_logic; --the value has to be written in regDst

      --output
			stall : out std_logic
      --stall PC, reset IF/ID pipeline, reset control signal from control unit
);
end hazard_detecion;

architecture Behavioral of hazard_detecion is

begin
  process(reg1_add, reg2_add, reg_dest, memRead, jump, branch, writeReg, sw_instr, reg_dest2, memRead2, writeReg2)
  begin
  
    --CHECK STALL FOR EXECUTE OPERATION (no store operation)
    if (memRead='1' and writeReg='1' and sw_instr='0') then 
        if (reg1_add=reg_dest and reg_dest /= "00000") then
        --stall, the value is found during the memory stage but needed in the execute stage
          stall<='1';
        elsif (reg2_add=reg_dest and reg_dest /= "00000") then
          --stall, the value is found fduring the memory stage but needed in the execute stage
          stall<='1';
         else 
           stall<='0'; 
        end if;
      
    --CHECK STALL FOR lw followed by sw OPERATION 
    elsif (memRead='1' and writeReg='1' and sw_instr='1' 
    and reg1_add=reg_dest and reg_dest /= "00000") then 
       stall<='1'; --the value is found during the memory stage(lw) but needed 
       --in the execute stage (sw, compute address memory)
       --example 
       --lw r1, 0(r3)
       --sw 4(r1), r2
        
    --CHECK BRANCH HAZARD
    elsif ((jump='1' or branch='1') and writeReg='1') then 
     if (reg1_add= reg_dest and reg_dest /= "00000") then
          stall<='1';
           --stall, the previous instruction has to modify the value
           --the previous instruction could be an execute operation or a load from memory
           --example
           --add r1, r1, r3
           --beq r1, #4
        end if;
        
        --stall, the second-last instruction has to read from memory
        --example
        --lw r1, 4(r2)
        --beq r1, #4
    elsif ((jump='1' or branch='1') and writeReg2='1' and memRead2='1') then 
        if (reg1_add= reg_dest2 and reg_dest2 /= "00000") then
          stall<='1';
        end if;
    else
    stall <='0';
    end if;
    
		end process;
end Behavioral;

configuration CFG_cu_hazard of hazard_detecion is
	for Behavioral
	end for;
end CFG_cu_hazard;
