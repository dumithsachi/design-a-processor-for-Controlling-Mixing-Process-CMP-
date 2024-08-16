----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:54:13 12/19/2023 
-- Design Name: 
-- Module Name:    Top_model - Behavioral 
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

entity Top_model is

    Port ( clk : in  STD_LOGIC;
				nrst_in: in STD_LOGIC;
           temp_in_reg : in  STD_LOGIC_VECTOR(5 downto 0);
			  enble: in STD_LOGIC;
			  temp_sensor_input : in STD_LOGIC_VECTOR(5 downto 0);
           time_in_user : in  STD_LOGIC_VECTOR(5 downto 0);
           vlve1_out : out  STD_LOGIC_VECTOR(5 downto 0);
           vlve2_out : out  STD_LOGIC_VECTOR(5 downto 0);
           vlve3_out : out  STD_LOGIC_VECTOR(5 downto 0);
           vlve4_out : out  STD_LOGIC_VECTOR(5 downto 0);
           sytm_le1_out : out  STD_LOGIC_VECTOR(5 downto 0);
			  moter_out : out  STD_LOGIC_VECTOR(5 downto 0);
           sytm_led2_out : out  STD_LOGIC_VECTOR(5 downto 0));
end Top_model;

architecture Behavioral of Top_model is

----component declar


COMPONENT Controll_unite is
	 Port ( 
	 -------top modele------
			nrst : in  STD_LOGIC;	-- reset signal
			clk : in  STD_LOGIC; --clock signal
         enbl : in  STD_LOGIC;  --enble 
         vlve1 : out  STD_LOGIC_VECTOR(5 downto 0); --valve 1 out
         vlve2 : out  STD_LOGIC_VECTOR(5 downto 0); --valve 2 out
         vlve3 : out  STD_LOGIC_VECTOR(5 downto 0); -- valve 3 out
         vlve4 : out  STD_LOGIC_VECTOR(5 downto 0);  -- valve4 out
         sytm_led1 : out  STD_LOGIC_VECTOR(5 downto 0); -- sytm led 1 out
         sytm_led2 : out  STD_LOGIC_VECTOR(5 downto 0); --sytm led 2 out
         moter_out : out  STD_LOGIC_VECTOR(5 downto 0);  -- moter output
			  
	------ counter unite-------
			contrstrt :out STD_LOGIC ; --- counter strat
			counterFlg : in STD_LOGIC_VECTOR(4 downto 0);
				
	---- comparater--------------
	      cmprater_flag : in  STD_LOGIC;-- comprater flag in
			cmprter_enbl : out STD_LOGIC; -- enable comparater
				
	---- instruction register-----------
			ist_re_wrte : out  STD_LOGIC; -- instruction register write read enble
			opcode_in	: in STD_LOGIC_VECTOR(3 downto 0); -- opcode in
			Operand_in	: in STD_LOGIC_VECTOR (4 downto 0);	-- operand code in
				
	---- program counter-------
			pgmcnter_incmnt : out  STD_LOGIC;  -- progrm counter increemnt
			prgmcntr_in : out  STD_LOGIC_vector(3 downto 0); -- program increemnt when jump state
			pclr : out STD_LOGIC;	--clear the program counter
			wr_enble : out STD_LOGIC; -- write and read enable program couter
				
	--- temp register----
			temp_wr_enbl : out STD_LOGIC  -- write read enable tempeture register
			
			);
	
end COMPONENT Controll_unite;
	
	

COMPONENT Ramblock is
	port(
			dina: in STD_LOGIC_VECTOR ( 8 downto 0);
			addra: in STD_LOGIC_VECTOR ( 4 downto 0);
			clka : in STD_LOGIC;
			wea : in STD_LOGIC_VECTOR ( 1 downto 0);
			dout : out STD_LOGIC_VECTOR ( 8 downto 0));
			
	end COMPONENT Ramblock;
	
	
COMPONENT temp_regstr is
	port(
				temp_in : in  STD_LOGIC_VECTOR(5 downto 0);
				clk : in  STD_LOGIC;
				wrt : in STD_LOGIC;
				temp_out : out  STD_LOGIC_VECTOR(5 downto 0)
	);
	
	end COMPONENT temp_regstr;
	
COMPONENT procm_cntr is
 Port ( clk : in  STD_LOGIC;
           inc_pc : in  STD_LOGIC;
			  cler :	in STD_LOGIC;
			  wrt_p	: in STD_LOGIC;
           prc_in : in  STD_LOGIC_VECTOR(4 downto 0);
           prc_out :out  STD_LOGIC_VECTOR(4 downto 0));
			  
end COMPONENT procm_cntr;

COMPONENT instrction_reg is

 Port ( blckrm_out : in  STD_LOGIC_VECTOR(8 downto 0);
           clk : in 	STD_LOGIC;
           wrtenb_i : in STD_LOGIC;
           --prc_out : in  STD_LOGIC_VECTOR(3 downto 0);
           operand_i : out  STD_LOGIC_VECTOR(4 downto 0);
			  opcode_i :out STD_LOGIC_VECTOR(4 downto 0)
			  );
