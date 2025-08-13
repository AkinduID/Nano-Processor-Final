library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Slow_Clock is
    Port ( Clk_In : in STD_LOGIC;
           Clk_Out : out STD_LOGIC);
end Slow_Clock;


architecture Behavioral of Slow_Clock is
signal count : integer := 1;
signal clock_status : STD_LOGIC:= '0';

begin
process(Clk_In) 
    begin
    if rising_edge(Clk_In) then
        count <= count+1;
        if (count = 30000000) then
            clock_status <= not clock_status;
            Clk_Out <= not clock_status;
            count <=1;
        end if;
    end if;
end process;
end Behavioral;
