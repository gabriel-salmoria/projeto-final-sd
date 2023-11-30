library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ULA_BO is
  Port ( inA: in STD_LOGIC_VECTOR(31 downto 0);
         InB: in STD_LOGIC_VECTOR(31 downto 0);
			seletor: in std_logic_vector(2 downto 0);
         OutS: out STD_LOGIC_VECTOR(64 downto 0)
         );
			
end ULA_BO;

architecture datapath of ULA_BO is

    signal saidamuxi, entradamuxfinal, saidaaddsub, saidaandor: std_logic_vector(31 downto 0);
    signal saidaula, saidamult: std_logic_vector (31 downto 0);
    signal comparacao, saida_slt, ultimo_mux: std_logic;
    signal saida_ula_ext, saida_final, saida_mult: std_logic_vector (64 downto 0);
    
    component and_or
        generic(x : integer);
        port(A, B : in std_logic_vector(x-1 downto 0);
          OP : in std_logic;
          RESULT : out std_logic_vector(x-1 downto 0)
            );
    end component;

    component addsub
        generic(x : integer);
        port(A, B : in std_logic_vector(x-1 downto 0);
          OP : in std_logic;
          SUM : out std_logic_vector(x-1 downto 0)
            );
    end component;
    
    component slt
        generic(x : integer);
        port(A, B : in std_logic_vector(x-1 downto 0);
            RESULT : out std_logic
                );
    end component;
    
    component mux_2x1
	GENERIC (
		N : INTEGER);
	PORT (
		E0 : IN std_logic_vector(N - 1 DOWNTO 0);
		E1 : IN std_logic_vector(N - 1 DOWNTO 0);
		sel : IN std_logic;
		saida : OUT std_logic_vector(N - 1 DOWNTO 0)
		);
    end component;
	 
	component multiplicador IS
		PORT (
			A: IN std_logic_vector(31 DOWNTO 0);
			B: IN std_logic_vector(31 DOWNTO 0);
			saida : OUT std_logic_vector(64 downto 0));
	end component;
    
begin
		
	with seletor select comparacao <= '1' when "111",
											    '0' when others;
												 
	with seletor select ultimo_mux <= '1' when "011",
												 '0' when others;
    
    
    somasubtrat: addsub generic map(32) port map(inA, inB, seletor(2), saidaaddsub);
    
    blocoand_or: and_or generic map(32) port map(inA, inB, seletor(0), saidaandor);
	 
	 slt_block : slt generic map(32) port map(inA, inB, saida_slt);
    
	 mult_block : multiplicador port map(inA, inB, saida_mult);
    --mux para escolher entre and/or e soma/sub
    
    mux2x1_i: mux_2x1 generic map(32) port map (saidaandor, saidaaddsub, seletor(1), saidamuxi);
   
    
    -- mux para pegar a saida S
	 saida_ula_ext <= "000000000000000000000000000000000" & saidaula;
	 entradamuxfinal <= "0000000000000000000000000000000" & saida_slt;
    mux2x1_iii: mux_2x1 generic map(32) port map(saidamuxi, entradamuxfinal, comparacao , saidaula);
    
    mux2x1_iv: mux_2x1 generic map(65) port map(saida_ula_ext, saida_mult, ultimo_mux, saida_final);
    
outS <= saida_final;

end datapath;
