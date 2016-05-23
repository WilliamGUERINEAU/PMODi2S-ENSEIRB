
-- VHDL Instantiation Created from source file select_input.vhd -- 22:50:51 05/21/2016
--
-- Notes: 
-- 1) This instantiation template has been automatically generated using types
-- std_logic and std_logic_vector for the ports of the instantiated module
-- 2) To use this template to instantiate this entity, cut-and-paste and then edit

	COMPONENT select_input
	PORT(
		Clock : IN std_logic;
		switch : IN std_logic;
		data_uart : IN std_logic_vector(7 downto 0);
		data_sd : IN std_logic_vector(7 downto 0);          
		uart_on : OUT std_logic;
		data_out : OUT std_logic_vector(7 downto 0);
		edge_detect : OUT std_logic
		);
	END COMPONENT;

	Inst_select_input: select_input PORT MAP(
		Clock => ,
		switch => ,
		data_uart => ,
		data_sd => ,
		uart_on => ,
		data_out => ,
		edge_detect => 
	);


