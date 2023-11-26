library ieee;
use ieee.std_logic_1164.all;

entity and_or is
	generic(x : integer := 32);
	port(A, B : in std_logic_vector(x-1 downto 0);
		  OP : in std_logic;
		  RESULT : out std_logic_vector(x-1 downto 0)
			);

end and_or;

architecture arch of and_or is

signal and_result : std_logic_vector(x-1 downto 0);
signal or_result : std_logic_vector(x-1 downto 0);

begin

and_result <= A and B;
or_result <= A or B;

with OP select RESULT <=
		and_result when '0',
		or_result when '1';
						
end arch;