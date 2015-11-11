library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity if_id_reg is
	Port (
		clk						: in STD_LOGIC;
		rst						: in STD_LOGIC;
		branch_taken			: in STD_LOGIC;
		do_flush				: out STD_LOGIC;
		flush_pc_in 		: in std_logic;
		flush_pc_out 		: out std_logic;
		imem_instruction_in		: in std_logic_vector(31 downto 0);
		pc_address_in			: in std_logic_vector(31 downto 0);
		imem_instruction_out	: out std_logic_vector(31 downto 0);
		pc_address_out			: out std_logic_vector(31 downto 0));
end entity if_id_reg;

architecture Behavioral of if_id_reg is

begin

	if_id_process : process (clk, rst)
    begin
		if rst='1' then
			do_flush <= '0';
			flush_pc_out <= '0';
			imem_instruction_out <= (others => '0');
			pc_address_out <= (others => '0');
		elsif rising_edge(clk) then
				imem_instruction_out <= imem_instruction_in;
				pc_address_out <= pc_address_in;
				flush_pc_out <= flush_pc_in;
			if branch_taken = '0' then				
				do_flush <= '0';
			else
				do_flush <= '1';
			end if;				
		end if;
    end process;

end Behavioral;
