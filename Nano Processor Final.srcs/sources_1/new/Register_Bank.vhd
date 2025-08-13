library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Register_Bank is
    Port ( En : in STD_LOGIC;
           Clk : in STD_LOGIC;
           Res : in STD_LOGIC;          
           Reg_En : in STD_LOGIC_VECTOR (2 downto 0);
           R0 : out STD_LOGIC_VECTOR(3 downto 0);
           R1 : out STD_LOGIC_VECTOR(3 downto 0);
           R2 : out STD_LOGIC_VECTOR(3 downto 0);
           R3 : out STD_LOGIC_VECTOR(3 downto 0);
           R4 : out STD_LOGIC_VECTOR(3 downto 0);
           R5 : out STD_LOGIC_VECTOR(3 downto 0);
           R6 : out STD_LOGIC_VECTOR(3 downto 0);
           R7 : out STD_LOGIC_VECTOR(3 downto 0);
           Reg_Input : in STD_LOGIC_VECTOR (3 downto 0));
end Register_Bank;

architecture Behavioral of Register_Bank is

component Reg_4bit
Port ( D : in STD_LOGIC_VECTOR (3 downto 0);
       En : in STD_LOGIC;
       Clk : in STD_LOGIC;
       Res : in STD_LOGIC;
       Q : out STD_LOGIC_VECTOR (3 downto 0));
end component;

component Decoder_3_to_8
Port ( I : in STD_LOGIC_VECTOR (2 downto 0);
       En : in STD_LOGIC;
       Y : out STD_LOGIC_VECTOR (7 downto 0));
end component;

signal y : STD_LOGIC_VECTOR(7 downto 0);


begin

R0<= "0000";


Reg_1 : Reg_4bit
port map(
    D => Reg_Input ,
    En => Y(1) ,
    Clk => Clk,
    Res => Res,
    Q =>R1
);

Reg_2 : Reg_4bit
port map(
    D => Reg_Input ,
    En => y(2) ,
    Clk => Clk,
    Res => Res,
    Q => R2 
);

Reg_3 : Reg_4bit
port map(
    D => Reg_Input ,
    En => y(3) ,
    Clk => Clk,
    Res => Res,
    Q =>R3 
);

Reg_4 : Reg_4bit
port map(
    D => Reg_Input ,
    En => y(4),
    Clk => Clk,
    Res => Res,
    Q => R4);

Reg_5 :Reg_4bit
port map(
    D => Reg_Input ,
    En => y(5),
    Clk => Clk,
    Res => Res,
    Q => R5
);

Reg_6 : Reg_4bit
port map(
    D => Reg_Input ,
    En => y(6),
    Clk => Clk,
    Res => Res,
    Q =>R6
);

Reg_7 : Reg_4bit
port map(
    D => Reg_Input ,
    En => y(7),
    Clk => Clk,
    Res => Res,
    Q =>R7
);

Decoder : Decoder_3_to_8
port map(
    I => Reg_En,
    En => '1',
    Y => y
);

end Behavioral;
