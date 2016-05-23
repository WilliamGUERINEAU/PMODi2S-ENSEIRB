
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY TestPmod1 IS
END TestPmod1;
 
ARCHITECTURE behavior OF TestPmod1 IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT I2Spmod
    PORT(
         clock : IN  std_logic;
         reset : IN  std_logic;
         data_in_l : IN  std_logic_vector(15 downto 0);
         data_in_r : IN  std_logic_vector(15 downto 0);
         data_out : OUT  std_logic;
         mck : OUT  std_logic;
         lrck : OUT  std_logic;
         sck : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clock : std_logic := '0';
   signal reset : std_logic := '0';
   signal data_in_l : std_logic_vector(15 downto 0) := (others => '0');
   signal data_in_r : std_logic_vector(15 downto 0) := (others => '0');

 	--Outputs
   signal data_out : std_logic;
   signal mck : std_logic;
   signal lrck : std_logic;
   signal sck : std_logic;

   -- Clock period definitions
   constant clock_period : time := 10 ns;
   
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: I2Spmod PORT MAP (
          clock => clock,
          reset => reset,
          data_in_l => data_in_l,
          data_in_r => data_in_r,
          data_out => data_out,
          mck => mck,
          lrck => lrck,
          sck => sck
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
		data_in_r <= "0000000000000000";
		data_in_r <= "1111111111111111";
      wait for clock_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
