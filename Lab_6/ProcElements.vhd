--------------------------------------------------------------------------------
--
-- LAB #6 - Processor Elements
--
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity BusMux2to1 is
	Port(	selector: in std_logic;
			In0, In1: in std_logic_vector(31 downto 0);
			Result: out std_logic_vector(31 downto 0) );
end entity BusMux2to1;

architecture selection of BusMux2to1 is
begin
    result <= In1 when selector='1' else In0;
end architecture selection;

--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Control is
      Port(clk : in  STD_LOGIC;
           opcode : in  STD_LOGIC_VECTOR (6 downto 0);
           funct3  : in  STD_LOGIC_VECTOR (2 downto 0);
           funct7  : in  STD_LOGIC_VECTOR (6 downto 0);
           Branch : out  STD_LOGIC_VECTOR(1 downto 0); --
           MemRead : out  STD_LOGIC; 
           MemtoReg : out  STD_LOGIC; --
           ALUCtrl : out  STD_LOGIC_VECTOR(4 downto 0); --
           MemWrite : out  STD_LOGIC; --
           ALUSrc : out  STD_LOGIC; --
           RegWrite : out  STD_LOGIC; --
           ImmGen : out STD_LOGIC_VECTOR(1 downto 0)); --
end Control;

architecture Boss of Control is
signal addCon, subCon, andCon, orCon,sllCon,srlCon, iForm, rForm: std_logic;
begin
-- Add your code here
rForm<= '1' when opcode = "0110011" else '0';
iForm<= '1' when opcode="0010011" else '0';
addCon<= '1' when (opcode="0000011" or opcode="0100011" or (rForm='1'and funct3="000" and funct7(5)='0') or (iForm='1' and funct3="000")) else '0';
subCon<= '1' when (opcode="1100011" or (rForm='1'and funct3="000" and funct7(5)='1')) else '0';
andCon<= '1' when ((rForm='1' or iForm='1') and funct3="111") else '0';
orCon<= '1' when ((rForm='1' or iForm='1') and funct3="110") else '0';
sllCon<= '1' when ((rForm='1' or iForm='1') and funct3="001") else '0';
srlCon<='1' when ((rForm='1' or iForm='1') and funct3="101") else '0';
ALUCtrl <= "00000" when addCon='1' else
        "00001" when subCon='1' else
        "00010" when andCon='1' else
        "00011" when orCon='1' else
        "00100" when sllCon='1' else
        "00101" when srlCon='1' else
        "11111";


RegWrite<='0' when (opcode="1100011" or opcode = "0100011" or clk='1') else '1'; --clk = 1 so it goes high during falling edge and latches then
MemWrite<='1' when opcode="0100011" else '0';
MemtoReg<='1' when opcode="0000011" else '0';
ALUSrc<='0' when (rForm='1' or opcode="1100011") else '1';
Branch<="01" when (opcode="1100011" and funct3="000") else "10" when (opcode="1100011" and funct3="001") else "00";
ImmGen<="01" when opcode="0100011" else "10" when opcode="1100011" else "11" when opcode="0110111" else "00";
MemRead<='0' when opcode="0000011" else '1';

end Boss;

--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ProgramCounter is
    Port(Reset: in std_logic;
	 Clock: in std_logic;
	 PCin: in std_logic_vector(31 downto 0);
	 PCout: out std_logic_vector(31 downto 0));
end entity ProgramCounter;

architecture executive of ProgramCounter is
begin
-- Add your code here
Proc: process(Clock, PCin, reset) is
begin
    if Reset = '1' then
        PCout <= X"003FFFFC";
    end if;
    if rising_edge(Clock) then
        PCout <= PCin;
    end if;
end process;
end executive;

--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ImmGen is
    Port(ImmCon: in std_logic_vector(1 downto 0);
	 Inst: in std_logic_vector(31 downto 0);
	 ImmOut: out std_logic_vector(31 downto 0));
end entity ImmGen;

architecture gen of ImmGen is
signal signn:std_logic;
signal e20:std_logic_vector(19 downto 0);
signal e19:std_logic_vector(18 downto 0);
begin 
-- Add your code here
signn<=Inst(31);
e20<= "11111111111111111111" when signn='1' else "00000000000000000000";
e19<= "1111111111111111111" when signn='1' else "0000000000000000000";
ImmOut<= e20&Inst(31 downto 25)&Inst(11 downto 7) when ImmCon="01" else
        e19&Inst(31)&Inst(7)&Inst(30 downto 25)&Inst(11 downto 8)&"0" when ImmCon="10" else
        Inst(31 downto 12)&"000000000000" when ImmCon ="11" else
        e20&Inst(31 downto 20);
end gen;
------------------------------