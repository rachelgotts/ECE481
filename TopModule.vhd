----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Rachel Gottschalk
-- 
-- Create Date:  
-- Design Name: 
-- Module Name: Top Module - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity Top_Module is
    Port ( CLK : in STD_LOGIC;
           reset : in std_logic;
           row : in STD_LOGIC_VECTOR (3 downto 0);
           col : out STD_LOGIC_VECTOR (3 downto 0);
           AN : out STD_LOGIC_VECTOR (7 downto 0);
           seg_code : out STD_LOGIC_VECTOR (7 downto 0));
end Top_Module;

architecture Behavioral of Top_Module is

signal Decode_digit : std_logic_vector(3 downto 0) := (others => '0');
signal ID_data : std_logic_vector(15 downto 0) := (others => '0');

type state_type is (IDLE, digit1, digit2, digit3, digit4);
signal current_state, next_state: state_type := IDLE;
signal current_decode, next_decode : std_logic_vector(3 downto 0) := (others => '0');
signal key_detected: std_logic;

signal shifted_decode1,shifted_decode2,shifted_decode3,shifted_decode4 : std_logic_vector(3 downto 0) := (others => '0');

begin

    U1: entity work.Keypad
    Port map ( CLK => CLK,
           row => row,
           col => col,
           key_pressed => Decode_digit);

    U2: entity work.SevenSeg 
    port map (
      reset => reset,
      clk => CLK,
      ID_data => ID_data,
      AN => AN,
      seg_code => seg_code  ); 

ID_data <= shifted_decode4 & shifted_decode3 & shifted_decode2 & shifted_decode1;
-- Key detection based on change in Decode_digit
process(clk, reset)
begin
     if rising_edge(clk) then
        if current_decode /= Decode_digit then
            key_detected <= '1';
            current_decode <= Decode_digit;
        else
            key_detected <= '0';
        end if;
    end if;
end process;

process(clk, reset)
begin
    if rising_edge(clk) then
        case current_state is

            when digit1 =>
                if key_detected = '1' and current_decode /= shifted_decode4 then
                    next_state <= digit2;
                    shifted_decode4 <= Decode_digit;
                else
                    next_state <= digit1;
                end if;

            when digit2 =>
                if key_detected = '1' and current_decode /= shifted_decode3 then
                    next_state <= digit3;
                    shifted_decode3 <= Decode_digit;
                else
                    next_state <= digit2;
                end if;

            when digit3 =>
                if key_detected = '1' and current_decode /= shifted_decode2 then
                    next_state <= digit4;
                    shifted_decode2 <= Decode_digit;
                else
                    next_state <= digit3;
                end if;

            when digit4 =>
                if key_detected = '1' and current_decode /= shifted_decode1 then
                    next_state <= digit1; 
                    shifted_decode1 <= Decode_digit; 
                else
                    next_state <= digit4;
                end if;

            when others =>
                next_state <= digit1;
        end case;

        current_state <= next_state;
    end if;
end process;


end Behavioral;