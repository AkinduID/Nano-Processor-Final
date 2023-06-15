library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Mux_2_to_1_3bit_TB is
--  Port ( );
end Mux_2_to_1_3bit_TB;

architecture Behavioral of Mux_2_to_1_3bit_TB is

component Mux_2_to_1_3bit
Port ( S : in STD_LOGIC;
       D0 : in STD_LOGIC_VECTOR (2 downto 0);
       D1 : in STD_LOGIC_VECTOR (2 downto 0);
       Y : out STD_LOGIC_VECTOR (2 downto 0));
end component;

signal S : STD_LOGIC;
signal D0 : STD_LOGIC_VECTOR (2 downto 0):="0000";
signal D1 : STD_LOGIC_VECTOR (2 downto 0):="0010";
signal Y : STD_LOGIC_VECTOR (2 downto 0);

begin
UUT:Mux_2_to_1_3bit
port map(
    S => S,
    D0 => D0,
    D1 => D1,
    Y => Y
);

process begin
S <= '1';
wait for 50ns;

S <= '0';
wait for 50ns;

end process;

end Behavioral;
