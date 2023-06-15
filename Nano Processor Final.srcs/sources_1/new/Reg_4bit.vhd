library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Reg_4bit is
    Port ( D : in STD_LOGIC_VECTOR (3 downto 0);
           Clk : in STD_LOGIC;
           Res : in STD_LOGIC;
           En : in STD_LOGIC;
           Q : out STD_LOGIC_VECTOR (3 downto 0):="0000");
end Reg_4bit ;

architecture Behavioral of Reg_4bit  is

begin
process(Clk) begin
if (rising_edge(Clk)) then
    if( Res = '1') then
        Q <= "0000";
    elsif (En = '1') then
        Q <= D;
    end if;
end if;
end process;
end Behavioral;
