LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE IEEE.std_logic_textio.ALL;
USE std.textio.ALL;

ENTITY testbench_and_or IS
END testbench_and_or;

architecture circuito of testbench_and_or is
	component and_or IS
		GENERIC (
			x : INTEGER
		);
		PORT (
			A      : IN std_logic_vector(x-1 DOWNTO 0);
			B      : IN std_logic_vector(x-1 DOWNTO 0);
			OP     : IN std_logic;
			RESULT : OUT std_logic_vector(x-1 DOWNTO 0)
		);
	END component;
	
	CONSTANT N : integer := 32;
	CONSTANT wait_time : TIME := 35 ns;
	
	SIGNAL A      : std_logic_vector(N-1 DOWNTO 0);
	SIGNAL B      : std_logic_vector(N-1 DOWNTO 0);
	SIGNAL OP     : std_logic;
	SIGNAL result : std_logic_vector(N-1 DOWNTO 0);
		
	BEGIN
		DUT: and_or 
			GENERIC MAP (
				x => N
			)
			PORT MAP (
				A      => A,
				B      => B,
				OP     => OP,
				result => result
			);
		
		stim: PROCESS IS
			file goldenmodel      : text OPEN read_mode IS "estimulos-and_or.dat";
			variable curr_line    : line;
			variable space        : character;
			variable A_value      : bit_vector(N-1 DOWNTO 0);
			variable B_value      : bit_vector(N-1 DOWNTO 0);
			variable OP_value     : bit;
			variable result_value : bit_vector(N-1 DOWNTO 0);

			BEGIN			
				WHILE not endfile(goldenmodel) LOOP
					-- first line: A & " " & B & OP
					readline(goldenmodel, curr_line);
					read(curr_line, A_value);
					read(curr_line, space);
					read(curr_line, B_value);
					read(curr_line, space);
					read(curr_line, OP_value);
					-- second line: A AND/OR B
					readline(goldenmodel, curr_line);
					read(curr_line, result_value);
					
					A      <= to_stdlogicvector(A_value);
					B      <= to_stdlogicvector(B_value);
					result <= to_stdlogicvector(result_value);
					
					IF (OP_value = '1') THEN
						OP <= '1';
					ELSE
						OP <= '0';
					END IF;

					wait for wait_time;
					
					ASSERT (to_stdlogicvector(result_value) = result) REPORT "Resultado incorreto. " SEVERITY error;
				END LOOP;
				
				ASSERT false REPORT "Teste encerrado." SEVERITY note;
			
				WAIT;
			
	END PROCESS;
END circuito;