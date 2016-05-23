library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
--use IEEE.STD_LOGIC_ARITH.ALL;
--library UNISIM;
--use UNISIM.VComponents.all;

entity PWM_mod is
    Port ( idata : in  STD_LOGIC_VECTOR(12 downto 0);         -- Module de gestion de la sortie PWM
           clock : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           Sortie : out  STD_LOGIC;
           ampSD : out  STD_LOGIC
			  );
end PWM_mod;

architecture Behavioral of PWM_mod is

signal CMP : integer range 0 to 4536;
signal Id : unsigned(12 downto 0);


begin

Id <= resize(unsigned(resize(signed(idata),14)+to_signed(2048,14)),13);

process(clock,reset)

begin

if(reset = '0') then
	CMP <= 0;
elsif(rising_edge(clock)) then

		if(CMP < 4536) then
			CMP <= CMP + 1;
		else 
			CMP <= 0;
		end if;	
end if;
end process;

Sortie <= '1' when CMP < to_integer(Id) else '0';

ampSD <= '1';

end Behavioral;

