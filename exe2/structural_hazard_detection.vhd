library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity struct_hazard_detect is 

    Port (        
        load_signal : in std_logic; -- reg_write ='1' and alu_src ='1' and memwrite_ex='0'
        reg_id_ex_rt: in std_logic_vector(4 downto 0);
        reg_if_id_rt: in std_logic_vector(4 downto 0);
        reg_if_id_rs: in std_logic_vector(4 downto 0);
        stall: out std_logic  := '0'  
    );


end entity struct_hazard_detect;

architecture behavioural of struct_hazard_detect is 

begin

    process(load_signal, reg_id_ex_rt, reg_if_id_rt, reg_if_id_rs)
    begin
        
        if (load_signal = '1' ) and (reg_id_ex_rt = reg_if_id_rs or reg_id_ex_rt = reg_if_id_rt)then
			stall <= '1';
		  else 
			stall <= '0';
        end if;

    end process;

end behavioural; 
