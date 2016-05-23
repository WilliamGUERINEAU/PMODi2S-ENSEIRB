----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:55:33 12/07/2015 
-- Design Name: 
-- Module Name:    bcd2seg - Behavioral 
-- Project Name: 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity bcd2seg is
    Port ( bcd : in  STD_LOGIC_VECTOR (4 downto 0);
			  aff : in STD_logic_vector (2 downto 0);
			  anode : out STD_logic_vector(7 downto 0);
           cathode : out  STD_LOGIC_VECTOR (6 downto 0));
end bcd2seg;

architecture Behavioral of bcd2seg is

signal lettre: STD_logic;

begin
process (bcd)
  begin
       case bcd is
		     when "00000" => cathode<= "1000000"; -- affichage de 0 & O
			  when "00001" => cathode<= "1111001"; -- affichage de 1 & I
			  when "00010" => cathode<= "0100100"; -- affichage de 2 
			  when "00011" => cathode<= "0110000"; -- affichage de 3
			  when "00100" => cathode<= "0011001"; -- affichage de 4 & y
			  when "00101" => cathode<= "0010010"; -- affichage de 5 & S
			  when "00110" => cathode<= "0000010"; -- affichage de 6 & b 
			  when "00111" => cathode<= "1111000"; -- affichage de 7
			  when "01000" => cathode<= "0000000"; -- affichage de 8
			  when "01001" => cathode<= "0010000"; -- affichage de 9 & g
			  when "01010" => cathode<= "0001000"; -- affichage de A
			  when "01011" => cathode<= "0000011"; -- affichage de b
			  when "01100" => cathode<= "0001001"; -- affichage de H
			  when "01101" => cathode<= "0100001"; -- affichage de d
			  when "01110" => cathode<= "0000110"; -- affichage de E
			  when "01111" => cathode<= "0101011"; -- affichage de n
			  when "10000" => cathode<= "0001100";-- affichage de p
			  when "10001" => cathode<= "1000111";-- affichage de L
			  when "10010" => cathode<= "1111111";-- affichage de rien
			  when others => cathode<= "0000100"; -- affichage d'erreur--e
       end case;
  end process;

 process (aff)
  begin
     case aff is
	       when "000" => anode<= "01111111";
			 when "001" => anode<= "10111111";
			 when "010" => anode<= "11011111";
			 when "011" => anode<= "11101111";
			 when "100" => anode<= "11110111";
			 when "101" => anode<= "11111011";
			 when "110" => anode<= "11111101";
			 when "111" => anode<= "11111110";
			 when others => anode <= "11111111"; 
	  end case;
  end process;
  
end Behavioral;

