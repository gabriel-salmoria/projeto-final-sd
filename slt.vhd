library ieee;
use ieee.std_logic_1164.all;

entity SLT is
	generic(x : integer := 32);
	port(A, B : in std_logic_vector(x-1 downto 0);
		  RESULT : out std_logic
			);
			
end SLT;

architecture arch of SLT is

signal temp : std_logic_vector(x-1 downto 0);


begin

sub : entity work.addsub(arch)
		port map(
				A 		=> A,
				B 		=> B,
				OP 	=> '1',
				SUM 	=> temp
				);
				
RESULT <= temp(x-1);

end arch;