library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Mux_2_to_1_4bit is
    Port (
        S : in STD_LOGIC;  
        D0 : in STD_LOGIC_VECTOR(3 downto 0);  
        D1 : in STD_LOGIC_VECTOR(3 downto 0);  
        Y  : out STD_LOGIC_VECTOR(3 downto 0)
    );
end Mux_2_to_1_4bit;

architecture Behavioral of Mux_2_to_1_4bit is
begin
Y <= D0 when S ='0' else D1;
end Behavioral;
