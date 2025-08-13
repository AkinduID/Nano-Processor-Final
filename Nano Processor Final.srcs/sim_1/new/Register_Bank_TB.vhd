library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Register_Bank_TB is
--  Port ( );
end Register_Bank_TB;

architecture Behavioral of Register_Bank_TB is

component Register_Bank
Port ( En : in STD_LOGIC:='1';
       Clk : in STD_LOGIC;
       Res : in STD_LOGIC;
       Reg_En : in STD_LOGIC_VECTOR (2 downto 0);
       Reg_Input : in STD_LOGIC_VECTOR (3 downto 0));
end component;

signal En : STD_LOGIC;
signal Clk : STD_LOGIC:='1';
signal Res : STD_LOGIC;
signal Reg_En : STD_LOGIC_VECTOR (2 downto 0);
signal Reg_Input: STD_LOGIC_VECTOR (3 downto 0);


begin
UUT: Register_Bank
port map(
    En=> En,
    Clk => Clk,
    Res => Res,
    Reg_En => Reg_En,
    Reg_Input => Reg_Input
);

process begin
Clk <= not(Clk);
wait for 50ns;
end process;

process begin

wait for 150ns;
En <= '1';
Reg_En <= "000";
Res <= '1';
wait for 150ns;

Res <= '0';
Reg_En <= "011";
Reg_Input <= "0001";
wait for 150ns;

Reg_En <= "100";
Reg_Input <= "0010";
wait for 150ns;

Reg_En <= "101";
Reg_Input <= "0111";
wait for 150ns;
 
Reg_En<= "011";
Reg_Input <= "0010";
wait for 150ns;
 
end process;
end Behavioral;
