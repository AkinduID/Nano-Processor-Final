library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Decoder_3_to_8 is
    Port ( I : in STD_LOGIC_VECTOR (2 downto 0);
           En : in STD_LOGIC;
           Y : out STD_LOGIC_VECTOR (7 downto 0));
end Decoder_3_to_8;

architecture Behavioral of Decoder_3_to_8 is

COMPONENT Decoder_2_to_4
    PORT(
        I:in STD_LOGIC_VECTOR;
        En:in STD_LOGIC;
        Y:out STD_LOGIC_VECTOR);
END COMPONENT;

SIGNAL I0,I1:STD_LOGIC_VECTOR(1 DOWNTO 0);
SIGNAL Y0,Y1:STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL en0,en1,I2:STD_LOGIC;
      
begin

Decoder_2_to_4_0:Decoder_2_to_4
    PORT MAP(
            I=>I0,
            En=>en0,
            Y=>Y0);

Decoder_2_to_4_1:Decoder_2_to_4
    PORT MAP(
            I=>I1,
            En=>en1,
            Y=>Y1);

en0<=NOT(I(2)) AND En;
en1<=I(2) AND En;
I0<=I(1 DOWNTO 0);
I1<=I(1 DOWNTO 0);
I2<=I(2);
Y(3 DOWNTO 0)<=Y0;
Y(7 DOWNTO 4)<=Y1;
  
end Behavioral;
