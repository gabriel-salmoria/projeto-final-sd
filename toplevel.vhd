library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity toplevel is
  Port ( A: in STD_LOGIC_VECTOR(31 downto 0);
         B: in STD_LOGIC_VECTOR(31 downto 0);
			fnct: in std_logic_vector(5 downto 0); 
         S: out STD_LOGIC_VECTOR(64 downto 0)
  );
end toplevel;

architecture main of toplevel is

    signal seletor1: std_logic_vector(2 downto 0);
    
    
    component ULA_BO
      Port (inA: in STD_LOGIC_VECTOR(31 downto 0);
				InB: in STD_LOGIC_VECTOR(31 downto 0);
			   seletor: in std_logic_vector(2 downto 0);
				OutS: out STD_LOGIC_VECTOR(64 downto 0)
            );
    end component;
    
    component ULA_Controle
      Port (
        funct     : in  STD_LOGIC_VECTOR(5 downto 0);
		  seletor	: out std_LOGIC_VECTOR(2 downto 0)
  );
    end component;

begin

bo: ULA_BO port map (inA => A, inB => B, seletor => seletor1, OutS => S);

controle: ULA_Controle port map (funct => fnct, seletor => seletor1);


end main;
