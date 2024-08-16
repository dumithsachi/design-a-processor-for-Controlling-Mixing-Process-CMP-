----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:02:40 12/19/2023 
-- Design Name: 
-- Module Name:    temp_regstr - Behavioral 
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity temp_regstr is
    Port (  temp_in : in  STD_LOGIC_VECTOR(5 downto 0);
				clk : in  STD_LOGIC;
				wrt : in STD_LOGIC;
				temp_out : out  STD_LOGIC_VECTOR(5 downto 0));
end temp_regstr;

architecture Behavioral of temp_regstr is
		signal tempregistr_data : STD_LOGIC_VECTOR(5 downto 0);

begin

process(clk)
	begin 
		if rising_edge(clk) then
			if wrt = '1' then
				tempregistr_data <= temp_in;
			else
				temp_out <= tempregistr_data;
			end if;
		end if;
end process;


end Behavioral;

