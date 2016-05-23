
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Linked is                                              -- Top module de la solution
    Port ( clock : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           RX : in STD_LOGIC;
           TX : out  STD_LOGIC;
			  LED : out  STD_LOGIC_VECTOR (2 downto 0);
			  Sortie : out STD_LOGIC;
			  ampSD : out STD_LOGIC;
			  mck : out  STD_LOGIC;
			  switch : in STD_LOGIC_VECTOR(1 downto 0);
			  data : out  STD_LOGIC;
           lrck : out  STD_LOGIC;
			  B_up : in std_logic;
			  B_down : in std_logic;
			  B_left : in std_logic;
			  B_right : in std_logic;
			  B_center : in std_logic;
           sck : out  STD_LOGIC;
			  VGA_hs       : out std_logic;   
           VGA_vs       : out std_logic;   
           VGA_red      : out std_logic_vector(3 downto 0);   -- red output
           VGA_green    : out std_logic_vector(3 downto 0);   -- green output
			  VGA_blue     : out std_logic_vector(3 downto 0));   -- blue output
			
end Linked;



architecture Behavioral of Linked is




-- Module de conversion des données en coordonnées
component Screen_buffer is
    Port ( clock : in  STD_LOGIC;
			  clock_sample : in STD_LOGIC;
           reset : in  STD_LOGIC;
           Enable : in  STD_LOGIC;
           data : in  STD_LOGIC_VECTOR (15 downto 0);
           X_data : out  STD_LOGIC_VECTOR(7 downto 0);
           Y_data : out  STD_LOGIC_VECTOR(6 downto 0));
end component;


-- Bloc de réassemblage des données reçues de l'UART
component Assembling is
    Port ( clock : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           data_en : in  STD_LOGIC;
           data_ok : out  STD_LOGIC;
           data : in  STD_LOGIC_VECTOR (7 downto 0);
           data_out : out  STD_LOGIC_VECTOR (15 downto 0));
end component;

-- Module de connexion avec l'UART
component UARTReceiver is
    Generic ( baud : integer := 460800);
    Port ( UART_TXD_IN : in STD_LOGIC;
           CLK100MHZ : in STD_LOGIC;
           data_out : out STD_LOGIC_VECTOR (7 downto 0);
           data_ready : out STD_LOGIC);
end component;


-- Module de gestion du PMOD stéréo I²S
component I2S_pmod is
    Port ( clock : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           data_r : in  STD_LOGIC_VECTOR (15 downto 0);
           data_l : in  STD_LOGIC_VECTOR (15 downto 0);
           data_out : out  STD_LOGIC;
           MCK : out  STD_LOGIC;
           LRCK : out  STD_LOGIC;
           CLK_100M : out  STD_LOGIC;
           SCK : out  STD_LOGIC);
end component;

-- RAM de stockage des données
component Temporisation is
    Port ( data_ok : in  STD_LOGIC;
			  clock : in  STD_LOGIC;
			  clock_sample : in  STD_LOGIC;
			  play_pause : in std_logic;
			  foward : in std_logic;
			  restart : in std_logic;
           reset : in  STD_LOGIC;
           data : in  STD_LOGIC_VECTOR (15 downto 0);
           data_out : out  STD_LOGIC_VECTOR (15 downto 0));
end component;

-- Filtre booster de basses
component BassBoost
	port (
	clk: in std_logic;
	rfd: out std_logic;
	rdy: out std_logic;
	din: in std_logic_vector(15 downto 0);
	dout: out std_logic_vector(15 downto 0));
end component;

-- Filtre booster d'aigues 
component TrebleBoost
	port (
	clk: in std_logic;
	rfd: out std_logic;
	rdy: out std_logic;
	din: in std_logic_vector(15 downto 0);
	dout: out std_logic_vector(15 downto 0));
end component;

--COMPONENT delay                Essai d'ajout d'un effet de délai
--	PORT(
--		clk : IN std_logic;
--		datain : IN std_logic_vector(15 downto 0);          
--		data_out : OUT std_logic_vector(15 downto 0)
--		);
--	END COMPONENT;
	
---- Bloc de traitement des données pour le module VGA - Ancienne solution
--component Top_module_VGA is
--    port(clock        : in  std_logic;
--         reset        : in  std_logic;
--         X_data       : in  STD_LOGIC_VECTOR(7 downto 0);
--         Y_data       : in  STD_LOGIC_VECTOR (6 downto 0);
--         Enable       : out std_logic;   
--         VGA_hs       : out std_logic;   
--         VGA_vs       : out std_logic;   
--         VGA_red      : out std_logic_vector(3 downto 0);   -- red output
--         VGA_green    : out std_logic_vector(3 downto 0);   -- green output
--         VGA_blue     : out std_logic_vector(3 downto 0));   -- blue output
--end component;

