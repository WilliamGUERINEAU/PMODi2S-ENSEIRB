--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   14:57:40 04/28/2016
-- Design Name:   
-- Module Name:   C:/Users/William/Desktop/Projet VHDL/Test_Stereo/ClockstereoTEST.vhd
-- Project Name:  Test_Stereo
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: clock_stereo
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY ClockstereoTEST IS
END ClockstereoTEST;
 
ARCHITECTURE behavior OF ClockstereoTEST IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT clock_stereo
    PORT(
         clock : IN  std_logic;
         reset : IN  std_logic;
         MCK : OUT  std_logic;
         LRCK : OUT  std_logic;
         SCK : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clock : std_logic := '0';
   signal reset : std_logic := '0';

 	--Outputs
   signal MCK : std_logic;
   signal LRCK : std_logic;
   signal SCK : std_logic;

   -- Clock period definitions
   constant clock_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: clock_stereo PORT MAP (
          clock => clock,
          reset => reset,
          MCK => MCK,
          LRCK => LRCK,
          SCK => SCK
        );

   -- Clock process definitions
   clock_process :process
   begin
		clock <= '0';
		wait for clock_period/2;
		clock <= '1';
		wait for clock_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      reset <='1';
      wait for 100 ns;	
		reset <= '0';

      wait for clock_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
