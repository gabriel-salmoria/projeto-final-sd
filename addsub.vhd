library ieee;
use ieee.std_logic_1164.all;

entity addsub is
	generic(x : integer := 32);
	port(A, B : in std_logic_vector(x-1 downto 0);
		  OP : in std_logic;
		  SUM : out std_logic_vector(x-1 downto 0)
			);
			
end addsub;

architecture arch of addsub is

signal sB : std_logic_vector(x-1 downto 0);
signal C : std_logic_vector(x downto 0);


begin

C <=  '0' & (A xor B);

first : entity work.full_adder(bhv)
	port map(
				X 		=> A(0),
				Y 		=> B(0),
				Cin 	=> OP,
				sum 	=> SUM(0),
				Cout 	=> C(1));

gen : for i in 1 to X generate begin

	a1 : entity work.full_adder(bhv)
		port map(
				X 		=> A(i),
				Y 		=> B(i),
				Cin 	=> C(i),
				sum 	=> SUM(i),
				Cout 	=> C(i+1)
				);
	
	end generate gen;

end arch;