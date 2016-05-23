
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Top_module_VGA is                                                        -- Module traduisant des informations avec des coordonnées en points sur l'écran
    port(clock        : in  std_logic;
         reset        : in  std_logic;
         X_data       : in  STD_LOGIC_VECTOR(8 downto 0);
         Y_data       : in  STD_LOGIC_VECTOR (7 downto 0);
			X_data2 : in  STD_LOGIC_VECTOR(8 downto 0);
         Y_data2 : in  STD_LOGIC_VECTOR (7 downto 0);
         Enable       : out std_logic;   
 --        Valid        : out std_logic;   
         VGA_hs       : out std_logic;   
         VGA_vs       : out std_logic;   
         VGA_red      : out std_logic_vector(3 downto 0);   -- red output
         VGA_green    : out std_logic_vector(3 downto 0);   -- green output
         VGA_blue     : out std_logic_vector(3 downto 0));   -- blue output
end Top_module_VGA;



architecture Behavioral of Top_module_VGA is


component VGA_bitmap_320x240 is
  generic(bit_per_pixel : integer range 1 to 12:=2;    -- number of bits per pixel
          grayscale     : boolean := false);           -- should data be displayed in grayscale
  port(clk          : in  std_logic;
       reset        : in  std_logic;
       VGA_hs       : out std_logic;   -- horisontal vga syncr.
       VGA_vs       : out std_logic;   -- vertical vga syncr.
       VGA_red      : out std_logic_vector(3 downto 0);   -- red output
       VGA_green    : out std_logic_vector(3 downto 0);   -- green output
       VGA_blue     : out std_logic_vector(3 downto 0);   -- blue output

       ADDR         : in  std_logic_vector(16 downto 0);
       data_in      : in  std_logic_vector(bit_per_pixel - 1 downto 0);
       data_write   : in  std_logic;
       data_out     : out std_logic_vector(bit_per_pixel - 1 downto 0));
end component;

component VGA_bitmap_160x120 is
  generic(bit_per_pixel : integer range 1 to 12:=2;    -- number of bits per pixel
          grayscale     : boolean := false);           -- should data be displayed in grayscale
  port(clk          : in  std_logic;
       reset        : in  std_logic;
       VGA_hs       : out std_logic;   -- horisontal vga syncr.
       VGA_vs       : out std_logic;   -- vertical vga syncr.
       VGA_red      : out std_logic_vector(3 downto 0);   -- red output
       VGA_green    : out std_logic_vector(3 downto 0);   -- green output
       VGA_blue     : out std_logic_vector(3 downto 0);   -- blue output

       ADDR         : in  std_logic_vector(14 downto 0);
       data_in      : in  std_logic_vector(bit_per_pixel - 1 downto 0);
       data_write   : in  std_logic;
       data_out     : out std_logic_vector(bit_per_pixel - 1 downto 0));
end component;

component window is
    Port ( clock : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           X_data : in  STD_LOGIC_VECTOR(8 downto 0);
           Y_data : in  STD_LOGIC_VECTOR (7 downto 0);
			  X_data2 : in  STD_LOGIC_VECTOR(8 downto 0);
           Y_data2 : in  STD_LOGIC_VECTOR (7 downto 0);
           X_pos : in  STD_LOGIC_VECTOR( 8 downto 0);
           Y_pos : in  STD_LOGIC_VECTOR( 7 downto 0);
           data_write : out  STD_LOGIC;
           Enable : out  STD_LOGIC;
--           Valid  : out  STD_LOGIC;
           data_in : out  STD_LOGIC_VECTOR (1 downto 0));
end component;



component ScreenPainting is
    Port ( clock : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           ADDR : out  STD_LOGIC_VECTOR (16 downto 0);
           X_pos : out  STD_LOGIC_VECTOR (8 downto 0);
           Y_pos : out  STD_LOGIC_VECTOR (7 downto 0)
           );
end component;



signal adresse : std_logic_vector(16 downto 0);
signal Y_pos_temp : std_logic_vector(7 downto 0);--6
signal X_pos_temp : std_logic_vector(8 downto 0);
signal data_w : std_logic;
signal color : std_logic_vector(1 downto 0);
begin

GA : VGA_bitmap_320x240 
 port map (clk => clock, reset => reset, ADDR => adresse, data_in => color, data_write =>data_w, VGA_hs => VGA_hs, VGA_vs=> VGA_vs, VGA_red  => VGA_red, VGA_green => VGA_green, VGA_blue => VGA_blue);

SP : ScreenPainting 
	Port map (
		clock => clock,
		reset => reset,
		ADDR => adresse,
		X_pos => X_pos_temp,
		Y_pos => Y_pos_temp);

W1 : window

	port map 
		
	( 	clock => clock,
		reset => reset,
		X_data => X_data,
		Y_data => Y_data,
		X_data2 => X_data2,
      Y_data2 => Y_data2,
		X_pos => X_pos_temp,
		Y_pos => Y_pos_temp,
		data_write => data_w,
		data_in => color,
--		Valid => Valid,
		Enable => Enable);
	


end Behavioral;

