LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE IEEE.std_logic_textio.ALL;
USE std.textio.ALL;

ENTITY testbench_slt IS
END testbench_slt;

architecture circuito of testbench_slt is
	component slt IS
		GENERIC (
			x : INTEGER
		);
		PORT (
			A      : IN std_logic_vector(x-1 DOWNTO 0);
			B      : IN std_logic_vector(x-1 DOWNTO 0);
			result : OUT std_logic
		);
	END component;
	
	CONSTANT N : integer := 32;
	CONSTANT wait_time : TIME := 35 ns;
	
	SIGNAL A      : std_logic_vector(N-1 DOWNTO 0);
	SIGNAL B      : std_logic_vector(N-1 DOWNTO 0);
	SIGNAL result : std_logic;
		
	BEGIN
		DUT: slt 
			GENERIC MAP (
				x => N
			)
			PORT MAP (
				A      => A,
				B      => B,
				result => result
			);
		
		stim: PROCESS IS
			file goldenmodel      : text OPEN read_mode IS "estimulos-slt.dat";
			variable curr_line    : line;
			variable space        : character;
			variable A_value      : bit_vector(N-1 DOWNTO 0);
			variable B_value      : bit_vector(N-1 DOWNTO 0);
			variable result_value : std_logic;

			BEGIN			
				WHILE not endfile(goldenmodel) LOOP
					-- first line: A & " " & B
					readline(goldenmodel, curr_line);
					read(curr_line, A_value);
					read(curr_line, space);
					read(curr_line, B_value);
					-- second line: A < B
					readline(goldenmodel, curr_line);
					read(curr_line, result_value);
					
					A  <= to_stdlogicvector(A_value);
					B  <= to_stdlogicvector(B_value);

					wait for wait_time;
					
					ASSERT (result_value = result)
					REPORT "Resultado incorreto." SEVERITY error;
				END LOOP;
				
				ASSERT false REPORT "Teste encerrado." SEVERITY note;
			
				WAIT;
			
	END PROCESS;
END circuito;