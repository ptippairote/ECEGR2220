--------------------------------------------------------------------------------
--
-- Test Bench for LAB #4
--
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.ALL;

ENTITY testALU_vhd IS
END testALU_vhd;

ARCHITECTURE behavior OF testALU_vhd IS 

	-- Component Declaration for the Unit Under Test (UUT)
	COMPONENT ALU
		Port(	DataIn1: in std_logic_vector(31 downto 0);
			DataIn2: in std_logic_vector(31 downto 0);
			ALUCtrl: in std_logic_vector(4 downto 0);
			Zero: out std_logic;
			ALUResult: out std_logic_vector(31 downto 0) );
	end COMPONENT ALU;

	--Inputs
	SIGNAL datain_a : std_logic_vector(31 downto 0) := (others=>'0');
	SIGNAL datain_b : std_logic_vector(31 downto 0) := (others=>'0');
	SIGNAL control	: std_logic_vector(4 downto 0)	:= (others=>'0');

	--Outputs
	SIGNAL result   :  std_logic_vector(31 downto 0);
	SIGNAL zeroOut  :  std_logic;

BEGIN

	-- Instantiate the Unit Under Test (UUT)
	uut: ALU PORT MAP(
		DataIn1 => datain_a,
		DataIn2 => datain_b,
		ALUCtrl => control,
		Zero => zeroOut,
		ALUResult => result
	);
	

	tb : PROCESS
	BEGIN

		-- Wait 100 ns for global reset to finish
		wait for 100 ns;

		-- Start testing the ALU
		datain_a <= X"01234567";	-- DataIn in hex
		datain_b <= X"11223344";
		control  <= "00000";		-- Control in binary (ADD and ADDI test)
		wait for 20 ns; 			-- result = 0x124578AB  and zeroOut = 0

		-- Add test cases here to drive the ALU implementation

		datain_a <= X"01234567";	-- DataIn in hex
		datain_b <= X"00000060";
		control  <= "00000";		-- Control in binary (ADD and ADDI test)
		wait for 20 ns; 			-- result = 0x124578AB  and zeroOut = 0

		datain_a <= X"01234567";	
		datain_b <= X"00123456";
		control  <= "00001";		-- sub and subi test
		wait for 20 ns; 			-- result = 0x01111111  and zeroOut = 0

		datain_a <= X"01234567";	
		datain_b <= X"01234567";
		control  <= "00001";		-- zeroout test
		wait for 20 ns; 			-- result = 0x00000000  and zeroOut = 1

		datain_a <= X"01234567";	
		datain_b <= X"01244567";
		control  <= "00010";		-- and and andi test
		wait for 20 ns; 			-- result = 0x01204567  and zeroOut = 0

		datain_a <= X"01234567";	
		datain_b <= X"00000060";
		control  <= "00010";		-- and and andi test
		wait for 20 ns; 			-- result = 0x00000060  and zeroOut = 0

		datain_a <= X"01234567";	
		datain_b <= X"96969696";
		control  <= "00011";		-- or and ori test
		wait for 20 ns; 			-- result = 0x097b7d7f7  and zeroOut = 0

		datain_a <= X"01234567";	
		datain_b <= X"00000060";
		control  <= "00011";		-- or and ori test
		wait for 20 ns; 			-- result = 0x01234567  and zeroOut = 0

		datain_a <= X"01234567";	
		datain_b <= X"00000001";	
		control  <= "00100";		-- sll and slli test
		wait for 20 ns; 			-- result = 0x02468ace  and zeroOut = 0

		datain_a <= X"01234567";	
		datain_b <= X"00000003";
		control  <= "00100";		-- sll and slli test
		wait for 20 ns; 			-- result = 0x091a2b38   and zeroOut = 0

		datain_a <= X"01234567";	
		datain_b <= X"00000001";	
		control  <= "00101";		-- srl and slri test
		wait for 20 ns; 			-- result = 0x0091a2b3   and zeroOut = 0

		datain_a <= X"01234567";	
		datain_b <= X"00000003";
		control  <= "00101";		-- srl and slri test
		wait for 20 ns; 			-- result = 0x01234567   and zeroOut = 0

		datain_a <= X"96969696";	-- doesn't matter
		datain_b <= X"01234567";
		control  <= "01111";		-- pass through test
		wait for 20 ns; 			-- result = 0x002468ac and zeroOut = 0
		

		wait; -- will wait forever
	END PROCESS;

END;