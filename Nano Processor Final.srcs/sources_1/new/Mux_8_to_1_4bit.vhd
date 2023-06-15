library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Mux_8_to_1_4bit is
    Port (
           R0 : in STD_LOGIC_VECTOR(3 downto 0);          
           R1 : in STD_LOGIC_VECTOR(3 downto 0);          
           R2 : in STD_LOGIC_VECTOR(3 downto 0);          
           R3 : in STD_LOGIC_VECTOR(3 downto 0);          
           R4 : in STD_LOGIC_VECTOR(3 downto 0);          
           R5 : in STD_LOGIC_VECTOR(3 downto 0);          
           R6 : in STD_LOGIC_VECTOR(3 downto 0);          
           R7 : in STD_LOGIC_VECTOR(3 downto 0);          

           Sel : in STD_LOGIC_VECTOR (2 downto 0);
           Output : out STD_LOGIC_VECTOR (3 downto 0));
end Mux_8_to_1_4bit;

architecture Behavioral of Mux_8_to_1_4bit is

begin   
Output <= R0 when Sel="000" else
     R1 when Sel="001" else
     R2 when Sel="010" else
     R3 when Sel="011" else
     R4 when Sel="100" else
     R5 when Sel="101" else
     R6 when Sel="110" else
     R7 when Sel="111" ;    
end Behavioral;