library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity System is
Port ( Clk : in STD_LOGIC;
       Reset_Push : in STD_LOGIC;
       Seg_7 : out STD_LOGIC_VECTOR (6 downto 0);
       Reg_7 : out STD_LOGIC_VECTOR(3 downto 0);
       Overflow : out STD_LOGIC;
       Zero : out STD_LOGIC);
end System;

architecture Behavioral of System is

component LUT_16_7 is
    Port ( address : in STD_LOGIC_VECTOR (3 downto 0);
           data : out STD_LOGIC_VECTOR (6 downto 0));
end component;

component Slow_Clock is
 Port (Clk_In : in STD_LOGIC;
 Clk_Out : out STD_LOGIC );
end component;

component Nano_Processor is
    Port ( Clk : in STD_LOGIC;
           Reset : in STD_LOGIC;
           Overflow : out STD_LOGIC;
           Zero : out STD_LOGIC;
           R7 : out STD_LOGIC_VECTOR (3 downto 0)   );
end component;

signal reg_7_data : STD_LOGIC_VECTOR(3 downto 0);
signal clk_out : STD_LOGIC;
 
begin
LUT : LUT_16_7
port map(
    address => reg_7_data,
    data =>  Seg_7
);

Slow_Clock_0 : Slow_Clock
Port map ( Clk_In => Clk,
      Clk_Out => clk_out);
      
Processor:Nano_Processor 
        Port map 
         ( Clk => clk_out,
           Reset => Reset_Push,
           Zero => Zero,
           Overflow => Overflow,
           R7 => reg_7_data);

Reg_7<= reg_7_data;
end Behavioral;
