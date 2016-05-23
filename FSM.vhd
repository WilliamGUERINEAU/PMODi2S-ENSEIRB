-- Appui sur bouton droit ou gauche : changement d'image
-- Appui sur bouton haut ou bas : changement de la luminosit
library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity FSM is
	port(
		clock, reset : in std_logic;
		--ADDR         : out  std_logic_vector(18 downto 0); ид supprimer
		data_value  : out  std_logic_vector(15 downto 0); --valeur de sortie, ид modifier
		enable_write   : out  std_logic; --enable write
		SCLK_rise, SCLK_fall : in std_logic;
		byte_cnt : in std_logic_vector(9 downto 0);
		end_of_block : in std_logic;
		data_in : in std_logic_vector(7 downto 0);
		read_block, write_block : out std_logic;
		new_byte : in std_logic;
		enable_write_ram : out std_logic;
		block_addr : out std_logic_vector(10 downto 0);
		offset : out std_logic_vector(15 downto 0)
		--pixel_in : in std_logic_vector(11 downto 0)--ид supprimer
		);
end FSM;

architecture Behavioral of FSM is

type state is(read_SDC, idle);
--type ram_state is(read_ram, write_ram);
--signal lum_state : ram_state;
signal future_state, current_state : state;
signal data_cnt : natural range 0 to 262143;
--signal current_color : natural range 0 to 2; -- 0 -> R, 1 -> G, 2 -> B
signal block_cnt : natural range 0 to 1800;
--signal pixel_value_int : std_logic_vector(12 downto 0);
signal change_completed : std_logic;
signal data_read, data_write : natural range 0 to 262143;
--signal lum_pixel : std_logic_vector(11 downto 0);
--signal lum_cnt : std_logic_vector(2 downto 0);
--signal incr_lum : std_logic;
--signal data_temp : std_logic_vector(12 downto 0);

	-------------------------------------------------------------------------------------
-- choix du numero de morceau (modifier les offset)
begin

	
	block_addr <= std_logic_vector(to_unsigned(block_cnt, 11));
	
--	offset_pro : process(clock)
--	begin
--		if(clock'event and clock = '1') then
--			if(num_song = 0) then
--				offset <= x"0001";
--			elsif(num_song = 1) then
--				offset <= x"29D0";
--			else
--				offset <= x"31A0";
--			end if;
--		end if;
--	end process;

	-------------------------------------------------------------------------------------
	-- FSM
	
	FSM : process(current_state, block_cnt, b_left, b_right, b_up_filter, b_down_filter, b_center, change_completed)
	begin
		case current_state is
		when read_SDC =>	if(block_cnt = 1800)  then
									future_state <= idle;
								else
									future_state <= read_SDC;
								end if;
		when idle =>	if(b_left = '1' or b_right = '1' or b_center = '1') then
								future_state <= read_SDC;
							--elsif(b_up_filter = '1' or b_down_filter = '1') then
								--future_state <= change_lum;
							else
								future_state <= idle;
							end if;
		--when change_lum =>	if(change_completed = '1') then
										--future_state <= idle;
									--else
										--future_state <= change_lum;
									--end if;
		end case;
	end process;
	
	process(clock)
	begin
		if(clock'event and clock = '1') then
			if(reset = '0') then
				current_state <= read_SDC;
			--elsif(future_state = change_lum)
				--then current_state <= change_lum;
			elsif(SCLK_rise = '1') then
				current_state <= future_state;
			end if;
		end if;
	end process;
	
	output : process(current_state, data_cnt, data_read, data_write)
	begin
		case current_state is
		when read_SDC =>	enable_write <= '1';
								read_block <= '1';
								write_block <= '0';
		when idle =>	enable_write <= '0';
							read_block <= '0';
							write_block <= '0';
		--when change_lum =>	if(lum_state = read_ram) then
			--						data_write <= '1';
				--						ADDR <= std_logic_vector(to_unsigned(pixel_write, 19));
					--				else
						--				data_write <= '0';
							--			ADDR <= std_logic_vector(to_unsigned(pixel_read, 19));
								--	end if;
									--read_block <= '0';
									--write_block <= '0';
		end case;
	end process;
	
	-------------------------------------------------------------------------------------
	-- lum control
	
	--process(clock)
	--begin
		--if(clock'event and clock = '1') then
		--	if(reset = '0' or current_state = idle or current_state = read_SDC) then
				--lum_state <= read_ram;
			--else
				--if(lum_state = read_ram) then
					--lum_state <= write_ram;
				--else
				--	lum_state <= read_ram;
				--end if;
			--end if;
		--end if;
	--end process;
	
	process(clock)
	begin
		if(clock'event and clock = '1') then
			if(reset = '0' or current_state = idle or current_state = read_SDC) then
				data_read <= 0;
				data_write <= 0;
				change_completed <= '0';
			end if;
		end if;
	end process;
	
	
	data_cnt_pro : process(clock)
	begin
		if(clock'event and clock = '1') then
			if(reset = '0' or current_state = idle) then
				data_cnt <= 0;
			elsif(SCLK_rise = '1') then
				if(new_byte = '1' and byte_cnt < "1000000001") then
					if(data_cnt < 262143) then
						data_cnt <= data_cnt + 1;
					end if;
				end if;
			end if;
		end if;
	end process;
	
	block_cnt_pro : process(clock)
	begin
		if(clock'event and clock = '1') then
			if(reset = '0' or current_state = idle) then
				block_cnt <= 0;
			elsif(SCLK_rise = '1') then
				if(end_of_block = '1') then
					if(block_cnt < 1800) then
						block_cnt <= block_cnt + 1;
					end if;
				end if;
			end if;
		end if;
	end process;
	
	
--	process(clock)
--	begin
--		if(clock'event and clock = '1') then
--			if(reset = '0') then
--				num_song <= 0;
--			elsif(SCLK_rise = '1') then
--				if(current_state = idle) then
--					if(b_right = '1') then
--						if(num_song = 2) then
--							num_song <= 0;
--						else
--							num_song <= num_song + 1;
--						end if;
--					elsif(b_left = '1') then
--						if(num_song = 0) then
--							num_song <= 2;
--						else
--							num_song <= num_song - 1;
--						end if;
--					end if;
--				end if;
--			end if;
--		end if;
--	end process;

end Behavioral;

