library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Nano_Processor is
    Port ( Clk : in STD_LOGIC;
           Reset : in STD_LOGIC:='0';
           Zero : out STD_LOGIC;
           Overflow : out STD_LOGIC;          
           R7 : out STD_LOGIC_VECTOR (3 downto 0)
           );
end Nano_Processor;

architecture Behavioral of Nano_Processor is

component Reg_3bit
    Port ( D : in STD_LOGIC_VECTOR (2 downto 0);
           Res : in STD_LOGIC;
           Clk : in STD_LOGIC;
           Q : out STD_LOGIC_VECTOR (2 downto 0));
end component;

    component Program_ROM
        Port (  Mem_Select : in STD_LOGIC_VECTOR (2 downto 0);
               Instruction : out STD_LOGIC_VECTOR (11 downto 0));
    end component;
    
    
    component Instruction_Decoder
        Port ( 
               Instruction: in STD_LOGIC_VECTOR (11 downto 0);
               Jmp_Reg_Val : in STD_LOGIC_VECTOR(3 downto 0);

               Reg_En : out STD_LOGIC_VECTOR (2 downto 0);
               Load_Selector : out STD_LOGIC;
               Immediate_Val : out STD_LOGIC_VECTOR (3 downto 0);
               Mux_A : out STD_LOGIC_VECTOR (2 downto 0);
               Mux_B : out STD_LOGIC_VECTOR (2 downto 0);
               AS_Sel : out STD_LOGIC;
               Jmp_Flag : out STD_LOGIC;
               Jmp_Address  : out STD_LOGIC_VECTOR (2 downto 0));
    end component;
    
    component ASU_4bit
        Port ( A : in STD_LOGIC_VECTOR (3 downto 0);
               B : in STD_LOGIC_VECTOR (3 downto 0);
               Ctrl : in STD_LOGIC;
               C_out : out STD_LOGIC;
               S : out STD_LOGIC_VECTOR (3 downto 0);
               Zero : out STD_LOGIC);
   end component;
    
    component Register_Bank 
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
               Reg_Input  : in STD_LOGIC_VECTOR (3 downto 0));
               
    end component;
    
    component Adder_3bit
        Port ( 
            A : in STD_LOGIC_VECTOR (2 downto 0);
            En : in STD_LOGIC;
            S : out STD_LOGIC_VECTOR (2 downto 0));
    end component;
    
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
        
   component Mux_2_to_1_4bit 
           Port ( S: in STD_LOGIC;
                  D0 : in STD_LOGIC_VECTOR (3 downto 0);
                  D1 : in STD_LOGIC_VECTOR (3 downto 0);
                  Y : out STD_LOGIC_VECTOR (3 downto 0));
   end component;
    
   component Mux_2_to_1_3bit 
            Port ( 
                D0 : in STD_LOGIC_VECTOR(2 downto 0);
                D1 : in STD_LOGIC_VECTOR(2 downto 0);
                S : in STD_LOGIC;
                Y : out STD_LOGIC_VECTOR (2 downto 0));
    end component;
      
    signal pc_nxt_instruction: STD_LOGIC_VECTOR(2 downto 0):= "000";
    signal pc_crnt_instruction: STD_LOGIC_VECTOR(2 downto 0):= "000";
    
    signal adder_3bit_out: STD_LOGIC_VECTOR(2 downto 0):= "000";
    
    signal instruction: STD_LOGIC_VECTOR(11 downto 0):= "000000000000";
    
    signal dec_immediate_val: STD_LOGIC_VECTOR(3 downto 0):= "0000";
    signal dec_jmp_flag: STD_LOGIC:= '0';
    signal dec_jmp_addrs: STD_LOGIC_VECTOR(2 DOWNTO 0):="000";
    signal dec_reg_en: STD_LOGIC_VECTOR(2 downto 0):= "000";
    signal dec_mux_a: STD_LOGIC_VECTOR(2 downto 0):= "000";
    signal dec_mux_b: STD_LOGIC_VECTOR(2 downto 0):= "000";
    signal dec_asu_ctrl: STD_LOGIC:= '0';
    signal dec_load_select: STD_LOGIC:= '0';
    
    signal asu_out: STD_LOGIC_VECTOR(3 downto 0):= "0000";
    
    
    signal reg_bank_input: STD_LOGIC_VECTOR(3 downto 0):= "0000";
    signal reg_0_data: STD_LOGIC_VECTOR(3 downto 0):= "0000";
    signal reg_1_data: STD_LOGIC_VECTOR(3 downto 0):= "0000";
    signal reg_2_data: STD_LOGIC_VECTOR(3 downto 0):= "0000";
    signal reg_3_data: STD_LOGIC_VECTOR(3 downto 0):= "0000";
    signal reg_4_data: STD_LOGIC_VECTOR(3 downto 0):= "0000";
    signal reg_5_data: STD_LOGIC_VECTOR(3 downto 0):= "0000";
    signal reg_6_data: STD_LOGIC_VECTOR(3 downto 0):= "0000";
    signal reg_7_data: STD_LOGIC_VECTOR(3 downto 0):= "0000";
    
    signal mux_a_out: STD_LOGIC_VECTOR(3 downto 0):= "0000";
    signal mux_b_out: STD_LOGIC_VECTOR(3 downto 0):= "0000";

