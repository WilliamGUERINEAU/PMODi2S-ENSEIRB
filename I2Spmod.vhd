----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:10:30 04/23/2016 
-- Design Name: 
-- Module Name:    I2Spmod - Behavioral 
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity I2Spmod is
    Port ( clock : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           data_in_l : in  STD_LOGIC_VECTOR (15 downto 0);
           data_in_r : in  STD_LOGIC_VECTOR (15 downto 0);
           data_out : out  STD_LOGIC;
           mck : out  STD_LOGIC;
           lrck : out  STD_LOGIC;
           sck : out  STD_LOGIC);
end I2Spmod;





architecture Behavioral of I2Spmod is

signal mclk_count : integer range 0 to 3;
signal lrck_count : integer range 0 to 2268;
signal sck_count : integer range 0 to 71;

signal bit_count : integer range 0 to 15;

signal sck_in : std_logic;
signal lrck_in : std_logic;
signal mclk_in : std_logic;

signal next_data : std_logic_vector(15 downto 0);

begin

-- Clock generating process : MCLK = 22.5792 Mhz , LRCK = 44.1 khz and SCK = 32*LRCK

mclk_generator : process (clock, reset)

begin

if reset = '1' then
	mclk_count <= 0 ;
	mclk_in <= '1';
elsif rising_edge(clock) then
	if mclk_count = 1 then
		mclk_count <= 0 ;
		mclk_in <= not(mclk_in);
	else
		mclk_in <= mclk_in;
		mclk_count <= mclk_count +1;
	end if;
end if;

end process;


lrck_generator : process (clock, reset)

begin

if reset = '1' then
	lrck_count <= 0 ;
	lrck_in <= '1';
elsif rising_edge(clock) then
	if lrck_count = 1132 then
		lrck_count <= 0 ;
		lrck_in <= not(lrck_in);
	else
		lrck_in <= lrck_in;
		lrck_count <= lrck_count +1;
	end if;
end if;

end process;

sck_generator : process (clock, reset)

begin

if reset = '1' then
	sck_count <= 0 ;
	sck_in <= '1' ;
elsif rising_edge(clock) then
	if sck_count = 35 then
		sck_count <= 0 ;
		sck_in <= not(sck_in);
	else
		sck_in <= sck_in;
		sck_count <= sck_count +1;
	end if;
end if;

end process;


-- Data sending 

sck <= sck_in;
lrck <= lrck_in;
mck <= mclk_in;

data_sending : process(sck_in, reset) 

begin

if reset = '1' then
	data_out <= '0';
	bit_count <= 0;
elsif falling_edge(sck_in) then
	if bit_count = 0 then
		data_out <= next_data(15);

		if lrck_in = '1' then
			next_data <= data_in_l;
		else 
			next_data <= data_in_r;
		end if;
		bit_count <= 15;
	else 
		next_data(15 downto 1) <= next_data(14 downto 0); 
		bit_count <= bit_count - 1;
	end if;
end if;
	

end process;



end Behavioral;

