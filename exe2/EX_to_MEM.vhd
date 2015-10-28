library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ex_to_mem is

    port (
        clk : in std_logic;
        rst : in std_logic;

        add_result_in : in std_logic_vector(31 downto 0);
        add_result_out : out std_logic_vector(31 downto 0);
        

        zero_in : in std_logic; 
        zero_out : out std_logic;

        alu_result_in : in std_logic_vector(31 downto 0);
        alu_result_out : out std_logic_vector(31 downto 0);

        read_data_in : in std_logic_vector(31 downto 0);
        read_data_out : out std_logic_vector(31 downto 0);

        write_register_in : in std_logic_vector(31 downto 0);
        write_register_out : out std_logic_vector(31 downto 0);

        --control

        reg_write_in : in std_logic;
        reg_write_out : out std_logic;

        branch_in : in std_logic;
        branch_out : out std_logic;

        mem_read_in : in std_logic;
        mem_read_out : out std_logic;
        
        mem_write_in : in std_logic;
        mem_write_out : out std_logic;

    )
        
end entity ex_to_mem;


architecture behavioural of ex_to_mem is

begin

    process (clk) is 
        begin 
        if rising_edge(clk)
            if rst = '1' then
                add_result_out <= (others => '0');
                zero_out <= '1';
                alu_result_out <= (others => '0');
                read_data_out <= (others => '0');
                write_register_out <= (others => '0');

                --control
                reg_write_out <= '0';
                branch_out <= '0';
                mem_read_out <= '0';
                mem_write_out <= '0';
            else 
                add_result_out <= add_result_in;
                zero_out <= zero_in;
                alu_result_out <= alu_result_in;
                read_data_out <= read_data_in;
                write_register_out <= write_register_in;

                --control

                reg_write_out <= reg_write_in;
                branch_out <= branch_in;
                mem_read_out <= mem_read_in;
                mem_write_out <= mem_write_in;

            end if;
        end if


    end process;

end architecture behavioural;






