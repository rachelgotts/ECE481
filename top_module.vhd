----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Rachel Gottschalk
-- 
-- Create Date:  
-- Design Name: 
-- Module Name: lab 3 - Behavioral
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity top_module is
    Port (
        clk           : in  STD_LOGIC;
        load_key_btn  : in  STD_LOGIC;
        encrypt_btn   : in  STD_LOGIC;
        switches      : in  STD_LOGIC_VECTOR(7 downto 0);
        LEDs          : out STD_LOGIC_VECTOR(7 downto 0);
        CA            : out STD_LOGIC;
        CB            : out STD_LOGIC;
        CC            : out STD_LOGIC;
        CD            : out STD_LOGIC;
        CE            : out STD_LOGIC;
        CF            : out STD_LOGIC;
        CG            : out STD_LOGIC;
        AN            : out STD_LOGIC_VECTOR(7 downto 0)  -- displays
    );
end top_module;

architecture Structural of top_module is

    component LFSR_encrypt_decrypt
        Port (
            clk           : in STD_LOGIC;
            load_key      : in STD_LOGIC;
            encrypt_cntl  : in STD_LOGIC;
            input_val     : in STD_LOGIC_VECTOR(7 downto 0);
            LFSR_out      : out STD_LOGIC_VECTOR(7 downto 0);
            output_val    : out STD_LOGIC_VECTOR(7 downto 0)
        );
    end component;

    component hex_to_seven_seg is
        Port (
            hex : in STD_LOGIC_VECTOR(3 downto 0);
            segments : out STD_LOGIC_VECTOR(6 downto 0)
        );
    end component;

    signal LFSR_output, encrypt_output: STD_LOGIC_VECTOR(7 downto 0);
    signal seg1, seg2: STD_LOGIC_VECTOR(6 downto 0);
    signal counter: STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
    signal switch: STD_LOGIC := '0';

begin
    -- Encryption module 
    encrypt_unit: LFSR_encrypt_decrypt
        port map (
            clk          => clk,
            load_key     => load_key_btn,
            encrypt_cntl => encrypt_btn,
            input_val    => switches,
            LFSR_out     => LFSR_output,
            output_val   => encrypt_output
        );

    -- First 7-segment display (most significant nibble)
    seven_seg1: hex_to_seven_seg
        port map (
            hex => encrypt_output(7 downto 4),
            segments => seg1
        );
    
    -- Second 7-segment display (least significant nibble)
    seven_seg2: hex_to_seven_seg
        port map (
            hex => encrypt_output(3 downto 0),
            segments => seg2
        );
    
     -- Counter for multiplexing
    process(clk)
    begin
        if rising_edge(clk) then
            counter <= counter + 1;
            if counter = "1000000000000000" then
                switch <= not switch;
            end if;
        end if;
    end process;

    -- Multiplexing logic
    process(switch)
    begin
        if switch = '0' then
            CA <= seg1(0);
            CB <= seg1(1);
            CC <= seg1(2);
            CD <= seg1(3);
            CE <= seg1(4);
            CF <= seg1(5);
            CG <= seg1(6);
            AN(0) <= '0'; 
            AN(1) <= '1'; 
        else
            CA <= seg2(0);
            CB <= seg2(1);
            CC <= seg2(2);
            CD <= seg2(3);
            CE <= seg2(4);
            CF <= seg2(5);
            CG <= seg2(6);
            AN(0) <= '1'; 
            AN(1) <= '0'; 
        end if;

        AN(2) <= '1';  -- Turned off
        AN(3) <= '1';
        AN(4) <= '1'; 
        AN(5) <= '1';
        AN(6) <= '1'; 
        AN(7) <= '1';
    end process;

    -- LEDs are output
    LEDs <= encrypt_output;

end Structural;
