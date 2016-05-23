
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity TestPMOD is
    Port ( clock : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           mck : out  STD_LOGIC;
           lrck : out  STD_LOGIC;
           sck : out  STD_LOGIC;
           data : out  STD_LOGIC);
end TestPMOD;

architecture Behavioral of TestPMOD is

signal cpt : integer range 0 to 18000;

component I2Spmod is
    Port ( clock : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           data_in_l : in  STD_LOGIC_VECTOR (15 downto 0);
           data_in_r : in  STD_LOGIC_VECTOR (15 downto 0);
           data_out : out  STD_LOGIC;
           mck : out  STD_LOGIC;
           lrck : out  STD_LOGIC;
           sck : out  STD_LOGIC);
end component;


begin


process (reset, clock)
begin

if reset = '1' then
	cpt <= 0;
elsif (rising_edge(clock)) then
	if cpt = 18000 then
		cpt <= 0 ;
	else 
		cpt <= cpt +1;
	end if;
end if;

end process;


i2s : I2Spmod port map (clock => clock, reset => reset, data_in_l =>std_logic_vector(to_signed(cpt,16)), data_in_r => std_logic_vector(to_signed(cpt,16)), mck => mck, sck => sck, data_out => data, lrck => lrck);




end Behavioral;

