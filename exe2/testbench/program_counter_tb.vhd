library ieee;
use ieee.std_logic_1164.all;
use work.defs.all;
use work.testutil.all;
-------------------------------------------------------------------------------

entity program_counter_tb is

end entity program_counter_tb;

-------------------------------------------------------------------------------

architecture behavioural of program_counter_tb is

 
  -- component ports

  signal rst      : std_logic := '0';
  signal PC_in	  : std_logic_vector(31 downto 0) := (others => '0');
  signal write_en : std_logic := '0';
  signal flush_in : std_logic := '0';
  signal flush_out : std_logic := '0';
  signal stall : std_logic := '0';
  signal PC_out   : std_logic_vector(31 downto 0) := (others => '0');

  -- clock
  constant clk_period : time := 20 ns;
  signal clk : std_logic := '1';

begin  -- architecture behavioural

  -- component instantiation
  DUT: entity work.program_counter
    port map (
      clk      => clk,
      rst      => rst,
      PC_in    => PC_in,
      write_en => write_en,
	  flush_in => flush_in,
	  flush_out => flush_out,
	  stall => stall,
      PC_out   => PC_out);

  -- clock generation
  clk <= not clk after clk_period/2;

  -- waveform generation
  WaveGen_Proc: process
  begin
    -- insert signal assignments here
	stall <= '1';
    wait for clk_period/4;
    rst <= '1';
    wait for clk_period;
    rst <= '0';
    wait for clk_period;
    check(PC_out = x"00000000", "PC_out addres should be zero after reset");
    report "Test 1 passed" severity note;

    PC_in <= x"00000004";
    write_en <= '1';
    check(PC_out = x"00000000",
          "PC_out address should not be updated immediately after write_en");
    report "Test 2 passed" severity note;
	 wait for clk_period;
	 wait for clk_period;
    write_en <= '0';
    check(PC_out = x"00000004", "PC_out address should be reflected  the 2th addressafter write_en");
    report "Test 3 passed" severity note;
	 wait for clk_period;
	 PC_in <= x"00000008";
	 write_en <= '1';
	 check(PC_out = x"00000004", "PC_out address should be reflected the 2th address");
    report "Test 4 passed" severity note;
	 
	 wait for clk_period;
	 wait for clk_period;
    write_en <= '0';
    check(PC_out = x"00000008", "PC_out address should be reflected  the 3rd addressafter write_en");
    report "Test 5 passed" severity note;
	 
    wait for clk_period;
	 check(PC_out = x"00000008", "PC_out address should be reflected the 3rd address");
    report "Test 6 passed" severity note;
	 
	 PC_in <= x"000000E0";
	 write_en <= '1';
	 check(PC_out = x"00000008", "PC_out address should be reflected the 3rd address");
    report "Test 7 passed" severity note;
	 
	 wait for clk_period;
	 wait for clk_period;
    write_en <= '0';
    check(PC_out = x"000000E0", "PC_out address should be reflected  the 4th addressafter write_en");
    report "Test 8 passed" severity note;
	 
	 wait until clk = '1';
    assert false report "TEST SUCCESS" severity failure;
  end process WaveGen_Proc;

  

end architecture behavioural;

-------------------------------------------------------------------------------

configuration program_counter_tb_behavioural_cfg of program_counter_tb is
  for behavioural
  end for;
end program_counter_tb_behavioural_cfg;

-------------------------------------------------------------------------------
