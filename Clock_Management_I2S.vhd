
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Clock_Management_I2S is
    Port ( clock : in  STD_LOGIC;  --22,579 MHz
           reset : in  STD_LOGIC;
           LRCK : out  STD_LOGIC;  -- 22,579MHz/(88200*32) = 8  Essai avec 44100 Hz
           SCK : out  STD_LOGIC);  -- 22,579MHz/88200 = 256   
end Clock_Management_I2S;

architecture Behavioral of Clock_Management_I2S is


signal lrck_count : integer range 0 to 255; --127
signal sck_count : integer range 0 to 7; -- 3
signal lrck_temp : std_logic;
signal sck_temp : std_logic;


begin

LRCK <= lrck_temp;
SCK <= sck_temp;

lrck_generator : process (clock, reset)

begin

if reset = '0' then
	lrck_count <= 255;
	lrck_temp <= '0';
elsif rising_edge(clock) then
	if lrck_count = 255 then
		lrck_count <= 0 ;
		lrck_temp <= not(lrck_temp);
	else
		lrck_temp <= lrck_temp;
		lrck_count <= lrck_count +1;
	end if;
end if;

end process;


sck_generator : process (clock, reset)

begin

if reset = '0' then
	sck_count <= 7;
	sck_temp <= '1';
elsif rising_edge(clock) then
	if sck_count = 7 then
		sck_count <= 0 ;
		sck_temp <= not(sck_temp);
	else
		sck_temp <= sck_temp;
		sck_count <= sck_count +1;
	end if;
end if;

end process;

end Behavioral;

