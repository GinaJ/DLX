
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity booth_mux_generic is
Generic (N: integer:= 8);
Port (	
    Zero        :	In	std_logic_vector(N-1 downto 0) ;
		A           :	In	std_logic_vector(N-1 downto 0);
    A_neg       :	In	std_logic_vector(N-1 downto 0) ;
		A_double    :	In	std_logic_vector(N-1 downto 0);
    A_neg_double:	In	std_logic_vector(N-1 downto 0);
		SEL         :	In	std_logic_vector(2 downto 0);
		Y           :	Out	std_logic_vector(N-1 downto 0)
    );

end booth_mux_generic;

architecture Behavioral of booth_mux_generic is

begin

          y <=  zero when sel = "000" else
                a when sel = "001" else 
                a when sel = "010" else 
                a_double when sel = "011" else 
                a_neg_double when sel = "100" else 
                a_neg when sel = "101" else 
                a_neg when sel = "110" else 
                zero when sel = "111";

end Behavioral;

architecture STRUCTURAL of booth_mux_generic is
signal mux_A, mux_2a, mux_zero_2a: std_logic_vector(N-1 downto 0);
signal selmux3, selmux4:std_logic;

component MUX21_GENERIC is
	Generic (N: integer:= 8);
	Port (	
        A:	  In	std_logic_vector(N-1 downto 0) ;
        B:	  In	std_logic_vector(N-1 downto 0);
        SEL:	In	std_logic;
        Y:	  Out	std_logic_vector(N-1 downto 0));
	end component;

begin
    selmux3 <= sel(1) xor sel(2);
    selmux4 <= sel(1) xor sel(0);
        mux1: MUX21_GENERIC generic map (n) port map (A, A_neg, sel(2), mux_a);
        mux2: MUX21_GENERIC generic map (n) port map (A_double, A_neg_double, sel(2), mux_2a);
        mux3: MUX21_GENERIC generic map (n) port map (zero, mux_2a, selmux3, mux_zero_2a);
        mux4: MUX21_GENERIC generic map (n) port map (mux_zero_2a, mux_a, selmux4, y);
end structural;

configuration CFG_BOOTH_MUX_GEN_BEHAVIORAL of booth_mux_generic is
	for BEHAVIORAL
	end for;
end CFG_BOOTH_MUX_GEN_BEHAVIORAL;

configuration CFG_BOOTH_MUX_GEN_STRUCTURAL of booth_mux_generic is
	for STRUCTURAL
		for all : MUX21_GENERIC
			use configuration WORK.CFG_MUX21_GEN_STRUCTURAL;
		end for;
  end for;
end CFG_BOOTH_MUX_GEN_STRUCTURAL; 
 
