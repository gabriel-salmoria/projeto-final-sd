LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE IEEE.std_logic_textio.ALL;
USE std.textio.ALL;

ENTITY testbench_addsub IS
END testbench_addsub;

architecture circuito of testbench_addsub is
	component addsub IS
		GENERIC (
			N : INTEGER
		);
		PORT (
			A   : IN std_logic_vector(N-1 DOWNTO 0);
			B   : IN std_logic_vector(N-1 DOWNTO 0);
			OP  : IN std_logic;
			sum : OUT std_logic_vector(N-1 DOWNTO 0)
		);
	END component;
	
	CONSTANT N : integer := 32;
	CONSTANT wait_time : TIME := 35 ns;
	
	SIGNAL A   : std_logic_vector(N-1 DOWNTO 0);
	SIGNAL B   : std_logic_vector(N-1 DOWNTO 0);
	SIGNAL OP  : std_logic;
	SIGNAL sum : std_logic_vector(N-1 DOWNTO 0);
		
	BEGIN
		DUT: addsub 
			GENERIC MAP (
				N => N
			)
			PORT MAP (
				A   => A,
				B   => B,
				OP  => OP,
				sum => sum
			);
		
		stim: PROCESS IS
			file goldenmodel   : text OPEN read_mode IS "estimulos-addsub.dat";
			variable curr_line : line;
			variable space     : character;
			variable A_value   : bit_vector(N-1 DOWNTO 0);
			variable B_value   : bit_vector(N-1 DOWNTO 0);
			variable OP_value  : bit;
			variable result    : bit_vector(N-1 DOWNTO 0);

			BEGIN			
				WHILE not endfile(goldenmodel) LOOP
					-- first line: A & " " & B & " " & OP
					readline(goldenmodel, curr_line);
					read(curr_line, A_value);
					read(curr_line, space);
					read(curr_line, B_value);
					read(curr_line, space);
					read(curr_line, OP_value);
					-- second line: A +/- B (N bits)
					readline(goldenmodel, curr_line);
					read(curr_line, result);
					
					A  <= to_stdlogicvector(A_value);
					B  <= to_stdlogicvector(B_value);

					if OP_value = '0' then
						OP <= '0';
					else
						OP <= '1';
					end if;
					
					wait for wait_time;
					
					ASSERT (to_stdlogicvector(result) = sum)
					REPORT 
						"Resultado incorreto. " 
						& "Expected: " & integer'Image(to_integer(signed(to_stdlogicvector(result))))
						& " Got: " & integer'Image(to_integer(signed(sum)))
					SEVERITY error;
				END LOOP;
				
				ASSERT false REPORT "Teste encerrado." SEVERITY note;
			
				WAIT;
			
	END PROCESS;
END circuito;