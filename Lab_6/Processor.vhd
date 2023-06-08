--------------------------------------------------------------------------------
--
-- LAB #6 - Processor 
--
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Processor is
    Port ( reset : in  std_logic;
	   clock : in  std_logic);
end Processor;

architecture holistic of Processor is
	component Control
   	     Port( clk : in  STD_LOGIC;
               opcode : in  STD_LOGIC_VECTOR (6 downto 0);
               funct3  : in  STD_LOGIC_VECTOR (2 downto 0);
               funct7  : in  STD_LOGIC_VECTOR (6 downto 0);
               Branch : out  STD_LOGIC_VECTOR(1 downto 0);
               MemRead : out  STD_LOGIC;
               MemtoReg : out  STD_LOGIC;
               ALUCtrl : out  STD_LOGIC_VECTOR(4 downto 0);
               MemWrite : out  STD_LOGIC;
               ALUSrc : out  STD_LOGIC;
               RegWrite : out  STD_LOGIC;
               ImmGen : out STD_LOGIC_VECTOR(1 downto 0));
	end component;

	component ALU
		Port(DataIn1: in std_logic_vector(31 downto 0);
		     DataIn2: in std_logic_vector(31 downto 0);
		     ALUCtrl: in std_logic_vector(4 downto 0);
		     Zero: out std_logic;
		     ALUResult: out std_logic_vector(31 downto 0) );
	end component;
	
	component Registers
	    Port(ReadReg1: in std_logic_vector(4 downto 0); 
                 ReadReg2: in std_logic_vector(4 downto 0); 
                 WriteReg: in std_logic_vector(4 downto 0);
		 WriteData: in std_logic_vector(31 downto 0);
		 WriteCmd: in std_logic;
		 ReadData1: out std_logic_vector(31 downto 0);
		 ReadData2: out std_logic_vector(31 downto 0));
	end component;

	component InstructionRAM
    	    Port(Reset:	  in std_logic;
		 Clock:	  in std_logic;
		 Address: in std_logic_vector(29 downto 0);
		 DataOut: out std_logic_vector(31 downto 0));
	end component;

	component RAM 
	    Port(Reset:	  in std_logic;
		 Clock:	  in std_logic;	 
		 OE:      in std_logic;
		 WE:      in std_logic;
		 Address: in std_logic_vector(29 downto 0);
		 DataIn:  in std_logic_vector(31 downto 0);
		 DataOut: out std_logic_vector(31 downto 0));
	end component;
	
	component BusMux2to1
		Port(selector: in std_logic;
		     In0, In1: in std_logic_vector(31 downto 0);
		     Result: out std_logic_vector(31 downto 0) );
	end component;
	
	component ProgramCounter
	    Port(Reset: in std_logic;
		 Clock: in std_logic;
		 PCin: in std_logic_vector(31 downto 0);
		 PCout: out std_logic_vector(31 downto 0));
	end component;

	component adder_subtracter
		port(	datain_a: in std_logic_vector(31 downto 0);
			datain_b: in std_logic_vector(31 downto 0);
			add_sub: in std_logic;
			dataout: out std_logic_vector(31 downto 0);
			co: out std_logic);
	end component adder_subtracter;

	component ImmGen
    Port(ImmCon: in std_logic_vector(1 downto 0);
	 Inst: in std_logic_vector(31 downto 0);
	 ImmOut: out std_logic_vector(31 downto 0));
	end component ImmGen;


	signal MemRead,MemWrite,RegWrite,MemtoReg,BranchLogic,zero, ALUSrc: std_logic;
	signal PCin,Inst,pc4,pc,ImmOut,WriteData, ReadData1, ReadData2, branchPC, AluIn2,ALUResult,memData,addOffset: std_logic_vector(31 downto 0);
	signal ImmCon, BranchCon: std_logic_vector(1 downto 0);
	signal ALUcon: std_logic_vector(4 downto 0);
begin
	-- Add your code here
	pcComp: ProgramCounter port map(Clock=>clock, Reset=>reset, PCin=>PCin, PCout=>pc);
	iRam: InstructionRAM port map(Reset=>reset, Clock=>clock, Address=>pc(31 downto 2), DataOut=>Inst);
	Reg: Registers port map(readReg1=>Inst(19 downto 15), readReg2=>Inst(24 downto 20), writeReg=> Inst(11 downto 7), WriteData=>WriteData, writeCmd=> RegWrite, ReadData1=>ReadData1,ReadData2=>ReadData2);
	ImmGenerator: ImmGen port map(ImmCon=>ImmCon, Inst=>Inst, ImmOut=>ImmOut);
	pcAdd: adder_subtracter port map(datain_a=>pc, datain_b=>X"00000004",add_sub=>'0',dataout=>pc4);
	branchAdd: adder_subtracter port map(datain_a=>pc, datain_b=>ImmOut,add_sub=>'0',dataout=>branchPC);
	branchMux: BusMux2to1 port map(selector=>BranchLogic,In0=>pc4,In1=>branchPC, Result=>PCin);
	BranchLogic<= '1' when ((BranchCon="01" and zero='1') or (BranchCon="10" and zero='0')) else '0';
	ImmMux: BusMux2to1 port map(selector=>ALUSrc, In0=>ReadData2,In1=>ImmOut, Result=>AluIn2);
	ALUcomp: ALU port map(DataIn1=>ReadData1,DataIn2=>AluIn2, ALUCtrl=>ALUcon, ALUResult=>ALUResult, Zero=>zero);
	AddressOffset: adder_subtracter port map(datain_b=>X"10000000", datain_a=>ALUResult, add_sub=>'1', dataout=>addOffset);
	dataMem: RAM port map(Reset=>reset, Clock=>clock, OE=>MemRead, WE=>MemWrite, Address=> addOffset(31 downto 2), DataIn=>ReadData2, DataOut=>memData);
	MemMux: BusMux2to1 port map(selector=>MemtoReg, In0=>ALUResult,In1=>memData, Result=>WriteData);
	Ctrl: Control port map(clk=> clock, opcode=>Inst(6 downto 0), funct3=>Inst(14 downto 12), funct7=>Inst(31 downto 25), Branch=>BranchCon, MemRead=>MemRead,MemWrite=>MemWrite,MemtoReg=>MemtoReg, ALUCtrl=>ALUCon, ALUSrc=>ALUSrc, ImmGen=>ImmCon, RegWrite=>RegWrite);

end holistic;

