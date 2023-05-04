Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_unsigned.all;

entity register32 is
	port(datain: in std_logic_vector(31 downto 0);
		 enout32,enout16,enout8: in std_logic;
		 writein32, writein16, writein8: in std_logic;
		 dataout: out std_logic_vector(31 downto 0));
end entity register32;

architecture biggermem of register32 is
	component register8
	port(datain: in std_logic_vector(7 downto 0);
	     enout:  in std_logic;
	     writein: in std_logic;
	     dataout: out std_logic_vector(7 downto 0));
	end component;
	signal en16, en8, wr16, wr8: STD_LOGIC;
begin
	
	en16 <= enout32 and enout16;
	en8 <= enout32 and enout16 and enout8;
	wr16 <= writein32 or writein16;
	wr8 <= writein32 or writein16 or writein8;

	byte0: register8 port map (datain => datain(7 downto 0), enout => en8, writein => wr8, dataout => dataout(7 downto 0));
	byte1: register8 port map (datain => datain(15 downto 8), enout => en16, writein => wr16, dataout => dataout(15 downto 8));
	byte2: register8 port map (datain => datain(23 downto 16), enout => enout32, writein => writein32, dataout => dataout(23 downto 16));
	byte3: register8 port map (datain => datain(31 downto 24), enout => enout32, writein => writein32, dataout => dataout(31 downto 24));
end architecture biggermem;
