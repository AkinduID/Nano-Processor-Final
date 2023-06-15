library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Adder_3bit is
    Port ( A : in STD_LOGIC_VECTOR (2 downto 0);
           En : in STD_LOGIC;
           S : out STD_LOGIC_VECTOR (2 downto 0)
           );
end Adder_3Bit;

architecture Behavioral of Adder_3bit is

component FA 
 port ( 
 A: in std_logic; 
 B: in std_logic; 
 C_in: in std_logic; 
 S: out std_logic;
 C_out: out std_logic
 ); 
 end component; 
 
signal C0, C1, C2, X0, X1, X2: STD_LOGIC;
signal B: std_logic_vector(2 downto 0);

begin 
FA_0 : FA 
 port map ( 
 A => A(0), 
 B => B(0), 
 C_in => '0', -- Set to ground 
 S => S(0), 
 C_Out => C0); 
 
FA_1 : FA 
 port map ( 
 A => A(1), 
 B => B(1), 
 C_in => C0, 
 S => S(1), 
 C_Out => C1); 
 
FA_2 : FA 
 port map ( 
 A => A(2), 
 B => B(2), 
 C_in => C1, 
 S => S(2), 
 C_Out => C2); 
 
 B <= "001";
 
end Behavioral; 
