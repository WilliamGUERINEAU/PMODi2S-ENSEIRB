
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
USE ieee.numeric_std.ALL;
 
ENTITY TestbenchVGA IS
END TestbenchVGA;
 
ARCHITECTURE behavior OF TestbenchVGA IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT TestVGA
    PORT(
         clock : IN  std_logic;
         reset : IN  std_logic;
         data : IN  std_logic_vector(15 downto 0);
         VGA_hs : OUT  std_logic;
         VGA_vs : OUT  std_logic;
         VGA_red : OUT  std_logic_vector(3 downto 0);
         VGA_green : OUT  std_logic_vector(3 downto 0);
         VGA_blue : OUT  std_logic_vector(3 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clock : std_logic := '0';
   signal reset : std_logic := '0';
   signal data : std_logic_vector(15 downto 0) := (others => '0');

 	--Outputs
   signal VGA_hs : std_logic;
   signal VGA_vs : std_logic;
   signal VGA_red : std_logic_vector(3 downto 0);
   signal VGA_green : std_logic_vector(3 downto 0);
   signal VGA_blue : std_logic_vector(3 downto 0);

   -- Clock period definitions
   constant clock_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: TestVGA PORT MAP (
          clock => clock,
          reset => reset,
          data => data,
          VGA_hs => VGA_hs,
          VGA_vs => VGA_vs,
          VGA_red => VGA_red,
          VGA_green => VGA_green,
          VGA_blue => VGA_blue
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
		data <= std_logic_vector(to_signed(32767,16));	
		reset <= '0';
      wait for clock_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
