----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Rachel Gottschalk
-- 
-- Create Date:    11:14:03 09/14/2023
-- Design Name: 
-- Module Name:    turn_signal - Behavioral
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

entity turn_signal is
    Port (
        reset_L : in std_logic;
        clk : in STD_LOGIC;
        L_turn : in STD_LOGIC;
        R_turn : in std_logic;
        L_light : out std_logic;
        R_light : out std_logic;
        H_light : out std_logic
    );
end turn_signal;

architecture Behavioral of turn_signal is
    type state_type is (IDLE, LSIG, RSIG, H1, H2);
    signal pr_state, nx_state: state_type;

begin
    process(clk)
    begin
        if rising_edge(clk) then
            if reset_L = '1' then
                pr_state <= IDLE;
            else
                pr_state <= nx_state;
            end if;
        end if;
    end process;


      -- Combinational part ( next state logic )
    process(pr_state, L_turn, R_turn)
    begin
        -- Default values
        L_light <= '0';
        R_light <= '0';
        H_light <= '0';
        nx_state <= IDLE; -- Default next state

        case pr_state is
            when IDLE =>
                if (L_turn = '1' and R_turn = '1') then
                    nx_state <= H1;
                elsif (L_turn = '1') then
                    nx_state <= LSIG;
                elsif (R_turn = '1') then
                    nx_state <= RSIG;
                end if;

            when LSIG =>
                L_light <= '1';
                nx_state <= IDLE;

            when RSIG =>
                R_light <= '1';
                nx_state <= IDLE;

            when H1 =>
                L_light <= '1';
                R_light <= '1';
                nx_state <= H2;

            when H2 =>
                H_light <= '1';
                nx_state <= IDLE;

            when others =>
                -- No changes; just keep the default values
        end case;
    end process;
end Behavioral;
