----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Rachel Gottschalk
-- 
-- Create Date:    11:14:03 09/14/2023
-- Design Name: 
-- Module Name:    look_ahead_add_sub - Behavioral
-- Project Name:   Lab 1
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

entity look_ahead_adder_subtractor is
    Port ( A : in  STD_LOGIC_VECTOR (3 downto 0);
           B : in  STD_LOGIC_VECTOR (3 downto 0);
           OP_SEL : in  STD_LOGIC; -- 0 for addition, 1 for subtraction
           Cout : out  STD_LOGIC;
           S : out  STD_LOGIC_VECTOR (3 downto 0));
end look_ahead_adder_subtractor;

architecture Behavioral of look_ahead_adder_subtractor is

    signal G, P, Gp, Pp: STD_LOGIC_VECTOR(3 downto 0);
    signal C: STD_LOGIC_VECTOR(4 downto 0);

begin

    -- Generate and Propagate signals
    GenProc: for i in 0 to 3 generate
        G(i) <= A(i) and B(i);
        P(i) <= A(i) xor B(i);
    end generate GenProc;

    -- XOR with OP_SEL to handle subtraction
    B_sub: for i in 0 to 3 generate
        Gp(i) <= G(i) xor OP_SEL;
        Pp(i) <= P(i) xor OP_SEL;
    end generate B_sub;

    -- Look-ahead carry logic
    C(0) <= OP_SEL;
    C(1) <= Gp(0) or (Pp(0) and OP_SEL);
    C(2) <= Gp(1) or (Pp(1) and Gp(0)) or (Pp(1) and Pp(0) and OP_SEL);
    C(3) <= Gp(2) or (Pp(2) and Gp(1)) or (Pp(2) and Pp(1) and Gp(0)) or (Pp(2) and Pp(1) and Pp(0) and OP_SEL);
    C(4) <= Gp(3) or (Pp(3) and Gp(2)) or (Pp(3) and Pp(2) and Gp(1)) or (Pp(3) and Pp(2) and Pp(1) and Gp(0));

    Cout <= C(4);

    -- Sum calculation
    S(0) <= Pp(0) xor C(0);
    S(1) <= Pp(1) xor C(1);
    S(2) <= Pp(2) xor C(2);
    S(3) <= Pp(3) xor C(3);

end Behavioral;
