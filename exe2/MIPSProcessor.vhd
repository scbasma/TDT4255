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
		ADDR_WIDTH 		: integer := 8;
		ADDR_REG_WIDTH : integer := 5;
		DATA_WIDTH 		: integer := 32;
		regfile_size 	: natural := 32);
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

architecture Behavioral of MIPSProcessor is
	
	-- PC signals
	signal address_in		: std_logic_vector(DATA_WIDTH-1 downto 0);
	signal address_out	: std_logic_vector(DATA_WIDTH-1 downto 0);
	signal next_address  : std_logic_vector(DATA_WIDTH-1 downto 0);
	signal flush_pc 		: std_logic;
	
	--ALU PC  signal
	signal empty : STD_LOGIC;
	-- IF_ID_Register 
	signal instruction : std_logic_vector(DATA_WIDTH-1 downto 0);
	signal pc_address : std_logic_vector(DATA_WIDTH-1 downto 0);
	signal flush_id : std_logic;
	signal flush_pc_out : std_logic;
	-- registers signals
	signal read_data1_id	: std_logic_vector(DATA_WIDTH-1 downto 0);
	signal read_data2_id	: std_logic_vector(DATA_WIDTH-1 downto 0);
	signal mem_write_id : STD_LOGIC;
	-- ID_EX_Register
	signal pc_address_ex  : std_logic_vector(31 downto 0);
	signal read_data_1_ex : std_logic_vector(31 downto 0);
	signal read_data_2_ex : std_logic_vector(31 downto 0);
	signal extended_value_ex : std_logic_vector(31 downto 0);
	signal instruction_20to16_ex : std_logic_vector(4 downto 0);
	signal instruction_15to11_ex : std_logic_vector(4 downto 0);
	signal write_reg_ex : std_logic_vector(4 downto 0);
	-- control signal outputs
	signal regwrite_ex : STD_LOGIC;
	signal branch_ex	 : STD_LOGIC;
	signal regdst_ex	 : STD_LOGIC;
	signal aluop_ex	 : std_logic_vector(1 downto 0);
	signal alusrc_ex	 : STD_LOGIC;
	signal memwrite_ex : STD_LOGIC;
	signal memtoreg_ex : STD_LOGIC;
	-- EX_MEM_Register
	signal add_result : std_logic_vector(DATA_WIDTH-1 downto 0);
	signal zero_mem : STD_LOGIC;
	signal alu_result_mem : std_logic_vector(31 downto 0);
	signal write_reg_mem : std_logic_vector(ADDR_REG_WIDTH-1 downto 0);

   signal branch_mem : std_logic;
   signal read_data_mem :  std_logic_vector(31 downto 0);
	signal memtoreg_mem : std_logic;
	signal regwrite_mem : std_logic;
	signal address_branch : std_logic_vector(31 downto 0);
	signal PC_src : std_logic;
	-- MEM_WB_Register
	signal regwrite_wb : std_logic;
	signal memtoreg_wb : std_logic;
	signal alu_result_wb : std_logic_vector(31 downto 0);
	signal write_data_wb : std_logic_vector(DATA_WIDTH-1 downto 0);
   signal write_reg_wb  :  std_logic_vector(ADDR_REG_WIDTH-1 downto 0);
	
	-- ALU signals
	signal zero			: STD_LOGIC;	
	signal data_2     : std_logic_vector(DATA_WIDTH-1 downto 0);
	signal alu_result : std_logic_vector(DATA_WIDTH-1 downto 0); -- BECAREFUL alu result is a buffer signal
	-- ALU Control signal
	signal alu_op_ctrl     : std_logic_vector(3 downto 0); 
	-- Control unit signals
	signal reg_write  : std_logic :='0';
	signal alu_op_id    : std_logic_vector(1 downto 0):="00";
	signal reg_dst    : std_logic :='0';
	signal branch     : std_logic :='0';
	signal jump			: std_logic :='0';
	signal mem_to_reg : std_logic :='0';
	signal alu_src    : std_logic :='0';
	signal flush_ctrl  : std_logic;
	-- SignExtend
	signal extend_out : std_logic_vector(DATA_WIDTH-1 downto 0);
	signal write_en : std_logic;
	signal imem_instruction : std_logic_vector(DATA_WIDTH-1 downto 0);
	--Foward signals 
	signal forwardA : std_logic_vector(1 downto 0);
	signal forwardB : std_logic_vector(1 downto 0);
