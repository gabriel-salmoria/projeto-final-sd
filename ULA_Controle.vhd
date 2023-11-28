library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ULA_Controle is
  Port (
    ULAop     : in  STD_LOGIC_VECTOR(1 downto 0);
    funct     : in  STD_LOGIC_VECTOR(5 downto 0);
    dataA     : out STD_LOGIC_VECTOR(31 downto 0);
    dataB     : out STD_LOGIC_VECTOR(31 downto 0);
    enRegA, enRegB, enRegC, reset, clock : in std_logic;
    dataC     : out STD_LOGIC_VECTOR(31 downto 0)
  );
end entity ULA_Controle;

architecture Behavioral of ULA_Controle is

    signal registradorA, registradorB, registradorC: STD_LOGIC_VECTOR(31 downto 0);
    signal regSoma, regSub, regAnd, regOr, regSLT: std_logic_vector (31 downto 0);
  
    component and_or
        generic(x : integer := 32);
        port(A, B : in std_logic_vector(x-1 downto 0);
          OP : in std_logic;
          RESULT : out std_logic_vector(x-1 downto 0)
            );
    end component;

    component addsub
        generic(x : integer := 32);
        port(A, B : in std_logic_vector(x-1 downto 0);
          OP : in std_logic;
          SUM : out std_logic_vector(x-1 downto 0)
            );
    end component;
    
    component slt
        generic(x : integer := 32);
        port(A, B : in std_logic_vector(x-1 downto 0);
            RESULT : out std_logic
                );
    end component;
    
begin

    Soma: addsub generic map(32) port map (A => registradorA, B => registradorB, OP => '0', SUM => regsoma); -- 0 para adição
    Subtracao: addsub generic map(32) port map (A => registradorA, B => registradorB, OP => '1', SUM => regsub); -- 1 para sub
    AndLogic: and_or port map (A => registradorA, B => registradorB, OP => '0', RESULT => regand); -- 0 para and
    OrLogic: and_or port map (A => registradorA, B => registradorB, OP => '1', RESULT => regor); -- 1 para or
    SLTLogic: slt port map (A => registradorA, B => registradorB, RESULT => regslt(0)  -- Verifico apenas olhando o bit menos significativo
    );
    
  process (clock, reset)
  begin
    if reset = '1' then
     -- Zerar os registradores em caso de reset = 1
      registradorA <= "00000000000000000000000000000000";
      registradorB <= "00000000000000000000000000000000";
      registradorC <= "00000000000000000000000000000000";
      
      
    elsif rising_edge(clock) then
      -- Atualizar registradores com dados dos registradores de entrada quando enable = 1
      
      if enRegA = '1' then
        dataA <= registradorA;
      end if;

      if enRegB = '1' then
        dataB <= registradorB;
      end if;

      if enRegC = '1' then
        dataC <= registradorC;
      end if;
      
    end if;
  end process;

  process (ULAop, funct)
  begin

    -- Lógica de funcionamento da ULA de acordo com as entradas aqui:
    
      case ULAop is
    
      when "00" =>
      
        dataC <= regsoma;  
       
      when "01" =>
      
        -- Operação de subtração
        dataC <= regsub;
        
      when "10" =>
        -- A partir de agora dependeremos do funct para saber a operação
        case funct is
          when "100100" =>
            -- Operação and
            dataC <= regand;
            
          when "100101" =>
            -- Operação OR
            dataC <= regOR;
            
          when "101010" =>
            -- Operação SLT
            dataC(0) <= regSLT(0);
              
          when others =>
            dataC <= (others => '0');
        end case;

      when others =>
        dataC <= (others => '0');
    end case;
  end process;

end Behavioral;
