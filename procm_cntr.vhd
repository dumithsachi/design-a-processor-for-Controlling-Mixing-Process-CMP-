library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity procm_cntr is
    Port (
        clk   : in  STD_LOGIC;
        inc_pc: in  STD_LOGIC;
        cler  : in  STD_LOGIC;
        wrt_p : in  STD_LOGIC;
        prc_in: in  STD_LOGIC_VECTOR(4 downto 0);
        prc_out: out STD_LOGIC_VECTOR(4 downto 0)
    );
end procm_cntr;

architecture Behavioral of procm_cntr is
    signal progrmcounter_out: STD_LOGIC_VECTOR(4 downto 0) := "00000";
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if cler = '1' then
                progrmcounter_out <= "00000";
            elsif inc_pc = '1' then
                progrmcounter_out <= (others => '0') & '1';  -- Increment by 1
            end if;
            if wrt_p = '1' then
                progrmcounter_out <= prc_in;
            end if;
        end if;
    end process;
	 prc_out <= progrmcounter_out;
end Behavioral;
