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
	shift <= "01" when shamt(1 downto 0)="01" else
	"10" when shamt(1 downto 0)="10" else
	"11" when shamt(1 downto 0)="11" else
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
