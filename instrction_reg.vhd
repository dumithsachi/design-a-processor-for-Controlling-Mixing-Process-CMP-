library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity instrction_reg is
    Port ( blckrm_out : in  STD_LOGIC_VECTOR(8 downto 0);
           clk : in 	STD_LOGIC;
           wrtenb_i : in STD_LOGIC;
           opcode_i : out  STD_LOGIC_VECTOR(3 downto 0);
           operand_i : out  STD_LOGIC_VECTOR(4 downto 0)
			  );
end instrction_reg;

architecture Behavioral of instrction_reg is
    signal instruction_out : STD_LOGIC_VECTOR(8 downto 0);
	 
    
begin
    process (clk)
    begin
        if rising_edge(clk) then
            if wrtenb_i = '1' then
                instruction_out <= blckrm_out;
					 opcode_i <= (others => '0');
                operand_i<= (others => '0');
            else
                opcode_i <= blckrm_out(8 downto 5);
                operand_i<= blckrm_out(4 downto 0);
            end if;
        end if;
    end process;
end Behavioral;
