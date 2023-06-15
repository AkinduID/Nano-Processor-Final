library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Mux_8_to_1_4bit_TB is
--  Port ( );
end Mux_8_to_1_4bit_TB;

architecture Behavioral of Mux_8_to_1_4bit_TB is

component Mux_8_to_1_4bit
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
end component;

signal R0 : STD_LOGIC_VECTOR(3 downto 0):="0000";          
signal R1 : STD_LOGIC_VECTOR(3 downto 0):="0001";          
signal R2 : STD_LOGIC_VECTOR(3 downto 0):="0010";          
signal R3 : STD_LOGIC_VECTOR(3 downto 0):="0011";          
signal R4 : STD_LOGIC_VECTOR(3 downto 0):="0100";          
signal R5 : STD_LOGIC_VECTOR(3 downto 0):="0101";          
signal R6 : STD_LOGIC_VECTOR(3 downto 0):="0110";          
signal R7 : STD_LOGIC_VECTOR(3 downto 0):="0111";          

signal Sel : STD_LOGIC_VECTOR (2 downto 0);
signal Output : STD_LOGIC_VECTOR (3 downto 0);

begin
UUT: Mux_8_to_1_4bit
port map(
    R0 => R0,         
    R1 => R1,          
    R2 => R2,         
    R3 => R3,          
    R4 => R4,         
    R5 => R5,        
    R6 => R6,        
    R7 => R7,         
    
    Sel => Sel,
    Output => Output
);

process begin
Sel<= "000";
wait for 50ns;

Sel<= "001";
wait for 50ns;

Sel<= "010";
wait for 50ns;

Sel<= "011";
wait for 50ns;

Sel<= "100";
wait for 50ns;

Sel<= "101";
wait for 50ns;

Sel<= "110";
wait for 50ns;

Sel<= "111";
wait for 50ns;
end process;
end Behavioral;