end COMPONENT instrction_reg;

COMPONENT comparator is
Port ( tem_r_in : in  STD_LOGIC_VECTOR(5 downto 0);
           tem_s_in : in  STD_LOGIC_VECTOR(5 downto 0);
			  cmp_enbl : in STD_LOGIC;
           flg : out  STD_LOGIC);
end COMPONENT comparator;

COMPONENT CountdownTimer is
Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           start : in STD_LOGIC;
           timer_value : in STD_LOGIC_VECTOR(5 downto 0);
           timeout : out STD_LOGIC;   --Signal indicating if the countdown has reached zero
           time_out : out STD_LOGIC_VECTOR(5 downto 0));--Output signal representing the current countdown value
end COMPONENT CountdownTimer;

-- end component---


-----2023-12-22 signal map-------
---block ram-------
signal wr_enbl_br : std_logic_vector(1 downto 0); --- write and read enable block ram
signal addrss_br : std_logic_vector(4 downto 0); --- set addrees to block ram
signal nouse : std_logic_vector (4 downto 0);  --- data in to the block ram
signal ram_out : std_logic_vector ( 8 downto 0); --- data out from the block ram


---- signal comparater -----------

signal tem_re_in :std_logic_vector ( 4 downto 0);  -- temprature value in to comparater from temp regster
signal tem_se_in : std_logic_vector ( 4 downto 0); --- temprature value in to comparater from sensor
signal com_enble : std_logic; --- enble comparater froon control unite
signal cm_flg : std_logic; --- flag from the comprater to control unite

---- temprature register signal ------

signal wr_enb_tr :std_logic; --- write read enable temprature register

---- program counter signal-------------

signal incremnt_pc : std_logic; --- incremnt the program counter
signal cleare : std_logic; ---- clear the program countr
signal wr_pc : std_logic; ---- write read enble program counter
signal input_pc : std_logic_vector(3 downto 0); --- input addres to the program counter

----- instruction register port map------------

signal wr_intr_re :std_logic; ---- write and read anable instruction register
signal opcode_ir : std_logic_vector( 3 downto 0);
signal operend_ir : std_logic_vector( 4 downto 0);

------countdown timer signal ------

signal rest_time :std_logic; ---reset the counter
signal strt_time:std_logic; ---- strat the counter
signal show_time : std_logic;
signal counter_flag: std_logic_vector(4 downto 0);

--- signal control unite-----

begin

ControllUnite : Controll_unite port map(


	 -------top modele------
			nrst => nrst_in,
			clk => clk,
         enbl => enble,
         vlve1 => vlve1_out,
         vlve2 => vlve2_out,
         vlve3 => vlve3_out,
         vlve4 => vlve4_out,
         sytm_led1 => sytm_le1_out,
         sytm_led2 => sytm_led2_out,
         moter_out => moter_out ,	
			
	------ counter unite-------
			
			contrstrt => strt_time,
			counterFlg => counter_flag,
				
	---- comparater--------------
	      cmprater_flag => cm_flg,
			cmprter_enbl => com_enble ,
				
	---- instruction register-----------
			ist_re_wrte => wr_intr_re,
			opcode_in	=> opcode_ir,
			Operand_in	=> operend_ir,
				
	---- program counter-------
			pgmcnter_incmnt => incremnt_pc,
			prgmcntr_in => input_pc,
			pclr => cleare,
			wr_enble => wr_pc ,
			
				
	--- temp register----
			temp_wr_enbl => wr_enb_tr

			);

counter : CountdownTimer port map(
			
			  clk => clk,
           reset => rest_time,
           start => strt_time,
           timer_value => time_in_user,
           timeout => show_time,
           time_out => counter_flag
			  );


Instrction_register : instrction_reg port map(

			blckrm_out => ram_out,
         clk => clk,
         wrtenb_i => wr_intr_re,
         opcode_i => opcode_ir ,
         operand_i => operend_ir
		);	
		
bram : Ramblock port map (
        clka => clk,
        wea => wr_enbl_br,
        addra => addrss_br,
        dina => nouse,
        dout => ram_out
    );
Compartr: comparator port map (
	
			tem_r_in => tem_re_in,
			tem_s_in => tem_se_in,
			cmp_enbl => com_enble,
			flg => cm_flg 
			
	);	
Temp_Registr :temp_regstr port map(

			temp_in => temp_in_reg,
			clk => clk,
			wrt => wr_enb_tr,
			temp_out => tem_re_in
			
		);		
Program_counter :procm_cntr port map(
			  clk => clk,
           inc_pc => incremnt_pc ,
			  cler => cleare ,
			  wrt_p => wr_pc,
           prc_in => input_pc,
           prc_out => addrss_br
		);			


end Behavioral;

