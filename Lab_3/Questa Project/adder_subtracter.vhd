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
