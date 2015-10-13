----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:31:11 10/07/2015 
-- Design Name: 
-- Module Name:    DataMemory - Behavioral 
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

entity DataMemory is

	 generic (
	 		 ADDR_WIDTH : integer := 8;
		    DATA_WIDTH : integer := 32;
		    size : natural := 1024);
	 
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           data_in : in  STD_LOGIC_VECTOR (DATA_WIDTH-1 downto 0);
           data_out : out  STD_LOGIC_VECTOR (DATA_WIDTH-1 downto 0);
           write_address : in  STD_LOGIC_VECTOR (ADDR_WIDTH-1 downto 0);
           read_address : in  STD_LOGIC_VECTOR (ADDR_WIDTH-1 downto 0);
           MemWrite : in  STD_LOGIC);
end DataMemory;

architecture Behavioral of DataMemory is

type Mem_T is array (size-1 downto 0) of STD_LOGIC_VECTOR (DATA_WIDTH-1 downto 0);
signal Data_mem : Mem_T := (others => (others => '0'));
signal address_reg :	STD_LOGIC_VECTOR (ADDR_WIDTH-1 downto 0);

begin

	Datamem_Proc: process(clk, rst)
	begin	
		if (rst = '1') then 
			for i in 0 to size-1 loop
				Data_mem(i) <= (others => '0');
			end loop;
		elsif rising_edge (clk) then
			if MemWrite='1' then
				Data_mem(to_integer(unsigned( write_address((ADDR_WIDTH-1) downto 0) ))) <= data_in;
			end if;
			address_reg <= read_address;
		end if;

		data_out <= Data_mem(to_integer(unsigned( address_reg ((ADDR_WIDTH-1) downto 0) )));

	end process Datamem_Proc;

end Behavioral;

