
-- VHDL Instantiation Created from source file delay.vhd -- 01:56:21 05/22/2016
--
-- Notes: 
-- 1) This instantiation template has been automatically generated using types
-- std_logic and std_logic_vector for the ports of the instantiated module
-- 2) To use this template to instantiate this entity, cut-and-paste and then edit

	COMPONENT delay
	PORT(
		clk : IN std_logic;
		datain : IN std_logic_vector(15 downto 0);          
		data_out : OUT std_logic_vector(15 downto 0)
		);
	END COMPONENT;

	Inst_delay: delay PORT MAP(
		clk => ,
		data_out => ,
		datain => 
	);


