-- Project Group #11
-- Sahaj Singh Student#: 301437700
-- Bryce Leung Student#: 301421630 

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;    
USE IEEE.NUMERIC_STD.ALL;

 -- Initialize entity and ports
ENTITY TX IS
	port(clk : IN STD_LOGIC;
		Reset : IN STD_LOGIC;
		Start : IN STD_LOGIC;
		Baud_Rate : IN INTEGER;
		Data : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		Done : OUT STD_LOGIC;
		Running : OUT STD_LOGIC;
		TX_Data : OUT STD_LOGIC);
END TX;


ARCHITECTURE RTL OF TX IS
	 -- Initialize State types 
	TYPE State_Type IS (Initialize, 
								Transmit_Start, 
								Send_Bits,
								Baud_Wait,
								Send_Parity,
								Transmit_Stop);
	SIGNAL Current_state : State_Type := Initialize;

	 -- Signal counter to pace based on Baud rate
	SIGNAL Baud_Counter : INTEGER;
	SIGNAL Counter : INTEGER;
	SIGNAL Counter_Reset : STD_LOGIC;

	 -- Signals that takes data that will be transmitted
	SIGNAL Data_Temp_Register : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL Checked, Complete : STD_LOGIC := '0';

BEGIN

	Data_Temp_Register <= Data;
	Done <= Complete;
	
	 -- Process to move through states transmitting the packet containing the data
	PROCESS(clk, Current_state, Counter, Start, Baud_Rate)
	VARIABLE indexed : INTEGER RANGE 0 TO 8 := 0;
	VARIABLE one_bit_counter : STD_LOGIC_VECTOR (3 DOWNTO 0) := "0000";
	BEGIN
		Baud_Counter <= (50000000)/Baud_Rate; -- update the baud rate when the input rate has been changed 
		IF(RISING_EDGE(clk)) THEN
			-- counter for the delay needed to match the associated Baud rate
			-- Resets the counter
			IF(Counter_Reset = '1') THEN
				Counter <= 0;
			ELSE -- If no reset is detected, the counter continues to increment
				Counter <= Counter + 1;
			END IF;
			-- Reset the current state
			IF (Reset = '1') THEN
				Current_state <= Initialize;
			ELSE
				Counter_Reset <= '0';
				CASE Current_state IS
					 -- State iniailized all variables 
					WHEN Initialize =>
						 -- The base line value outputted from the transmitter before the starting drop to 0 happens
						 -- Reset variables
						one_bit_counter := "0000";
						TX_Data <= '1';
						indexed := 0;
						Running <= '0';
						Checked <= '0';
						Counter_Reset <= '1';
						
						 -- Begins the transmission of data once the start flag has been set to start
						IF(Start = '1' AND Complete = '0') THEN
							Current_state <= Transmit_Start;
						ELSIF(Start = '0' AND Complete = '1') THEN
							 Complete <= '0';
						END IF;
						
					 -- State that begins the transmission by outputting the starting bit to indicate the beginnning of packet transfer
					WHEN Transmit_Start =>
						TX_Data <= '0';
						Running <= '1';
						
						 -- Wait until counter reaches the required calculated value to for associated Baud rate
						IF(Counter = (Baud_Counter - 1)) THEN
							Counter_Reset <= '1';
							Current_state <= Send_Bits ;
						END IF ;

					 -- State that takes the data from the register storing the data to send and outputs it
					WHEN Send_Bits =>
						 -- Checks if all positions in the register have been transmitted
						IF(indexed < 8) THEN
							TX_Data <= Data_Temp_Register(indexed);
							IF(Data_Temp_Register(indexed) = '1') THEN
								one_bit_counter := STD_LOGIC_VECTOR(UNSIGNED(one_bit_counter) + 1);
							END IF;
							Running <= '1';
							Current_state <= Baud_Wait;
						ELSE
							Counter_Reset <= '1';
							Current_state <= Send_Parity;
						END IF;

					 -- State that waits until the counter reaches the required calculated value to for associated Baud rate
					WHEN Baud_Wait =>
						IF(Counter = (Baud_Counter - 1)) THEN
							Counter_Reset <= '1';
							indexed := indexed + 1;
							Current_state <= Send_Bits;
						END IF;

					 -- State that sends the parity bit
					WHEN Send_Parity =>
						IF(Checked = '0') THEN
							 -- Sends a parity bit based on the number of 1s in the data sent
							IF(one_bit_counter(0) = '1') THEN
								TX_Data <= '1';
							ELSE
								TX_Data <= '0';
							END IF;
						END IF;
						Checked <= '1';
						IF(Counter = (Baud_Counter - 1)) THEN
							Counter_Reset <= '1';
							Current_state <= Transmit_Stop;
						END IF;
						
					 -- State that sends the stop bit 
					WHEN Transmit_Stop => 
						TX_Data <= '1';
						Running <= '1';
						IF(Counter = (Baud_Counter - 1)) THEN
							Counter_Reset <= '1';
							Current_state <= Initialize;
							Complete <= '1';
							Running <= '0';
						END IF;
				END CASE;
			END IF;
		END IF;
	END PROCESS;
END ARCHITECTURE RTL;
