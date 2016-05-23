library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity RAM_tempo is
    Port ( clock : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           data_r_in : in  STD_LOGIC_VECTOR (15 downto 0);
           X_data : out  STD_LOGIC_VECTOR (6 downto 0);
           Y_data : out  STD_LOGIC_VECTOR (6 downto 0));
end RAM_tempo;

architecture Behavioral of RAM_tempo is


constant LENGT : integer := 100; 
 

type ram_type is array ((LENGT-1)  downto 0 ) of std_logic_vector (15 downto 0);
signal RAM : ram_type;


signal writing : integer range 0 to LENGT-1;
signal reading : integer range 0 to LENGT-1;
signal adress : integer range 0 to LENGT-1;

signal data_valid  std_logic;

begin


adress <= reading when data_valid = '0' else writing; 

process (clock)
begin
   if (clock'event and clock = '1') then 
         if (data_valid = '1') then
            RAM(adress) <= data_r_in;
         else
            data_r_out <= RAM(adress);
         end if;
   end if;
end process;


process( clock, reset) -- Gestion des compteurs de lecture/écriture avec le taux d'échantillonnage
begin

if (reset ='1') then 
	writing <= 0;
elsif rising_edge(clock) then
		if data_valid ='1' then
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


process(clock, reset)
begin

if reset = '1' then
	filtring <= 0;
	data_valid <= '0';
elsif rising_edge(clock) then
	if filtring = 441 then
		filtring <= 0;
		data_valid <= '1';
	else filtring <= filtring +1;
	end if;
	

end process;


process(clock, reset) 
begin
if (reset ='1') then 
	reading <= 0;
elsif rising_edge(clock) then
		if reading = (LENGT-1) then
			reading <= 0;
		else 
			reading <= reading +1 ;
		end if;
end if;

end process;



end Behavioral;



