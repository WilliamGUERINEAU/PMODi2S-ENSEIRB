----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    09:51:42 04/11/2016 
-- Design Name: 
-- Module Name:    TranslatingTemporal - Behavioral 
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

entity TranslatingTemporal is
    Port ( clock : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           data_in : in  STD_LOGIC_VECTOR (12 downto 0);
           Y_amp : out  STD_LOGIC_VECTOR (7 downto 0);
           X_amp : out  STD_LOGIC_VECTOR (7 downto 0));
end TranslatingTemporal;

architecture Behavioral of TranslatingTemporal is

begin


end Behavioral;

