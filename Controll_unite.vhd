
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity Controll_unite is
    Port ( 
	 -------top modele------

			nrst : in  STD_LOGIC;	-- reset signal
			clk : in  STD_LOGIC; --clock signal
         enb : in  STD_LOGIC;  --enble 
         vlve1 : out  STD_LOGIC; --valve 1 out
         vlve2 : out  STD_LOGIC;  --valve 2 out
         vlve3 : out  STD_LOGIC; -- valve 3 out
         vlve4 : out  STD_LOGIC;  -- valve4 out
         sytm_led1 : out  STD_LOGIC; -- sytm led 1 out
         sytm_led2 : out  STD_LOGIC; --sytm led 2 out
         moter_out : out  STD_LOGIC;  -- moter output
			
			  
	------ counter unite-------
			contrstrt :out STD_LOGIC ; --- counter strat
			counterFlg : in STD_LOGIC;
			counter_wr_enbl:out STD_LOGIC; --conter enble
				
	---- comparater--------------
	      cmprater_flag : in  STD_LOGIC;-- comprater flag in
			cmprter_enbl : out STD_LOGIC; -- enable comparater
			comprater_wr:out STD_LOGIC;--enble read and writ
				
	---- instruction register-----------
			ist_re_wrte : out  STD_LOGIC; -- instruction register write read enble
			opcode_in	: in STD_LOGIC_VECTOR(3 downto 0); -- opcode in
			Operand_in	: in STD_LOGIC_VECTOR (4 downto 0);	-- operand code in
				
	---- program counter-------
			pgmcnter_incmnt : out  STD_LOGIC;  -- progrm counter increemnt
			prgmcntr_in : out  STD_LOGIC_VECTOR(4 downto 0); -- program increemnt when jump state
			pclr : out STD_LOGIC;	--clear the program counter
			wr_enble_pc : out STD_LOGIC; -- write and read enable program couter
				
	--- temp register----
			temp_wr_enbl : out STD_LOGIC  -- write read enable tempeture register
			
			);
			  
end Controll_unite;

architecture Behavioral of Controll_unite is

-- Define the states 
type state_type is (inicize, Fetch, Decode, Execute,Sytm,Val,Motr,Goto,Set_tep,Set_time,Lord_tem,Lord_contr,Str_cntr,Temp_rd,Cmp,jmp);
	 
signal current_state, next_state : state_type;

-----------------------
	 signal wea : STD_LOGIC;
    signal pgmcntr_incmnt : STD_LOGIC;
    signal counterFlg_internal : STD_LOGIC;
--------------
begin
 --- define rst state
    process (clk, nrst)
    begin
        if nrst = '0' then
            current_state <= inicize;
            
        elsif rising_edge(clk) then
            -- Clock rising edge condition
            current_state <= next_state;
        end if;
 end process;
 
 
-- Define the FSM behavior
    process (current_state, enb,opcode_in,Operand_in,cmprater_flag,counterFlg)
	 
    begin
        case current_state is
		  

            when inicize =>
					if enb = '1' then
						wr_enble_pc <= '1';
						prgmcntr_in <= "00000";
						
                  next_state <= Fetch; -- go to  to Decode state
						  
					 else
					      next_state <= inicize; -- Stay in Idle state
                end if;
		-----------------------------               
            when Fetch => 
					 wea <= '0';
					 wr_enble_pc <= '0';
					 ist_re_wrte <= '1';
					 pgmcnter_incmnt <='0'; 
					 
				next_state <= Decode;			 
		----------------------------------			 	       
            when Decode =>
					ist_re_wrte <= '0';
					next_state <= Execute;
					
		-----------------------------------------
		
				when Execute =>
				case opcode_in is 
				when "1111" =>
				   next_state <= Sytm;---1
				when "1110" =>
					next_state <= Val;-- 13
				when "1101" =>
					next_state <= Motr;--2
				when "1100" =>
				   next_state <= Goto;--11
				when "1011" =>
				   next_state <= Set_tep; --8
				when "1010" =>
				   next_state <= Set_time;--5
				when "1001" =>
				   next_state <= Lord_tem;	--	6		
				when "1000" =>
				   next_state <= Lord_contr;----7
				when "0111" =>
				   next_state <= Str_cntr;---3
				when "0110" =>
				   next_state <= Temp_rd;--4
				when "0101" =>
					next_state <= Cmp;--9		
				when "0100" =>
					next_state <= Jmp;---10
				when others => 
					next_state <= Fetch;--12
	
					end case;
					
