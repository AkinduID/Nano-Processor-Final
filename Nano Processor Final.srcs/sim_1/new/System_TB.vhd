library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity System_TB is
--  Port ( );
end System_TB;

architecture Behavioral of System_TB is

component System 
    Port ( Clk : in STD_LOGIC;
           Reset_Push : in STD_LOGIC;
           Seg_7 : out STD_LOGIC_VECTOR (6 downto 0);
           Overflow : out STD_LOGIC;
           Reg_7 : out STD_LOGIC_VECTOR(3 downto 0);
           Zero : out STD_LOGIC);
end component;

signal Clk : STD_LOGIC:='0';
signal Reset_Push : STD_LOGIC:='0';
signal Seg_7 : STD_LOGIC_VECTOR (6 downto 0);
signal Overflow : STD_LOGIC;
signal Zero : STD_LOGIC;
signal Reg_7 : STD_LOGIC_VECTOR(3 downto 0);

begin
UUT: System
port map(
     Clk => Clk,
     Reset_Push => Reset_Push,
     Seg_7 => Seg_7,
     Overflow => Overflow,
     Zero=> Zero,
     Reg_7 => Reg_7
);

process begin
Clk <= not Clk;
wait for 2ns;
end process;

process begin
wait for 300ns;


Reset_Push <= '1';
wait for 40ns;
Reset_Push<= '0';
wait for 150ns;
Reset_Push <= '1';
wait for 40ns;
Reset_Push<= '0';
end process;

end Behavioral;
