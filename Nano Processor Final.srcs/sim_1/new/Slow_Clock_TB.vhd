library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Slow_Clock_TB is
--  Port ( );
end Slow_Clock_TB;

architecture Behavioral of Slow_Clock_TB is

component Slow_Clock
Port ( Clk_In : in STD_LOGIC;
       Clk_Out : out STD_LOGIC);
end component;

signal Clk_In: STD_LOGIC :='1';
signal Clk_Out : STD_LOGIC:='0';

begin
UUT: Slow_Clock
port map(
    Clk_In => Clk_In,
    Clk_Out => Clk_Out);
    
process begin
Clk_In <= not(Clk_In);
wait for 50ns;
end process;
    

end Behavioral;