begin
	
	-- Mux before Program counter
	address_in <=	next_address  	when	((PC_src='0') and jump='0') else
			add_result 	when  ((PC_src='1') and jump='0') else
			std_logic_vector(signed(next_address(31 downto 26)) & (signed(instruction(25 downto 0)))); 
	flush_ctrl <= flush_id or flush_pc_out;
	imem_instruction <= imem_data_in ;
	write_en <= processor_enable;
	PC_src <= '1' when ((branch='1') and (read_data1_id=read_data2_id)) else
		   '0'; --TO MODIFY !!!
	add_result <= 	std_logic_vector(signed(pc_address) + signed(extend_out));				
	-- Mux before regfile
	write_reg_ex <=	instruction_20to16_ex when regdst_ex='0' else
							instruction_15to11_ex; 
	-- Mux before ALU
	data_2 <= 	read_data_2_ex when alusrc_ex='0' else
					extended_value_ex; 
	-- Mux after Data memory
	write_data_wb <= 	alu_result_wb when memtoreg_wb='0' else 
						dmem_data_in; 
						
	imem_address <= address_out(ADDR_WIDTH-1 downto 0);
	dmem_address <= alu_result_mem(ADDR_WIDTH-1 downto 0);
	dmem_data_out<= read_data_mem;
	
	
	IF_ID_Register : entity work.if_id_reg 
	port map(
		clk						=> clk,
		branch_taken			=> PC_src,
		do_flush					=> flush_id,
		flush_pc_in				=> flush_pc,
		flush_pc_out			=> flush_pc_out,
		imem_instruction_in	=> imem_instruction,
		pc_address_in			=> address_out,
		imem_instruction_out	=> instruction,
		pc_address_out			=> pc_address);
	
	ID_EX_Register : entity work.id_ex_reg
  	port map (
		-- inputs
      clk			   => clk,
		read_data_1_in => read_data1_id,
		read_data_2_in => read_data2_id,
		extended_value_in => extend_out,
		instruction_20to16_in => instruction(20 downto 16),
		instruction_15to11_in => instruction(15 downto 11),
		
		--control signal inputs
		regwrite_in => reg_write,
		regdst_in	=> reg_dst,
		aluop_in	=> alu_op_id,
		alusrc_in	=> alu_src,
		memwrite_in => mem_write_id,
		memtoreg_in => mem_to_reg,
		
		-- outputs
		read_data_1_out => read_data_1_ex,
		read_data_2_out => read_data_2_ex,
		extended_value_out => extended_value_ex,
		instruction_20to16_out =>instruction_20to16_ex,
		instruction_15to11_out => instruction_15to11_ex,
		
		-- control signal outputs
		regwrite_out => regwrite_ex,
		regdst_out	 => regdst_ex,
		aluop_out	 => aluop_ex,
		alusrc_out	 => alusrc_ex,
		memwrite_out => memwrite_ex,
		memtoreg_out => memtoreg_ex,
		
    --for forwarding unit
    reg_rt_in => "00000",
    reg_rt_out => "00000",
    reg_rs_in => "00000",
    reg_rs_out => "00000");
	
	 
	 EX_MEM_Register : entity work.ex_to_mem 
    port map(
        clk  => clk,
        alu_result_in  => alu_result,
        alu_result_out => alu_result_mem,
        read_data_in  => read_data_2_ex,
        read_data_out => read_data_mem,
        write_register_in => write_reg_ex,
        write_register_out => write_reg_mem,

        --control
        reg_write_in  => regwrite_ex,
        reg_write_out  => regwrite_mem,
        mem_to_reg_in  => memtoreg_ex,
        mem_to_reg_out => memtoreg_mem,   
        mem_write_in => memwrite_ex,
        mem_write_out => dmem_write_enable
    );
	 
	MEM_WB_Register : entity work.mem_to_wb
    port map(
        clk => clk,
        rst => reset,
        alu_result_in => alu_result_mem,
        alu_result_out => alu_result_wb,
        write_register_in => write_reg_mem,
        write_register_out => write_reg_wb,
		  mem_to_reg_in  => memtoreg_mem,
        mem_to_reg_out => memtoreg_wb,
		  reg_write_in  => regwrite_mem,
		  reg_write_out => regwrite_wb
    ); 
	 
	Fowarding : entity work.forwarding
    port map(
        reg_rt_id_ex => instruction_20to16_ex ,
        reg_rs_id_ex => instruction_15to11_ex ,
        reg_rd_ex_mem => write_reg_mem,
        reg_rd_mem_wb =>  write_reg_wb,
        reg_write_ex_mem => regwrite_mem,
        reg_write_mem_wb => regwrite_wb,
        forward_a => forwardA,
        forward_b => forwardB
		  );
	SignExtend : entity work.SignExtend
		port map( 
			data_in  => instruction( 15 downto 0),
         data_out => extend_out);
	
	RegisterFile : entity work.RegisterFile
		generic map(
			ADDR_REG_WIDTH => ADDR_REG_WIDTH,
			DATA_WIDTH => DATA_WIDTH,
			size => regfile_size )
		port map(
			clk => clk,
			rst	=> reset,
			RegWrite => regwrite_wb,		
			read_register1_addr => instruction( 25 downto 21), 
			read_register2_addr => instruction( 20 downto 16),
			write_register_addr => write_reg_wb,
			write_data	=> write_data_wb,
			read_data1	=> read_data1_id,
			read_data2	=> read_data2_id);
		
	ALU : entity work.ALU
		port map (
			rt  			=> read_data_1_ex,
			rs				=> data_2,
			alu_op		=> alu_op_ctrl ,
			alu_result	=> alu_result,
			zero			=> zero );
	
	ALU_PC : entity work.ALU
		port map (
			rt  			=> address_out,
			rs				=> x"00000001",
			alu_op		=> "0010" ,
			alu_result	=> next_address,
			zero			=> empty);
			
	ALU_Ctrl : entity work.ALU_Ctrl
		port map(
			op_code => aluop_ex,
			instruction_funct => extended_value_ex( 5 downto 0) ,			
			alu_op =>  alu_op_ctrl);
	
	program_counter : entity work.program_counter
		port map(
			clk      => clk,
			rst		=> reset,
			write_en => write_en,
			flush_in => flush_id,
			flush_out => flush_pc,			
			PC_in		=> address_in,
			PC_out	=> address_out); 	
			
	control_unit : entity work.control_unit
		port map(
		 clk => clk,
		 rst => reset,	  
		 flush => flush_ctrl,
		 instruction => instruction(31 downto 26),
		 reg_dst    => reg_dst,
		 branch     => branch,
		 jump			=> jump,
		 mem_to_reg  => mem_to_reg,
		 alu_op      => alu_op_id ,
		 alu_src     => alu_src,
		 reg_write   => reg_write ,
		 mem_write   => mem_write_id,
		 processor_enable => processor_enable	);	
	
end Behavioral;

