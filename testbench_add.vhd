LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;
use IEEE.std_logic_textio.all;
use std.textio.all;

ENTITY testbench_add IS
end testbench_add;

architecture circuito of testbench_add is
	component somador IS
		GENERIC (
			N : INTEGER
		);
		PORT (
			A   : IN std_logic_vector(N - 1 DOWNTO 0);
			B   : IN std_logic_vector(N - 1 DOWNTO 0);
			sum : OUT std_logic_vector(N - 1 DOWNTO 0)
		);
	END component;
	
	signal A   : std_logic_vector(63 DOWNTO 0); --:= "0000000000000000000000000000000000000000000000000000000000000000";
	signal B   : std_logic_vector(63 DOWNTO 0); --:= "0000000000000000000000000000000000000000000000000000000000000000";
	signal sum : std_logic_vector(63 DOWNTO 0);
		
	CONSTANT wait_time : TIME := 10 ns;
	begin
		DUT: somador 
		GENERIC MAP (
			N => 64
		)
		PORT MAP (
			A   => A,
			B   => B,
			sum => sum
		);
		
		stim: PROCESS IS
			file goldenmodel   : text open read_mode is "/home/joao/projeto-final-sd/estimulos-add.dat";
			variable curr_line : line;
			variable space     : character;
			variable A_value   : bit_vector(63 downto 0);
			variable B_value   : bit_vector(63 downto 0);
			variable result    : bit_vector(63 downto 0);

			BEGIN			
				while not endfile(goldenmodel) loop
					read(curr_line, A_value);
					read(curr_line, space);
					read(curr_line, B_value);
					
					A <= to_stdlogicvector(A_value);
					B <= to_stdlogicvector(B_value);

					readline(goldenmodel, curr_line);
					read(curr_line, result);
					
					wait for wait_time;
					
					ASSERT (to_stdlogicvector(result) = sum)
					REPORT 
						"Soma incorreta: " 
						& integer'image(to_integer(unsigned(sum)))
						& " != "
						& integer'image(to_integer(unsigned(to_stdlogicvector(result))))
					SEVERITY error;
					
				END LOOP;
				
				ASSERT false REPORT "Test done." SEVERITY note;
			
				WAIT;
			
	END PROCESS;
end circuito;