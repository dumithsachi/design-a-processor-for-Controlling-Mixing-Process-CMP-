library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity CountdownTimer is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           start : in STD_LOGIC;
           timer_value : in STD_LOGIC_VECTOR(5 downto 0);
           timeout : out STD_LOGIC;   --Signal indicating if the countdown has reached zero
           time_out : out STD_LOGIC_VECTOR(5 downto 0));--Output signal representing the current countdown value
end CountdownTimer;

architecture Behavioral of CountdownTimer is
    signal count : STD_LOGIC_VECTOR(5 downto 0) := (others => '0');
    signal counting : BOOLEAN := FALSE;
begin
    process(clk, reset)
    begin
        if reset = '1' then
            count <= (others => '0');
            counting <= FALSE;
        elsif rising_edge(clk) then
            if start = '1' then
                counting <= TRUE;
                count <= timer_value;
            elsif counting = TRUE then
                if count = "000000" then
                    counting <= FALSE;
                else
                    count <= count - "000001";
                end if;
            end if;
        end if;
    end process;

    timeout <= '1' when count = "000000" else '0';
    time_out <= count;

end Behavioral;
