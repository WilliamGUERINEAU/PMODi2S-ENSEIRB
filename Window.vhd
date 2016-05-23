
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity window is                                                        -- Comparaison avec le curseur
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
          -- Valid : out  STD_LOGIC;        Signal de test
           data_in : out  STD_LOGIC_VECTOR (1 downto 0));
end window;

architecture Behavioral of window is

-- Création de signaux entiers pour faciliter le traitement avec valeurs extrêmes au cas où, à optimiser

-- Signaux de données entrantes

signal X_data_int : integer range 0 to 320;              
signal Y_data_int : integer range 0 to 240;
signal X_data_int2 : integer range 0 to 320;          
signal Y_data_int2 : integer range 0 to 240;

-- Signaux de positions du curseur
 
signal X_pos_int : integer range 0 to 320;
signal Y_pos_int : integer range 0 to 240;

--Signaux de paramètrages des fenêtres

signal X_start : integer range 0 to 320;
signal Y_start : integer range 0 to 240;
signal X_start2 : integer range 0 to 320;               -- Pas besoin de 4 bits ici par exemple (optmisation)
signal Y_start2 : integer range 0 to 240;

signal X_width : integer range 0 to 320;
signal Y_height : integer range 0 to 240;


begin


X_data_int <= to_integer(unsigned(X_data));
Y_data_int <= to_integer(unsigned(Y_data));

X_data_int2 <= to_integer(unsigned(X_data2));
Y_data_int2 <= to_integer(unsigned(Y_data2));

Y_pos_int <= to_integer(unsigned(Y_pos));
X_pos_int <= to_integer(unsigned(X_pos));



process(clock, reset)
begin

if reset = '0' then
	data_in <= "00";
--	Valid <= '0';
	data_write <= '0';
	X_start <= 60; -- Premier cadre
	Y_start <= 10;
	X_start2 <= 60; -- Deuxième cadre
	Y_start2 <= 130;
	X_width <= 200; -- Largeur des fenêtres
	Y_height <= 100; -- Hauteur des fenêtres
elsif rising_edge(clock) then
	if ( (((( X_pos_int = X_start) or ( X_pos_int = X_start + 1)) or (( X_pos_int = X_start+ X_width) or ( X_pos_int =X_width + X_start - 1))) and	(Y_pos_int = 74 )) or  (((( X_pos_int = X_start2) or ( X_pos_int = X_start2 + 1)) or (( X_pos_int = X_start2+ X_width) or ( X_pos_int =X_width + X_start2 - 1))) and	(Y_pos_int = 194 ))) then
		data_write <= '1';
		data_in <= "01"; -- Position des zéros
	--	Valid <= '0';
	elsif ( (((Y_pos_int = Y_start) or (Y_pos_int = (Y_start + Y_height))) and ( X_pos_int >( X_start -1)) and ( X_pos_int < (X_start + X_width + 1))) or (((X_pos_int = X_start) or (X_pos_int = (X_start + X_width))) and ( Y_pos_int >( Y_start -1)) and ( Y_pos_int < (Y_start + Y_height + 1)))or (((Y_pos_int = Y_start2) or (Y_pos_int = (Y_start2 + Y_height))) and ( X_pos_int >( X_start2 -1)) and ( X_pos_int < (X_start2 + X_width + 1))) or (((X_pos_int = X_start2) or (X_pos_int = (X_start2 + X_width))) and ( Y_pos_int >( Y_start2 -1)) and ( Y_pos_int < (Y_start2 + Y_height + 1)))) then  
		data_in <= "11";    -- Bordures 
	--	Valid <= '0';
		data_write <= '1';
		
	elsif ( (X_pos_int  = (X_data_int + X_start )) and ( Y_pos_int = ( Y_start  + Y_data_int ))) then -- Fenêtre haut
		data_write <= '1';
		data_in <= "10";
	--	Valid <= '1';
	elsif ( (X_pos_int  = (X_data_int2 + X_start2 )) and ( Y_pos_int = ( Y_start2  + Y_data_int2 ))) then -- Fenêtre basse
		data_write <= '1';
		data_in <= "10";
	--	Valid <= '1';	
	else 
	--	Valid <= '0';                                  -- Vide
		data_in <= "00";
		data_write <= '1';
	end if;
end if;

		

end process;

-- Signal de vérification de présence du curseur dans une des fenêtres

Enable <= '1' when  ((( X_pos_int >( X_start - 2 )) and ( X_pos_int < (X_start + X_width )) and ( Y_pos_int >( Y_start  )) and ( Y_pos_int < (Y_start + Y_height ))) or (( X_pos_int >( X_start - 2 )) and ( X_pos_int < (X_start + X_width )) and ( Y_pos_int >( Y_start  )) and ( Y_pos_int < (Y_start + Y_height )))) or ((( X_pos_int >( X_start2 - 2 )) and ( X_pos_int < (X_start2 + X_width )) and ( Y_pos_int >( Y_start2  )) and ( Y_pos_int < (Y_start2 + Y_height ))) or (( X_pos_int >( X_start2 - 2 )) and ( X_pos_int < (X_start2 + X_width )) and ( Y_pos_int >( Y_start2  )) and ( Y_pos_int < (Y_start2 + Y_height )))) else '0';




end Behavioral;

