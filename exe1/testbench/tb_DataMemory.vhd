--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   14:04:32 10/13/2015
-- Design Name:   
-- Module Name:   /home/shomed/e/espstr/exe1/tb_DataMemory.vhd
-- Project Name:  exe1
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: DataMemory
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
 
ENTITY tb_DataMemory IS
END tb_DataMemory;
 
ARCHITECTURE behavior OF tb_DataMemory IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT DataMemory
    PORT(
         clk : IN  std_logic;
         rst : IN  std_logic;
         data_in : IN  std_logic_vector(31 downto 0);
         data_out : OUT  std_logic_vector(31 downto 0);
         write_address : IN  std_logic_vector(7 downto 0);
         read_address : IN  std_logic_vector(7 downto 0);
         MemWrite : IN  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal data_in : std_logic_vector(31 downto 0) := (others => '0');
   signal write_address : std_logic_vector(7 downto 0) := (others => '0');
   signal read_address : std_logic_vector(7 downto 0) := (others => '0');
   signal MemWrite : std_logic := '0';

 	--Outputs
   signal data_out : std_logic_vector(31 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: DataMemory PORT MAP (
          clk => clk,
          rst => rst,
          data_in => data_in,
          data_out => data_out,
          write_address => write_address,
          read_address => read_address,
          MemWrite => MemWrite
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for clk_period*10;

      -- insert stimulus here 
		MemWrite <= '1';
		data_in <= x"10000000";
		write_address <= x"01";
		read_address <= x"01";
		
		check(data_out = x"00000000", "data out should not be updated on the same cycle");
      report "Test 1 passed" severity note;
		wait for clk_period;
		
		MemWrite <= '0';
      wait for clk_period;
		check(data_out = x"10000000", "data out should be updated on the next cycle");
      report "Test 2 passed" severity note;
		
		wait until clk = '1';
		assert false report "TEST SUCCESS" severity failure;
   end process;

END;
