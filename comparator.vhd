----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:56:22 12/19/2023 
-- Design Name: 
-- Module Name:    comparator - Behavioral 
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity comparator is
    Port ( tem_r_in : in  STD_LOGIC_VECTOR(5 downto 0);
           tem_s_in : in  STD_LOGIC_VECTOR(5 downto 0);
			  comprater_wr: in STD_LOGIC;
			  cmp_enbl : in STD_LOGIC;
           flg : out  STD_LOGIC);
end comparator;

architecture Behavioral of comparator is

begin
	process(tem_r_in,tem_s_in,cmp_enbl)
		begin
			if cmp_enbl = '1' then
				if tem_s_in > tem_r_in then
						flg <= '1';
				else 
						flg <='0';
				end if;
			else
				flg <= '0';
			end if;
		end process;

end Behavioral;

