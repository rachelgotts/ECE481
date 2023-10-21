----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Rachel Gottschalk
-- 
-- Create Date:    12:15:02 09/10/2023 
-- Design Name: 
-- Module Name:    tb_four_bit_adder_subtractor - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: Testbench for the four_bit_adder_subtractor
--
-- Dependencies: four_bit_adder_subtractor.vhdl
--
-- Revision: 
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity look_ahead_adder_subtractor_tb is
end look_ahead_adder_subtractor_tb;

architecture simulate of look_ahead_adder_subtractor_tb is
    signal A, B: STD_LOGIC_VECTOR(3 downto 0);
    signal OP_SEL: STD_LOGIC;
    signal Cout: STD_LOGIC;
    signal S: STD_LOGIC_VECTOR(3 downto 0);
    
    -- Instantiate the look_ahead_adder_subtractor
    component look_ahead_adder_subtractor
        Port ( A : in  STD_LOGIC_VECTOR (3 downto 0);
               B : in  STD_LOGIC_VECTOR (3 downto 0);
               OP_SEL : in  STD_LOGIC;
               Cout : out  STD_LOGIC;
               S : out  STD_LOGIC_VECTOR (3 downto 0));
    end component;

begin

    DUT: look_ahead_adder_subtractor port map(
        A => A,
        B => B,
        OP_SEL => OP_SEL,
        Cout => Cout,
        S => S
    );

    -- Test procedure
    process
    begin
        -- Addition test vectors
        OP_SEL <= '0'; -- Select addition
        
        A <= "0001"; B <= "0000"; wait for 10 ns; -- 1 + 0
        A <= "0001"; B <= "0001"; wait for 10 ns; -- 1 + 1
        A <= "0110"; B <= "0010"; wait for 10 ns; -- 6 + 2
        
        -- Subtraction test vectors
        OP_SEL <= '1'; -- Select subtraction
        
        A <= "0010"; B <= "0001"; wait for 10 ns; -- 2 - 1
        A <= "0110"; B <= "0010"; wait for 10 ns; -- 6 - 2
        A <= "0010"; B <= "0110"; wait for 10 ns; -- 2 - 6

        wait; -- End simulation
    end process;

end simulate;
