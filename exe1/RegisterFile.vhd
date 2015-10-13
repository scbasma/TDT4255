----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:08:08 10/10/2015 
-- Design Name: 
-- Module Name:    RegisterFile - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity RegisterFile is

	generic (
		ADDR_WIDTH : integer := 8;
		DATA_WIDTH : integer := 32;
		size : natural := 1024);

	port(
			clk : in STD_LOGIC;
			rst	: in STD_LOGIC;
			RegWrite : in STD_LOGIC;				
			read_register1_addr : in STD_LOGIC_VECTOR (ADDR_WIDTH-1 downto 0); 
			read_register2_addr : in STD_LOGIC_VECTOR (ADDR_WIDTH-1 downto 0); 
			write_register_addr : in STD_LOGIC_VECTOR (ADDR_WIDTH-1 downto 0);
			write_data	: in STD_LOGIC_VECTOR (DATA_WIDTH-1 downto 0); 
			read_data1	: out STD_LOGIC_VECTOR (DATA_WIDTH-1 downto 0);
			read_data2	: out STD_LOGIC_VECTOR (DATA_WIDTH-1 downto 0));

end RegisterFile;

architecture Behavioral of RegisterFile is

	type Regs_T is array (size-1 downto 0) of STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
	signal Regfile : Regs_T := (others => (others =>'0'));

begin

	Regfile_Proc: process(clk, rst)
	begin
    	if  rst='1' then
			for i in 0 to size-1 loop
				Regfile(i) <= (others => '0');
			end loop;
		elsif rising_edge(clk) then
			if  RegWrite='1' then
				Regfile(to_integer(unsigned(write_register_addr)))<=write_data;
			end if;
		end if;
	end process  Regfile_Proc;

	read_data1 <= (others=>'0') when read_register1_addr="00000000"
         else Regfile(to_integer(unsigned(read_register1_addr)));
			
	read_data2 <= (others=>'0') when read_register2_addr="00000000"
         else Regfile(to_integer(unsigned(read_register2_addr)));

end Behavioral;

