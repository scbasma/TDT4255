library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.defs.all;
use work.testutil.all;
-------------------------------------------------------------------------------

entity tb_control_unit is
end entity tb_control_unit;

-------------------------------------------------------------------------------

architecture behavioural of tb_control_unit is

  -- component ports
  signal rst : std_logic := '0';
  signal instruction      : std_logic_vector(5 downto 0) := (others => '0');
  signal processor_en : std_logic;
  signal write_en				: std_logic;
  signal reg_dst            : std_logic;
  signal branch            : std_logic;
  signal jump	            : std_logic;
  signal mem_to_reg         : std_logic;
  signal alu_src             : std_logic;
  signal alu_op             : std_logic_vector(1 downto 0);
  signal reg_write          : std_logic;
  signal mem_write          : std_logic;

  -- clock
  constant clk_period : time      := 20 ns;
  signal clk          : std_logic := '1';

begin  -- architecture behavioural

  -- component instantiation
  DUT : entity work.control_unit
    port map (
		processor_enable => processor_en,
      clk         => clk,
      rst         => rst,
      instruction => instruction,
		write_en    => write_en,
      reg_dst     => reg_dst,
      branch      => branch,
		jump        => jump,
      mem_to_reg  => mem_to_reg,
      alu_op      => alu_op,
		alu_src     => alu_src,
      reg_write	  => reg_write,
      mem_write   => mem_write);

  -- clock generation
  clk <= not clk after clk_period / 2;

  -- waveform generation
  WaveGen_Proc : process

	procedure check_idle_output is
    begin  -- procedure check_idle_output
      check(write_en = '0', "write enable incorrect idle output");
      check(reg_dst = '0', "reg dst incorrect idle output");
      check(branch = '0', "branch incorrect idle output");
		check(jump = '0', "jump incorrect idle output");
      check(mem_to_reg = '0', "mem to reg incorrect idle output");
      check(alu_op = "00", "alu op incorrect idle output");
      check(alu_src = '0', "alu src incorrect idle output");
      check(reg_write = '0', "reg write incorrect idle output");
      check(mem_write = '0', "mem write incorrect idle output");
    end procedure check_idle_output;
	 
    procedure check_fetch_output is
    begin  -- procedure check_idle_output
      check(write_en = '0', "write enable incorrect fetch output");
      check(reg_dst = '0', "reg dst incorrect fetch output");
      check(branch = '0', "branch incorrect fetch output");
		check(jump = '0', "jump incorrect fetch output");
      check(mem_to_reg = '0', "mem to reg incorrect fetch output");
      check(alu_op = "00", "alu op incorrect fetch output");
      check(alu_src = '0', "alu src incorrect fetch output");
      check(reg_write = '0', "reg write incorrect fetch output");
      check(mem_write = '0', "mem write incorrect fetch output");
    end procedure check_fetch_output;

    procedure check_stable_idle is
    begin  -- procedure check_stable_idle
      --check(instruction = "100000", "[TEST BUG]: Empty should be 1 for idle to be stable");
      idle_reset_check : for i in 0 to 20 loop
        check_idle_output;
        wait for clk_period;
      end loop idle_reset_check;
    end procedure check_stable_idle;

    procedure check_rformat_output is
    begin  -- procedure check_fetch_output
      check(write_en = '1', "write enable incorrect r-format output");
      check(reg_dst = '1', "reg dst incorrect r-format output");
      check(branch = '0', "branch incorrect r-format output");
		check(jump = '0', "jump incorrect r-format output");      
      check(mem_to_reg = '0', "mem to reg incorrect r-format output");
      check(alu_op = "10", "alu op incorrect r-format output");
      check(alu_src = '0', "alu src incorrect r-format output");
      check(reg_write = '1', "reg write incorrect r-format output");
      check(mem_write = '0', "mem write incorrect r-format output");
    end procedure check_rformat_output;

    procedure check_lw_output is
    begin  -- procedure check_decode_output
      check(write_en = '0', "write enable incorrect lw output");
      check(reg_dst = '0', "reg dst incorrect lw output");
      check(branch = '0', "branch incorrect lw output");
		check(jump = '0', "jump incorrect lw output");
      check(mem_to_reg = '1', "mem to reg incorrect lw output");
      check(alu_op = "00", "alu op incorrect lw output");
      check(alu_src = '1', "alu src incorrect lw output");
      check(reg_write = '1', "reg write incorrect lw output");
      check(mem_write = '0', "mem write incorrect lw output");
    end procedure check_lw_output;
	
	procedure check_stall_lw_output is
    begin  -- procedure check_decode_output
      check(write_en = '1', "write enable incorrect stall lw output");
      check(reg_dst = '0', "reg dst incorrect stall lw output");
      check(branch = '0', "branch incorrect stall lw output");
		check(jump = '0', "jump incorrect stall lw output");
      check(mem_to_reg = '1', "mem to reg incorrect stall lw output");
      check(alu_op = "00", "alu op incorrect stall lw output");
      check(alu_src = '1', "alu src incorrect stall lw output");
      check(reg_write = '1', "reg write incorrect stall lw output");
      check(mem_write = '0', "mem write incorrect stall lw output");
    end procedure check_stall_lw_output;
    
	 procedure check_sw_output is
    begin  
      check(write_en = '0', "write enable incorrect sw output");
      check(reg_dst = '0', "reg dst incorrect sw output");
      check(branch = '0', "branch incorrect sw output");		
		check(jump = '0', "jump incorrect sw output");
      check(mem_to_reg = '0', "mem to reg incorrect sw output");
      check(alu_op = "00", "alu op incorrect sw output");
      check(alu_src = '1', "alu src incorrect sw output");
      check(reg_write = '0', "reg write incorrect sw output");
      check(mem_write = '1', "mem write incorrect sw output");
    end procedure check_sw_output;

	procedure check_stall_sw_output is
    begin  
      check(write_en = '1', "write enable incorrect stall sw output");
      check(reg_dst = '0', "reg dst incorrect stall sw output");
      check(branch = '0', "branch incorrect stall sw output");		
		check(jump = '0', "jump incorrect stall sw output");
      check(mem_to_reg = '0', "mem to reg incorrect stall sw output");
      check(alu_op = "00", "alu op incorrect stall sw output");
      check(alu_src = '1', "alu src incorrect stall sw output");
      check(reg_write = '0', "reg write incorrect stall sw output");
      check(mem_write = '1', "mem write incorrect stall sw output");
    end procedure check_stall_sw_output;

    procedure check_beq_output is
    begin  -- procedure check_pop_b_output
      check(write_en = '1', "write enable incorrect beq output");
      check(reg_dst = '0', "reg dst incorrect beq output");
      check(branch = '1', "branch incorrect beq output");
		check(jump = '0', "jump incorrect beq output");
      check(mem_to_reg = '0', "mem to reg incorrect beq output");
      check(alu_op = "01", "alu op incorrect beq output");
      check(alu_src = '0', "alu src incorrect beq output");
      check(reg_write = '0', "reg write incorrect beq output");
      check(mem_write = '0', "mem write incorrect beq output");
    end procedure check_beq_output;
	
	procedure check_stall2_output is
    begin  -- procedure check_pop_a_output
      check(write_en = '0', "write enable incorrect stall 2 output");
      check(reg_dst = '0', "reg dst incorrect stall 2 output");
      check(branch = '0', "branch incorrect stall 2 output");
		check(jump = '0', "jump incorrect stall 2 output");
      check(mem_to_reg = '0', "mem to reg incorrect stall 2 output");
      check(alu_op = "00", "alu op incorrect stall 2 output");
      check(alu_src = '0', "alu src incorrect stall 2 output");
      check(reg_write = '0', "reg write incorrect stall 2 output");
      check(mem_write = '0', "mem write incorrect stall 2 output");
    end procedure check_stall2_output;
	 
    procedure check_jump_output is
    begin  -- procedure check_pop_a_output
      check(write_en = '0', "write enable incorrect jump output");
      check(reg_dst = '0', "reg dst incorrect jump output");
      check(branch = '0', "branch incorrect jump output");
		check(jump = '1', "jump incorrect jump output");
      check(mem_to_reg = '0', "mem to reg incorrect jump output");
      check(alu_op = "00", "alu op incorrect jump output");
      check(alu_src = '0', "alu src incorrect jump output");
      check(reg_write = '0', "reg write incorrect jump output");
      check(mem_write = '0', "mem write incorrect jump output");
    end procedure check_jump_output;
	 
	  procedure check_stall_jump_output is
    begin  -- procedure check_pop_a_output
      check(write_en = '1', "write enable incorrect stall jump output");
      check(reg_dst = '0', "reg dst incorrect stall jump output");
      check(branch = '0', "branch incorrect stall jump output");
		check(jump = '1', "jump incorrect stall jump output");
      check(mem_to_reg = '0', "mem to reg incorrect stall jump output");
      check(alu_op = "00", "alu op incorrect stall jump output");
      check(alu_src = '0', "alu src incorrect stall jump output");
      check(reg_write = '0', "reg write incorrect stall jump output");
      check(mem_write = '0', "mem write incorrect stall jump output");
    end procedure check_stall_jump_output;
	 
	  procedure check_lui_output is
    begin  -- procedure check_pop_a_output
      check(write_en = '0', "write enable incorrect lui output");
      check(reg_dst = '0', "reg dst incorrect lui output");
      check(branch = '0', "branch incorrect lui output");
		check(jump = '0', "jump incorrect lui output");
      check(mem_to_reg = '0', "mem to reg incorrect lui output");
      check(alu_op = "11", "alu op incorrect lui output");
      check(alu_src = '1', "alu src incorrect lui output");
      check(reg_write = '1', "reg write incorrect lui output");
      check(mem_write = '0', "mem write incorrect lui output");
    end procedure check_lui_output;
	 
	  procedure check_stall_lui_output is
    begin  -- procedure check_pop_a_output
      check(write_en = '1', "write enable incorrect stall lui output");
      check(reg_dst = '0', "reg dst incorrect stall lui output");
      check(branch = '0', "branch incorrect stall lui output");
		check(jump = '0', "jump incorrect stall lui output");
      check(mem_to_reg = '0', "mem to reg incorrect stall lui output");
      check(alu_op = "11", "alu op incorrect stall lui output");
      check(alu_src = '1', "alu src incorrect stall lui output");
      check(reg_write = '1', "reg write incorrect stall lui output");
      check(mem_write = '0', "mem write incorrect stall lui output");
    end procedure check_stall_lui_output;


  begin
    -- insert signal assignments here
    wait for clk_period/4;
    rst <= '1';
    wait for clk_period;
    rst <= '0';

