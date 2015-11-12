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
  signal reg_dst            : std_logic;
  signal branch            : std_logic;
  signal jump	            : std_logic;
  signal mem_to_reg         : std_logic;
  signal alu_src             : std_logic;
  signal alu_op             : std_logic_vector(1 downto 0);
  signal reg_write          : std_logic;
  signal mem_write          : std_logic;
  signal flush 				: std_logic := '0';

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
      reg_dst     => reg_dst,
      branch      => branch,
		jump        => jump,
      mem_to_reg  => mem_to_reg,
      alu_op      => alu_op,
		alu_src     => alu_src,
      reg_write	  => reg_write,
	  flush => flush,
      mem_write   => mem_write);

  -- clock generation
  clk <= not clk after clk_period / 2;

  -- waveform generation
  WaveGen_Proc : process

	procedure check_init_output is
    begin  -- procedure check_init_output
      check(reg_dst = '0', "reg dst incorrect idle output");
      check(branch = '0', "branch incorrect idle output");
		check(jump = '0', "jump incorrect idle output");
      check(mem_to_reg = '0', "mem to reg incorrect idle output");
      check(alu_op = "00", "alu op incorrect idle output");
      check(alu_src = '0', "alu src incorrect idle output");
      check(reg_write = '0', "reg write incorrect idle output");
      check(mem_write = '0', "mem write incorrect idle output");
    end procedure check_init_output;
	 
    procedure check_stable_init is
    begin  -- procedure check_stable_init
      init_reset_check : for i in 0 to 20 loop
        check_init_output;
        wait for clk_period;
      end loop init_reset_check;
    end procedure check_stable_init;

    procedure check_rformat_output is
    begin  -- procedure check_fetch_output
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
      check(reg_dst = '0', "reg dst incorrect lw output");
      check(branch = '0', "branch incorrect lw output");
		check(jump = '0', "jump incorrect lw output");
      check(mem_to_reg = '1', "mem to reg incorrect lw output");
      check(alu_op = "00", "alu op incorrect lw output");
      check(alu_src = '1', "alu src incorrect lw output");
      check(reg_write = '1', "reg write incorrect lw output");
      check(mem_write = '0', "mem write incorrect lw output");
    end procedure check_lw_output;
    
	 procedure check_sw_output is
    begin  
      check(reg_dst = '0', "reg dst incorrect sw output");
      check(branch = '0', "branch incorrect sw output");		
		check(jump = '0', "jump incorrect sw output");
      check(mem_to_reg = '0', "mem to reg incorrect sw output");
      check(alu_op = "00", "alu op incorrect sw output");
      check(alu_src = '1', "alu src incorrect sw output");
      check(reg_write = '0', "reg write incorrect sw output");
      check(mem_write = '1', "mem write incorrect sw output");
    end procedure check_sw_output;
	 
    procedure check_beq_output is
    begin  -- procedure check_pop_b_output
      check(reg_dst = '0', "reg dst incorrect beq output");
      check(branch = '1', "branch incorrect beq output");
		check(jump = '0', "jump incorrect beq output");
      check(mem_to_reg = '0', "mem to reg incorrect beq output");
      check(alu_op = "01", "alu op incorrect beq output");
      check(alu_src = '0', "alu src incorrect beq output");
      check(reg_write = '0', "reg write incorrect beq output");
      check(mem_write = '0', "mem write incorrect beq output");
    end procedure check_beq_output;
	 
    procedure check_jump_output is
    begin  -- procedure check_pop_a_output
      check(reg_dst = '0', "reg dst incorrect jump output");
      check(branch = '0', "branch incorrect jump output");
		check(jump = '1', "jump incorrect jump output");
      check(mem_to_reg = '0', "mem to reg incorrect jump output");
      check(alu_op = "00", "alu op incorrect jump output");
      check(alu_src = '0', "alu src incorrect jump output");
      check(reg_write = '0', "reg write incorrect jump output");
      check(mem_write = '0', "mem write incorrect jump output");
    end procedure check_jump_output;
	 
	  procedure check_lui_output is
    begin  -- procedure check_pop_a_output
      check(reg_dst = '0', "reg dst incorrect lui output");
      check(branch = '0', "branch incorrect lui output");
		check(jump = '0', "jump incorrect lui output");
      check(mem_to_reg = '0', "mem to reg incorrect lui output");
      check(alu_op = "11", "alu op incorrect lui output");
      check(alu_src = '1', "alu src incorrect lui output");
      check(reg_write = '1', "reg write incorrect lui output");
      check(mem_write = '0', "mem write incorrect lui output");
    end procedure check_lui_output;
	 
  begin
    -- insert signal assignments here
    wait for clk_period/4;
    rst <= '1';
    wait for clk_period;
    rst <= '0';

-- TEST stable behaviour after reset
	 processor_en <='0';	
	 instruction <= "000000";
    check_stable_init;
    report "Test 1 passed" severity note;
	 processor_en <='1';	
    wait for clk_period;
    check_rformat_output;
    report "Test 2 passed" severity note;
	 
	 
	 wait for clk_period;
	 instruction <= "100011";
    check_rformat_output;
    report "Test 3 passed" severity note;
	 wait for clk_period;
	 instruction <= "100011";
    check_lw_output;
    report "Test 4 passed" severity note;
	 instruction <= "101011";
	 wait for clk_period;
    check_sw_output;
    report "Test 5 passed" severity note;
	 
	 instruction <= "101011";
	 wait for clk_period;
    check_sw_output;
    report "Test 6 passed" severity note;
	 
	 instruction <= "000100";
	 wait for clk_period;
    check_beq_output;
    report "Test 7 passed" severity note;
	 
	 instruction <= "000010";
	 wait for clk_period;
    check_jump_output;
    report "Test 8 passed" severity note;
	
	  
	 instruction <= "001111";
	 wait for clk_period;
    check_lui_output;
    report "Test 9 passed" severity note;
	 
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

