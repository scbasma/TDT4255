library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ALU is

  port (
    rt: in signed(31 downto 0) := to_signed(0, 32);
    rs: in signed(31 downto 0) := to_signed(0, 32);

    alu_op: in std_logic_vector(3 downto 0);

    alu_result: buffer signed(31 downto 0) := to_signed(0, 32);
    zero: out boolean := true

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
      when "0000" => alu_result <= rt and rs;
      when "0001" => alu_result <= rt or rs;
	   when "0111" => if rt < rs 
								then alu_result <= to_signed(1, 32);
								else alu_result <= to_signed(0, 32);
							end if;
		when others => alu_result <= signed(rt) + signed(rs);
    end case;
  end process;
end behavorial;

