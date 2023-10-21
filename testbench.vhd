----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Rachel Gottschalk
-- 
-- Create Date:    11:14:03 09/14/2023
-- Design Name: 
-- Module Name:    clk_div - Behavioral
-- Project Name:   Lab 2
-- Target Devices: 
-- Tool versions: 
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity turn_signal_tb is
end turn_signal_tb;

architecture sim of turn_signal_tb is
    -- Signals matching the FSM ports
    signal reset_L : std_logic := '0';
    signal clk : std_logic := '0';
    signal L_turn : std_logic := '0';
    signal R_turn : std_logic := '0';
    signal L_light : std_logic;
    signal R_light : std_logic;
    signal H_light : std_logic;

    -- Clock period definition for testbench
    constant clk_period : time := 1000000000 ns;  -- 1 second, expressed in nanoseconds

begin

    -- Instantiate the FSM
    uut: entity work.turn_signal
        port map (
            reset_L => reset_L,
            clk => clk,
            L_turn => L_turn,
            R_turn => R_turn,
            L_light => L_light,
            R_light => R_light,
            H_light => H_light
        );

    -- Clock generation process
    clk_process : process
    begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;

    -- Test sequence process
    test_process : process
    begin
        -- Test hazard lights
        -- Reset the FSM
        reset_L <= '1';
        wait for clk_period;
        reset_L <= '0';
        
        -- Test idle state
        L_turn <= '0';
        R_turn <= '0';
        wait for 10 * clk_period;  -- Wait for 10 seconds
        
        -- Test left signal
        L_turn <= '1';
        R_turn <= '0';
        wait for 10 * clk_period;  -- Blink for 10 seconds
        L_turn <= '0';
        
        -- Test right signal
        L_turn <= '0';
        R_turn <= '1';
        wait for 10 * clk_period;  -- Blink for 10 seconds
        R_turn <= '0';
        
        -- Test hazard lights
        L_turn <= '1';
        R_turn <= '1';
        wait for 20 * clk_period;  -- Blink for 20 seconds
        L_turn <= '0';
        R_turn <= '0';
    
        wait;
    end process;

end sim;
