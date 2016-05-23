
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity TestVGA is                                                             -- Bloc de gestion du VGA
    Port ( clock : in  STD_LOGIC;
			  clock_sample : in STD_LOGIC;                                       -- Horloge d'échantillonage 
           reset : in  STD_LOGIC;
           data : in  STD_LOGIC_VECTOR (15 downto 0) ;                        -- Fenêtre du haut
           data2 : in  STD_LOGIC_VECTOR (15 downto 0) ;                       -- Fenêtre du bas
			  VGA_hs       : out std_logic;   
           VGA_vs       : out std_logic;   
           VGA_red      : out std_logic_vector(3 downto 0);   -- red output
           VGA_green    : out std_logic_vector(3 downto 0);   -- green output
           VGA_blue     : out std_logic_vector(3 downto 0));   -- blue output
end TestVGA;

architecture Behavioral of TestVGA is



component Screen_buffer is
    Port ( clock : in  STD_LOGIC;
			  clock_sample : in STD_LOGIC;
           reset : in  STD_LOGIC;
           Enable : in  STD_LOGIC;
           data : in  STD_LOGIC_VECTOR (15 downto 0);
           X_data : out  STD_LOGIC_VECTOR(8 downto 0);
           Y_data : out  STD_LOGIC_VECTOR(7 downto 0)
			);
end component;

component Top_module_VGA is
    port(clock        : in  std_logic;
         reset        : in  std_logic;
         X_data       : in  STD_LOGIC_VECTOR(8 downto 0);
         Y_data       : in  STD_LOGIC_VECTOR (7 downto 0);
			X_data2      : in  STD_LOGIC_VECTOR(8 downto 0);
         Y_data2      : in  STD_LOGIC_VECTOR (7 downto 0);
         Enable       : out std_logic;   
         VGA_hs       : out std_logic;   
         VGA_vs       : out std_logic;   
         VGA_red      : out std_logic_vector(3 downto 0);   -- red output
         VGA_green    : out std_logic_vector(3 downto 0);   -- green output
         VGA_blue     : out std_logic_vector(3 downto 0));   -- blue output
end component;

signal X_data_temp : STD_LOGIC_VECTOR(8 downto 0);
signal Y_data_temp : STD_LOGIC_VECTOR(7 downto 0);
signal X_data_temp2 : STD_LOGIC_VECTOR(8 downto 0);
signal Y_data_temp2 : STD_LOGIC_VECTOR(7 downto 0);
signal en : std_logic;

begin


buff : Screen_buffer 
    Port map( clock => clock,
			  clock_sample => clock_sample,
           reset => reset,
           data => data,
			  Enable => en,
           X_data => X_data_temp,
           Y_data => Y_data_temp);

buff2 : Screen_buffer 
    Port map( clock => clock,
			  clock_sample => clock_sample,
           reset => reset,
           data => data2,
			  Enable => en,
           X_data => X_data_temp2,
           Y_data => Y_data_temp2);
			  
VGA : Top_module_VGA 
    port map (clock   => clock,
         reset        => reset,
         X_data       => X_data_temp,
         Y_data       => Y_data_temp,
         X_data2       => X_data_temp2,
         Y_data2       => Y_data_temp2,
         Enable       => en,   
         VGA_hs       => VGA_hs,   
         VGA_vs       => VGA_vs,   
         VGA_red      => VGA_red,   -- red output
         VGA_green    => VGA_green,   -- green output
         VGA_blue     => VGA_blue);   -- blue output




end Behavioral;

