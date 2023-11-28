LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY mux_2x1_1bit IS
	PORT (
		E0 : IN std_logic;
		E1 : IN std_logic;
		sel : IN std_logic;
		saida : OUT std_logic);

end mux_2x1_1bit;

architecture circuito of mux_2x1_1bit is
begin
   saida <= 
        E0 when sel = '0'
        else
       
    E1;
end circuito;