library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity delay is
generic (
    size: integer := 256
);
port (
    clk : in std_logic;
    data_out : out std_logic_vector(15 downto 0);
    datain : in std_logic_vector(15 downto 0)
         );
end delay;

architecture arch_delay of delay is
type memory_type is array (0 to size) of integer;
signal memory : memory_type;   
signal pointer: integer := 0; 
signal dataout: integer; 

begin
    process(clk)
    begin
    if(clk'event and clk='1') then
        dataout <= memory(pointer);
        memory(pointer) <= to_integer(signed(datain)); 
        pointer <= pointer + 1;
    end if;
    if(pointer = size) then
        pointer <= 0;
    end if;
    end process;
data_out <= std_logic_vector(to_signed(dataout,16));

end arch_delay;