----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    09:36:58 03/27/2014 
-- Design Name: 
-- Module Name:    cpt_modulo4 - Behavioral 
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

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity cpt_modulo8 is
    Port ( RAZ : in  STD_LOGIC;
           clockEnableDisplay : in  STD_LOGIC;
           H : in  STD_LOGIC;
           SORTIE : out  STD_LOGIC_VECTOR (2 downto 0));
end cpt_modulo8;

architecture Behavioral of cpt_modulo8 is

constant modulo: integer:=8;
signal s : integer range 0 to modulo-1;

begin

process(H,clockEnableDisplay,RAZ)
begin
if H'event and H='1' then
       if RAZ = '0' then
		    s <= 0;
		 elsif clockEnableDisplay = '1' then
		      case s is
            when modulo-2 => s <= modulo-1; 
				when modulo-1 => s <= 0; 
				when others => s <= s+1;
				end case;
		 end if;
end if;
end process;

SORTIE <= std_logic_vector(to_unsigned(s,3));

end Behavioral;

