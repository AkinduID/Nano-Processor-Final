library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity Adder_3bit_TB is
--  Port ( );
end Adder_3bit_TB;

architecture Behavioral of Adder_3bit_TB is

component Adder_3bit
Port ( A : in STD_LOGIC_VECTOR (2 downto 0);
       En : in STD_LOGIC;
       S : out STD_LOGIC_VECTOR (2 downto 0));
end component;

signal A : STD_LOGIC_VECTOR(2 downto 0);
signal En : STD_LOGIC;
signal S : STD_LOGIC_VECTOR (2 downto 0);

begin
UUT: Adder_3bit
port map(
    A => A,
    En => En,
    S => S
);

process begin
A <= "010";
En <= '1';
wait for 100ns;

A <= "011";
wait for 100ns;
end process;

end Behavioral;
