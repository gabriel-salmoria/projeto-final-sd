LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE IEEE.std_logic_textio.ALL;
USE std.textio.ALL;

ENTITY testbench_mul IS
END testbench_mul;

architecture circuito of testbench_mul is
	component multiplicador IS
		PORT (
			A     : IN std_logic_vector(31 DOWNTO 0);
			B     : IN std_logic_vector(31 DOWNTO 0);
			saida : OUT std_logic_vector(64 downto 0)
		);
	END component;
	
	SIGNAL A     : std_logic_vector(31 DOWNTO 0);
	SIGNAL B     : std_logic_vector(31 DOWNTO 0);
	SIGNAL saida : std_logic_vector(64 DOWNTO 0);
		
	CONSTANT wait_time : TIME := 35 ns;
	BEGIN
		DUT: multiplicador
			PORT MAP (
				A     => A,
				B     => B,
				saida => saida
			);
				
		stim: PROCESS IS
			file goldenmodel   : text OPEN read_mode IS "estimulos-mul.dat";
			variable curr_line : line;
			variable space     : character;
			variable A_value   : bit_vector(31 DOWNTO 0);
			variable B_value   : bit_vector(31 DOWNTO 0);
			variable result    : bit_vector(64 DOWNTO 0);

			BEGIN			
				WHILE not endfile(goldenmodel) LOOP
					-- first line: A & " " & B
					readline(goldenmodel, curr_line);
					read(curr_line, A_value);
					read(curr_line, space);
					read(curr_line, B_value);
					-- second line: A * B (65 bits)
					readline(goldenmodel, curr_line);
					read(curr_line, result);
					
					A <= to_stdlogicvector(A_value);
					B <= to_stdlogicvector(B_value);
					
					wait for wait_time;
					
					ASSERT (to_stdlogicvector(result) = saida)
					REPORT "Multiplicacao incorreta." SEVERITY error;
				END LOOP;
				
				ASSERT false REPORT "Teste encerrado." SEVERITY note;
			
				WAIT;
			
	END PROCESS;
END circuito;