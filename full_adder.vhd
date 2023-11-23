library ieee;
use ieee.std_logic_1164.all;

entity Full_Adder is
   port( X, Y, Cin : in std_logic;
         sum, Cout : out std_logic);
end Full_Adder;
 
architecture bhv of Full_Adder is
begin
   sum <= (X xor Y) xor Cin;
   Cout <= (X and (Y or Cin)) or (Cin and Y);
end bhv;
