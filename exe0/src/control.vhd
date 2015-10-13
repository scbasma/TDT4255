library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.defs.all;

entity control is

    port (
        clk : in std_logic;
        rst : in std_logic;

        -- Communication
        instruction : in instruction_t;
        empty : in std_logic;
        read : out std_logic;

        -- Stack control
        push : out std_logic;
        pop : out std_logic;
        stack_src : out stack_input_select_t;
        operand : out operand_t;
		  opcode : out opcode_t;
        -- ALU control
        a_wen : out std_logic;
        b_wen : out std_logic;
        alu_sel : out alu_operation_t
    );
end entity control;

architecture behavioural of control is

-- Fill in type and signal declarations here

type state_type is (IDLE, FETCH, DECODE, POP_B, POP_A, PUSH_OPERAND, COMPUTE, PUSH_RESULT);
signal current_s, next_s: state_type;

begin -- architecture behavioural


    process (clk, rst) is
        begin 
        if rst = '1' then 
            current_s <= IDLE;
        elsif rising_edge(clk) then
            current_s <= next_s;
         end if;
    end process;
    
    process(empty,instruction, current_s) is
        begin
            case current_s is 
                when IDLE =>
						  push <= '0';
						  pop <= '0';
						  read <= '0';
						  a_wen <= '0';
						  b_wen <= '0';
                    if (empty = '0') then
                        next_s <= FETCH;
                    else
                        next_s <= IDLE;
                    end if;
                when FETCH =>
                    read <= '1';
                    next_s <= DECODE;
                when DECODE =>
							read <= '0';
                    if unsigned(instruction(15 downto 8)) = 0 then
                        next_s <= PUSH_OPERAND;
                    else
                        next_s <= POP_B;
                    end if;
                when PUSH_OPERAND =>
                        operand <= instruction(7 downto 0);
                        stack_src <= STACK_INPUT_OPERAND;
                        push <= '1';
                        next_s <= IDLE;
                    
                when POP_B =>
                    b_wen <= '1';
                    pop <= '1';    
                    next_s <= POP_A;
                when POP_A =>
						  b_wen <= '0';
                    a_wen <= '1';
                    pop <= '1';
                    next_s <= COMPUTE;          
                when COMPUTE =>
						  a_wen <= '0';
						  pop <= '0';
                    if unsigned(instruction(15 downto 8)) = 1 then
                        alu_sel <= ALU_ADD;
                    elsif unsigned(instruction(15 downto 8)) = 2 then 
                        alu_sel <= ALU_SUB;
                    end if;
                    next_s <= PUSH_RESULT;
                when PUSH_RESULT =>
                    stack_src <= STACK_INPUT_RESULT;
                    if unsigned(instruction(15 downto 8)) = 1 then
                        alu_sel <= ALU_ADD;
                    elsif unsigned(instruction(15 downto 8)) = 2 then 
                        alu_sel <= ALU_SUB;
                    end if;
						  push <= '1';
						  next_s <= IDLE;
            end case;
        end process;                    
         

end architecture behavioural;
