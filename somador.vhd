LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY somador IS
	GENERIC (
		N : INTEGER := 64
	);	
	PORT (
		A   : IN std_logic_vector(N - 1 DOWNTO 0);
		B   : IN std_logic_vector(N - 1 DOWNTO 0);
		sum : OUT std_logic_vector(N - 1 DOWNTO 0)
	);
END somador;

ARCHITECTURE rtl OF somador IS
	SIGNAL add1, add2 : unsigned(N - 1 DOWNTO 0);
	SIGNAL resultado  : unsigned(N - 1 DOWNTO 0);
	BEGIN
		PROCESS(A, B)
		BEGIN
			add1 <= unsigned(A);
			add2 <= unsigned(B);
		END PROCESS;
		
		resultado <= add1 + add2;
		sum <= std_logic_vector(resultado);
END rtl;