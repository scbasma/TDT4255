library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.defs.all;
use work.testutil.all;

entity tb_ALU is
end entity tb_ALU;

architecture behavioural of tb_ALU is
  
  signal rt: std_logic_vector(31 downto 0) := (others => '0');

  signal rs: std_logic_vector(31 downto 0) := (others => '0');

  signal alu_op: std_logic_vector(3 downto 0) := (others => '0');

  signal alu_result: std_logic_vector(31 downto 0) := (others => '0');
  
  signal zero: boolean := false;

  -- clock  
  constant clk_period : time := 20 ns;
  signal clk: std_logic := '1';

begin

  DUT: entity work.ALU
    port map (

        rt => rt, 
        rs => rs,
        alu_op => alu_op, 
        alu_result => alu_result,
        zero => zero);


    clk <= not clk after clk_period/2;
	 
    ALU_TEST: process
    begin
      wait until rising_edge(clk);
      rt <= std_logic_vector(to_signed(2, 32));
      rs <= std_logic_vector(to_signed(2, 32));
      alu_op <= "0110"; -- SUB
      wait until falling_edge(clk);
      check(alu_result = std_logic_vector(signed(rt) - signed(rs)), "Subtraction failed");
      report "regular Subtraction passed" severity note;
		
		
      wait until rising_edge(clk);
      rt <= std_logic_vector(to_signed(2147483647, 32));
      rs <= std_logic_vector(to_signed(-2147483647, 32));
      alu_op <= "0110"; -- SUB
      wait until falling_edge(clk);
      check(alu_result = std_logic_vector(signed(rt) - signed(rs)), "Subtraction failed");
      report "BIG Subtraction passed" severity note;
		
		wait until rising_edge(clk);
      rt <= std_logic_vector(to_signed(2, 32));
      rs <= std_logic_vector(to_signed(2, 32));
      alu_op <= "0010"; -- ADD
      wait until falling_edge(clk);
      check(alu_result = std_logic_vector(signed(rt) + signed(rs)), "Addition failed");
      report "Addition passed" severity note;
		

      wait until rising_edge(clk);
      rt <= std_logic_vector(to_signed(2147483647, 32));
      rs <= std_logic_vector(to_signed(-2147483647, 32));
      alu_op <= "0010"; -- 
      wait until falling_edge(clk);
      check(alu_result = std_logic_vector(signed(rt) + signed(rs)), "big addition failed");
      report "Big addition passed" severity note;
		
    
      wait until rising_edge(clk);
      rt <= std_logic_vector(to_signed(2, 32));
      rs <= std_logic_vector(to_signed(2, 32));
      alu_op <= "0000"; -- AND
      wait until falling_edge(clk);
      check(alu_result = std_logic_vector(signed(rt) and  signed(rs)), "AND failed");
      report "AND passed" severity note;
		
		
      wait until rising_edge(clk);
      rt <= std_logic_vector(to_signed(0, 32));
      rs <= std_logic_vector(to_signed(1, 32));
      alu_op <= "0000"; -- AND
      wait until falling_edge(clk);
      check(alu_result = std_logic_vector(signed(rt) and  signed(rs)), "AND failed");
      report "AND passed" severity note;
		

      wait until rising_edge(clk);
      rt <= std_logic_vector(to_signed(1, 32));
      rs <= std_logic_vector(to_signed(1, 32));
      alu_op <= "0001"; -- OR
      wait until falling_edge(clk);
      check(alu_result = std_logic_vector(signed(rt) or  signed(rs)), "OR failed");
      report "OR passed" severity note;
		
		wait until rising_edge(clk);
      rt <= std_logic_vector(to_signed(1, 32));
      rs <= std_logic_vector(to_signed(2, 32));
      alu_op <= "0111"; -- SLT
      wait until falling_edge(clk);
      check(signed(alu_result) = 1, "slt failed");
		
		wait until rising_edge(clk);
      rt <= std_logic_vector(to_signed(3, 32));
      rs <= std_logic_vector(to_signed(2, 32));
      alu_op <= "0111"; -- SLT
      wait until falling_edge(clk);
      check(signed(alu_result) = 0, "slt failed");
      report "slt passed" severity note;
		
		report "Simulation completed" severity failure;
    end process ALU_TEST;

end architecture behavioural; 

configuration tb_ALU_behavioural_cfg of tb_ALU is
  for behavioural
  end for;
end tb_ALU_behavioural_cfg;
      
