
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity TestVVGA is
    
  port(clock        : in  std_logic;
       reset        : in  std_logic;
       VGA_hs       : out std_logic;   
       VGA_vs       : out std_logic;   
       VGA_red      : out std_logic_vector(3 downto 0);   -- red output
       VGA_green    : out std_logic_vector(3 downto 0);   -- green output
       VGA_blue     : out std_logic_vector(3 downto 0));   -- blue output



end TestVVGA;

architecture Behavioral of TestVVGA is

component ScreenPainting is
    Port ( clock : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           ADDR : out  STD_LOGIC_VECTOR (14 downto 0);
           data_write : out  STD_LOGIC;
			  X_pos : out  STD_LOGIC_VECTOR (7 downto 0);
           Y_pos : out  STD_LOGIC_VECTOR (6 downto 0);
           data_in : out  STD_LOGIC_vector(1 - 1 downto 0));
end component;



component VGA_bitmap_160x120 is
  generic(bit_per_pixel : integer range 1 to 12:=1;    -- number of bits per pixel
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


signal adresse : std_logic_vector(14 downto 0);
signal m1 : std_logic;
signal m2 : std_logic_vector(1 - 1 downto 0);

begin

Screen : ScreenPainting
 port map (clock => clock, reset => reset, ADDR => adresse, data_write => m1, data_in => m2);
 
 VGA : VGA_bitmap_160x120 
 port map (clk => clock, reset => reset,ADDR => adresse, data_in => m2, data_write =>m1, VGA_hs => VGA_hs, VGA_vs=> VGA_vs, VGA_red  => VGA_red, VGA_green => VGA_green, VGA_blue => VGA_blue);





end Behavioral;

