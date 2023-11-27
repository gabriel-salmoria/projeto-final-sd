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

    signal registradorA, registradorB, registradorC : STD_LOGIC_VECTOR(31 downto 0);
  
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
        registradorA <= dataA;
      end if;

      if enRegB = '1' then
        registradorB <= dataB;
      end if;

      if enRegC = '1' then
        registradorC <= dataC;
      end if;
      
    end if;
  end process;

  process (ULAop, funct, registradorA, registradorB)
  begin

    -- Lógica de funcionamento da ULA de acordo com as entradas aqui:
    
    case ULAop is
    
      when "00" =>
      
      Soma: addsub
        generic map(x => 32)
        port map(A   => registradorA,
               B   => registradorB,
               OP  => '0',  -- '0' para adição
               SUM => dataC);
       
      when "01" =>
        -- Operação de subtração
        Subtracao: addsub
            generic map(x => 32)
            port map (
            A   => registradorA,
            B   => registradorB,
            OP  => '1',  -- '1' para subtração
            SUM => dataC);
        
      when "10" =>
        -- A partir de agora dependeremos do funct para saber a operação
        case funct is
          when "100100" =>
            -- Operação and
            AndLogic: and_or
                generic map(x => 32)
                port map (
                A      => registradorA,
                B      => registradorB,
                OP     => '0',  -- '0' para AND
                RESULT => dataC);
            
          when "100101" =>
            -- Operação OR
            OrLogic: and_or
                generic map(x => 32)
                port map (
                A      => registradorA,
                B      => registradorB,
                OP     => '1',  -- '1' para OR
                RESULT => dataC);
            
          when "101010" =>
            -- Operação SLT
            SLTLogic: slt
                generic map(x => 32)
                port map (
                A      => registradorA,
                B      => registradorB,
                RESULT => dataC(0)  -- Verifico apenas olhando o bit menos significativo
              );
              
          when others =>
            dataC <= (others => '0');
        end case;

      when others =>
        dataC <= (others => '0');
    end case;
  end process;

end architecture Behavioral;
