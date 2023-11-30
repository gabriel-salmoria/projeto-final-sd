library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ULA_Controle is
  Port (
    funct     	: in  STD_LOGIC_VECTOR(5 downto 0);
	 seletor		: out std_LOGIC_VECTOR(2 downto 0)
  );
end ULA_Controle;

architecture Behavioral of ULA_Controle is

    signal selector: std_logic_vector (2 downto 0);
    signal entradaA, entradaB: std_logic_vector(31 downto 0);
    signal saidaS: std_logic_vector(64 downto 0);

    
begin
    
  process (funct)
  begin
	  case funct is
	  	 when "100000" =>
			-- Operação add
			selector <= "010";
			
		 when "100010" =>
			-- Operação sub
			selector <= "110";
			
		 when "100100" =>
			-- Operação and
			selector <= "000";
			
		 when "100101" =>
			-- Operação OR
			selector <= "001";
			
		 when "101010" =>
			-- Operação SLT
			selector <= "111";
			
		 when "111111" =>
			-- Operação SLT
			selector <= "011";
			  
		 when others =>
			selector <= "100";
	  end case;

  end process;

seletor <= selector;

end Behavioral;
