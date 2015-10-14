library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ALU_Ctrl is 

  port (
      
      op_code: in std_logic_vector(1 downto 0);
      instruction_funct: in std_logic_vector(5 downto 0);
      
      alu_op: out std_logic_vector(5 downto 0)

  );

end ALU_Ctrl;

architecture behavorial of ALU_Ctrl is 
begin 

  process(op_code, instruction_funct)
  begin
    case op_code is 
      when "00" => alu_op <= "0010";
      when "01" => alu_op <= "0110";
      when "10" => 
          case instruction_funct is
            when "100000" => alu_op <= "0010";
            when "100010" => alu_op <= "0110";
            when "100100" => alu_op <= "0000";
            when "100101" => alu_op <= "0001";
            when "101010" => alu_op <= "0111";
			   when others => alu_op <= "0010"; 
          end case;
		 when others => alu_op <= "0010";
    end case;
  end process;
end behavorial;
