library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity forwarding is 

    Port (
    
        --inputs 
        --rt and rs from id/ex stage
        reg_rt_id_ex : in std_logic_vector(4 downto 0);
        reg_rs_id_ex : in std_logic_vector(4 downto 0);
        --destination from ex/mem stage and mem/wb
        reg_rd_ex_mem: in std_logic_vector(4 downto 0);
        reg_rd_mem_wb: in std_logic_vector(4 downto 0);
        --are we going to write to a register?  
        reg_write_ex_mem : in std_logic;
        reg_write_mem_wb : in std_logic; 

        --outputs
        forward_a: out std_logic_vector(1 downto 0);
        forward_b: out std_logic_vector(1 downto 0)


    

    );

end entity forwarding;

architecture behavioural of forwarding is 

begin
   

    process(reg_rt_id_ex, reg_rs_id_ex, reg_rd_ex_mem, reg_rd_mem_wb, reg_write_ex_mem, reg_write_mem_wb) is 
    begin
     forward_a <= "00";
    forward_b <= "00";
	  --MEM HAZARD
    if reg_write_mem_wb = '1' and reg_rd_mem_wb /= "00000"
    and (reg_rd_ex_mem /= reg_rs_id_ex)
    and (reg_rd_mem_wb = reg_rs_id_ex) then
        forward_a <= "01";
    end if;

    
    if reg_write_mem_wb = '1' and reg_rd_mem_wb /= "00000"
    and ( reg_rd_ex_mem /= reg_rt_id_ex)
    and (reg_rd_mem_wb = reg_rt_id_ex) then
        forward_b <= "01";
    end if;
    --EX HAZARD
    if reg_write_ex_mem = '1' and reg_rd_ex_mem /= "00000" and reg_rd_ex_mem = reg_rs_id_ex then
        forward_a <= "10";

    end if;
    if reg_write_ex_mem = '1' and reg_rd_ex_mem /= "00000" and reg_rd_ex_mem = reg_rt_id_ex then
       forward_b <= "10";
    end if;

   

    
    end process;
end behavioural;
