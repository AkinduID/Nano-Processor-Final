library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Instruction_Decoder_TB is
--  Port ( );
end Instruction_Decoder_TB;

architecture Behavioral of Instruction_Decoder_TB is
component Instruction_Decoder
    Port ( Instruction : in STD_LOGIC_VECTOR (11 downto 0);
           Jmp_Reg_Val : in STD_LOGIC_VECTOR(3 downto 0);
           Reg_En : out STD_LOGIC_VECTOR (2 downto 0);
           Load_Selector : out STD_LOGIC;
           Immediate_Val : out STD_LOGIC_VECTOR (3 downto 0);
           Mux_A : out STD_LOGIC_VECTOR (2 downto 0);
           Mux_B : out STD_LOGIC_VECTOR (2 downto 0);
           AS_Sel : out STD_LOGIC;
           Jmp_Flag: out STD_LOGIC;
           Jmp_Address : out STD_LOGIC_VECTOR (2 downto 0));
end component;

signal Instruction  : STD_LOGIC_VECTOR (11 downto 0);
signal Jmp_Reg_Val : STD_LOGIC_VECTOR(3 downto 0);
signal Reg_En: STD_LOGIC_VECTOR (2 downto 0);
signal Load_Selector : STD_LOGIC;
signal Immediate_Val  : STD_LOGIC_VECTOR (3 downto 0);
signal Mux_A : STD_LOGIC_VECTOR (2 downto 0);
signal Mux_B : STD_LOGIC_VECTOR (2 downto 0);
signal AS_Sel : STD_LOGIC;
signal Jmp_Flag : STD_LOGIC;
signal Jmp_Address : STD_LOGIC_VECTOR (2 downto 0);

begin
UUT: Instruction_Decoder
port map(
    Instruction => Instruction ,
    Jmp_Reg_Val => Jmp_Reg_Val,
    Reg_En => Reg_En,
    Load_Selector => Load_Selector,
    Immediate_Val => Immediate_Val,
    Mux_A  => Mux_A ,
    Mux_B  => Mux_B ,
    AS_Sel => AS_Sel,
    Jmp_Flag => Jmp_Flag,
    Jmp_Address  => Jmp_Address
    
);

process begin

Instruction  <=  "100000010001";
wait for 100ns;

Instruction  <=  "010000001001";
wait for 100ns;

Instruction  <= "110000011001";
wait for 100ns;

Jmp_Reg_Val <= "0100";
Instruction  <= "000001010000";
wait for 100ns;

Instruction  <= "000011010000";
wait for 100ns;

Instruction  <= "000010011100";
wait for 100ns;

end process;

end Behavioral;
