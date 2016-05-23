
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY TEsttttt IS
END TEsttttt;
 
ARCHITECTURE behavior OF TEsttttt IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT TestLed
    PORT(
         clock : IN  std_logic;
         reset : IN  std_logic;
         data_en : IN  std_logic;
         data : IN  std_logic_vector(7 downto 0);
         led : OUT  std_logic_vector(15 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clock : std_logic := '0';
   signal reset : std_logic := '0';
   signal data_en : std_logic := '0';
   signal data : std_logic_vector(7 downto 0) := (others => '0');

 	--Outputs
   signal led : std_logic_vector(15 downto 0);

   -- Clock period definitions
   constant clock_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: TestLed PORT MAP (
          clock => clock,
          reset => reset,
          data_en => data_en,
          data => data,
          led => led
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
      reset <= '1';
      wait for 100 ns;	
		reset <= '0';
		data_en <= '1';
		data <= "10000000";
		
		
		

      wait for clock_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
