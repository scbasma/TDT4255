--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   12:56:33 10/14/2015
-- Design Name:   
-- Module Name:   /home/shomea/s/scbasma/exercise1/tb_alu_ctrl.vhd
-- Project Name:  exercise1
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: ALU_Ctrl
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use work.defs.all;
use work.testutil.all;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY tb_alu_ctrl IS
END tb_alu_ctrl;
 
ARCHITECTURE behavior OF tb_alu_ctrl IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT ALU_Ctrl
    PORT(
         op_code : IN  std_logic_vector(1 downto 0);
         instruction_funct : IN  std_logic_vector(5 downto 0);
         alu_op : OUT  std_logic_vector(3 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal op_code : std_logic_vector(1 downto 0) := (others => '0');
   signal instruction_funct : std_logic_vector(5 downto 0) := (others => '0');

 	--Outputs
   signal alu_op : std_logic_vector(3 downto 0);
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
     constant clk_period : time := 20 ns;
	  signal clk: std_logic := '1';
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: ALU_Ctrl PORT MAP (
          op_code => op_code,
          instruction_funct => instruction_funct,
          alu_op => alu_op
        );

	clk <= not clk after clk_period/2;

    ALU_CTRL_TEST: process
    begin
      wait until rising_edge(clk);
      op_code <= "10";
      instruction_funct <= "100000";
      wait until falling_edge(clk);
      check(alu_op = "0010", "alu_op should be 0010 after op_code=10 and instruction_funct=100000");
      report "Test 1 Passed"  severity note;
		
    end process ALU_CTRL_TEST;

END;

