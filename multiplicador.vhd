LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY multiplicador IS
	PORT (
		A: IN std_logic_vector(31 DOWNTO 0);
		B: IN std_logic_vector(31 DOWNTO 0);
		saida : OUT std_logic_vector(63 downto 0));

end multiplicador;

architecture circuito of multiplicador is

signal zero, quarta_soma1, quarta_soma2, resultado_final: std_logic_vector(63 downto 0);
signal saida_mux: std_logic_vector(2047 downto 0);
signal soma0: std_logic_vector(1023 downto 0);
signal soma1: std_logic_vector(511 downto 0);
signal soma2: std_logic_vector(255 downto 0);

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
begin
   zero <= (others => '0');
	
	mux: for i in 0 to 31 generate begin
		multiplexador: mux_2x1 generic map(64) port map(zero, 
		
		(i=>B(0), i+1=>B(1), i+2=>B(2), i+3=>B(3), i+4=>B(4), i+5=>B(5), i+6=>B(6), i+7=>B(7), i+8=>B(8), i+9=>B(9), i+10=>B(10),
		i+11=>B(11), i+12=>B(12), i+13=>B(13), i+14=>B(14), i+15=>B(15), i+16=>B(16), i+17=>B(17), i+18=>B(18), i+19=>B(19), i+20=>B(20),
		i+21=>B(21), i+22=>B(22), i+23=>B(23), i+24=>B(24), i+25=>B(25), i+26=>B(26), i+27=>B(27), i+28=>B(28), i+29=>B(29), i+30=>B(30), i+31=>B(31),
		others =>'0')
		,A(i),saida_mux(63+(i*64) downto (i*64)));
	end generate mux;
	
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
	quisomador: somador generic map(64) port map(quarta_soma1, quarta_soma2, resultado_final);
	
	saida <= resultado_final;
	
end circuito;