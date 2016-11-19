library ieee; 
use ieee.std_logic_1164.all; 
use ieee.std_logic_unsigned.all;


entity sparce_tree is 
	generic (POWER : 	natural := 5);
	Port (	A:	In	std_logic_vector((2**POWER) downto 1);
		B:	In	std_logic_vector((2**POWER) downto 1);
		Ci:	In	std_logic;
		Cout:	Out	std_logic_vector((2**(POWER-2)) downto 0)
		);
end sparce_tree; 


architecture STRUCTURAL of sparce_tree is

 component block_g is
	Port (	
		Pik: 	in	std_logic;
		Gik: 	in	std_logic;
		Gk1j:	in	std_logic;
		Gij:	out	std_logic);
  end component;

  component block_pg is
	Port (	
		Pik:	in	std_logic;
		Pk1j:	in	std_logic;
		Gik:	in	std_logic;
		Gk1j:	in	std_logic;
		Pij:	out	std_logic;
		Gij:	out	std_logic);
  end component;

constant N : integer := 2**POWER;
type Matrix is array (N downto 1) of std_logic_vector (N downto 1 ) ;-- from P1:1 to P32:32
signal matrixP, matrixG : Matrix;
signal p1, g1: std_logic;

--functions used to compute the different index of the matrix
-- i j k have the same meaning of the block g and pg.
-- to compute index_i i use 'm', the number of block (q ang pq) 'consecutivi' from the 4° row
function index_i(j, I, m: integer) return integer is
	variable tmp: integer;
	begin
	tmp := j*(2**I) - 4*m;
	return tmp;
end index_i;

function index_j(j, I: integer) return integer is
	variable tmp: integer;
	begin
	tmp := j*(2**I)-(2**I-1);
	return tmp;
end index_j;

function index_k(j, I: integer) return integer is
	variable tmp: integer;
	begin
	tmp := (j-1)*(2**I)+(2**(I-1)+1);
	return tmp;
end index_k;