-- Module de controle du volume
COMPONENT vol_control
	PORT(
		volume : IN std_logic_vector(2 downto 0);
		data_in : IN std_logic_vector(15 downto 0);
		
		data_out : OUT std_logic_vector(15 downto 0)
		);
	END COMPONENT;

-- Module de la sortie mono PWM de la carte
component PWM_mod is
    Port ( idata : in  STD_LOGIC_VECTOR(12 downto 0);
           clock : in  STD_LOGIC;
  --         data_ok : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           Sortie : out  STD_LOGIC;
           ampSD : out  STD_LOGIC
			  );
end component;

-- Generation du clock à 
component clkgen
port
 (-- Clock in ports
  CLK_IN1           : in     std_logic;  -- 100 MHz
  -- Clock out ports
      CLK_OUT300M      : out std_logic);   -- 200 MHz
end component;

-- Création de l'effet stéréo
component Haas_effect is
    Port ( clock : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           clock_sample : in  STD_LOGIC;
         --  data_in : in  STD_LOGIC;
           data_r_in : in  STD_LOGIC_VECTOR (15 downto 0);
           data_r_out : out  STD_LOGIC_VECTOR (15 downto 0));
end component;


-- Bloc de traitement des données pour le module VGA
component TestVGA is
    Port ( clock : in  STD_LOGIC;
	 		  clock_sample : in STD_LOGIC;
           reset : in  STD_LOGIC;
           data : in  STD_LOGIC_VECTOR (15 downto 0) ;
           data2 : in  STD_LOGIC_VECTOR (15 downto 0) ;
			  VGA_hs       : out std_logic;   
           VGA_vs       : out std_logic;   
           VGA_red      : out std_logic_vector(3 downto 0);   -- red output
           VGA_green    : out std_logic_vector(3 downto 0);   -- green output
           VGA_blue     : out std_logic_vector(3 downto 0));   -- blue output
end component;

-- Machine d'états
component fsm_v2 IS
PORT (
      RESET      : IN  STD_LOGIC;
      CLOCK      : IN  STD_LOGIC;
      
      B_UP       : IN  STD_LOGIC;
      B_DOWN     : IN  STD_LOGIC;
      B_CENTER   : IN  STD_LOGIC;
      B_LEFT     : IN  STD_LOGIC;
      B_RIGHT    : IN  STD_LOGIC;
		volume : out std_logic_vector(2 downto 0);
      PLAY_PAUSE : OUT STD_LOGIC;
	   RESTART    : OUT STD_LOGIC;
      FORWARD    : OUT STD_LOGIC		
      --VOLUME_UP  : OUT STD_LOGIC;
      --VOLUME_DW  : OUT STD_LOGIC
      );
END Component;


--Filtres anti-rebonds
component pulse_filter is
  Generic ( DEBNC_CLOCKS : INTEGER range 2 to (INTEGER'high) := 2**16);
  Port (
    SIGNAL_I : in  STD_LOGIC;
    CLK_I    : in  STD_LOGIC;
    SIGNAL_O : out STD_LOGIC
  );
end component;

COMPONENT Impulsion IS
PORT (
      CLOCK   : IN  STD_LOGIC;
      INPUT   : IN  STD_LOGIC;
      OUTPUT  : OUT STD_LOGIC
      );
END COMPONENT;

signal data_ready1 ,clock200M , ok, mok, data_sent, mlrck, msck, en, clock100: STD_LOGIC;
signal dataUART : STD_LOGIC_VECTOR(7 downto 0);
signal X_data_temp : STD_LOGIC_VECTOR(7 downto 0);
signal Y_data_temp : STD_LOGIC_VECTOR(6 downto 0);
signal m100,m101,m100_bass,m100_treble,out_valid,out_vol : STD_LOGIC_VECTOR(15 downto 0);
signal m1000 : STD_LOGIC_VECTOR(15 downto 0);
signal buf_vol : std_logic_vector(2 downto 0);
signal rescaled : STD_LOGIC_VECTOR(12 downto 0);
signal ul,ul2 : STD_LOGIC;
signal bup1, bup2, bdown1, bdown2, bleft1, bleft2, bright1,bright2, bcenter1,bcenter2 : std_logic;
signal pp, restart, fow : std_logic;


begin

Recep : UARTReceiver port map ( UART_TXD_IN => RX, CLK100MHZ => clock100, data_out => dataUART, data_ready => data_ready1);

Gene : clkgen
  port map
   (-- Clock in ports
      CLK_IN1 => clock,
    -- Clock out ports
      CLK_OUT300M => clock200M); -- 200 MHz
 --   CLK_OUT300M => clock200M);
 --   CLK_OUT3 => CLK_OUT3);

