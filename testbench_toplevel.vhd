LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE IEEE.std_logic_textio.ALL;
USE std.textio.ALL;

ENTITY testbench_toplevel IS
END testbench_toplevel;

architecture circuito of testbench_toplevel is
	component toplevel IS
		PORT (
			A     : IN std_logic_vector(31 DOWNTO 0);
			B     : IN std_logic_vector(31 DOWNTO 0);
			fnct : IN std_logic_vector(5 downto 0); 
			S     : OUT std_logic_vector(64 downto 0)
		);
	END component;
	
	SIGNAL A     : std_logic_vector(31 DOWNTO 0);
	SIGNAL B     : std_logic_vector(31 DOWNTO 0);
	SIGNAL funct : std_logic_vector(5 downto 0); 
	SIGNAL S     : std_logic_vector(64 DOWNTO 0);
		
	CONSTANT wait_time : TIME := 35 ns;
	BEGIN
		DUT: toplevel
			PORT MAP (
				A     => A,
				B     => B,
				fnct => funct,
				S     => S
			);
				
		stim: PROCESS IS
			file goldenmodel     : text OPEN read_mode IS "estimulos-toplevel.dat";
			variable curr_line   : line;
			variable space       : character;
			variable A_value     : bit_vector(31 DOWNTO 0);
			variable B_value     : bit_vector(31 DOWNTO 0);
			variable funct_value : bit_vector(5  DOWNTO 0);
			variable result      : bit_vector(64 DOWNTO 0);

			BEGIN			
				WHILE not endfile(goldenmodel) LOOP
					-- first line: A & " " & B & funct
					readline(goldenmodel, curr_line);
					read(curr_line, A_value);
					read(curr_line, space);
					read(curr_line, B_value);
					read(curr_line, space);
					read(curr_line, funct_value);
					-- second line: A OP B (65 bits)
					readline(goldenmodel, curr_line);
					read(curr_line, result);
					
					A <= to_stdlogicvector(A_value);
					B <= to_stdlogicvector(B_value);
					funct <= to_stdlogicvector(funct_value);
					
					wait for wait_time;
					
					ASSERT (to_stdlogicvector(result) = S)
					REPORT "Resultado incorreto." SEVERITY error;
				END LOOP;
				
				ASSERT false REPORT "Teste encerrado." SEVERITY note;
			
				WAIT;
			
	END PROCESS;
END circuito;