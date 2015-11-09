library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ex_to_mem is

    port (
        clk : in std_logic;

        alu_result_in : in std_logic_vector(31 downto 0);
        alu_result_out : out std_logic_vector(31 downto 0);

        read_data_in : in std_logic_vector(31 downto 0);
        read_data_out : out std_logic_vector(31 downto 0);

        write_register_in : in std_logic_vector(4 downto 0);
        write_register_out : out std_logic_vector(4 downto 0);

        --control

        reg_write_in : in std_logic;
        reg_write_out : out std_logic;

        mem_to_reg_in  : in STD_LOGIC;
        mem_to_reg_out   : out STD_LOGIC;
		  
        mem_write_in : in std_logic;
        mem_write_out : out std_logic);
        
end entity ex_to_mem;


architecture behavioural of ex_to_mem is

begin

    process (clk) is 
        begin 
        if rising_edge(clk) then
           
                reg_write_out <= reg_write_in;
                mem_write_out <= mem_write_in;
		mem_to_reg_out <= mem_to_reg_in;
          
		alu_result_out <= alu_result_in;
		read_data_out <= read_data_in;
		write_register_out <= write_register_in;
        end if;


    end process;

end architecture behavioural;






