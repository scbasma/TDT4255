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
	 write_en    : out std_logic;
    reg_dst     : out std_logic;
    branch      : out std_logic;
	 jump			 : out std_logic;
    mem_read    : out std_logic;
    mem_to_reg  : out std_logic;
    alu_op      : out std_logic_vector(1 downto 0);
	 alu_src     : out std_logic;
    reg_write   : out std_logic;
    mem_write   : out std_logic);


end entity control_unit;

architecture behavioural of control_unit is


	type state_type is (IDLE, FETCH, S_RFORMAT, S_LW,S_SW,S_BEQ,S_JUMP,S_LUI, STALL,STALL2);
	signal current_s, next_s: state_type;
	signal instruction_current : std_logic_vector(5 downto 0);

begin -- architecture behavioural


    process (clk, rst,processor_enable) is
        begin 
        if rst = '1' then 
            current_s <= IDLE;
        elsif rising_edge(clk) and processor_enable='1' then
            current_s <= next_s;
         end if;
    end process;
    
    process(instruction, current_s,processor_enable) is
        begin
            case current_s is 
                when IDLE =>
							write_en    <= '0';-- and  processor_enable ;
							reg_dst     <= '0';
							branch      <= '0';
							jump 			<= '0';
							mem_read    <= '0';
							mem_to_reg  <= '0';
							alu_op      <= "00";
							alu_src     <= '0';
							reg_write   <= '0';
							mem_write   <= '0';
							
							if processor_enable = '1' then 
								next_s <= FETCH ;
							else
								next_s <= IDLE;
							end if;
                when FETCH =>
							write_en    <= '0';
							reg_dst     <= '0';
							branch      <= '0';
							jump 			<= '0';
							mem_read    <= '0';
							mem_to_reg  <= '0';
							alu_op      <= "00";
							alu_src     <= '0';
							reg_write   <= '0';
							mem_write   <= '0';
							case instruction is
								when "000000" =>	next_s <= S_RFORMAT;
								when "100011" =>	next_s <= S_LW;
								when "101011" =>	next_s <= S_SW;
								when "000010" =>  next_s <= S_JUMP;
								when "000100" =>  next_s <= S_BEQ;
								when "001111" =>  next_s <= S_LUI;
								when others   =>  next_s <= FETCH;							
							end case;						
         
                when S_RFORMAT =>
					   write_en    <= '1';
						reg_dst     <= '1';
						branch      <= '0';
						jump 			<= '0';
						mem_read    <= '0';
						mem_to_reg  <= '0';
						alu_op      <= "10";
						alu_src     <= '0';
						reg_write   <= '1';
						mem_write   <= '0';
						next_s <= STALL2;	
					 when S_LW =>
					    write_en    <= '0';
						 reg_dst     <= '0';
						 branch      <= '0';
						 jump 		 <= '0';
						 mem_read    <= '1';
						 mem_to_reg  <= '1';
						 alu_op      <= "00";
						 alu_src     <= '1';
						 reg_write   <= '1';
						 mem_write   <= '0';
						 next_s <= STALL;
					 when S_SW =>
						 write_en    <= '0';
						 reg_dst     <= '0';
						 branch      <= '0';
						 jump 		 <= '0';
						 mem_read    <= '0';
						 mem_to_reg  <= '0';
						 alu_op      <= "00";
						 alu_src     <= '1';
						 reg_write   <= '0';
						 mem_write   <= '1';
						 next_s <= STALL;
					 when S_JUMP =>
					    write_en    <= '0';
						 reg_dst     <= '0';
						 branch      <= '0';
						 jump 		 <= '1';
						 mem_read    <= '0';
						 mem_to_reg  <= '0';
						 alu_op      <= "00";
						 alu_src     <= '0';
						 reg_write   <= '0';
						 mem_write   <= '0';
						 next_s <= STALL;
					 when S_BEQ =>
					    write_en    <= '1';
						 reg_dst     <= '0';
						 branch      <= '1';
						 jump 		 <= '0';
						 mem_read    <= '0';
						 mem_to_reg  <= '0';
						 alu_op      <= "01";
						 alu_src     <= '0';
						 reg_write   <= '0';
						 mem_write   <= '0';
						 next_s <= STALL2;	
					when S_LUI =>
					    write_en    <= '0';
						 reg_dst     <= '0';
						 branch      <= '0';
						 jump 		 <= '0';
						 mem_read    <= '0';
						 mem_to_reg  <= '0';
						 alu_op      <= "11";
						 alu_src     <= '1';

						 reg_write   <= '1';
						 mem_write   <= '0';
						 next_s <= STALL;							 
                when STALL =>
					     write_en    <= '1';
                    next_s <= STALL2;
					 when STALL2 =>					
							reg_dst     <= '0';
							branch      <= '0';
							jump 			<= '0';
							mem_read    <= '0';
							mem_to_reg  <= '0';
							alu_op      <= "00";
							alu_src     <= '0';
							reg_write   <= '0';
							mem_write   <= '0';
							
					 	  write_en    <= '0';
                    next_s <= FETCH;
					 when others => null;
            end case;
        end process;                    
         

end architecture behavioural;