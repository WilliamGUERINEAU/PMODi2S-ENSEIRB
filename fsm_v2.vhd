LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY fsm_v2 IS
PORT (
      RESET      : IN  STD_LOGIC;
      CLOCK      : IN  STD_LOGIC;
      
      B_UP       : IN  STD_LOGIC;
      B_DOWN     : IN  STD_LOGIC;
      B_CENTER   : IN  STD_LOGIC;
      B_LEFT     : IN  STD_LOGIC;
      B_RIGHT    : IN  STD_LOGIC;

      PLAY_PAUSE : OUT STD_LOGIC;
	   RESTART    : OUT STD_LOGIC;
      FORWARD    : OUT STD_LOGIC;		
      --VOLUME_UP  : OUT STD_LOGIC;
		volume : out std_logic_vector(2 downto 0)
      --VOLUME_DW  : OUT STD_LOGIC
      );
END fsm_v2;

ARCHITECTURE Behavioral OF fsm_v2 IS
	TYPE STATE_TYPE IS (init, play_fwd, play_bwd, pause, stop);
	signal vol: integer range 0 to 7;
	SIGNAL state : STATE_TYPE;
BEGIN

  PROCESS (CLOCK)
  BEGIN       
    IF (CLOCK'EVENT AND CLOCK = '1') THEN
      IF RESET = '0' THEN
        state  <= INIT;
      ELSE
		  CASE state IS
          WHEN INIT =>
				vol <= 5;
            IF B_CENTER = '1' THEN
				  state <= PLAY_FWD;
            ELSE
				  state <= INIT;
            END IF;
          WHEN PLAY_FWD =>
            IF B_CENTER = '1' THEN
				  state <= PAUSE;
				elsif B_UP = '1' then
				  vol <= vol + 1;
				  if( vol > 7) then
					vol <= 7;
				end if;
				elsif B_DOWN = '1' then
				  vol <= vol - 1;
				  if( vol < 0) then
					vol <= 0;
				  end if;
            ELSE
				  state <= PLAY_FWD;
            END IF;
          WHEN PLAY_BWD =>		 				 
            IF B_CENTER = '1' THEN
			     state <= PAUSE;
				elsif B_UP = '1' then
				  vol <= vol + 1;
				  if( vol > 7) then
					vol <= 7;
				end if;
				elsif B_DOWN = '1' then
				  vol <= vol - 1;
				  if( vol < 0) then
					vol <= 0;
				  end if;
            ELSE
				  state <= PLAY_BWD;
            END IF;
          WHEN PAUSE =>
            IF B_LEFT = '1' THEN
				  state <= PLAY_BWD;
            ELSIF B_RIGHT = '1' THEN
				  state <= PLAY_FWD;
            ELSIF B_CENTER = '1' THEN
				  state  <= STOP;
            ELSE
				  state <= PAUSE;
            END IF;
          WHEN STOP =>
               IF B_CENTER = '1' THEN
						state <= PLAY_FWD;
               ELSE
						state <= STOP;
               END IF;
          WHEN OTHERS=>
					   state <= INIT;
         END CASE;
	    END IF;
	  END IF;
	END PROCESS;

   --Output signal computation
	
	RESTART    <= '1' WHEN (state = INIT) OR (state = STOP) ELSE
	              '0';

	PLAY_PAUSE <= '1' WHEN (state = PLAY_BWD) OR (state = PLAY_FWD) ELSE
	              '0';


	FORWARD    <= '1' WHEN (state = PLAY_FWD) ELSE
	              '0';

	
	VOLUME <= std_logic_vector(to_unsigned(vol,3));
	
END Behavioral;
