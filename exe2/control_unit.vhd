library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity control_unit is
  
  port (
    clk : in std_logic;
    rst : in std_logic;

    -- Communication
    instruction : in  std_logic_vector(5 downto 0);
	 processor_enable : in std_logic;
    reg_dst     : out std_logic;
    branch      : out std_logic;
	 jump			 : out std_logic;
    mem_to_reg  : out std_logic;
    alu_op      : out std_logic_vector(1 downto 0);
	 alu_src     : out std_logic;
    reg_write   : out std_logic;
    mem_write   : out std_logic
	 );



end entity control_unit;

architecture behavioural of control_unit is

begin -- architecture behavioural


    process (rst,processor_enable,instruction) is
        begin 
        if rst = '1' then 
				reg_dst     <= '0';
				branch      <= '0';
				jump 			<= '0';
				mem_to_reg  <= '0';
				alu_op      <= "00";
				alu_src     <= '0';
				reg_write   <= '0';
				mem_write   <= '0';
		 
        elsif processor_enable='1' then
            case instruction is
					when "000000" =>	-- R FORMAT
						reg_dst     <= '1';
						branch      <= '0';
						jump 			<= '0';
						mem_to_reg  <= '0';
						alu_op      <= "10";
						alu_src     <= '0';
						reg_write   <= '1';
						mem_write   <= '0';
					when "100011" =>	-- LW
						reg_dst     <= '0';
						branch      <= '0';
						jump 			<= '0';
						mem_to_reg  <= '1';
						alu_op      <= "00";
						alu_src     <= '1';
						reg_write   <= '1';
						mem_write   <= '0';	
					when "101011" =>	-- SW
						reg_dst     <= '0';
						branch      <= '0';
						jump 			<= '0';
						mem_to_reg  <= '0';
						alu_op      <= "00";
						alu_src     <= '1';
						reg_write   <= '0';
						mem_write   <= '1';	
					when "000010" =>  -- JUMP
						reg_dst     <= '0';
						branch      <= '0';
						jump 			<= '1';
						mem_to_reg  <= '0';
						alu_op      <= "00";
						alu_src     <= '0';
						reg_write   <= '0';
						mem_write   <= '0';	
					when "000100" =>  -- BEQ
						reg_dst     <= '0';
						branch      <= '1';
						jump 			<= '0';
						mem_to_reg  <= '0';
						alu_op      <= "01";
						alu_src     <= '0';
						reg_write   <= '0';
						mem_write   <= '0';	
					when "001111" =>  -- LUI
						reg_dst     <= '0';
						branch      <= '0';
						jump 			<= '0';
						mem_to_reg  <= '0';
						alu_op      <= "11";
						alu_src     <= '1';
						reg_write   <= '1';
						mem_write   <= '0';
					when others   => 		
						reg_dst     <= '0';
						branch      <= '0';
						jump 			<= '0';
						mem_to_reg  <= '0';
						alu_op      <= "00";
						alu_src     <= '0';
						reg_write   <= '0';
						mem_write   <= '0';	
				end case;	
         end if;
    end process;
 

end architecture behavioural;