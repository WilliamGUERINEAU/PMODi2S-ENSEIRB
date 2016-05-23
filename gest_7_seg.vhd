----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:06:50 12/07/2015 
-- Design Name: 
-- Module Name:    gest_7_seg - Behavioral 
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

entity gest_7_seg is
    Port ( msg : in  STD_LOGIC_vector ( 2 downto 0);
			  disp3 : in std_logic_vector (3 downto 0);
           disp2 : in std_logic_vector (3 downto 0);
			  disp1 : in std_logic_vector (3 downto 0);
			  disp0 : in std_logic_vector (3 downto 0);
			  aff5 : out  STD_LOGIC_VECTOR (4 downto 0);
           aff6 : out  STD_LOGIC_VECTOR (4 downto 0);
           aff7 : out  STD_LOGIC_VECTOR (4 downto 0);
           aff8 : out  STD_LOGIC_VECTOR (4 downto 0);
			  aff1 : out  STD_LOGIC_VECTOR (4 downto 0);
           aff2 : out  STD_LOGIC_VECTOR (4 downto 0);
           aff3 : out  STD_LOGIC_VECTOR (4 downto 0);
           aff4 : out  STD_LOGIC_VECTOR (4 downto 0));
end gest_7_seg;

architecture Behavioral of gest_7_seg is

begin
process(msg)
begin
case msg is 
	when "000" => aff1<="10010";--HI
					  aff2<="10010";
					  aff3<="01100";
					  aff4<="00001";
					  aff5(3 downto 0) <=disp3;--afficher score
					  aff6(3 downto 0) <=disp2;
					  aff7(3 downto 0) <=disp1;
					  aff8(3 downto 0) <=disp0;
					  aff5(4)<='0';
					  aff6(4)<='0';
					  aff7(4)<='0';
					  aff8(4)<='0';
   when "001" => aff1<="10000";--PLAY
					  aff2<="10001";
					  aff3<="01010";
					  aff4<="00100";
					  aff5(3 downto 0) <=disp3;--afficher score
					  aff6(3 downto 0) <=disp2;
					  aff7(3 downto 0) <=disp1;
					  aff8(3 downto 0) <=disp0;
					  aff5(4)<='0';
					  aff6(4)<='0';
					  aff7(4)<='0';
					  aff8(4)<='0';
   when "010" => aff1<="10010";--End
					  aff2<="01110";
					  aff3<="01111";
					  aff4<="01101";
					  aff5(3 downto 0) <=disp3;--afficher score
					  aff6(3 downto 0) <=disp2;
					  aff7(3 downto 0) <=disp1;
					  aff8(3 downto 0) <=disp0;
					  aff5(4)<='0';
					  aff6(4)<='0';
					  aff7(4)<='0';
					  aff8(4)<='0';
   when "011" => aff1<="10010";--YES
					  aff2<="00100";
					  aff3<="01110";
					  aff4<="00101";
					  aff5(3 downto 0) <=disp3;--afficher score
					  aff6(3 downto 0) <=disp2;
					  aff7(3 downto 0) <=disp1;
					  aff8(3 downto 0) <=disp0;
					  aff5(4)<='0';
					  aff6(4)<='0';
					  aff7(4)<='0';
					  aff8(4)<='0';
	when "100" => aff1<="10010";--nO
					  aff2<="10010";
					  aff3<="01111";
					  aff4<="00000";
					  aff5(3 downto 0) <=disp3;--afficher score
					  aff6(3 downto 0) <=disp2;
					  aff7(3 downto 0) <=disp1;
					  aff8(3 downto 0) <=disp0;
					  aff5(4)<='0';
					  aff6(4)<='0';
					  aff7(4)<='0';
					  aff8(4)<='0';
	when others => aff1<= "10010";
						aff2<= "10010";
						aff3<= "10010";
						aff4<= "10010";

end case;
end process;
end Behavioral;

