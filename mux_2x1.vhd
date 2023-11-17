LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY mux_2x1 IS
	GENERIC (
		N : INTEGER);
	PORT (
		E0 : IN std_logic_vector(N - 1 DOWNTO 0);
		E1 : IN std_logic_vector(N - 1 DOWNTO 0);
		sel : IN std_logic;
		saida : OUT std_logic_vector(N - 1 DOWNTO 0));

end mux_2x1;

architecture circuito of mux_2x1 is
begin
   saida <= 
        E0 when sel = '0'
        else
       
    E1;
end circuito;