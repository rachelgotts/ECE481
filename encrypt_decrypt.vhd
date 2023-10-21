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

entity LFSR_encrypt_decrypt is
    Port (
        clk           : in STD_LOGIC;
        load_key      : in STD_LOGIC;
        encrypt_cntl  : in STD_LOGIC;
        input_val     : in STD_LOGIC_VECTOR(7 downto 0);
        LFSR_out      : out STD_LOGIC_VECTOR(7 downto 0);
        output_val    : out STD_LOGIC_VECTOR(7 downto 0)
    );
end LFSR_encrypt_decrypt;

architecture Behavioral of LFSR_encrypt_decrypt is
    signal LFSR_int: STD_LOGIC_VECTOR(7 downto 0) := "00000000"; 
    signal load_key_reg, encrypt_cntl_reg: STD_LOGIC := '0';
    signal perform_xor: STD_LOGIC := '0'; -- Flag for XOR operation
    
begin

LFSR_out <= LFSR_int; 

process(clk)
begin
    if rising_edge(clk) then
        -- register control signals
        load_key_reg <= load_key;
        encrypt_cntl_reg <= encrypt_cntl;

        -- loads key if is asked 
        if load_key_reg = '0' and load_key = '1' then
            LFSR_int <= input_val;
        -- do lfsr operation if prompted 
        elsif encrypt_cntl_reg = '0' and encrypt_cntl = '1' then
            LFSR_int(7) <= LFSR_int(0);
            LFSR_int(6) <= LFSR_int(7);
            LFSR_int(5) <= LFSR_int(6) xnor LFSR_int(0);
            LFSR_int(4) <= LFSR_int(5) xnor LFSR_int(0);
            LFSR_int(3) <= LFSR_int(4) xnor LFSR_int(0);
            LFSR_int(2) <= LFSR_int(3);
            LFSR_int(1) <= LFSR_int(2);
            LFSR_int(0) <= LFSR_int(1);
            
            perform_xor <= '1'; -- set the flag for the XOR operation
        end if;

        -- XOR operation for encrypt (delayed by one clock cycle)
        if perform_xor = '1' then
            output_val <= input_val xor LFSR_int;
            perform_xor <= '0'; -- reset the flag
        end if;
    end if;
end process;

end Behavioral;

