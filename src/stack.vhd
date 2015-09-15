library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.defs.all;

entity stack is
  
  generic (
    size : natural := 1024);            -- Maximum number of operands on stack

  port (
    clk       : in  std_logic;
    rst       : in  std_logic;
    value_in  : in  operand_t;
    push      : in  std_logic;
    pop       : in  std_logic;
    top       : out operand_t);

end entity stack;

architecture behavioural of stack is

	type stage_t is array(0 to size-1) of operand_t;
	signal stage : stage_t; -- := (others => (others => '0'));
  -- Fill in type and signal declarations here.

begin  -- architecture behavioural
	
	shift_process : process(clk,rst)
	begin
		if rst = '1' then
			top <= x"00";
			stage <= (others => (others =>'0'));
		elsif rising_edge(clk) then
			if (push = '1') then
			   top<= value_in;
				stage(0) <= value_in;
				for i in 1 to size-1 loop
					stage(i) <= stage(i-1);
				end loop;
			elsif (pop = '1') then
				stage(size-1)<= x"00";				
				for i in size-1 downto 1 loop
					stage(i-1) <= stage(i);
				end loop;
				top <= stage(1);
			end if;
			
			
			
		end if;
		
	end process;

end architecture behavioural;
