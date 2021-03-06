library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity id_ex_reg is
  	Port (
		-- inputs
		rst			   : in STD_LOGIC;
        clk			   : in STD_LOGIC;
		read_data_1_in : in std_logic_vector(31 downto 0);
		read_data_2_in : in std_logic_vector(31 downto 0);
		extended_value_in : in std_logic_vector(31 downto 0);
		instruction_20to16_in : in std_logic_vector(4 downto 0);
		instruction_15to11_in : in std_logic_vector(4 downto 0);
		
		--control signal inputs
		regwrite_in : in STD_LOGIC;
		regdst_in	: in STD_LOGIC;
		aluop_in	: in std_logic_vector(1 downto 0);
		alusrc_in	: in STD_LOGIC;
		memwrite_in : in STD_LOGIC;
		memtoreg_in : in STD_LOGIC;
		
		-- outputs
		read_data_1_out : out std_logic_vector(31 downto 0);
		read_data_2_out : out std_logic_vector(31 downto 0);
		extended_value_out : out std_logic_vector(31 downto 0);
		instruction_20to16_out : out std_logic_vector(4 downto 0);
		instruction_15to11_out : out std_logic_vector(4 downto 0);
		
		-- control signal outputs
		regwrite_out : out STD_LOGIC;
		regdst_out	 : out STD_LOGIC;
		aluop_out	 : out std_logic_vector(1 downto 0);
		alusrc_out	 : out STD_LOGIC;
		memwrite_out : out STD_LOGIC;
		memtoreg_out : out STD_LOGIC;
		
    --for forwarding unit
 
    reg_rs_in : in std_logic_vector(4 downto 0);
    reg_rs_out : out std_logic_vector(4 downto 0));
end entity id_ex_reg; 

architecture Behavioral of id_ex_reg is

begin
	
	id_ex_process : process(clk, rst)
	begin
		if rst='1' then
			read_data_1_out <= (others => '0');
			read_data_2_out <= (others => '0');
			extended_value_out <= (others => '0');
			instruction_20to16_out <= (others => '0');
			instruction_15to11_out <= (others => '0');
			regwrite_out <= '0';
			regdst_out	 <= '0';
			aluop_out	 <= (others => '0');
			alusrc_out	 <= '0';
			memwrite_out <= '0';
			memtoreg_out <= '0';
			reg_rs_out <= (others => '0');
			
		elsif rising_edge(clk) then
			regwrite_out <= regwrite_in;
			reg_rs_out <= reg_rs_in;
			regdst_out	<= regdst_in;
			aluop_out	<= aluop_in;
			alusrc_out	<= alusrc_in;
			memwrite_out <= memwrite_in;
			memtoreg_out <= memtoreg_in;
			read_data_1_out <= read_data_1_in;
			read_data_2_out <= read_data_2_in;
			extended_value_out <= extended_value_in;
			instruction_20to16_out <= instruction_20to16_in;
			instruction_15to11_out <= instruction_15to11_in;			
		end if;

	end process;
	
	

end Behavioral;
