library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.defs.all;
use work.testutil.all;

entity tb_ALU is
end tb_ALU;

architecture behavioural of tb_ALU is
  
  signal rt: std_logic_vector(31 downto 0) := (others = '0');

  signal rs: std_logic_vector (31 downto 0) := (others = '0');

  signal alu_op: std_logic_vector (3 downto 0) := (others = '0');

  signal alu_result: std_logic_vector (31 downto 0) := (others = '0');
  
  signal zero: std_logic := '0';

  -- clock  
  constant clk_period : time := 20 ns;
  signal clk: std_logic := '1';

begin

  DUT: entity work.ALU
    port map (

        clk => clk,
        rt => rt, 
        rs => rs,
        alu_op => alu_op, 
        alu_result => alu_result,
        zero => zero);


    clk => not clk after clk_period/2;

    ALU_TEST: process
    begin
      wait until rising_edge(clk);
      rt <= to_signed(2, 32);
      rs <= to_signed(2, 32);
      alu_op = "0010" -- ADD
      wait until falling_edge(clk);
      assert(alu_result = signed(rt) + signed(rs))
      report "Addition passed" severity note;
    end process ALU_TEST;

end architecture behavioural; 

configuration tb_ALU_behavioural_cfg of tb_ALU is
  for behavioural
  end for;
end tb_ALU_behavioural_cfg;
      
