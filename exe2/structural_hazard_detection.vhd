library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity struct_hazard_detect is 

    Port (
        
        reg_id_ex_memread : in std_logic; --signal to determine if load instruction

        reg_id_ex_rt: in std_logic_vector(4 downto 0);
        reg_if_id_rt: in std_logic_vector(4 downto 0);
        reg_if_id_rs: in std_logic_vector(4 downto 0);

        stall: out std_logic



    
    );


end entity struct_hazard_detect;

architecture behavioural of struct_hazard_detect is 

begin

    stall <= '0';

    process(reg_id_ex_memread, reg_id_ex_rt, reg_if_id_rt, reg_if_id_rs)
    begin
        
        if reg_id_ex_memread = '1' and (reg_id_ex_rt = reg_if_id_rs or reg_id_ex_rt = reg_if_id_rt)
        then stall <= '1';
        end if;

    end process;

end behavioural; 
