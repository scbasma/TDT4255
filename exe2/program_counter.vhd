library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;


entity program_counter is
    port( 

	clk		: in std_logic; -- clock
	rst		: in std_logic;
	stall    : in std_logic;
	write_en 	: in std_logic;
	flush_in		: in std_logic;
	flush_out		: out std_logic;
	PC_in		: in std_logic_vector(31 downto 0); -- address input
	PC_out		: out std_logic_vector(31 downto 0) ); -- address output

end entity program_counter;


architecture behavioural of program_counter is
	signal last_PC : std_logic_vector(31 downto 0);
	signal internal_PC : std_logic_vector(31 downto 0);
begin
    
    
  internal_PC <= last_PC when stall='1' 
                          else (others => '0') when rst='1'
                          else PC_in;

	
    process (clk, rst, write_en) is
    begin
		 if clk'event and clk='1' then
			if rst='1' then
			  PC_out <= (others => '0');			  
			elsif rst='0' and write_en='1' then
			  last_PC <= PC_in;
			  PC_out <= internal_PC;			  
			end if;
		 end if;
	 end process;
	flush_out <= flush_in;
end architecture behavioural;
