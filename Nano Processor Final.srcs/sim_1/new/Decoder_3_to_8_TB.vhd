library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Decoder_3_to_8_TB is
--  Port ( );
end Decoder_3_to_8_TB;

architecture Behavioral of Decoder_3_to_8_TB is
component Decoder_3_to_8 is
    Port ( I : in STD_LOGIC_VECTOR (2 downto 0);
           En : in STD_LOGIC;
           Y : out STD_LOGIC_VECTOR (7 downto 0));
end component;

signal I : STD_LOGIC_VECTOR (2 downto 0);
signal En : STD_LOGIC;
signal Y : STD_LOGIC_VECTOR (7 downto 0);

begin
UUT: Decoder_3_to_8
port map(
    I => I,
    En => En,
    Y => Y
);

process begin
En <= '1';
I <= "101";
wait for 100ns;
end process;
end Behavioral;