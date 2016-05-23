library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Assembling is                                      -- Bloc permettant de reconstruire les échantillons
    Port ( clock : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           data_en : in  STD_LOGIC;
           data_ok : out  STD_LOGIC;
           data : in  STD_LOGIC_VECTOR (7 downto 0);
           data_out : out  STD_LOGIC_VECTOR (15 downto 0));
end Assembling;

architecture Behavioral of Assembling is


signal stock_data : std_logic_vector(15 downto 0);
signal one: integer range 0 to 1;                        -- Integer pour la possibilité de reconstruire des échantillons plus grands

begin

process(clock, reset)
begin
if ( reset = '0' ) then
	data_ok <= '0';
	one <= 0;
	stock_data <= "1111111111111111";
elsif(rising_edge(clock)) then
	if data_en = '1' then	
		if one = 0 then
			stock_data(7 downto 0 ) <= data;
			one <= 1;
			data_ok <= '1';
			data_out <= stock_data(15 downto 0);
		else
			stock_data(15 downto 8) <= data;
			one <= 0;
			data_ok <= '0';
			
		end if;
	else 
		data_ok <= '0';
	end if ;
end if;
	

end process;


end Behavioral;


