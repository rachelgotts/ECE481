----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Rachel Gottschalk
-- 
-- Create Date:    11:14:03 09/14/2023
-- Design Name: 
-- Module Name:    top_module - Behavioral
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

entity top_module is
Port(
    reset : in std_logic;
    clk_in: in std_logic;
    L_turn : in std_logic;
    R_turn : in std_logic;
    L_light : out std_logic;
    R_light : out std_logic;
    H_light : out std_logic
);
end top_module;

architecture structural of top_module is
signal clk_divided : std_logic;

-- Declare the clock divider as a component
component clk_div
Port(
    reset : in std_logic;
    clk_in : in std_logic;
    clk_out : out std_logic
);
end component;

-- Declare the FSM as a component 
component turn_signal
Port(
    reset_L : in std_logic;
    clk : in STD_LOGIC;
    L_turn : in STD_LOGIC;
    R_turn : in std_logic;
    L_light : out std_logic;
    R_light : out std_logic;
    H_light : out std_logic
);
end component;

begin

-- Instantiate the clock divider
clk_div_inst : clk_div
Port map(
    reset => reset,
    clk_in => clk_in,
    clk_out => clk_divided
);

-- Instantiate the FSM, using the divided clock
fsm_inst : turn_signal
Port map(
    reset_L => reset,
    clk => clk_divided,
    L_turn => L_turn,
    R_turn => R_turn,
    L_light => L_light,
    R_light => R_light,
    H_light => H_light
);

end structural;
