--------------------------------------------------------------------------------
--
-- LAB #4
--
--------------------------------------------------------------------------------

Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_unsigned.all;

entity ALU is
	Port(	DataIn1: in std_logic_vector(31 downto 0);
		DataIn2: in std_logic_vector(31 downto 0);
		ALUCtrl: in std_logic_vector(4 downto 0);
		Zero: out std_logic;
		ALUResult: out std_logic_vector(31 downto 0) );
end entity ALU;

architecture ALU_Arch of ALU is
	-- ALU components	
	component adder_subtracter
		port(datain_a: in std_logic_vector(31 downto 0);
			datain_b: in std_logic_vector(31 downto 0);
			add_sub: in std_logic;
			dataout: out std_logic_vector(31 downto 0);
			co: out std_logic);
	end component adder_subtracter;

	component shift_register
		port(datain: in std_logic_vector(31 downto 0);
		   	dir: in std_logic;
			shamt:	in std_logic_vector(4 downto 0);
			dataout: out std_logic_vector(31 downto 0));
	end component shift_register;

	signal add_out,sub_out,and_out,or_out,sll_out,srl_out,temp: std_logic_vector(31 downto 0);
begin
	-- Add ALU VHDL implementation here
	add: adder_subtracter port map (datain_a => DataIn1, datain_b=> DataIn2, add_sub => '0', dataout => add_out);--add and addi
	sub: adder_subtracter port map (datain_a => DataIn1, datain_b=> DataIn2, add_sub => '1', dataout => sub_out);--sub 
	and_out <= DataIn1 AND DataIn2;--and and andi
	or_out <= DataIn1 OR DataIn2;--or and ori
	shiftl: shift_register port map (datain => DataIn1, dir=> '0', shamt=>DataIn2(4 downto 0),dataout=>sll_out);--sll and slli
	shiftr: shift_register port map (datain => DataIn1, dir=> '1', shamt=>DataIn2(4 downto 0),dataout=>srl_out);--srl ans srli
	temp <= add_out when ALUCtrl="00000" else --add and addi
				sub_out when ALUCtrl = "00001" else --sub 
				and_out when ALUCtrl = "00010" else --and and andi
				or_out when ALUCtrl ="00011" else --or and ori
				sll_out when ALUCtrl ="00100" else --sll and slli
				srl_out when ALUCtrl ="00101" else --srl and srli
				DataIn2; --data2 passthrough
	Zero <= '1' when temp="00000000000000000000000000000000" else
			'0';
	ALUResult<=temp;

				


		

end architecture ALU_Arch;


