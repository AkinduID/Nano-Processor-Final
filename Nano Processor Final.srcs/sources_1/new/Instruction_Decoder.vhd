library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Instruction_Decoder is
    Port ( 
           Instruction : in STD_LOGIC_VECTOR (11 downto 0);
           Jmp_Reg_Val : in STD_LOGIC_VECTOR(3 downto 0);

           Reg_En : out STD_LOGIC_VECTOR (2 downto 0);
           Load_Selector : out STD_LOGIC;
           Immediate_Val : out STD_LOGIC_VECTOR (3 downto 0);
           Mux_A : out STD_LOGIC_VECTOR (2 downto 0);
           Mux_B : out STD_LOGIC_VECTOR (2 downto 0);
           AS_Sel : out STD_LOGIC;
           Jmp_Flag : out STD_LOGIC;
           Jmp_Address : out STD_LOGIC_VECTOR (2 downto 0));
end Instruction_Decoder;

architecture Behavioral of Instruction_Decoder is

component Decoder_2_to_4
Port (I : in STD_LOGIC_VECTOR (1 downto 0);
      En : in STD_LOGIC;
      Y : out STD_LOGIC_VECTOR (3 downto 0));
end component;

signal add_en : std_logic;
signal mov_en : std_logic;
signal neg_en : std_logic;
signal jnz_en : std_logic;


signal opcode_id : std_logic_vector(1 downto 0);
signal reg_a : std_logic_vector(2 downto 0);
signal reg_b : std_logic_vector(2 downto 0);
signal val_in : std_logic_vector(3 downto 0);
signal jmp_val: std_logic_vector(2 downto 0);
signal jmp_chk : STD_LOGIC;

begin

opcode_id <= Instruction(11 downto 10); --2bits  operation type
reg_a <= Instruction(9 downto 7);       -- 3bit  register a address
reg_b <= Instruction(6 downto 4);       -- 3bit  register a address
val_in <= Instruction(3 downto 0);      -- 4bit  value /operand
jmp_val <= Instruction(2 downto 0);     -- 3bit  Jump address

decoder : Decoder_2_to_4
port map(
    I => opcode_id,
    En => '1',
    Y(0) => add_en,
    Y(1) => neg_en,
    Y(2) => mov_en,
    Y(3) => jnz_en
);
  
   Reg_En(0) <= reg_a(0);
   Reg_En(1) <= reg_a(1);
   Reg_En(2) <= reg_a(2);
   
   Load_Selector <= (not(mov_en) or neg_en or add_en);
   Immediate_Val(0) <= val_in (0);
   Immediate_Val(1) <= val_in (1);
   Immediate_Val(2) <= val_in (2);
   Immediate_Val(3) <= val_in (3);
  
   Mux_A(0) <= (add_en and reg_a(0));
   Mux_A(1) <= (add_en and reg_a(1)); 
   Mux_A(2) <= (add_en and reg_a(2)) ;
      
   Mux_B(0) <= (add_en and reg_b(0)) or (neg_en and reg_a(0));
   Mux_B(1) <= (add_en and reg_b(1)) or (neg_en and reg_a(1)); 
   Mux_B(2) <= (add_en and reg_b(2)) or (neg_en and reg_a(2));
  
   jmp_chk  <= not(Jmp_Reg_Val(0)) and not(Jmp_Reg_Val(1)) and not(Jmp_Reg_Val(2)) and not(Jmp_Reg_Val(3));
 
   AS_Sel <= neg_en ;
   
   Jmp_Flag <=  not(jmp_chk and jnz_en); 
   Jmp_Address <= jmp_val;

end Behavioral;
