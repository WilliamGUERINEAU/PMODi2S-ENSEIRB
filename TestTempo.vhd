
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY TestTempo IS
END TestTempo;
 
ARCHITECTURE behavior OF TestTempo IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Temporisation
    PORT(
         data_ok : IN  std_logic;
         clock : IN  std_logic;
         reset : IN  std_logic;
         data : IN  std_logic_vector(15 downto 0);
         data_out : OUT  std_logic_vector(12 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal data_ok : std_logic := '0';
   signal clock : std_logic := '0';
   signal reset : std_logic := '0';
   signal data : std_logic_vector(15 downto 0) := (others => '0');

 	--Outputs
   signal data_out : std_logic_vector(12 downto 0);

   -- Clock period definitions
   constant clock_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Temporisation PORT MAP (
          data_ok => data_ok,
          clock => clock,
          reset => reset,
          data => data,
          data_out => data_out
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
		data <= "0000111100001111";
		wait for 1000 ns;
		data_ok <= '1';
      wait for clock_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
