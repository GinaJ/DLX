library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity booth_mul is 
	generic (
		Nbit: 	natural := 16);
	Port (	
    		A:	In	std_logic_vector(Nbit-1 downto 0);
		B:	In	std_logic_vector(Nbit-1 downto 0);
		Res:	Out	std_logic_vector((2*Nbit)-1 downto 0)
		);
end booth_mul ; 

architecture STRUCTURAL of booth_mul is
   
component P4adder is 
	generic (
            N:		natural := 32; --number of bits, lenght of vectors
            PowerN:	natural := 5
            );
	Port (	
    		A:	In	std_logic_vector(N-1 downto 0);
		B:	In	std_logic_vector(N-1 downto 0);
		Ci:	In	std_logic;
		S:	Out	std_logic_vector(N-1 downto 0);
		Overf:	Out	std_logic
		);
end component P4adder; 


component booth_mux_generic is
Generic (N: integer:= 8);
Port (	
	Zero	:	In	std_logic_vector(N-1 downto 0) ;
	A	:	In	std_logic_vector(N-1 downto 0);
	A_neg	:	In	std_logic_vector(N-1 downto 0) ;
	A_double:	In	std_logic_vector(N-1 downto 0);
	A_neg_double:	In	std_logic_vector(N-1 downto 0);
	SEL	:	In	std_logic_vector(2 downto 0);
	Y	:	Out	std_logic_vector(N-1 downto 0)
    );
end component booth_mux_generic;

constant total_size : integer := 2*Nbit;
type out_m is array ((Nbit/2)-1 downto 0) of std_logic_vector (total_size-1  downto 0 ) ;
type out_s is array ((Nbit/2)-2 downto 0) of std_logic_vector (total_size-1  downto 0 ) ;
type internal_signal is array ((Nbit/2)-1 downto 0) of std_logic_vector (total_size-1  downto 0 ) ;
signal out_mux : out_m; 	--is the output of each mux
signal out_sum : out_s; 	--is the output of each adder
signal newB : std_logic_vector(Nbit downto 0);		--is the signal used for the encoder
signal A_ext, zeros : std_logic_vector(total_size-1 downto 0);	--is the A with lenght of the final result
signal cout : std_logic_vector((Nbit/2)-2  downto 0);

signal tmp_A, tmp_A_neg, tmp_A_double, tmp_A_neg_double : internal_signal;

--SOLO PER POTENZE DI DUE
--compute the number of iterations (levels of mux - adder)
function Log2( input:integer ) return integer is
 variable temp,log:integer;
 begin
  temp:=input;
  log:=0;
   while (temp /= 0) loop
    temp:=temp/2;
    log:=log+1;
   end loop;
  return log-1;
end function log2;

--used to obtain 2A, 4A, 8A, ...
function shiftLeft( A_ext:std_logic_vector; i:integer ) return std_logic_vector is
 variable signA: std_logic_vector(total_size-1 downto 0);
 begin
	signA := A_ext(A_ext'left - i - 1 downto 0) & (i downto 0 => '0');
 return signA;
end function shiftLeft;

--used to obtain -2A, -4A, -8A, ...
function shiftLeftNegate( A_ext:std_logic_vector; i:integer ) return std_logic_vector is
 variable signA: std_logic_vector(total_size-1 downto 0);
 begin
	signA := std_logic_vector(unsigned(not(A_ext(A_ext'left - i - 1 downto 0) & (i downto 0 => '0'))) + 1);
 return signA;
end function shiftLeftNegate;


begin

--zero vector: needed to compile correctly
zeros <= (A_ext'range => '0');

--create the B used into the encoder
 newB(0) <='0';
 newB(newB'left downto 1) <= B;

--extension of the sign of A in A_ext
-- A_ext <= resize(A, total_size);
 A_ext(A'range ) <= A;
 A_ext(A_ext'left downto Nbit ) <= ( A_ext'left downto Nbit => A( A'left ));

 cycle: for i in 0 to (Nbit/2-1) generate

	first_case: if i = 0 generate
		
		--required to compile correctly
		zeros <= (A_ext'range => '0');
		tmp_A(i) <= A_ext;
		tmp_A_neg(i) <= std_logic_vector(unsigned(not(A_ext)) + 1);
		tmp_A_double(i) <= shiftLeft(A_ext, 2*i);
		tmp_A_neg_double(i) <= shiftLeftNegate(A_ext, 2*i);

		Muxes : booth_mux_generic 	
		generic map(total_size)
		port map(
			zeros,			-- all 0s
			tmp_A(i),		-- A
			tmp_A_neg(i), 		-- -A
			tmp_A_double(i),	-- 2A
			tmp_A_neg_double(i),	-- -2A
			newB((2*i+2) downto (2*i)),
			out_mux(i));

	end generate first_case;

	other_case: if I > 0 generate

		--required to compile correctly
		tmp_A(i) <= shiftLeft(A_ext, 2*i - 1);
		tmp_A_neg(i) <= shiftLeftNegate(A_ext, 2*i - 1);
		tmp_A_double(i) <= shiftLeft(A_ext, 2*i);
		tmp_A_neg_double(i) <= shiftLeftNegate(A_ext, 2*i);

		Muxes : booth_mux_generic 	
		generic map(total_size)
		port map(
			zeros,			-- all 0s
			tmp_A(i),		-- 4A for i = 1
			tmp_A_neg(i),		-- -4A for i = 1
			tmp_A_double(i),	-- 8A for i = 1
			tmp_A_neg_double(i),	-- -8A for i = 1
			newB((2*i+2) downto (2*i)),
			out_mux(i));

	
		first_sum: if (i=1) generate	-- generate first sum
			sum:  P4adder 
			generic map (total_size, log2(total_size)) --modificato to_log2
			port map(out_mux(1),out_mux(0), '0', out_sum(i-1), cout(i-1));
		end generate;
		
		other_sum: if (i>1) generate -- -i>1, generate other sum
			sum: P4adder 
			generic map (total_size, log2(total_size)) --modificato to_log2
port map(out_mux(i),out_sum(i-2), '0', out_sum(i-1), cout(i-1));
			--port map(out_mux(i),out_sum(i-2), cout(i-2), out_sum(i-1), cout(i-1));
		end generate;

	end generate other_case;

 end generate;
res <= out_sum((Nbit/2)-2);
end STRUCTURAL;

configuration CFG_BOOTH_MULTIPLIER_STRUCT of booth_mul  is
	for structural

		for cycle
			for first_case
				for all : booth_mux_generic
 					use configuration WORK.CFG_BOOTH_MUX_GEN_STRUCTURAL;
 				end for;
			end for;

			for other_case
				for all : booth_mux_generic
 					use configuration WORK.CFG_BOOTH_MUX_GEN_STRUCTURAL;
 				end for;

				for first_sum
					for all : P4adder
							use configuration WORK.CFG_P4adder_STRUCTURAL;
					end for;
				end for;
				for other_sum
					for all : P4adder
							use configuration WORK.CFG_P4adder_STRUCTURAL;
					end for;
				end for;

			end for;
		end for;
	end for;
end CFG_BOOTH_MULTIPLIER_STRUCT;


 
