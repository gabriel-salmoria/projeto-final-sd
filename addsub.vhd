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

C(0) <= OP;

subtraction: for i in 0 to x-1 generate
	sB(i) <= B(i) xor OP;
end generate subtraction;

gen : for i in 0 to x-1 generate begin
	a1 : entity work.full_adder(bhv)
		port map(
				X 		=> A(i),
				Y 		=> sB(i),
				Cin 	=> C(i),
				sum 	=> SUM(i),
				Cout 	=> C(i+1)
				);
	
	end generate gen;

end arch;