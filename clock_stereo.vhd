library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity clock_stereo is
    Port ( clock : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           MCK : out  STD_LOGIC;
			  CLK_100M   : out    std_logic;

           LRCK : out  STD_LOGIC;
           SCK : out  STD_LOGIC);
end clock_stereo;

architecture Behavioral of clock_stereo is


component clockgen
port
 (-- Clock in ports
  CLK_100M           : in     std_logic;
  -- Clock out ports
  MCK          : out    std_logic;
  CLK_100M_sync          : out    std_logic

 );
end component;


component Clock_Management_I2S is
    Port ( clock : in  STD_LOGIC;  --22,579 MHz
           reset : in  STD_LOGIC;
           LRCK : out  STD_LOGIC;  -- 22,579MHz/(88200*32) = 8
           SCK : out  STD_LOGIC);  -- 22,579MHz/88200 = 226
end component;


Signal MCK_temp : std_logic;



begin

Gen : clockgen
  port map
   (-- Clock in ports
    CLK_100M => clock,
    -- Clock out ports
	 CLK_100M_sync => CLK_100M,

    MCK => MCK_temp);
	 
Clock_manag : Clock_Management_I2S 
	port map 
	 ( clock => MCK_temp, reset => reset, LRCK => LRCK, SCK => SCK);

MCK <= MCK_temp;



end Behavioral;

