----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:09:13 12/02/2014 
-- Design Name: 
-- Module Name:    Transcoder - Behavioral 
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
use IEEE.NUMERIC_STD.ALL;
use ieee.std_logic_unsigned.all;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Transcoder is
    Port ( score : in  STD_LOGIC_VECTOR (4 downto 0);
           disp0 : out  STD_LOGIC_VECTOR (3 downto 0);
			  disp1 : out  STD_LOGIC_VECTOR (3 downto 0);
			  disp2 : out  STD_LOGIC_VECTOR (3 downto 0);
			  disp3 : out  STD_LOGIC_VECTOR (3 downto 0));
end Transcoder;

architecture Behavioral of Transcoder is


signal bcd: STD_LOGIC_VECTOR (9 downto 0);
signal bin: STD_LOGIC_VECTOR (7 downto 0);

begin

bin(7 downto 5)<="000";bin(4 downto 0)<=score;

process(bin)
variable z: std_logic_vector(17 downto 0);

begin 
     for i in 0 to 17 loop
	       z(i) := '0';
	  end loop;
	       z(10 downto 3) := bin;
	  for i in 0 to 4 loop
	       if z(11 downto 8) > 4 then
			     z(11 downto 8) := z(11 downto 8)+3;
			 end if;
			 if z(15 downto 12) > 4 then
			     z(15 downto 12) := z(15 downto 12)+3;
			 end if;
			 z(17 downto 1) := z(16 downto 0);
	  end loop;
	  bcd <= z( 17 downto 8);
end process;

disp3 <= "0000";
disp2 <= "0000";
disp1 <= bcd(7 downto 4);
disp0 <= bcd(3 downto 0);
      
end Behavioral;