-------------------------------------------------------------------------------------------------------------------------------------					
				   when Sytm =>   --1
					case Operand_in is
						when "00001" =>
							sytm_led1 <= '1';
						when "00010" =>
							sytm_led2 <= '1';
						when others => 
						sytm_led1 <= '0';
						sytm_led2 <= '0';
					end case;
					
					pgmcnter_incmnt <='1';
					next_state <= Fetch;
					
-------------------------------------------------------------------------------------------------------------------------------------					
				   when Val =>   --13
					case Operand_in is
						when "01000" =>
							vlve1 <= '1';
							vlve2 <= '1';
							vlve3 <= '1';
						when "00111" =>
							vlve4 <= '1';
						when others => 
						vlve1 <= '1';
						vlve2 <= '1';
						vlve3 <= '1';
						vlve4 <= '1';
					end case;
					
					pgmcnter_incmnt <='1';
					next_state <= Fetch;
-------------------------------------------------------------------------------------------------------------------------------------					
					
					when Motr =>
					
					case Operand_in is
						when "00001" =>
							moter_out <= '1';
						when others => 
						moter_out <= '0';
					end case;
					pgmcnter_incmnt <='1';
					next_state <= Fetch;				
					
---------------------------------------------------------------------------------------------------------------------------------------
					when Str_cntr =>
					
					contrstrt <= '1';
					pgmcnter_incmnt <='1';
					next_state <= Fetch;
---------------------------------------------------------------------------------------------------------------------------------------
		
					when Temp_rd =>
					
					comprater_wr <= '1';
					pgmcnter_incmnt <='1';
					next_state <= Fetch;
---------------------------------------------------------------------------------------------------------------------------------------
					when Set_tep =>
					
					temp_wr_enbl <= '0';
					pgmcnter_incmnt <='1';
					next_state <= Fetch;
					
------------------------------------------------------------------------------------------------------------------------------------
					when Lord_tem =>
					comprater_wr <= '0';
					pgmcnter_incmnt <='1';
					next_state <= Fetch;
					
-----------------------------------------------------------------------------------------------------------------------------------
					when Lord_contr =>
					counter_wr_enbl <= '0';
					pgmcnter_incmnt <='1';
					next_state <= Fetch;
			
---------------------------------------------------------------------------------------------------------------------------------------
					when Set_time =>
					
					counter_wr_enbl <= '0';
					pgmcnter_incmnt <='1';
					next_state <= Fetch;
-------------------------------------------------------------------------------------------------------------------------------
					when Cmp =>
					
					cmprter_enbl <= '1';
					pgmcnter_incmnt <='1';
					comprater_wr <= '1';
					next_state <= Fetch;
					
---------------------------------------------------------------------------------------------------------------------------------------
					when Jmp =>
						case Operand_in is
								when "01101" =>
									if cmprater_flag = '1' then
										wr_enble_pc <= '1';
										prgmcntr_in <= "01101";
									else
										pgmcntr_incmnt <= '1';
									end if;

								when "10010" => 
									if counterFlg = '1' then
										wr_enble_pc <= '1';
										prgmcntr_in <= "10001";
									else
										pgmcntr_incmnt <= '1';
									end if;
								when others =>
									pgmcntr_incmnt <= '1';
							
							end case;
						next_state <= Fetch;

					
---------------------------------------------------------------------------------------------------------------------------------------
					when Goto =>
					
						wr_enble_pc <= '1';
						prgmcntr_in <= "10101";
						contrstrt <= '0';
						 next_state <= Fetch;
					

					
---------------------------------------------------------------------------------------------------------------------------------------	
				
            when others =>
                next_state <= inicize; -- Handle undefined state (optional)
        end case;
    end process;




end Behavioral;