rescaled <= std_logic_vector(RESIZE(signed(out_valid),13));


 
Assembled : Assembling Port map ( clock => clock100, reset => reset, data_en => data_ready1, data => dataUART,  data_ok => ok, data_out => m1000);

Temp : Temporisation Port Map ( 
		clock => clock100, 
		clock_sample => mlrck,
		reset => reset,
		restart => restart,
		data_ok => ok, 
		data_out => out_vol,
		data => m1000,
		foward => fow,
		play_pause => pp);--,data_send => data_sent) ;


PWMM : PWM_mod Port Map ( clock => clock200M, reset => reset, idata => rescaled, Sortie => Sortie, ampSD => ampSD);

Bass : BassBoost
		port map (
			clk => clock100,
			rfd => ul,
			rdy => ul2,
			din => m100,
			dout => m100_bass);

Treble : TrebleBoost
		port map (
			clk => clock100,
			rfd => ul,
			rdy => ul2,
			din => m100,
			dout => m100_treble);

--Inst_delay: delay PORT MAP(
--		clk => clock100,
--		data_out => m100_del,
--		datain => m100
--	);
	
Stereo : I2S_pmod 
    Port map( 
	 
			  clock => clock,
           reset => reset,
           data_r => m101,
           data_l =>out_valid,
           data_out => data,
           MCK => mck,
           CLK_100M => clock100,
           LRCK => mlrck,
           SCK => msck);

lrck <= mlrck ;
sck <= msck;
Stereodarzing : Haas_effect 
    Port map( clock => msck,
           reset => reset,
           clock_sample => mlrck,
        --   data_in => data_sent,
           data_r_in => out_valid,
           data_r_out => m101 );



VGAzing : TestVGA 
    Port map( clock        =>clock100,
			  clock_sample => mlrck,
           reset        => reset,
           data         => m100 ,
			  data2         => out_valid,
			  VGA_hs       => VGA_hs,   
           VGA_vs       => VGA_vs,   
           VGA_red      => VGA_red,   -- red output
           VGA_green    => VGA_green,   -- green output
           VGA_blue     => VGA_blue);   -- blue output





UP_SYNC1 : pulse_filter port map (SIGNAL_I => B_up, CLK_I => clock, SIGNAL_O => bup1);
DOWN_SYNC1 : pulse_filter port map (SIGNAL_I => B_down, CLK_I => clock, SIGNAL_O => bdown1);
LEFT_SYNC1 : pulse_filter port map (SIGNAL_I => B_left, CLK_I => clock, SIGNAL_O => bleft1);
RIGHT_SYNC1 : pulse_filter port map (SIGNAL_I => B_right, CLK_I => clock, SIGNAL_O => bright1);
CENTER_SYNC1 : pulse_filter port map (SIGNAL_I => B_center, CLK_I => clock, SIGNAL_O => bcenter1);

UP_SYNC_IMPULSION : Impulsion port map (INPUT => bup1, CLOCK => clock, OUTPUT => bup2);
DOWN_SYNC_IMPULSION : Impulsion port map (INPUT => bdown1, CLOCK => clock, OUTPUT => bdown2);
LEFT_SYNC_IMPULSION : Impulsion port map (INPUT => bleft1, CLOCK => clock, OUTPUT => bleft2);
RIGHT_SYNC_IMPULSION : Impulsion port map (INPUT => bright1, CLOCK => clock, OUTPUT => bright2);
CENTER_SYNC_IMPULSION : Impulsion port map (INPUT => bcenter1, CLOCK => clock, OUTPUT => bcenter2);

MachineD : fsm_v2 
PORT MAP(
      RESET      => reset,
      CLOCK      => clock100,
      
      B_UP       => bup2,
      B_DOWN     => bdown2,
      B_CENTER   => bcenter2,
      B_LEFT     => bleft2,
      B_RIGHT    => bright2,
		
		volume => buf_vol,

      PLAY_PAUSE => pp,
	   RESTART    => restart,
      FORWARD    => fow		
      );


Inst_vol_control: vol_control PORT MAP(
		volume => buf_vol,
		data_in => out_vol,
		data_out => m100
		
	
	);


LED <= buf_vol;

process(switch,m100,m100_bass,m100_treble)
begin

if(switch(0) = '1') then 
	out_valid(15 downto 2) <= m100_bass(13 downto 0);
	out_valid(1 downto 0) <= "00";
elsif(switch(1) = '1') then
	out_valid(15 downto 2) <= m100_treble(13 downto 0);
	out_valid(1 downto 0) <= "00";
else
	out_valid <= m100;
end if;
end process;

end Behavioral;

