library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Reg_3bit_TB is
--  Port ( );
end Reg_3bit_TB;

architecture Behavioral of Reg_3bit_TB is
component Reg_3bit is
    Port ( D : in STD_LOGIC_VECTOR (2 downto 0):="000";
           Res : in STD_LOGIC;
           Clk : in STD_LOGIC;
           Q : out STD_LOGIC_VECTOR (2 downto 0):="000");
end component;

signal D : STD_LOGIC_VECTOR (2 downto 0);
signal Res : STD_LOGIC;
signal Clk : STD_LOGIC:='1';
signal Q : STD_LOGIC_VECTOR (2 downto 0);

begin
UUT : Reg_3bit
port map(
    D => D,
    Res =>Res,
    Clk => Clk,
    Q => Q
);

process begin
Clk <= not Clk;
wait for 20ns;
end process;

process begin
 D<= "010";
 wait for 200ns;
 
 D<= "001";
 Res <= '1';
 wait for 50ns;
end process;
end Behavioral;