----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:46:51 05/21/2016 
-- Design Name: 
-- Module Name:    vol_control - Behavioral 
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity vol_control is
    Port ( --Clock : in  STD_LOGIC;
           volume : in  STD_LOGIC_VECTOR (2 downto 0);
           data_in : in  STD_LOGIC_VECTOR (15 downto 0);
           data_out : out  STD_LOGIC_VECTOR (15 downto 0)
          );
end vol_control;

architecture Behavioral of vol_control is
signal vol : integer range 0 to 7;
signal ent : integer range -65536 to 65535;
signal sor : integer range -65536 to 65535;


begin

ent <= to_integer(signed(data_in));
vol <= to_integer(unsigned(volume));

sor <= ent*vol/7;

data_out <= std_logic_vector(to_signed(sor,16));

end Behavioral;

