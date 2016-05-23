
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Temporisation is
    Port ( data_ok : in  STD_LOGIC;                                     -- Bloc de temporisation des données
			  clock : in  STD_LOGIC;
			  clock_sample : in  STD_LOGIC;
			  play_pause : in std_logic;
			  foward : in std_logic;
			  restart : in std_logic;
           reset : in  STD_LOGIC;
           data : in  STD_LOGIC_VECTOR (15 downto 0);
           data_out : out  STD_LOGIC_VECTOR (15 downto 0));
end Temporisation;

architecture Behavioral of Temporisation is

constant LENGT : integer := 220500;                 -- 44100 * 5 => 5 secondes 
 

type ram_type is array ((LENGT-1)  downto 0 ) of std_logic_vector (15 downto 0);
signal RAM : ram_type;


signal writing : integer range 0 to LENGT-1;
signal reading : integer range 0 to LENGT-1;
signal adress : integer range 0 to LENGT-1;

begin



process (clock)
begin

   if (clock'event and clock = '1') then 
         data_out <= RAM(reading);
			if (data_ok = '1') then
            RAM(writing) <= data;       
         end if;
   end if;
end process;


process( clock, reset) -- Gestion des compteurs de lecture/écriture 
begin

if (reset ='0') then 
	writing <= 0;
elsif rising_edge(clock) then
	if data_ok = '1' then
		if writing = (LENGT-1) then
			writing <= 0;
		else 
			writing <= writing +1 ;
		end if;
	end if;
end if;

end process;







process(clock_sample, reset) 
begin

if reset = '0' then
	reading <= 0;
elsif rising_edge(clock_sample) then   -- Horloge à 44100 Hz

	if restart ='1' then
		reading <= 0;
	elsif play_pause = '1' then
		if foward = '1' then
			if reading = (LENGT-1) then
				reading <= 0;
			else
				reading <= reading+1;
			end if;
		else
			if reading = 0 then
				reading <= (LENGT-1);
			else
				reading <= reading - 1;
			end if;	
	
		end if;
	else 
		reading <= reading;
	end if;	
end if;

end process;


end Behavioral;

