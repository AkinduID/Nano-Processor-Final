library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Reg_3bit is
    Port ( D : in STD_LOGIC_VECTOR (2 downto 0):="000";
           Res : in STD_LOGIC;
           Clk : in STD_LOGIC;
           Q : out STD_LOGIC_VECTOR (2 downto 0):="000");
end Reg_3bit;

architecture Behavioral of Reg_3bit is

begin

process(Clk) begin
if(rising_edge(Clk)) then
    if(Res ='1') then
        Q <= "000";
    else
        Q <= D;
    end if;
end if;
end process;

end Behavioral;
