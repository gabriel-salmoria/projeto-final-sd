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
signal ends : std_logic_vector(1 downto 0);

begin

sub : entity work.addsub(arch)
		port map(
				A 		=> A,
				B 		=> B,
				OP 	=> '1',
				SUM 	=> temp
				);

ends <= a(x-1) & b(x-1);

with ends select result <= temp(x-1) when "00",
						        '0' when "01",
								'1' when "10",
						temp(x-1) when "11";

end arch;