library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;


entity Program_ROM is
    Port (  Mem_Select : in STD_LOGIC_VECTOR (2 downto 0);
            Instruction : out STD_LOGIC_VECTOR (11 downto 0));
          
end Program_ROM;

architecture Behavioral of Program_ROM is

type rom_type is array (0 to 7) of std_logic_vector(11 downto 0);
signal Instruction_ROM : rom_type := (
                                  --Opereand  RegA  RegB  Value
    "100010000001",  --MOV R1 1     10        001   000   0001 - 1    -000
    "100100000010",  --MOV R2 2     10        010   000   0010 - 2    -001
    "100110000011",  --MOV R3 3     10        110   000   0011 - 3    -010
    "001110010000",  --ADD R7 R1    00        111   001   0000        -011
    "001110100000",  --ADD R7 R2    00        111   010   0000        -100
    "001110110000",  --ADD R7 R3    00        111   011   0000        -101
    "110000000110",  --JZR R0 6     11        000   000   110         -110
    "000000000000"                                                   --111
 );
begin
Instruction <= Instruction_ROM(to_integer(unsigned(Mem_Select)));
end Behavioral;
