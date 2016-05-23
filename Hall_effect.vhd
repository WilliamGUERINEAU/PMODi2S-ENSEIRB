library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Haas_effect is
    Port ( clock : in  STD_LOGIC;                                     -- Bloc de génération du stéréo
           reset : in  STD_LOGIC;
           clock_sample : in  STD_LOGIC;
           data_r_in : in  STD_LOGIC_VECTOR (15 downto 0);
           data_r_out : out  STD_LOGIC_VECTOR (15 downto 0));
end Haas_effect;

architecture Behavioral of Haas_effect is


constant LENGT : integer := 1024; -- 20 ms                      
 

type ram_type is array ((LENGT-1)  downto 0 ) of std_logic_vector (15 downto 0);
signal RAM : ram_type;


signal writing : integer range 0 to LENGT-1;
signal reading : integer range 0 to LENGT-1;
signal adress : integer range 0 to LENGT-1;


signal data_send_temp : std_logic;
signal first_front : std_logic;

begin


adress <= reading when data_send_temp = '0' else writing; 

process (clock)
begin
   if (clock'event and clock = '1') then 
         if (data_send_temp = '1') then
            RAM(adress) <= data_r_in;
         else
            data_r_out <= RAM(adress);
         end if;
   end if;
end process;


process(clock, reset)                                                            -- Process pour obtenir un front d'une largeur d'une période de clock
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

process( clock, reset) -- Gestion des compteurs de lecture/écriture 
begin

if (reset ='0') then 
	writing <= 0;
elsif rising_edge(clock) then
		if data_send_temp ='1' then
		
			if writing = (LENGT-1) then
				writing <= 0;
			else 
				writing <= writing +1 ;
			end if;
		else 
			writing <= writing;
		end if;
		
end if;

end process;

process(clock_sample, reset) 
begin
if (reset ='0') then 
	reading <= 1;
elsif rising_edge(clock_sample) then
		if reading = (LENGT-1) then
			reading <= 0;
		else 
			reading <= reading +1 ;
		end if;
end if;

end process;


end Behavioral;

