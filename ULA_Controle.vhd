library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ULA_Controle is
  Port (
    ULAop     : in  STD_LOGIC_VECTOR(1 downto 0);
    funct     : in  STD_LOGIC_VECTOR(5 downto 0)
  );
end ULA_Controle;

architecture Behavioral of ULA_Controle is

    signal selector: std_logic_vector (2 downto 0);
    signal entradaA, entradaB: std_logic_vector(31 downto 0);
    signal saidaS: std_logic_vector(64 downto 0);


    component ULA_BO
      Port ( inA: in STD_LOGIC_VECTOR(31 downto 0);
         InB: in STD_LOGIC_VECTOR(31 downto 0);
         OutS: in STD_LOGIC_VECTOR(64 downto 0);
         seletor: std_logic_vector(2 downto 0)
         );
    end component;

    
begin

    operativo_ula: ULA_BO port map (inA => entradaA, inB => entradaB, OutS => saidaS, seletor => selector);
    
  process (ULAop, funct)
  begin

    -- Lógica de funcionamento da ULA de acordo com as entradas aqui:
    
      case ULAop is
    
      when "00" =>
        selector <= "010";

       
      when "01" =>
        -- Operação de subtração
        selector <= "110";
        
      when "10" =>
        -- A partir de agora dependeremos do funct para saber a operação
        case funct is
          when "100100" =>
            -- Operação and
            selector <= "000";
            
          when "100101" =>
            -- Operação OR
            selector <= "001";
            
          when "101010" =>
            -- Operação SLT
            selector <= "111";
              
          when others =>
            selector <= "100";
        end case;

        
      when "11" => -- Aqui ele fará a multiplicação
        selector <= "011";
        
      when others =>
        selector <= "100";
    end case;
  end process;

end Behavioral;
