library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Nano_Processor_TB is
--  Port ( );
end Nano_Processor_TB;

architecture Behavioral of Nano_Processor_TB is
    component Nano_Processor
    Port ( Clk : in STD_LOGIC;
           Reset : in STD_LOGIC:='0';
           Zero : out STD_LOGIC;
           Overflow: out STD_LOGIC;
           R7 : out STD_LOGIC_VECTOR (3 downto 0)
           );
    end component;
    

    signal R7 : STD_LOGIC_VECTOR (3 downto 0) := "0000";
    signal Clk: STD_LOGIC := '0';
    signal Reset : STD_LOGIC:= '0';
    signal Zero : STD_LOGIC := '0';
    signal Overflow : STD_LOGIC := '0';
    
begin
    UUT: Nano_Processor port map(
            R7 => R7,
            Clk => Clk,
            Reset => Reset,
            Zero => Zero,
            Overflow => Overflow
       );  
       
process begin
Clk <= not Clk;
wait for 20ns;
end process;

process begin
wait for 300ns;
Reset <= '1';
wait for 50ns;
Reset <= '0';
end process;                  
end Behavioral;   
                  
