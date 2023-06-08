--------------------------------------------------------------------------------
--
-- LAB #3
--
--------------------------------------------------------------------------------

Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_unsigned.all;

entity bitstorage is
	port(bitin: in std_logic;
		 enout: in std_logic;
		 writein: in std_logic;
		 bitout: out std_logic);
end entity bitstorage;

architecture memlike of bitstorage is
	signal q: std_logic := '0';
begin
	process(writein) is
	begin
		if (rising_edge(writein)) then
			q <= bitin;
		end if;
	end process;
	
	-- Note that data is output only when enout = 0	
	bitout <= q when enout = '0' else 'Z';
end architecture memlike;

--------------------------------------------------------------------------------
Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_unsigned.all;

entity fulladder is
    port (a : in std_logic;
          b : in std_logic;
          cin : in std_logic;
          sum : out std_logic;
          carry : out std_logic
         );
end fulladder;

architecture addlike of fulladder is
begin
  sum   <= a xor b xor cin; 
  carry <= (a and b) or (a and cin) or (b and cin); 
end architecture addlike;


--------------------------------------------------------------------------------
Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_unsigned.all;

entity register8 is
	port(datain: in std_logic_vector(7 downto 0);
	     enout:  in std_logic;
	     writein: in std_logic;
	     dataout: out std_logic_vector(7 downto 0));
end entity register8;

architecture memmy of register8 is
	component bitstorage
		port(bitin: in std_logic;
		 	 enout: in std_logic;
		 	 writein: in std_logic;
		 	 bitout: out std_logic);
	end component;
begin
	bits: for i in 0 to 7 generate
		bitx: bitstorage port map (bitin => datain(i), enout => enout, writein => writein, bitout => dataout(i));
	end generate;
end architecture memmy;


--------------------------------------------------------------------------------
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

--------------------------------------------------------------------------------
Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_unsigned.all;

entity adder_subtracter is
	port(	datain_a: in std_logic_vector(31 downto 0);
		datain_b: in std_logic_vector(31 downto 0);
		add_sub: in std_logic;
		dataout: out std_logic_vector(31 downto 0);
		co: out std_logic);
end entity adder_subtracter;

architecture calc of adder_subtracter is
	component fulladder
	port (a : in std_logic;
          b : in std_logic;
          cin : in std_logic;
          sum : out std_logic;
          carry : out std_logic);
	end component;
	signal btemp, bi, carry: std_logic_vector(31 downto 0);
begin
	bi <= not(datain_b)+'1';
	btemp <= bi when add_sub='1' else
		datain_b;
	
	fulladd0: fulladder port map (a => datain_a(0), b => btemp(0), cin => '0', sum => dataout(0), carry => carry(0));
	adder: for i in 1 to 31 generate
		fulladd: fulladder port map (a => datain_a(i), b => btemp(i), cin => carry(i-1), sum => dataout(i), carry => carry(i));
	end generate;
	co <= carry(31);
end architecture calc;


--------------------------------------------------------------------------------
Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_unsigned.all;

entity shift_register is
	port(	datain: in std_logic_vector(31 downto 0);
	   	dir: in std_logic;
		shamt:	in std_logic_vector(4 downto 0);
		dataout: out std_logic_vector(31 downto 0));
end entity shift_register;

architecture shifter of shift_register is
	signal shift: std_logic_vector(1 downto 0);
	signal l1,r1: std_logic_vector(32 downto 0);
	signal l2,r2: std_logic_vector(33 downto 0);
	signal l3,r3: std_logic_vector(34 downto 0);
begin
	shift <= "01" when shamt="00001" else
	"10" when shamt="00010" else
	"11" when shamt="00011" else
	"00";
	l1 <= datain & "0";
	l2 <= datain & "00";
	l3 <= datain & "000";
	r1 <= "0" & datain;
	r2 <= "00" & datain;
	r3 <= "000" & datain;
	with (dir & shift) select
	dataout <= l1(31 downto 0) when "001",
		l2(31 downto 0) when "010",
		l3(31 downto 0) when "011",
		r1(32 downto 1) when "101",
		r2(33 downto 2) when "110",
		r3(34 downto 3) when "111",
		datain when others;

end architecture shifter;
