----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    09:42:23 03/27/2014 
-- Design Name: 
-- Module Name:    MUX - Behavioral 
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

entity MUX is
    Port ( D7 : in  STD_LOGIC_VECTOR (4 downto 0);
			  D6 : in  STD_LOGIC_VECTOR (4 downto 0);
			  D5 : in  STD_LOGIC_VECTOR (4 downto 0);
			  D4 : in  STD_LOGIC_VECTOR (4 downto 0);
			  D3 : in  STD_LOGIC_VECTOR (4 downto 0);
           D2 : in  STD_LOGIC_VECTOR (4 downto 0);
           D1 : in  STD_LOGIC_VECTOR (4 downto 0);
           D0 : in  STD_LOGIC_VECTOR (4 downto 0);
           ADR : in  STD_LOGIC_VECTOR (2 downto 0);
           SORTIE : out  STD_LOGIC_VECTOR (4 downto 0));
end MUX;

architecture Behavioral of MUX is

begin

Multi:Process(ADR,D0,D1,D2,D3,D4,D5,D6,D7)
begin
   CASE ADR is 
	  when "000" => SORTIE <= D0; 
	  when "001" => SORTIE <= D1;
	  when "010" => SORTIE <= D2;
	  when "011" => SORTIE <= D3;
	  when "100" => SORTIE <= D4;
	  when "101" => SORTIE <= D5;
	  when "110" => SORTIE <= D6;
	  when others => SORTIE <= D7;
   END CASE;
end process;	
	

end Behavioral;

