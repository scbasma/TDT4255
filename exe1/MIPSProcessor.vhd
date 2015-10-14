-- Part of TDT4255 Computer Design laboratory exercises
-- Group for Computer Architecture and Design
-- Department of Computer and Information Science
-- Norwegian University of Science and Technology

-- MIPSProcessor.vhd
-- The MIPS processor component to be used in Exercise 1 and 2.

-- TODO replace the architecture DummyArch with a working Behavioral

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity MIPSProcessor is
	generic (
		ADDR_WIDTH : integer := 8;
		DATA_WIDTH : integer := 32;
		regfile_size : natural := 32);
	port ( 
		clk, reset 				: in std_logic;
		processor_enable		: in std_logic;
		imem_data_in			: in std_logic_vector(DATA_WIDTH-1 downto 0);
		imem_address			: out std_logic_vector(ADDR_WIDTH-1 downto 0);
		dmem_data_in			: in std_logic_vector(DATA_WIDTH-1 downto 0);
		dmem_address			: out std_logic_vector(ADDR_WIDTH-1 downto 0);
		dmem_data_out			: out std_logic_vector(DATA_WIDTH-1 downto 0);
		dmem_write_enable		: out std_logic
	);
end MIPSProcessor;

architecture DummyArch of MIPSProcessor is
	
	-- PC signals
	signal address_in		: std_logic_vector(31 downto 0);
	signal address_out	: std_logic_vector(31 downto 0);
	signal next_address  : std_logic_vector(31 downto 0);
	-- registers signals
	signal read_data_1	: std_logic_vector(DATA_WIDTH-1 downto 0);
	signal read_data_2	: std_logic_vector(DATA_WIDTH-1 downto 0);
	signal write_data    : std_logic_vector(DATA_WIDTH-1 downto 0);
   signal write_reg_add :  std_logic_vector(ADDR_WIDTH-1 downto 0);	
	-- ALU signals
	signal zero			:   boolean;	
	signal data_2     : std_logic_vector(31 downto 0);
	signal alu_result : std_logic_vector(31 downto 0); -- BECAREFUL alu result is a buffer signal
	-- ALU Control signal
	signal alu_op     : std_logic_vector(3 downto 0); 
	-- Control unit signals
	signal reg_write  : std_logic;
	signal write_en   : std_logic;
	signal op_code    : std_logic_vector(1 downto 0);
	signal reg_dst    : std_logic;
	signal branch     : std_logic;
	signal jump			: std_logic;
	signal mem_read   : std_logic;
	signal mem_to_reg : std_logic;
	signal alu_src    : std_logic;
	-- SignExtend
	signal extend_out : std_logic_vector(31 downto 0);
	
	
begin
	
	address_in <=	next_address							when	(branch='0' and jump='0') else
						next_address+(extend_out sll 2)	when  (branch='1' and zero =true and jump='0') else
						(imem_data_in(25 downto 0) sll 2)& next_address(31 downto 28); 
	

	DummyProc: process(clk, reset)
	begin
		if reset = '1' then
			counterReg <= (others => '0');
		elsif rising_edge(clk) then
			if processor_enable = '1' then
				counterReg <= counterReg + 1;
			end if;
		end if;
	end process;
	
	
	SignExtend : entity work.SignExtend
		port map( 
			data_in  => imem_data_in( 15 downto 0),
         data_out => extend_out);
	
	RegisterFile : entity work.RegisterFile
		generic map(
			ADDR_WIDTH => ADDR_WIDTH,
			DATA_WIDTH => DATA_WIDTH,
			size => regfile_size )
		port map(
			clk => clk,
			rst	=> rst,
			RegWrite => reg_write,		
			read_register1_addr => imem_data_in( 25 downto 21), 
			read_register2_addr => imem_data_in( 20 downto 16),
			write_register_addr => write_reg_add,
			write_data	=> write_data,
			read_data1	=> read_data_1,
			read_data2	=> read_data_2);
		
	ALU : entity work.ALU
		port map (
			rt  			=> read_data_1,
			rs				=> data_2,
			alu_op		=> alu_op ,
			alu_result	=> alu_result,
			zero			=> zero );
	
	ALU_PC : entity work.ALU
		port map (
			rt  			=> address_out,
			rs				=> x"4",
			alu_op		=> "0010" ,
			alu_result	=> next_address,
			zero			=> 0);
			
	ALU_Ctrl : entity ALU_Ctrl
		port map(
			op_code => op_code,
			instruction_funct => imem_data_in( 5 downto 0) ,			
			alu_op =>  alu_op);
	
	program_counter : entity work.program_counter
		port map(
			clk      => clk,
			rst		=> rst,
			write_en => write_en,	
			PC_in		=> address_in,
			PC_out	=> address_out); 		
	
	
	control_unit : entity work.control_unit
		port map(
		 clk => clk,
		 rst => rst,	  
		 instruction => imem_data_in(31 downto 26),
		 write_en   => write_en,
		 reg_dst    => reg_dst,
		 branch     => branch,
		 jump			=> jump,
		 mem_read    => mem_read,
		 mem_to_reg  => mem_to_reg,
		 alu_op      => op_code ,
		 alu_src     => alu_src,
		 reg_write   => reg_write ,
		 mem_write   => dmem_write_enable);
		
	
end DummyArch;