begin

	--initial define, used to handle the carry-in
    p1 <= A(1) xor B(1);
    g1 <= A(1) and B(1);    
    Cout(0) <= Ci;

   cycle: for I in 0 to POWER generate
		--defining basic p and pq
		define_matrix: if I = 0 generate
						blkg_Cin: block_g port map (
										p1, --Pik 	p1
										g1, --Gik 	g1
										Ci, --Gk-1j ci
										matrixG(1)(1)  --Gij in the slide is called G1:0 but i need to overwrite the value g1 (matrixG(1)(1)) to mantaince a consistance with the loop
										);
						cycle_init: for j in 2 to N generate	--compute all basic g and pq
								matrixP(j)(j) <= A(j) xor B(j);	--basic g
								matrixG(j)(j) <= A(j) and B(j);	--basic pq
						end generate cycle_init;
		end generate define_matrix;
		
		--create block q and pq until the 4° row
		define_blocks1: if I <= 3 and I > 0 generate
						cycle_blocks1: for j in 1 to (N/(2**I)) generate	--for each row i have a number of blocks = N/2^i
								
								-- until the 4° row there is only one block g for line
								define_block_g1: if j = 1 generate							
	
									blkg: block_g port map (
												matrixP(index_i(j, I, 0)) (index_k(j, I)), --Pik
												matrixG(index_i(j, I, 0)) (index_k(j, I)), --Gik
												matrixG(index_k(j, I)-1)  (index_j(j, I)), --Gk-1j
												matrixG(index_i(j, I, 0)) (index_j(j, I))  --Gij
												);
									
									--starting from the 2° row the output ogìf the block g go to the Cout									
									Gblock_to_output: if (I>1) generate
										Cout((index_i(j, I, 0)/4)) <= matrixG(index_i(j, I, 0)) (index_j(j, I));
									end generate Gblock_to_output;
								end generate define_block_g1;
								
								--defining the others block as pq
								define_blocks_pg1: if j > 1 generate
									blkpg: block_pg port map (
												matrixP(index_i(j, I, 0)) (index_k(j, I)), --Pik
												matrixP(index_k(j, I)-1)  (index_j(j, I)), --Pk-1j
												matrixG(index_i(j, I, 0)) (index_k(j, I)), --Gik
												matrixG(index_k(j, I)-1)  (index_j(j, I)), --Gk-1j
												matrixP(index_i(j, I, 0)) (index_j(j, I)), --Pij
												matrixG(index_i(j, I, 0)) (index_j(j, I))  --Gij
												);
								end generate define_blocks_pg1;
								
						end generate cycle_blocks1;
		end generate define_blocks1;
		
		--create block q and pq starting from the 4° row
		define_blocks2: if I > 3 and I > 0 generate
						cycle_blocks2: for j in 1 to (N/(2**I)) generate
								
								--block g
								define_block_g2: if j = 1 generate	
									-- I use the parameter 'm' to correctly connect blocks becouse there are blocks g more than 1, and them are 'raggruppati'
									cycle_blocksq2: for m in 0 to (2**(I-3))-1 generate					
										blkg: block_g port map (
													matrixP(index_i(j, I, m)) (index_k(j, I)), --Pik
													matrixG(index_i(j, I, m)) (index_k(j, I)), --Gik
													matrixG(index_k(j, I)-1)  (index_j(j, I)), --Gk-1j
													matrixG(index_i(j, I, m)) (index_j(j, I))  --Gij
													);
										Cout((index_i(j, I, m)/4)) <= matrixG(index_i(j, I, m)) (index_j(j, I)); --handling the Cout
									end generate cycle_blocksq2;
								end generate define_block_g2;
								
								--block pg
								define_blocks_pg2: if j > 1 generate
									-- I use the parameter 'm' to correctly connect blocks becouse there are blocks g more than 1, and them are 'raggruppati'
									cycle_blockspq2: for m in 0 to (2**(I-3))-1 generate	
										blkpg: block_pg port map (
													matrixP(index_i(j, I, m)) (index_k(j, I)), --Pik
													matrixP(index_k(j, I)-1)  (index_j(j, I)), --Pk-1j
													matrixG(index_i(j, I, m)) (index_k(j, I)), --Gik
													matrixG(index_k(j, I)-1)  (index_j(j, I)), --Gk-1j
													matrixP(index_i(j, I, m)) (index_j(j, I)), --Pij
													matrixG(index_i(j, I, m)) (index_j(j, I))  --Gij
													);
									end generate cycle_blockspq2;
								end generate define_blocks_pg2;
								
						end generate cycle_blocks2;
		end generate define_blocks2;
		
   end generate cycle;
	
end STRUCTURAL;

configuration CFG_sparce_tree_STRUCTURAL of sparce_tree is
	for STRUCTURAL
		for cycle
			for define_matrix
				for all : block_g
					use configuration WORK.CFG_block_g_BEHAVIORAL;
				end for;
			end for;

			for define_blocks1
				for cycle_blocks1
					for define_block_g1
						for all : block_g
							use configuration WORK.CFG_block_g_BEHAVIORAL;
						end for;
					end for;
					for define_blocks_pg1
						for all : block_pg
							use configuration WORK.CFG_block_pg_BEHAVIORAL;
						end for;
					end for;
				end for;
			end for;

			for define_blocks2
				for cycle_blocks2
					for define_block_g2
						for cycle_blocksq2
							for all : block_g
								use configuration WORK.CFG_block_g_BEHAVIORAL;
							end for;
						end for;
					end for;
					for define_blocks_pg2
						for cycle_blockspq2
							for all : block_pg
								use configuration WORK.CFG_block_pg_BEHAVIORAL;
							end for;
						end for;
					end for;
				end for;
			end for;
		end for;
	end for;
end CFG_sparce_tree_STRUCTURAL;
