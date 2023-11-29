library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity toplevel is
  Port ( A: in STD_LOGIC_VECTOR(31 downto 0);
         B: in STD_LOGIC_VECTOR(31 downto 0);
         S: in STD_LOGIC_VECTOR(64 downto 0)
  );
end toplevel;

architecture main of toplevel is

    signal seletor: std_logic_vector(2 downto 0);
    signal selOp: std_logic_vector(1 downto 0);
    signal fnct: std_logic_vector(5 downto 0);
    
    
    component ULA_BO
      Port ( inA: in STD_LOGIC_VECTOR(31 downto 0);
         InB: in STD_LOGIC_VECTOR(31 downto 0);
         OutS: in STD_LOGIC_VECTOR(64 downto 0);
         seletor: std_logic_vector(2 downto 0)
            );
    end component;
    
    component ULA_Controle
      Port (
        ULAop     : in  STD_LOGIC_VECTOR(1 downto 0);
        funct     : in  STD_LOGIC_VECTOR(5 downto 0)
  );
    end component;

begin

bo: ULA_BO port map (inA => A, inB => B, OutS => S, seletor => seletor);

controle: ULA_Controle port map (ULAop => selOp, funct => fnct);


end main;
