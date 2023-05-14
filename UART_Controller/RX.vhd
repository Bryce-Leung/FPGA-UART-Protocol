-- Project Group #11
-- Sahaj Singh Student#: 301437700
-- Bryce Leung Student#: 301421630 

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;    
USE IEEE.NUMERIC_STD.ALL;

-- Initialize entity and ports
ENTITY RX IS
	PORT(clk : IN STD_LOGIC;
		Reset : IN STD_LOGIC;
		RX_Data : IN STD_LOGIC;
		Baud_Rate : IN INTEGER;
		Data : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		Successfully_Received : OUT STD_LOGIC; 
		Running : OUT STD_LOGIC); 
END RX;


ARCHITECTURE RTL OF RX IS
	 -- Initialize State types 
	TYPE State_Type IS (Initialize, 
								Detect_Start, 
								Read_Bits,
								Baud_Wait,
								Parity_Check,
								Detect_Stop);
	SIGNAL Current_state, NSTATE : State_Type;

	 -- Signal counter to pace based on Baud rate
	SIGNAL Baud_Counter : INTEGER;
	SIGNAL Counter : INTEGER;
	--SIGNAL Counter_Reset : STD_LOGIC := '0';

	 -- Signals that takes data recieved and will be outputted to memory 
	SIGNAL Data_Temp_Register : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL Recieved_Validated : STD_LOGIC;
	SIGNAL Parity_Good, Checked : STD_LOGIC := '0';
	SIGNAL Start : STD_LOGIC := '0';
	SIGNAL Previous_Packet : std_logic_vector(7 downto 0) := (OTHERS => '0');
	
	shared variable Counter_Reset : STD_LOGIC := '0';

BEGIN	 
	 -- Process to move through states reading the data received
	PROCESS(clk, Counter, Baud_Rate)
		VARIABLE indexed : INTEGER RANGE 0 TO 8 := 0;
		VARIABLE one_bit_counter : STD_LOGIC_VECTOR (3 DOWNTO 0) := "0000";
	BEGIN
		Baud_Counter <= (50000000)/Baud_Rate; -- update the baud rate when the input rate has been changed 
		if(RISING_EDGE(clk)) then
			-- counter for the delay needed to match the associated Baud rate
			-- Resets the counter
			IF(Counter_Reset = '1') THEN
				Counter <= 0;
			ELSE -- If no reset is detected, the counter continues to increment
				Counter <= Counter + 1;
			END IF;
			 -- Reset the current state
			IF(Reset = '1') THEN
				Current_state <= Initialize;
			ELSE
				Counter_Reset := '0';

				CASE Current_state IS
					 -- State iniailized all variables 
					WHEN Initialize =>
						 -- Clear the register and reset signals and variables
						Data_Temp_Register <= (OTHERS => '0');
						indexed := 0;
						one_bit_counter := "0000";
						Running <= '0';
						Parity_Good <= '0';
						Checked <= '0';
						--Counter_Reset := '1';
						Recieved_Validated <= '0';
						
						IF(RX_Data = '1') THEN
							Start <= '0';
						END IF;

						 -- Check checks to see if the start bit has been sent to the receiver
						IF(Start = '0') THEN
							IF(RX_Data = '0' AND Start = '0') THEN
								Counter_Reset := '1';
								Current_state <= Detect_Start;
							END IF;
						END IF;

					 -- State waits for the required time to match Baud rate before moving onto reading to the register	
					WHEN Detect_Start =>
						Running <= '1';
						Start <= '1';
						 -- Wait until counter reaches the required calculated value to for associated Baud rate
						
						IF(Counter = (Baud_Counter - 1)) THEN
							Counter_Reset := '1';
							Current_state <= Read_Bits;
						END IF ;

					 -- State that takes the incoming data after the start bit and places it into respective part of the register
					WHEN Read_Bits => 
						 -- Checks if all positions in the register have been filled
						IF(indexed < 8) THEN
							IF(Counter = (Baud_Counter - 1)/2) THEN
								 -- Adds to the 1s counter if the input is 1
								IF(RX_Data = '1') THEN
									one_bit_counter := STD_LOGIC_VECTOR(UNSIGNED(one_bit_counter) + 1);
								END IF;
								Data_Temp_Register(indexed) <= RX_Data;
								Running <= '1';
								Current_state <= Baud_Wait;
							END IF;
						ELSE
							Current_state <= Parity_Check;
						END IF;

					 -- State that waits until the counter reaches the required calculated value to for associated Baud rate
					WHEN Baud_Wait =>
						IF(Counter = (Baud_Counter - 1)) THEN
							Counter_Reset := '1';
							indexed := indexed + 1;
							Current_state <= Read_Bits;
						END IF;

					 -- State that obtains the parity bit and checks if data obtained matches the characteristics for the number of 1s 
					WHEN Parity_Check =>
						IF(Counter = (Baud_Counter - 1)/2) THEN
							IF(Checked = '0') THEN
								IF((RX_Data = '1')) THEN
									IF(one_bit_counter(0) = '1') THEN
										Parity_Good <= '1';
									ELSE
										Parity_Good <= '0';
									END IF;
								ELSIF((RX_Data = '0')) THEN
									IF(one_bit_counter(0) = '0') THEN
										Parity_Good <= '1';
									ELSE
										Parity_Good <= '0';
									END IF;
								ELSE
									Parity_Good <= '0';
								END IF;
							END IF;
							Checked <= '1';
						END IF;
						IF(Counter = (Baud_Counter - 1)) THEN
							Counter_Reset := '1';
							Current_state <= Detect_Stop;
						END IF ;
					
						
					 -- State waits for the required time to match Baud rate before moving back to the idle initialization state
					WHEN Detect_Stop => 
						Running <= '1';
						
						IF(Counter = (Baud_Counter - 1)/2) THEN
							 -- Checks if the closing bit is sent and the data based on the parity bit is correct
							IF(RX_Data = '1' AND Parity_Good = '1') THEN
								Recieved_Validated <= '1';
								Previous_Packet <= Data_Temp_Register;
								Start <= '0';
								
							END IF;
						END IF;
			
						IF(Counter = (Baud_Counter - 1)) THEN
							Running <= '0';
							Counter_Reset := '1';
							Current_state <= Initialize;
						END IF ;
				END CASE;
			END IF;
		END IF;
	END PROCESS;


	-- Process that outputs the data recieved depending on whether the new message was succesfuly recieved with no errors
	PROCESS(Recieved_Validated, Data_Temp_Register, Previous_Packet)
	BEGIN
			if(Recieved_Validated = '1') then
				Data <= Data_Temp_Register;
				Successfully_Received <= '1';
			else -- If the transmitted message was found to contain an error the message does not get accepted and the pervious one stands
				Successfully_Received <= '0';
				Data <= Previous_Packet;
			end if ;
	END PROCESS;

END ARCHITECTURE RTL;
