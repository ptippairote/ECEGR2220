--------------------------------------------------------------------------------
--
-- LAB #5 - Memory and Register Bank
--
--------------------------------------------------------------------------------
LIBRARY ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_unsigned.all;

entity RAM is
    Port(Reset:	  in std_logic;
	 Clock:	  in std_logic;	 
	 OE:      in std_logic;
	 WE:      in std_logic;
	 Address: in std_logic_vector(29 downto 0);
	 DataIn:  in std_logic_vector(31 downto 0);
	 DataOut: out std_logic_vector(31 downto 0));
end entity RAM;

architecture staticRAM of RAM is

   type ram_type is array (0 to 127) of std_logic_vector(31 downto 0);
   signal i_ram : ram_type;
   signal tempAdr: std_logic_vector(31 downto 0);
begin

  RamProc: process(Clock, Reset, OE, WE, Address) is

  begin
    if Reset = '1' then
      for i in 0 to 127 loop   
          i_ram(i) <= X"00000000";
      end loop;
    end if;

    if falling_edge(Clock) then
	-- Add code to write data to RAM
	-- Use to_integer(unsigned(Address)) to index the i_ram array
		if not(to_integer(unsigned(Address))>127) and WE='1' then
			i_ram(to_integer(unsigned(Address))) <= DataIn;
    	end if;
	end if;

	-- Rest of the RAM implementation
	if (to_integer(unsigned(Address))>127 or OE='1') then
	DataOut <= (others=>'Z');
	else
	DataOut <= i_ram(to_integer(unsigned(Address)));
	end if;
  end process RamProc;

end staticRAM;	


--------------------------------------------------------------------------------
LIBRARY ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_unsigned.all;

entity Registers is
    Port(ReadReg1: in std_logic_vector(4 downto 0); 
         ReadReg2: in std_logic_vector(4 downto 0); 
         WriteReg: in std_logic_vector(4 downto 0);
	 WriteData: in std_logic_vector(31 downto 0);
	 WriteCmd: in std_logic;
	 ReadData1: out std_logic_vector(31 downto 0);
	 ReadData2: out std_logic_vector(31 downto 0));
end entity Registers;

architecture remember of Registers is
	component register32
  	    port(datain: in std_logic_vector(31 downto 0);
		 enout32,enout16,enout8: in std_logic;
		 writein32, writein16, writein8: in std_logic;
		 dataout: out std_logic_vector(31 downto 0));
	end component;
	type temparray is array (0 to 8) of std_logic_vector(31 downto 0);
	signal tempout: temparray;
	signal we: std_logic_vector(8 downto 0);
	signal regindex1, regindex2: integer range 0 to 8;
begin
    -- Add your code here for the Register Bank implementation
	Regs: for i in 1 to 8 generate
		Reg: register32 port map(dataIn=>WriteData, enout32=>'0', enout16=>'1', enout8=>'1', writein32=>we(i), writein16=>'0', writein8=>'0', dataout=>tempout(i));
	end generate;
	zero: register32 port map(dataIn=> X"00000000", enout32=>'0', enout16=>'1', enout8=>'1', writein32=>'0', writein16=>'0', writein8=>'0', dataout=>tempout(0));
	with readReg1 select regindex1 <=
	1 when "01010",
	2 when "01011",
	3 when "01100",
	4 when "01101",
	5 when "01110",
	6 when "01111",
	7 when "10000",
	8 when "10001",
	0 when others;
	with readReg2 select regindex2 <=
	1 when "01010",
	2 when "01011",
	3 when "01100",
	4 when "01101",
	5 when "01110",
	6 when "01111",
	7 when "10000",
	8 when "10001",
	0 when others;
	with regindex1 select ReadData1 <=
        tempout(1) when 1, 
        tempout(2) when 2, 
        tempout(3) when 3, 
        tempout(4) when 4, 
        tempout(5) when 5, 
        tempout(6) when 6, 
        tempout(7) when 7, 
        tempout(8) when 8, 
	tempout(0) when others;

with regindex2 select ReadData2 <=
        tempout(1) when 1, 
        tempout(2) when 2, 
        tempout(3) when 3, 
        tempout(4) when 4, 
        tempout(5) when 5, 
        tempout(6) when 6, 
        tempout(7) when 7, 
        tempout(8) when 8, 
	tempout(0) when others;

	we(1)<= (not writeReg(4)) and (writeReg(3)) and (not writeReg(2)) and (writeReg(1)) and (not writeReg(0)) and writeCmd;
	we(2)<= (not writeReg(4)) and (writeReg(3)) and (not writeReg(2)) and (writeReg(1)) and (writeReg(0)) and writeCmd;
	we(3)<= (not writeReg(4)) and (writeReg(3)) and (writeReg(2)) and (not writeReg(1)) and (not writeReg(0)) and writeCmd;
	we(4)<= (not writeReg(4)) and (writeReg(3)) and (writeReg(2)) and (not writeReg(1)) and (writeReg(0)) and writeCmd;
	we(5)<= (not writeReg(4)) and (writeReg(3)) and (writeReg(2)) and (writeReg(1)) and (not writeReg(0)) and writeCmd;
	we(6)<= (not writeReg(4)) and (writeReg(3)) and (writeReg(2)) and (writeReg(1)) and (writeReg(0)) and writeCmd;
	we(7)<= (writeReg(4)) and (not writeReg(3)) and (not writeReg(2)) and (not writeReg(1)) and (not writeReg(0)) and writeCmd;
	we(8)<= (writeReg(4)) and (not writeReg(3)) and (not writeReg(2)) and (not writeReg(1)) and (writeReg(0)) and writeCmd;

	
end remember;

----------------------------------------------------------------------------------------------------------------------------------------------------------------
