----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/12/2023 07:36:02 PM
-- Design Name: 
-- Module Name: 7_Seg - Behavioral
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

entity hex_to_seven_seg is
    Port (
        hex : in STD_LOGIC_VECTOR(3 downto 0);
        segments : out STD_LOGIC_VECTOR(6 downto 0) 
    );
end hex_to_seven_seg;

architecture Behavioral of hex_to_seven_seg is
begin
    process(hex)
    begin
        case hex is
            when "0000" => segments <= "1000000"; -- 0
            when "0001" => segments <= "1111001"; -- 1
            when "0010" => segments <= "0100100"; -- 2
            when "0011" => segments <= "0110000"; -- 3
            when "0100" => segments <= "0011001"; -- 4
            when "0101" => segments <= "0010010"; -- 5
            when "0110" => segments <= "0000010"; -- 6
            when "0111" => segments <= "1111000"; -- 7
            when "1000" => segments <= "0000000"; -- 8
            when "1001" => segments <= "0010000"; -- 9
            when "1010" => segments <= "0001000"; -- A
            when "1011" => segments <= "0000011"; -- B
            when "1100" => segments <= "1000110"; -- C
            when "1101" => segments <= "0100001"; -- D
            when "1110" => segments <= "0000110"; -- E
            when others => segments <= "0001110"; -- F
        end case;
    end process;

end Behavioral;
