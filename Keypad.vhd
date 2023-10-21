----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Rachel Gottschalk
-- 
-- Create Date:  
-- Design Name: 
-- Module Name: Keypad - Behavioral
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Keypad is
    Port (
        CLK: in STD_LOGIC;
        row: in STD_LOGIC_VECTOR(3 downto 0);
        col: out STD_LOGIC_VECTOR(3 downto 0);
        key_pressed: out STD_LOGIC_VECTOR(3 downto 0)
    );
end Keypad;

architecture Behavioral of Keypad is
    type State_Type is (SCAN_COL, SCAN_COL2, SCAN_COL3, SCAN_COL4, CHECK_ROW, CHECK_ROW2, CHECK_ROW3, CHECK_ROW4, WAIT_RELEASE);
    signal current_state, next_state: State_Type := SCAN_COL;
    signal current_key, next_key : std_logic_vector(3 downto 0) := (others => '0');
    signal current_col, next_col : std_logic_vector(3 downto 0) := (others => '0');
    signal current_count, next_count : integer range 0 to 100_000 := 0; 
    constant DEBOUNCE_LIMIT: integer := 100_000;  
    
begin
key_pressed <= current_key;
col <= current_col;


    process(CLK)
    begin
        if rising_edge(CLK) then
            current_state <= next_state;
            current_count <= next_count;
            current_key <= next_key;
            current_col <= next_col;
            
        end if;
    end process;
    

    process(current_state, current_count,current_key,current_col,row)
    begin    
    next_state <= current_state;
    next_key <= current_key;
    next_col <= current_col;
    next_count <= current_count;
    
    case current_state is
    when SCAN_COL =>
        if(current_count =  DEBOUNCE_LIMIT) then
            next_col <= "0111";
            next_count <= 0;
            next_state <= CHECK_ROW;
        else
            next_count <= current_count + 1;
        end if;
    
    when CHECK_ROW =>
        if(current_count = 8) then
            next_count <= 0;
            next_state <= SCAN_COL2;
                    --scan all rows to determine the key_code
             if (row = "0111") then 
                 next_key <= "0001";  -- digit 1
             elsif (row = "1011") then 
                  next_key <= "0100";  --digit 4
             elsif( row = "1101") then 
                  next_key <= "0111";  --digit 7
             elsif (row = "1110") then 
                  next_key <= "1110";  -- digit *   ( E )
             end if;
         else
            next_count <= current_count + 1;
         end if;
         
    when SCAN_COL2 =>
        if(current_count =  DEBOUNCE_LIMIT) then
            next_col <= "1011";
            next_count <= 0;
            next_state <= CHECK_ROW2;
        else
            next_count <= current_count + 1;
        end if;
        
    when CHECK_ROW2 =>
       if(current_count = 8) then
           next_count <= 0;
           next_state <= SCAN_COL3;         
           --scan all rows to determine the key_code
           if (row = "0111") then 
               next_key <= "0010";  -- digit 2
           elsif (row = "1011") then 
                next_key <= "0101";  --digit 5
           elsif( row = "1101" ) then 
               next_key <= "1000";  --digit 8
           elsif (row = "1110") then 
               next_key <= "0000";  -- digit 0   
           end if;
         else
            next_count <= current_count + 1;
         end if;
                
     when SCAN_COL3 =>
        if(current_count =  DEBOUNCE_LIMIT) then
            next_col <= "1101";
            next_count <= 0;
            next_state <= CHECK_ROW3;
        else
            next_count <= current_count + 1;
        end if;
        
     when CHECK_ROW3 =>
       if(current_count = 8) then
           next_count <= 0;     
            next_state <= SCAN_COL4; 
                --scan all rows to determine the key_code
            if (row = "0111") then 
             next_key <= "0011";  -- digit 3
            elsif (row = "1011") then 
             next_key <= "0110";  --digit 6
            elsif( row = "1101") then 
             next_key <= "1001";  --digit 9
            elsif (row = "1110") then 
             next_key <= "1111";  -- digit #  (F)   
            end if;       
        else
            next_count <= current_count + 1;
        end if;
                
      when SCAN_COL4 =>
        if(current_count =  DEBOUNCE_LIMIT) then
            next_col <= "1110";
            next_count <= 0;
            next_state <= CHECK_ROW4;
        else
            next_count <= current_count + 1;
        end if;
        
      when CHECK_ROW4 =>
       if(current_count = 8) then
           next_count <= 0;         
            next_state <= SCAN_COL;
            if (row = "0111") then 
             next_key <= "1010";  -- digit A
            elsif (row = "1011") then 
             next_key <= "1011";  --digit B
            elsif( row = "1101" ) then 
             next_key <= "1100";  --digit C
            elsif (row = "1110") then 
             next_key <= "1101";  -- digit D   
            end if;   
        else
            next_count <= current_count + 1;
        end if;                 
       
      when others =>
        next_state <= SCAN_COL;
        
    end case;
        
    end process;

end Behavioral;