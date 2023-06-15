----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/12/2023 09:21:35 AM
-- Design Name: 
-- Module Name: Reg_4bit_TB - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Reg_4bit_TB is
--  Port ( );
end Reg_4bit_TB;

architecture Behavioral of Reg_4bit_TB is
component Reg_4bit is
    Port ( D : in STD_LOGIC_VECTOR (3 downto 0);
           Clk : in STD_LOGIC;
           Res : in STD_LOGIC;
           En : in STD_LOGIC;
           Q : out STD_LOGIC_VECTOR (3 downto 0):="0000");
end component;

signal D : STD_LOGIC_VECTOR (3 downto 0);
signal En : STD_LOGIC;
signal Clk : STD_LOGIC:='1';
signal Res : STD_LOGIC;
signal Q : STD_LOGIC_VECTOR (3 downto 0);

begin
UUT: Reg_4bit
port map(
    D => D,
    En => En,
    Res => Res,
    Clk => Clk,
    Q => Q
);

process
begin
Clk <= not(Clk);
wait for 50ns;
end process;

process
begin
En <= '1';
Res <= '1';
wait for 100ns;

En <= '1';
Res <= '0';
D <= "0101";
wait for 100ns;

En <= '0';
Res <= '0';
D <= "1101";
wait for 100ns;
end process;

end Behavioral;
