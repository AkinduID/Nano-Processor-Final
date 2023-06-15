library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Decoder_2_to_4_TB is
--  Port ( );
end Decoder_2_to_4_TB;

architecture Behavioral of Decoder_2_to_4_TB is
component Decoder_2_to_4 is
    Port ( I : in STD_LOGIC_VECTOR (1 downto 0);
           En : in STD_LOGIC;
           Y : out STD_LOGIC_VECTOR (3 downto 0));
end component;

signal I : STD_LOGIC_VECTOR (1 downto 0);
signal En : STD_LOGIC;
signal Y : STD_LOGIC_VECTOR (3 downto 0);

begin
UUT: Decoder_2_to_4
port map(
    I => I,
    En => En,
    Y => Y
);

process begin
En <= '1';
I <= "01";
wait for 100ns;
end process;
end Behavioral;