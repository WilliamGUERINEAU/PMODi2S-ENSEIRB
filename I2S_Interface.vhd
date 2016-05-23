
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity I2S_Interface is
    Port ( SCK : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           data_l : in  STD_LOGIC_VECTOR(15 downto 0);
           data_r : in  STD_LOGIC_VECTOR(15 downto 0);
           data_out : out  STD_LOGIC);
end I2S_Interface;

architecture Behavioral of I2S_Interface is

signal bit_count : integer range 0 to 15;
signal next_data : std_logic_vector( 15 downto 0);
signal hold_data : std_logic_vector( 15 downto 0);
signal change : std_logic ;

begin


next_data <= hold_data when change = '1' else data_l; 



-- Data sending 


data_sending : process(SCK, reset) 

begin

if reset = '0' then
	data_out <= '0';
	change <= '1';
	bit_count <= 15; 
elsif falling_edge(SCK) then
	data_out <= next_data(bit_count);
	if bit_count = 0 then
		change <= not(change); 
		bit_count <= 15;
		
	else
		bit_count <= bit_count - 1;
	end if;
	if bit_count = 15 then
		hold_data <= data_r;
	else
		hold_data <= hold_data;
	end if;	
end if;
	

end process;

end Behavioral;

