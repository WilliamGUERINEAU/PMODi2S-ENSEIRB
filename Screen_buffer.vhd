
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Screen_buffer is
    Port ( clock : in  STD_LOGIC;
			  clock_sample : in STD_LOGIC;
           reset : in  STD_LOGIC;
           Enable : in  STD_LOGIC;
           data : in  STD_LOGIC_VECTOR (15 downto 0);
           X_data : out  STD_LOGIC_VECTOR(8 downto 0);
           Y_data : out  STD_LOGIC_VECTOR(7 downto 0)
			  );
end Screen_buffer;

architecture Behavioral of Screen_buffer is


constant LENGT : integer := 200;        -- Index value does not match array range for signal .... car pas une puissance de deux
 
type ram_type is array ((LENGT-1)  downto 0 ) of std_logic_vector ( 7 downto 0);
signal RAM : ram_type;
signal writing : integer range 0 to LENGT-1;
signal reading : integer range 0 to LENGT-1;
signal adress : integer range 0 to LENGT-1;

signal data_send_temp : std_logic;
signal first_front : std_logic;

signal rescaling : std_logic_vector ( 16 downto 0);





begin


rescaling <= std_logic_vector(unsigned(resize(signed(data),17) + to_signed(32768,17)));         -- Rescaling en valeurs positives


adress <= reading when data_send_temp = '0' else writing; 

process (clock)
begin
   if (clock'event and clock = '1') then 
         if (data_send_temp = '1') then
            RAM(adress) <= rescaling(16 downto 9);                -- Seulement 8 bits utiles
         else
            Y_data <= RAM(adress);
				X_data <= std_logic_vector(to_unsigned(reading,9));
         end if;
   end if;
end process;


process( clock, reset) -- Gestion des compteurs de lecture/écriture 
begin
if (reset ='0') then 
	writing <= 0;
elsif rising_edge(clock) then
	if data_send_temp = '1' then
		if writing = (LENGT-1) then
			writing <= 0;
		else 
			writing <= writing +1 ;
		end if;
	end if;
end if;

end process;


process(clock, reset)
begin

if reset = '0' then
	data_send_temp <='0';
	first_front <='1';
elsif rising_edge(clock) then
		if ((clock_sample = '1') and (first_front = '1')) then
			data_send_temp <= '1';
			first_front <= '0';
		elsif clock_sample ='1' then
			first_front <= '0';
			data_send_temp <= '0';
		else 
			first_front <= '1';
			data_send_temp <= data_send_temp;
		
		end if;
end if;

end process;


process(clock, reset) 
begin

if reset = '0' then
	reading <= 0;
elsif rising_edge(clock) then
	if Enable ='1' then
		if reading = (LENGT-1) then
			reading <= 0;
		else
			reading <= reading+1;
		end if;
	else 
		reading <= 0;
	end if;
end if;

end process;



end Behavioral;

