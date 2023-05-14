-- Project Group #11
-- Sahaj Singh Student#: 301437700
-- Bryce Leung Student#: 301421630 

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;    
USE IEEE.NUMERIC_STD.ALL;

ENTITY tb_RX IS
END tb_RX;

ARCHITECTURE test OF tb_RX IS 
 -- Call component RX
COMPONENT RX
	PORT(
		clk : IN STD_LOGIC;
		Reset :IN STD_LOGIC;
		RX_Data : IN STD_LOGIC;
		Baud_Rate : IN INTEGER;
		Data : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		Successfully_Received : OUT STD_LOGIC;
		Running : OUT STD_LOGIC);  -- When RX is running and recieving the data
END COMPONENT;

	 -- Initialize signals
	CONSTANT PERIOD : TIME := 5 ns;
	SIGNAL tb_clk : STD_LOGIC := '0';
	SIGNAL tb_reset : STD_LOGIC := '1';
	signal tb_RX_Data : STD_LOGIC := '0';
	SIGNAL tb_Baud_Rate : INTEGER := 115200;
	SIGNAL tb_Data : STD_LOGIC_VECTOR(7 DOWNTO 0);
	signal tb_Successfully_Received : std_logic;
	SIGNAL tb_Running : STD_LOGIC;

BEGIN
	 -- Waiting durations : ((434*2)+1) * PERIOD ns
	 -- Port map the RX component
	DUT: RX 
	PORT MAP (tb_clk, tb_reset, tb_RX_Data, tb_Baud_Rate, tb_Data, tb_Successfully_Received, tb_Running);


	 -- Setting the clock to toggle after the set period
	tb_clk <= not(tb_clk) AFTER PERIOD;

	 -- Initialization reset
	tb_reset <= '1', '0' AFTER 400 ns;
	
	PROCESS IS
	BEGIN
		 -- Stabilize input signal to 1 before starting first transmission
		tb_RX_Data <= '1';
		WAIT FOR 5000 ns;	
		 -- Send first packet (Correct)
		tb_RX_Data <= '0'; -- Start Bit
		WAIT FOR 869  * PERIOD;
		tb_RX_Data <= '0'; -- Bit 0
		WAIT FOR 869  * PERIOD;
		tb_RX_Data <= '1'; -- Bit 1
		WAIT FOR 869  * PERIOD;
		tb_RX_Data <= '0'; -- Bit 2
		WAIT FOR 869  * PERIOD;
		tb_RX_Data <= '1'; -- Bit 3
		WAIT FOR 869  * PERIOD;
		tb_RX_Data <= '0'; -- Bit 4
		WAIT FOR 869  * PERIOD;
		tb_RX_Data <= '1'; -- Bit 5
		WAIT FOR 869  * PERIOD;
		tb_RX_Data <= '0'; -- Bit 6
		WAIT FOR 869  * PERIOD;
		tb_RX_Data <= '0'; -- Bit 7
		WAIT FOR 869  * PERIOD;
		tb_RX_Data <= '1'; -- Parity Bit 
		WAIT FOR 869  * PERIOD;
		tb_RX_Data <= '1'; -- Stop Bit
		WAIT FOR 869  * PERIOD;
		WAIT FOR 5000 ns;
		
		 -- Send Second packet (Correct)
		tb_RX_Data <= '0'; -- Start Bit
		WAIT FOR 869  * PERIOD;
		tb_RX_Data <= '0'; -- Bit 0
		WAIT FOR 869  * PERIOD;
		tb_RX_Data <= '1'; -- Bit 1
		WAIT FOR 869  * PERIOD;
		tb_RX_Data <= '0'; -- Bit 2
		WAIT FOR 869  * PERIOD;
		tb_RX_Data <= '1'; -- Bit 3
		WAIT FOR 869  * PERIOD;
		tb_RX_Data <= '0'; -- Bit 4
		WAIT FOR 869  * PERIOD;
		tb_RX_Data <= '1'; -- Bit 5
		WAIT FOR 869  * PERIOD;
		tb_RX_Data <= '1'; -- Bit 6
		WAIT FOR 869  * PERIOD;
		tb_RX_Data <= '1'; -- Bit 7
		WAIT FOR 869  * PERIOD;
		tb_RX_Data <= '1'; -- Parity Bit 
		WAIT FOR 869  * PERIOD;
		tb_RX_Data <= '1'; -- Stop Bit
		WAIT FOR 869  * PERIOD;
		WAIT FOR 5000 ns;

		
		 -- Send third packet (Incorrect Parity Bit)
		tb_RX_Data <= '0'; -- Start bit
		WAIT FOR 869  * PERIOD;
		tb_RX_Data <= '1'; -- Bit 0
		WAIT FOR 869  * PERIOD;
		tb_RX_Data <= '0'; -- Bit 1
		WAIT FOR 869  * PERIOD;
		tb_RX_Data <= '0'; -- Bit 2
		WAIT FOR 869  * PERIOD;
		tb_RX_Data <= '0'; -- Bit 3
		WAIT FOR 869  * PERIOD;
		tb_RX_Data <= '0'; -- Bit 4
		WAIT FOR 869  * PERIOD;
		tb_RX_Data <= '0'; -- Bit 5
		WAIT FOR 869  * PERIOD;
		tb_RX_Data <= '1'; -- Bit 6
		WAIT FOR 869  * PERIOD;
		tb_RX_Data <= '1'; -- Bit 7
		WAIT FOR 869  * PERIOD;
		tb_RX_Data <= '0'; -- Parity Bit 
		WAIT FOR 869  * PERIOD;
		tb_RX_Data <= '1'; -- Stop bit
		WAIT FOR 869  * PERIOD;
		WAIT FOR 5000 ns;
		
		 -- Send fourth packet (Correct Parity Bit)
		tb_RX_Data <= '0'; -- Start bit
		WAIT FOR 869  * PERIOD;
		tb_RX_Data <= '1'; -- Bit 0
		WAIT FOR 869  * PERIOD;
		tb_RX_Data <= '0'; -- Bit 1
		WAIT FOR 869  * PERIOD;
		tb_RX_Data <= '0'; -- Bit 2
		WAIT FOR 869  * PERIOD;
		tb_RX_Data <= '0'; -- Bit 3
		WAIT FOR 869  * PERIOD;
		tb_RX_Data <= '0'; -- Bit 4
		WAIT FOR 869  * PERIOD;
		tb_RX_Data <= '0'; -- Bit 5
		WAIT FOR 869  * PERIOD;
		tb_RX_Data <= '1'; -- Bit 6
		WAIT FOR 869  * PERIOD;
		tb_RX_Data <= '1'; -- Bit 7
		WAIT FOR 869  * PERIOD;
		tb_RX_Data <= '1'; -- Parity Bit 
		WAIT FOR 869  * PERIOD;
		tb_RX_Data <= '1'; -- Stop bit
		WAIT FOR 869  * PERIOD;
		WAIT FOR 5000 ns;
		
		 -- Send fifth packet (Correct)
		tb_RX_Data <= '0'; -- Start bit
		WAIT FOR 869  * PERIOD;
		tb_RX_Data <= '1'; -- Bit 0
		WAIT FOR 869  * PERIOD;
		tb_RX_Data <= '1'; -- Bit 1
		WAIT FOR 869  * PERIOD;
		tb_RX_Data <= '1'; -- Bit 2
		WAIT FOR 869  * PERIOD;
		tb_RX_Data <= '1'; -- Bit 3
		WAIT FOR 869  * PERIOD;
		tb_RX_Data <= '1'; -- Bit 4
		WAIT FOR 869  * PERIOD;
		tb_RX_Data <= '1'; -- Bit 5
		WAIT FOR 869  * PERIOD;
		tb_RX_Data <= '1'; -- Bit 6
		WAIT FOR 869  * PERIOD;
		tb_RX_Data <= '1'; -- Bit 7
		WAIT FOR 869  * PERIOD;
		tb_RX_Data <= '0'; -- Parity Bit 
		WAIT FOR 869  * PERIOD;
		tb_RX_Data <= '1'; -- Stop Bit
		WAIT FOR 869  * PERIOD;
		WAIT FOR 5000 ns;
		
		 -- Send sixth packet (Incorrect missing stop bit)
		tb_RX_Data <= '0'; -- Start bit
		WAIT FOR 869  * PERIOD;
		tb_RX_Data <= '1'; -- Bit 0
		WAIT FOR 869  * PERIOD;
		tb_RX_Data <= '0'; -- Bit 1
		WAIT FOR 869  * PERIOD;
		tb_RX_Data <= '0'; -- Bit 2
		WAIT FOR 869  * PERIOD;
		tb_RX_Data <= '1'; -- Bit 3
		WAIT FOR 869  * PERIOD;
		tb_RX_Data <= '1'; -- Bit 4
		WAIT FOR 869  * PERIOD;
		tb_RX_Data <= '1'; -- Bit 5
		WAIT FOR 869  * PERIOD;
		tb_RX_Data <= '0'; -- Bit 6
		WAIT FOR 869  * PERIOD;
		tb_RX_Data <= '0'; -- Bit 7
		WAIT FOR 869  * PERIOD;
		tb_RX_Data <= '0'; -- Parity Bit 
		WAIT FOR 10000 ns;
		
		 -- Send Seventh packet (Correct)
		tb_RX_Data <= '0'; -- Start bit
		WAIT FOR 869  * PERIOD;
		tb_RX_Data <= '0'; -- Bit 0
		WAIT FOR 869  * PERIOD;
		tb_RX_Data <= '0'; -- Bit 1
		WAIT FOR 869  * PERIOD;
		tb_RX_Data <= '0'; -- Bit 2
		WAIT FOR 869  * PERIOD;
		tb_RX_Data <= '0'; -- Bit 3
		WAIT FOR 869  * PERIOD;
		tb_RX_Data <= '0'; -- Bit 4
		WAIT FOR 869  * PERIOD;
		tb_RX_Data <= '0'; -- Bit 5
		WAIT FOR 869  * PERIOD;
		tb_RX_Data <= '0'; -- Bit 6
		WAIT FOR 869  * PERIOD;
		tb_RX_Data <= '1'; -- Bit 7
		WAIT FOR 869  * PERIOD;
		tb_RX_Data <= '1'; -- Parity Bit 
		WAIT FOR 869  * PERIOD;
		tb_RX_Data <= '1'; -- Stop Bit
		WAIT FOR 869  * PERIOD;
		WAIT FOR 5000 ns;
		
		 -- Send eigth packet (Correct)
		tb_RX_Data <= '1'; -- Return back to 1 before next transmission after missing the stop bit
		WAIT FOR 5000 ns;
		tb_RX_Data <= '0'; -- Start bit
		WAIT FOR 869  * PERIOD;
		tb_RX_Data <= '1'; -- Bit 0
		WAIT FOR 869  * PERIOD;
		tb_RX_Data <= '0'; -- Bit 1
		WAIT FOR 869  * PERIOD;
		tb_RX_Data <= '0'; -- Bit 2
		WAIT FOR 869  * PERIOD;
		tb_RX_Data <= '0'; -- Bit 3
		WAIT FOR 869  * PERIOD;
		tb_RX_Data <= '0'; -- Bit 4
		WAIT FOR 869  * PERIOD;
		tb_RX_Data <= '0'; -- Bit 5
		WAIT FOR 869  * PERIOD;
		tb_RX_Data <= '0'; -- Bit 6
		WAIT FOR 869  * PERIOD;
		tb_RX_Data <= '1'; -- Bit 7
		WAIT FOR 869  * PERIOD;
		tb_RX_Data <= '0'; -- Parity Bit 
		WAIT FOR 869  * PERIOD;
		tb_RX_Data <= '1'; -- Stop Bit
		WAIT FOR 869  * PERIOD;
		WAIT;
		
	END PROCESS;
END ARCHITECTURE test;