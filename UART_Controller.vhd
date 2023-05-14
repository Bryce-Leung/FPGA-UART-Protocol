-- Project Group #11
-- Sahaj Singh Student#: 301437700
-- Bryce Leung Student#: 301421630 

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

 -- Initialize entity and ports
ENTITY UART_Controller IS
	PORT(CLOCK_50 : IN STD_LOGIC;
			KEY : IN STD_LOGIC_Vector(3 DOWNTO 0);
			SW : IN STD_LOGIC_VECTOR(17 DOWNTO 0);
			LEDR : OUT STD_LOGIC_VECTOR(17 DOWNTO 0) := (OTHERS => '0');
			LEDG : OUT STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0');
			UART_CTS : OUT STD_LOGIC;
			UART_RTS : IN STD_LOGIC;
			UART_TXD : OUT STD_LOGIC;
			UART_RXD : IN STD_LOGIC);
END UART_Controller;

ARCHITECTURE RTL OF UART_Controller IS

	 -- Call component debouncer
	COMPONENT debouncer IS
		GENERIC(
			Timeout_Cycles : POSITIVE);
		PORT(
			CLK               : IN STD_LOGIC;
			Reset               : IN STD_LOGIC;
			Button            : IN STD_LOGIC;
			Button_Debounced  : OUT STD_LOGIC);
	END COMPONENT;

	 -- Call component TX
	COMPONENT TX IS
		port(clk : IN STD_LOGIC;
			Reset : IN STD_LOGIC;
			Start : IN STD_LOGIC;
			Baud_Rate : IN INTEGER;
			Data : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
			Done : OUT STD_LOGIC;
			Running : OUT STD_LOGIC;
			TX_Data : OUT STD_LOGIC);
	END COMPONENT;

	 -- Call component RX
	COMPONENT RX IS 
		PORT(clk : IN STD_LOGIC;
			Reset : IN STD_LOGIC;
			RX_Data : IN STD_LOGIC;
			Baud_Rate : IN INTEGER;
			Data : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
			Successfully_Received : OUT STD_LOGIC;
			Running : OUT STD_LOGIC);
	END COMPONENT;
	
	 -- Initialize State types 
	TYPE State_Type IS (Idle,
								Transmitting,
								Receiving
								);
	SIGNAL Current_state, NSTATE : State_Type;
		
	 -- Initialize signals
	SIGNAL Slow_CLK_Start, Slow_CLK_Baud_Rate : STD_LOGIC;
	SIGNAL Reset, Start, Idling, Baud_Load, Running_TX, Running_RX, Transfer_Successful, Done : STD_LOGIC := '0';
	SIGNAL Data_Send_Buffer, Data_Recieved_Buffer, LEDR_Buffer : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL Baud_Rate : INTEGER := 9600;
	SIGNAL Recieve_Bits : STD_LOGIC := '1';
	SIGNAL CTS_Status : STD_LOGIC := '0';
	SIGNAL Start_Condition : STD_LOGIC := '0';
	SIGNAL ButtonIn1, ButtonIn2 : STD_LOGIC;
	
BEGIN
	-- PORT MAP:
	-- Port map TX component
	obj0: TX PORT MAP (CLOCK_50, Reset, Start, Baud_Rate, Data_Send_Buffer, Done, Running_TX, UART_TXD);
	
	-- Port map RX component
	obj1: RX PORT MAP (CLOCK_50, Reset, Recieve_Bits, Baud_Rate, Data_Recieved_Buffer, Transfer_Successful, Running_RX);

	-- Port map start button debouncer
	debounce0: debouncer GENERIC MAP (50) PORT MAP (CLOCK_50, Reset, ButtonIn1, Slow_CLK_Start);

	-- Port map Baud rate loading button debouncer
	debounce1: debouncer GENERIC MAP (50) PORT MAP (CLOCK_50, Reset, ButtonIn2, Slow_CLK_Baud_Rate);
	
	
	-- LINKING SWITCHES:
	-- Link the reset flag to key(3)
	Reset <= NOT(KEY(3));
	
	-- Link the start flag to key(0) 
	Start <= Slow_CLK_Start;
	
	-- Link the Baud rate loading to key(1)
	Baud_Load <= Slow_CLK_Baud_Rate;
	
	
	-- LINKING LEDS:
	-- Link the LEDG(7) to the transfer successful status
	LEDG(7) <= Transfer_Successful;
	
	-- Link the LEDG(6) to indicate that RX is running
	LEDG(6) <= Running_RX;
	
	-- Link the LEDG(3) to indicate that TX is running
	LEDG(3) <= Running_TX;

	-- Link the LEDG(4) to indicate that TX is Done
	LEDG(4) <= Done;
		
	-- Link LEDG(0) to indicate that the device is currently in the idle state
	LEDG(0) <= Idling;
	
	-- Link LEDR(7 downto 0) to display the recieved message from UART
	LEDR(7 DOWNTO 0) <= LEDR_Buffer;
	
	
	Recieve_Bits <= NOT(UART_RXD);
	
	UART_CTS <= CTS_Status;
	
	ButtonIn1 <= NOT(KEY(0));
	
	ButtonIn2 <= NOT(KEY(1));
	
	 -- Process controls whether the device will transmit or recieve data
	PROCESS(Start, Reset, Done, Baud_Load, CLOCK_50, Data_Recieved_Buffer)
	BEGIN
		-- If the reset button is pressed the Baud rate returns to default 9600 Baud and returns to idle state
		IF(Reset = '1') THEN
			Current_state <= Idle;
			LEDR_Buffer <= (OTHERS => '0');
			Baud_Rate <= 9600;
		ELSE
			IF(RISING_EDGE(CLOCK_50)) THEN
				CASE Current_state IS 					
					 -- State that the device stays in while no transmission or reception is being performed
					WHEN Idle =>
						Idling <= '1';
						
						  -- Link the switches to the data to transmit buffer
						Data_Send_Buffer <= SW(7 DOWNTO 0);
						
						 -- When the set Baud rate button has been pressed the value from the switches are accepted as the new rate
					   IF(Baud_Load = '1') THEN
							Baud_Rate <= TO_INTEGER(UNSIGNED(SW(17 DOWNTO 0)));
						END IF;
					
						-- Checks if a start signal to transmit or a start receiving bit has been detected
						IF(Start_Condition = '1') THEN
							Idling <= '0';
							Current_state <= Transmitting;
						ELSIF(Recieve_Bits = '0') THEN
							Idling <= '0';
							Current_state <= Receiving;
						END IF;
						
					 -- State that waits until TX us done recieing
					WHEN Transmitting =>
						-- Returns to idle state when the TX's done flag is sent
						IF(Done = '1') THEN
							Current_state <= Idle;
						END IF;
						
						-- Only start transmission when CTS_Status is '1' and UART_RTS is '1'
						IF(CTS_Status = '1' AND UART_RTS = '1') THEN
							Start_Condition <= '1';
						ELSE
							Start_Condition <= '0';
						END IF;

					 -- State that waits until RX is done recieving
					WHEN Receiving =>
						IF(Transfer_Successful = '1') THEN
							LEDR_Buffer <= Data_Recieved_Buffer;
						END IF;
						
						-- Set CTS_Status to '1' when the receiver is ready to receive data
						IF(Running_RX = '0') THEN
							CTS_Status <= '1';
							Current_state <= Idle;
						ELSE
							CTS_Status <= '0';
						END IF;
						
				END CASE;
			END IF;
		END IF;
	END PROCESS;
	
	
END RTL;