
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;
 
entity ScreenPainting is                                       -- Module de création du curseur
    Port ( clock : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           ADDR : out  STD_LOGIC_VECTOR (16 downto 0);
           X_pos : out  STD_LOGIC_VECTOR (8 downto 0);
           Y_pos : out  STD_LOGIC_VECTOR (7 downto 0) 
           );
end ScreenPainting;

architecture Behavioral of ScreenPainting is


signal X_work : integer range 0 to 320;
signal Y_work : integer range 0 to 240;
signal adresse : integer range 0 to 76800;   -- 320 *240

begin

process(clock, reset)


begin


if (reset ='0') then 

	X_work <= 0;
	Y_work <= 0;
	adresse <= 0;
elsif(rising_edge(clock)) then
	if adresse = 76799 then   
   	X_work <= 0;
		Y_work <= 0;
		adresse <= 0;
	elsif X_work = 319 then
		Y_work <= Y_work + 1;
		X_work <= 0;
		adresse <= adresse + 1;
	else 
		Y_work <= Y_work;
		X_work <= X_work + 1;
		adresse <= adresse + 1;
	end if;
end if;
end process;

ADDR <= std_logic_vector(to_unsigned(adresse,17));
X_pos <= std_logic_vector(to_unsigned(X_work,9));
Y_pos <= std_logic_vector(to_unsigned(Y_work,8));






end Behavioral;

