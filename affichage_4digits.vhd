----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    09:56:54 03/27/2014 
-- Design Name: 
-- Module Name:    affichage_4digits - Behavioral 
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

entity affichage_4digits is
    Port ( RAZ : in  STD_LOGIC;
           enable : in  STD_LOGIC;
           H : in  STD_LOGIC;
           D7 : in  STD_LOGIC_VECTOR (4 downto 0);
           D6 : in  STD_LOGIC_VECTOR (4 downto 0);
           D5 : in  STD_LOGIC_VECTOR (4 downto 0);
           D4 : in  STD_LOGIC_VECTOR (4 downto 0);
			  D3 : in  STD_LOGIC_VECTOR (4 downto 0);
           D2 : in  STD_LOGIC_VECTOR (4 downto 0);
           D1 : in  STD_LOGIC_VECTOR (4 downto 0);
           D0 : in  STD_LOGIC_VECTOR (4 downto 0);
           ANODE : out  STD_LOGIC_VECTOR (7 downto 0);
           CATHODE : out  STD_LOGIC_VECTOR (6 downto 0)
           );
end affichage_4digits;

architecture Behavioral of affichage_4digits is

COMPONENT bcd2seg
	PORT(
		bcd : IN std_logic_vector(4 downto 0);    
		cathode : OUT std_logic_vector(6 downto 0);
		anode : OUT std_logic_vector(7 downto 0);
		aff : IN std_logic_vector (2 downto 0)
		);
	END COMPONENT;

COMPONENT MUX
	PORT(
		D7 : IN std_logic_vector(4 downto 0);
		D6 : IN std_logic_vector(4 downto 0);
		D5 : IN std_logic_vector(4 downto 0);
		D4 : IN std_logic_vector(4 downto 0);
		D3 : IN std_logic_vector(4 downto 0);
		D2 : IN std_logic_vector(4 downto 0);
		D1 : IN std_logic_vector(4 downto 0);
		D0 : IN std_logic_vector(4 downto 0);
		ADR : IN std_logic_vector(2 downto 0);          
		SORTIE : OUT std_logic_vector(4 downto 0)
		);
	END COMPONENT;
	
COMPONENT cpt_modulo8
	PORT(
		RAZ : IN std_logic;
		clockEnableDisplay : IN std_logic;
		H : IN std_logic;          
		SORTIE : OUT std_logic_vector(2 downto 0)
		);
	END COMPONENT;


signal selec_aff : std_logic_vector(2 downto 0);
signal selec_digit : std_logic_vector(4 downto 0);

begin

Inst_cpt_modulo8: cpt_modulo8 PORT MAP(
		RAZ => RAZ,
		clockEnableDisplay => enable,
		H => H,
		SORTIE => selec_aff 
	);
Inst_MUX: MUX PORT MAP(
		D7 => D7,
		D6 => D6,
		D5 => D5,
		D4 => D4,
		D3 => D3,
		D2 => D2,
		D1 => D1,
		D0 => D0,
		ADR => selec_aff,
		SORTIE => selec_digit
	);
Inst_bcd2seg: bcd2seg PORT MAP(
		bcd => selec_digit,
		aff => selec_aff,
		cathode => CATHODE,
		anode => ANODE
	);



end Behavioral;