-- TEST stable behaviour after reset
	 processor_en <='0';	
	 instruction <= "000000";
    check_stable_idle;
    report "Test 1 passed" severity note;
	 processor_en <='1';	
    wait for clk_period;
    check_fetch_output;
    report "Test 2 passed" severity note;
	 
	 
	 wait for clk_period;
	 instruction <= "100011";
    check_rformat_output;
    report "Test 3 passed" severity note;
	 
	 wait for clk_period;
    check_stall2_output;
    report "Test 4 passed" severity note;
	 
	 wait for clk_period;
    check_fetch_output;
    report "Test 5 passed" severity note;
	 
	 wait for clk_period;
	 check_lw_output;
    report "Test 6 passed" severity note;
	 
	 wait for clk_period;
	 check_stall_lw_output;
    report "Test 7 passed" severity note;
	 
	 instruction <= "101011";
	 
	 wait for clk_period;
    check_stall2_output;
    report "Test 8 passed" severity note;

	 wait for clk_period;
    check_fetch_output;
    report "Test 9 passed" severity note;
	
	 wait for clk_period;
	 
	 check_sw_output;
    report "Test 10 passed" severity note;
	 wait for clk_period;
	 
	 check_stall_sw_output;
    report "Test 11 passed" severity note;
	 
	 instruction <= "000100";
	 wait for clk_period;
    check_stall2_output;
    report "Test 12 passed" severity note;
	 
	 wait for clk_period;
    check_fetch_output;
    report "Test 13 passed" severity note;
	 
	 wait for clk_period;
	 check_beq_output;
    report "Test 14 passed" severity note;
	 
	 instruction <= "000010";
	 wait for clk_period;
    check_stall2_output;
    report "Test 15 passed" severity note;
	 
	 wait for clk_period;
	 check_fetch_output;
    report "Test 16 passed" severity note;
	 
	 wait for  clk_period;
	 check_jump_output;
    report "Test 17 passed" severity note;
	 
	 wait for clk_period;
	 check_stall_jump_output;
    report "Test 18 passed" severity note;
	 
	 instruction <= "001111";
	 wait for clk_period;
    check_stall2_output;
    report "Test 19 passed" severity note;
	 
	 wait for clk_period;
	 check_fetch_output;
    report "Test 20 passed" severity note;
	
	 wait for  clk_period;
	 check_lui_output;
    report "Test 21 passed" severity note;
	 
	 wait for clk_period;
	 check_stall_lui_output;
    report "Test 22 passed" severity note;
	 
	 instruction <= "001111";
	 wait for clk_period;
    check_stall2_output;
    report "Test 23 passed" severity note;
	 
	 wait for clk_period;
	 check_fetch_output;
    report "Test 24 passed" severity note;	
	 assert false report "TEST SUCCESS" severity failure;
    wait until clk = '1';

  end process WaveGen_Proc;

end architecture behavioural;

-------------------------------------------------------------------------------

configuration control_tb_behavioural_cfg of tb_control_unit is
  for behavioural
  end for;
end control_tb_behavioural_cfg;

-------------------------------------------------------------------------------

