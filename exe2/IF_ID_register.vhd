library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity if_id_reg is
	Port (
		clk						: in STD_LOGIC;
		branch_taken			: in STD_LOGIC;
		do_flush				: out STD_LOGIC;
		flush_in				: in STD_LOGIC;
		imem_instruction_in		: in std_logic_vector(31 downto 0);
		pc_address_in			: in std_logic_vector(31 downto 0);
		imem_instruction_out	: out std_logic_vector(31 downto 0);
		pc_address_out			: out std_logic_vector(31 downto 0));
end entity if_id_reg;

architecture Behavioral of if_id_reg is

begin

	if_id_process : process (clk,branch_taken)
    begin
		if rising_edge(clk) then
				if (flush_in = '1')  then
				imem_instruction_out <= (others => '0');
				pc_address_out <= (others => '0');
				else
				imem_instruction_out <= imem_instruction_in;
				pc_address_out <= pc_address_in;
				end if;
				do_flush <= '0';
		elsif (branch_taken = '1')  then
				imem_instruction_out <= (others => '0');
				pc_address_out <= (others => '0');
				do_flush <= '1';
		end if;
    end process;

end Behavioral;