library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ASU_4bit_TB is
--  Port ( );
end ASU_4bit_TB ;

architecture Behavioral of ASU_4bit_TB  is

component ASU_4bit
Port ( A : in STD_LOGIC_VECTOR (3 downto 0);
       B : in STD_LOGIC_VECTOR (3 downto 0);
       Ctrl : in STD_LOGIC;
       C_out : out STD_LOGIC;
       S : out STD_LOGIC_VECTOR (3 downto 0);
       Zero : out STD_LOGIC);
end component;

signal A : STD_LOGIC_VECTOR (3 downto 0);
signal B : STD_LOGIC_VECTOR (3 downto 0);
signal Ctrl : STD_LOGIC;
signal C_out : STD_LOGIC;
signal S : STD_LOGIC_VECTOR (3 downto 0);
signal Zero : STD_LOGIC;
begin

UUT: ASU_4bit
port map(
    A => A,
    B => B,
    Ctrl => Ctrl,
    C_out => C_out,
    S => S,
    Zero => Zero
);

process begin
A <= "0010";
B <= "0100";
Ctrl <= '1';
wait for 100ns;

A <= "0010";
B <= "0100";
Ctrl <= '0';
wait for 100ns;

end process;

end Behavioral;
