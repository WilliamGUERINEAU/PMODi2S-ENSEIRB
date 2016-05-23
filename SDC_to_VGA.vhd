--------------------------------------------------------------------------------------------------
-- Maxime Gernet
-- Laren Bohbot
--
-- 7 janvier 2016
-- ENSEIRB-MATMECA
--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
-- Projet de deuxième année :
-- Affichage d'une image stockée sur carte SD
--------------------------------------------------------------------------------------------------

library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity SDC_to_PWM is
	port(
		clock, reset : in std_logic;
      SCLK : out std_logic;
      MOSI : out std_logic;
      MISO : in std_logic;
		CS : out std_logic;
		SD_reset : out std_logic;
		sortie : out std_logic_vector(12 downto 0);
		card_detect : in std_logic;
		led_detect : out std_logic;
		b_left, b_right, b_up, b_down, b_center : in std_logic);
end SDC_to_PWM;

architecture Behavioral of SDC_to_PWM is

signal SCLK_rise, SCLK_fall : std_logic;
signal high_speed_enable : std_logic;
signal send_cmd, data_r, data_w, transfer_complete, new_byte_w, new_byte_r, new_byte : std_logic;
signal byte_w, byte_r, data_out : std_logic_vector(7 downto 0);
signal size, byte_cnt : std_logic_vector(9 downto 0);
signal resp0, resp55, resp41, resp17 : std_logic_vector(7 downto 0);
signal resp8, resp58 : std_logic_vector(39 downto 0);
signal value_l, value_r : std_logic_vector(15 downto 0);
signal read_block, write_block, end_of_block : std_logic;
signal wea : std_logic_vector(0 downto 0);
signal data_value : std_logic_vector(12 downto 0);
signal enable_write : std_logic;
signal block_addr : std_logic_vector(10 downto 0);
signal offset : std_logic_vector(15 downto 0);
signal CCS : std_logic;

component SPI_driver
	port(
		clock, reset : in std_logic;
		SCLK_rise, SCLK_fall : in std_logic;
		send_cmd, write_data, read_data : in std_logic;
		transfer_complete : out std_logic;
		new_byte_w, new_byte_r : out std_logic;
		byte_w : in std_logic_vector(7 downto 0);
		byte_r : out std_logic_vector(7 downto 0);
		size : in std_logic_vector(9 downto 0);
		CS, MOSI, SCLK : out std_logic;
		MISO : in std_logic);
end component;

component SD_driver
	port(
		clock, reset : in std_logic;
		SCLK_rise, SCLK_fall : in std_logic;
		send_cmd, data_r, data_w : out std_logic;
		transfer_complete : in std_logic;
		new_byte_r, new_byte_w : in std_logic;
		byte_r : in std_logic_vector(7 downto 0);
		byte_w : out std_logic_vector(7 downto 0);
		size : out std_logic_vector(9 downto 0);
		resp0, resp55, resp41, resp17 : out std_logic_vector(7 downto 0);
		resp8, resp58 : out std_logic_vector(39 downto 0);
		read_block, write_block : in std_logic;
		end_of_block : out std_logic;
		data_out : out std_logic_vector(7 downto 0);
		byte_cnt : out std_logic_vector(9 downto 0);
		new_byte : out std_logic;
		block_addr : in std_logic_vector(10 downto 0);
		high_speed_enable : out std_logic;
		offset : in std_logic_vector(15 downto 0);
		CCS : in std_logic);
end component;

component SCLK_generator
	port(
		clock					: in std_logic;
		reset					: in std_logic;
		high_speed_enable : in std_logic;
		SCLK_rise 			: out std_logic;
		SCLK_fall 			: out std_logic);
end component;

component FSM
	port(
		clock, reset : in std_logic;
		data_value : out  std_logic_vector(12 downto 0);
		enable_write : out  std_logic;
		SCLK_rise, SCLK_fall : in std_logic;
		byte_cnt : in std_logic_vector(9 downto 0);
		end_of_block : in std_logic;
		data_in : in std_logic_vector(7 downto 0);
		read_block, write_block : out std_logic;
		new_byte : in std_logic;
		block_addr : out std_logic_vector(10 downto 0);
		offset : out std_logic_vector(15 downto 0);
		b_left, b_right, b_up, b_down, b_center : in std_logic);
end component;

begin
	inst1 : SPI_driver port map(clock, reset, SCLK_rise, SCLK_fall, send_cmd, data_w, data_r, transfer_complete, new_byte_w, new_byte_r, byte_w, byte_r, size, CS, MOSI, SCLK, MISO);
	inst2 : SD_driver port map(clock, reset, SCLK_rise, SCLK_fall, send_cmd, data_r, data_w, transfer_complete, new_byte_r, new_byte_w, byte_r, byte_w, size, resp0, resp55, resp41, resp17, resp8, resp58, read_block, write_block, end_of_block, data_out, byte_cnt, new_byte, block_addr, high_speed_enable, offset, CCS);
	inst3 : SCLK_generator port map(clock, reset, high_speed_enable, SCLK_rise, SCLK_fall);
	inst4 : FSM port map(clock, reset, sortie, enable_write, SCLK_rise, SCLK_fall, byte_cnt, end_of_block, data_out, read_block, write_block, new_byte, block_addr, offset, b_left, b_right, b_up, b_down, b_center);
	
	CCS <= resp58(30);
	SD_reset <= '0';
	led_detect <= card_detect;

end Behavioral;

