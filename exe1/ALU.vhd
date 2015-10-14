library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ALU is

  port (
    rt: in std_logic_vector (31 downto 0);
    rs: in std_logic_vector (31 downto 0);

    alu_op: in std_logic_vector(3 downto 0);

    alu_result: out std_logic_vector(31 downto 0);
    zero: out std_logic 

  );

end ALU;

architecture behavorial of ALU is
begin

  zero <= (alu_result = 0);

  process (alu_op, rt, rs)
  begin
    case alu_op is
      when "0010" => alu_result <= signed(rt) + signed(rs);
      when "0110" => alu_result <= signed(rt) - signed(rs);
      when "0111" => alu_result <= if rt < rs then result <= '1' else result<= '0' end if;
      when "0000" => alu_result <= rt and rs;
      when "0001" => alu_result <= rt or rs;
    end case;
  end process;
end behavorial;

