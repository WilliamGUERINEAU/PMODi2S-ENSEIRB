
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity I2S_pmod is                                                     -- Module de gestion du PMOD Stéréo I²S
    Port ( clock : in  STD_LOGIC;
           reset : in  STD_LOGIC;												  -- Attention : bien utiliser le clock 100Mhz en sortie pour avoir un traitement correctement synchro !
           data_r : in  STD_LOGIC_VECTOR (15 downto 0);
           data_l : in  STD_LOGIC_VECTOR (15 downto 0);
           data_out : out  STD_LOGIC;
           MCK : out  STD_LOGIC;
           LRCK : out  STD_LOGIC;
			  CLK_100M   : out    std_logic;
           SCK : out  STD_LOGIC);
end I2S_pmod;

architecture Behavioral of I2S_pmod is

component I2S_Interface is 
    Port ( SCK : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           data_l : in  STD_LOGIC_VECTOR(15 downto 0);
           data_r : in  STD_LOGIC_VECTOR(15 downto 0);
           data_out : out  STD_LOGIC);
end component;

component clock_stereo is
    Port ( clock : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           MCK : out  STD_LOGIC;
           LRCK : out  STD_LOGIC;
			  CLK_100M          : out    std_logic;
           SCK : out  STD_LOGIC);
end component;



signal SCK_temp : std_logic;

begin


I2S_mod : I2S_Interface 
	port map (
		SCK => SCK_temp,
		reset => reset,
		data_r => data_l,
		data_l => data_r,
		data_out => data_out
		);
clock_stereo_TOP : clock_stereo 
	port map (
		clock => clock,
		reset => reset,
		MCK => MCK,
      CLK_100M => CLK_100M,
		LRCK => LRCK,
		SCK => SCK_temp);
		
		
SCK <= SCK_temp;


end Behavioral;

