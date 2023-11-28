LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use IEEE.std_logic_unsigned.all;

ENTITY multiplicador IS
	PORT (
		A: IN std_logic_vector(31 DOWNTO 0);
		B: IN std_logic_vector(31 DOWNTO 0);
		saida : OUT std_logic_vector(64 downto 0));

end multiplicador;

architecture circuito of multiplicador is

signal zero, quarta_soma1, quarta_soma2, resultado: std_logic_vector(63 downto 0);
signal saida_mux: std_logic_vector(2047 downto 0);
signal soma0: std_logic_vector(1023 downto 0);
signal soma1: std_logic_vector(511 downto 0);
signal soma2: std_logic_vector(255 downto 0);
signal notA, notB, saida_muxA, saida_muxB: std_logic_vector(31 downto 0);
signal resultado_final_positivo, resultado_final_negativo, resultado_final: std_logic_vector(64 downto 0);
signal sinal: std_logic;

component somador IS
GENERIC (
N : INTEGER);
PORT (
	A : IN std_logic_vector(N - 1 DOWNTO 0);
	B: IN std_logic_vector(N - 1 DOWNTO 0);
	sum : OUT std_logic_vector(N - 1 DOWNTO 0));
END component;

component mux_2x1 IS
	GENERIC (
		N : INTEGER);
	PORT (
		E0 : IN std_logic_vector(N - 1 DOWNTO 0);
		E1 : IN std_logic_vector(N - 1 DOWNTO 0);
		sel : IN std_logic;
		saida : OUT std_logic_vector(N - 1 DOWNTO 0));

end component;

component mux_2x1_1bit IS
	PORT (
		E0 : IN std_logic;
		E1 : IN std_logic;
		sel : IN std_logic;
		saida : OUT std_logic);

end component;

begin
   zero <= (others => '0');
	notA <= not(A) + "00000000000000000000000000000001";
	notB <= not(B) + "00000000000000000000000000000001";
	sinal <= A(31) xor B(31);

	multiplexadorB: mux_2x1 generic map(32) port map(B, notB, B(31), saida_muxB);	
 
   muxA: for m in 0 to 31 generate begin
		multiplexadorA: mux_2x1_1bit port map (A(m), notA(m), A(31), saida_muxA(m));
	end generate muxA;

 
	  muxsoma: for i in 0 to 31 generate begin
		multiplexador: mux_2x1 generic map(64) port map(zero, 
		
		(i=>saida_muxB(0), i+1=>saida_muxB(1), i+2=>saida_muxB(2), i+3=>saida_muxB(3), i+4=>saida_muxB(4), i+5=>saida_muxB(5), i+6=>saida_muxB(6), i+7=>saida_muxB(7), i+8=>saida_muxB(8), i+9=>saida_muxB(9), i+10=>saida_muxB(10),
		i+11=>saida_muxB(11), i+12=>saida_muxB(12), i+13=>saida_muxB(13), i+14=>saida_muxB(14), i+15=>saida_muxB(15), i+16=>saida_muxB(16), i+17=>saida_muxB(17), i+18=>saida_muxB(18), i+19=>saida_muxB(19), i+20=>saida_muxB(20),
		i+21=>saida_muxB(21), i+22=>saida_muxB(22), i+23=>saida_muxB(23), i+24=>saida_muxB(24), i+25=>saida_muxB(25), i+26=>saida_muxB(26), i+27=>saida_muxB(27), i+28=>saida_muxB(28), i+29=>saida_muxB(29), i+30=>saida_muxB(30), i+31=>saida_muxB(31),
		others =>'0')
		,saida_muxA(i),saida_mux(63+(i*64) downto (i*64)));
	end generate muxsoma;
	
	primeira_soma: for j in 0 to 15 generate begin
		prisomador: somador generic map(64)port map(saida_mux(63+(128*j) downto (128*j)), saida_mux(127+(128*j) downto 64+(128*j)), soma0(63+(64*j) downto 64*j));
	end generate primeira_soma;
	
	segunda_soma: for k in 0 to 7 generate begin
		segsomador: somador generic map(64) port map(soma0(63+(k*128) downto (128*k)), soma0(127+(128*k) downto 64+(128*k)), soma1(63+(64*k) downto 64*k));
	end generate segunda_soma;
	
	terceira_soma: for l in 0 to 3 generate begin
		tersomador: somador generic map(64) port map(soma1(63+(l*128) downto (128*l)), soma1(127+(128*l) downto 64+(128*l)), soma2(63+(64*l) downto 64*l));
	end generate terceira_soma;
	
	quasomador1: somador generic map(64) port map(soma2(63 downto 0), soma2(127 downto 64), quarta_soma1);
	quasomador2: somador generic map(64) port map(soma2(191 downto 128), soma2(255 downto 192), quarta_soma2);
	quisomador: somador generic map(64) port map(quarta_soma1, quarta_soma2, resultado);
	
	resultado_final_positivo <= '0' & resultado;
	resultado_final_negativo <= not(resultado_final_positivo) + "00000000000000000000000000000000000000000000000000000000000000001";
	
	muxsaida: mux_2x1 generic map(65) port map(resultado_final_positivo, resultado_final_negativo, sinal, resultado_final);
	
	saida <= resultado_final;
	
end circuito;