begin

    Program_Counter :Reg_3bit
    Port map ( 
        D => pc_nxt_instruction,
        Res => Reset,
        Q => pc_crnt_instruction,
        Clk => Clk
        );
    
    Adder_3bit_0 : Adder_3bit
      Port map( 
             A => pc_crnt_instruction,
             En =>'1',
             S => adder_3bit_out);
        
    Mux_2_to_1_3bit_0 : Mux_2_to_1_3bit 
     Port map (D1 => adder_3bit_out,
            D0 =>dec_jmp_addrs,
            S => dec_jmp_flag,     
            Y => pc_nxt_instruction);    
    
     Program_ROM_0 :Program_ROM
        Port map(  Mem_Select => pc_crnt_instruction ,
              Instruction => instruction);
    
    Instruction_Decoder_0 : Instruction_Decoder
    Port map ( Instruction => instruction,
               Jmp_Reg_Val => mux_a_out,
               Reg_En => dec_reg_en,
               Load_Selector  => dec_load_select,
               Immediate_Val=>  dec_immediate_val,
               Mux_A  => dec_mux_a,
               Mux_B => dec_mux_b,
               AS_Sel  =>  dec_asu_ctrl,
               Jmp_Flag => dec_jmp_flag,
               Jmp_Address => dec_jmp_addrs
               );
               
     Mux_2_to_1_4bit_0 : Mux_2_to_1_4bit 
            Port map ( S => dec_load_select,
                       D0  => dec_immediate_val,
                       D1 => asu_out,
                       Y => reg_bank_input);

    Reg_Bank_0: Register_Bank
    Port map( En => '1',
              Clk => Clk,
              Res => Reset,   
              R0 => reg_0_data,
              R1 => reg_1_data,
              R2 => reg_2_data,
              R3 => reg_3_data,
              R4 => reg_4_data,
              R5 => reg_5_data,
              R6 => reg_6_data,
              R7 => reg_7_data,        
              Reg_En => dec_reg_en,           
              Reg_Input => reg_bank_input);    
   
     
     Mux_A :Mux_8_to_1_4bit 
     Port map ( 
            Sel => dec_mux_a,
                 R0 => reg_0_data,
                 R1 => reg_1_data,
                 R2 => reg_2_data,
                 R3 => reg_3_data,
                 R4 => reg_4_data,
                 R5 => reg_5_data,
                 R6 => reg_6_data,
                 R7 => reg_7_data,
                 Output => mux_a_out);
    
                    
     Mux_B :Mux_8_to_1_4bit 
        Port map ( 
               Sel => dec_mux_b,
                R0 => reg_0_data,
                R1 => reg_1_data,
                R2 => reg_2_data,
                R3 => reg_3_data,
                R4 => reg_4_data,
                R5 => reg_5_data,
                R6 => reg_6_data,
                R7 => reg_7_data,
                Output => mux_b_out);
  
    ASU_4bit_0 : ASU_4bit
    Port map  ( 
           A => mux_a_out,
           B => mux_b_out,
           Ctrl => dec_asu_ctrl,
           C_out => Overflow, 
           S => asu_out,
           Zero => Zero
           );
    
    R7 <= reg_7_data;
    
end Behavioral;
