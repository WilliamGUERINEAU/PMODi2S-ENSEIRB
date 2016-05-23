----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    21:45:51 05/21/2016 
-- Design Name: 
-- Module Name:    select_input - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity select_input is
    Port ( Clock : in  STD_LOGIC;
           --reset : in  STD_LOGIC;
			  switch : in std_logic;
           data_uart : in  STD_LOGIC_VECTOR (7 downto 0);
           data_sd : in  STD_LOGIC_VECTOR (7 downto 0);
           uart_on : out  STD_LOGIC;
           data_out : out  STD_LOGIC_VECTOR (7 downto 0);
           edge_detect : out  STD_LOGIC);
end select_input;

architecture Behavioral of select_input is
 signal detection:STD_LOGIC;
 signal delayed:STD_LOGIC;
 signal add: integer range 0 to 220500;
begin

process(clock)
    begin
        if clock= '1' and clock'event then
               delayed<=switch;
        end if;
    end process;
detection <= switch xor delayed;

process(clock)
	begin
		if clock= '1' and clock'event then
			if (switch ='1') then
				data_out <= data_sd;
				uart_on <= '0';
			elsif (switch = '0') then
				data_out <= data_uart;
				uart_on <= '1';
			end if;
		end if;
	end process;
	edge_detect <= detection;

end Behavioral;

