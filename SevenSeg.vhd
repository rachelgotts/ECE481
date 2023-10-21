----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Rachel Gottschalk
-- 
-- Create Date:  
-- Design Name: 
-- Module Name: Seven Seg - Behavioral
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

use IEEE.NUMERIC_STD.ALL;
use IEEE.std_logic_unsigned.ALL;


entity SevenSeg is
    Port ( reset : in STD_LOGIC;
           clk : in STD_LOGIC;
           ID_data : in STD_LOGIC_VECTOR (15 downto 0);
           AN : out STD_LOGIC_VECTOR (7 downto 0);
           seg_code : out STD_LOGIC_VECTOR (7 downto 0));
end SevenSeg;

architecture Behavioral of SevenSeg is

signal refresh_tick : std_logic := '0'; --every 1 ms to enable one of digits

signal cycle_count : integer range 0 to 1000000 := 0; -- 1 ms 

signal digit_count : std_logic_vector(1 downto 0) := (others => '0');
signal digit_count_int : integer range 0 to 7 := 0; --up to 4 digits

signal seg_digit : std_logic_vector(3 downto 0) := (others => '0');

begin

--10 ns * 1000000 = 1 ms   (1kHz for 4 digits)
--10 ns * 1000 = 1 us (1 MHz for 4 digits)


---generate refresh_tick signal to enable a digit every 1 ms
process(clk, reset)
begin
  if(rising_edge(clk)) then 
    if (reset = '1') then 
	  cycle_count <= 0;
	  refresh_tick <= '0';	
	else
	   if (cycle_count = 10000) then 
	      cycle_count <= 0;
		  refresh_tick <= '1';
	   else
		   cycle_count <= cycle_count + 1;
		   refresh_tick <= '0';
	   end if;	
	end if;   
  end if;
end process;

process(clk,reset, refresh_tick)
begin
  if (rising_edge(clk)) then 
    if (reset = '1') then 
	   digit_count <= (others =>'0');
	else 
	    if (refresh_tick = '1') then 
		 digit_count <= digit_count + 1; 
		end if;
	end if;
  end if;
end process;


---alternative way:
process(clk,reset, refresh_tick)
begin
  if (rising_edge(clk)) then 
    if (reset = '1') then 
	   digit_count_int <= 0;
	else 
	    if (refresh_tick = '1') then 
		  if (digit_count_int = 3) then 
		      digit_count_int <= 0;
		  else
		    digit_count_int <= digit_count_int + 1; 
		  end if;
		end if;
	end if;
  end if;
end process;

--link ID_data to seg_digit
process(digit_count,ID_data)
begin
  case (digit_count) is 
   
   when "00" =>           --digit 0 is enabled
                seg_digit <= ID_data(3 downto 0);
				AN <= "11111110"; 
			--	AN <= x"E"; --digit 0
   
   when "01" =>           --digit 1 is enabled
                seg_digit <= ID_data(7 downto 4);
				
				AN <= "11111101"; 
			--	AN <= x"D"; --digit 1				
				
   when "10" =>           --digit 2 is enabled
                seg_digit <= ID_data(11 downto 8);
				AN <= "11111011"; 
			--	AN <= x"B"; --digit 2
				
   when "11" =>           --digit 3 is enabled
                seg_digit <= ID_data(15 downto 12);
				AN <= "11110111"; 
			--	AN <= x"7"; --digit 3				
				
   when others =>         --no digit is enabled
                seg_digit <= ID_data(15 downto 12);
				AN <= "11111111"; 
			--	AN <= x"F"; --all OFF
  end case;

end process;

---7-seg display encoder block 
process(seg_digit)
begin
  case (seg_digit) is
   when x"0" => seg_code <= "00000011"; --0
   when x"1" => seg_code  <= "10011111" ;  --1
   when x"2" => seg_code <= "00100101";   --2
   when x"3" => seg_code <= "00001101" ;  --3
   when x"4" => seg_code <= "10011001" ;   --4
   when x"5" => seg_code <= "01001001";  --5
   when x"6" => seg_code <= "01000001" ;  --6
   when x"7" => seg_code <= "00011111"  ;  --7
   when x"8" =>  seg_code <= "00000001"  ;  --8
   when x"9" => seg_code <= "00001001"  ;  --9
   when x"A" => seg_code <= "11000101"  ;  --a
   when x"B" => seg_code <= "11000001"  ;  --b
   when x"C" => seg_code <= "11100101"  ;  --c
   when x"D" => seg_code <= "10000101"  ;  --d
   when x"E" => seg_code <= "00100001"  ;  --e
   when x"F" => seg_code <= "01110001"  ;  --f 
   when others => seg_code <= "11111111"  ;  --all OFF
   
  end case;

end process;

end Behavioral;
