-- Project Group #11
-- Sahaj Singh Student#: 301437700
-- Bryce Leung Student#: 301421630 

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;    
USE IEEE.NUMERIC_STD.ALL;
 
ENTITY tb_TX_RX IS
END tb_TX_RX;

ARCHITECTURE test OF tb_TX_RX IS 
	 -- Call component TX
	COMPONENT TX
		port(clk : IN STD_LOGIC;
			Reset : IN STD_LOGIC;
			Start : IN STD_LOGIC;
			Baud_Rate : IN INTEGER;
			Data : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
			Done : OUT STD_LOGIC;
			Running : OUT STD_LOGIC; -- When TX is running and transferring the data
			TX_Data : OUT STD_LOGIC);
	END COMPONENT;
	
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
	
	 -- Setting up a unified clock
	CONSTANT PERIOD : TIME := 8 ns;
	SIGNAL tb_clk1, tb_clk2 : STD_LOGIC := '0';

	SIGNAL tb_reset : STD_LOGIC := '1';
	
	 -- Initialize signals TX
	SIGNAL tb_Start : STD_LOGIC := '0';
	signal tb_Data_in : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL tb_Done : STD_LOGIC := '0';
	SIGNAL tb_Running_TX : STD_LOGIC;

	 -- Initialize signals RX
	SIGNAL tb_Data_out : STD_LOGIC_VECTOR(7 DOWNTO 0);
	signal tb_Successfully_Received : std_logic;
	SIGNAL tb_Running_RX : STD_LOGIC;

	 -- Signal connecting the RX and TX component
	SIGNAL tb_TX_Data_RX : STD_LOGIC;
	SIGNAL tb_Baud_Rate : INTEGER := 115200;
	
BEGIN

	 -- Port map the TX component
	DUT1: TX 
	PORT MAP (tb_clk1, tb_reset, tb_Start, tb_Baud_Rate, tb_Data_in, tb_Done, tb_Running_TX, tb_TX_Data_RX);

	 -- Port map the RX component
	DUT2: RX 
	PORT MAP (tb_clk2, tb_reset, tb_TX_Data_RX, tb_Baud_Rate, tb_Data_out, tb_Successfully_Received, tb_Running_RX);
	

	 -- Setting the clock to toggle after the set period
	tb_clk1 <= not(tb_clk1) after PERIOD;
	tb_clk2 <= not(tb_clk2) after PERIOD;

	 -- Initialization reset
	tb_reset <= '1', '0' AFTER 400 ns;
	
	PROCESS IS
	BEGIN
		 -- Delay before beginnning
		WAIT FOR 5000 ns;
	
		 -- Transmit first packet (Parity bit 0)
		tb_Data_in <= "01010101";
		WAIT FOR 5000 ns;
		tb_Start <= '1';
		WAIT FOR 100 ns;
		tb_Start <= '0';
		WAIT FOR 100000 ns;
		
		 -- Transmit second packet (Parity bit 1)
		tb_Data_in <= "01111111";
		WAIT FOR 5000 ns;
		tb_Start <= '1';
		WAIT FOR 100 ns;
		tb_Start <= '0';
		WAIT FOR 100000 ns;
		
		 -- Transmit third packet (Parity bit 1)
		tb_Data_in <= "00001110";
		WAIT FOR 5000 ns;
		tb_Start <= '1';
		WAIT FOR 100 ns;
		tb_Start <= '0';
		WAIT FOR 100000 ns;
		
		 -- Transmit fourth packet (Parity bit 0)
		tb_Data_in <= "11001111";
		WAIT FOR 5000 ns;
		tb_Start <= '1';
		WAIT FOR 100 ns;
		tb_Start <= '0';
		WAIT FOR 100000 ns;
		
		 -- Transmit fifth packet (Parity bit 0)
		tb_Data_in <= "11000100";
		WAIT FOR 5000 ns;
		tb_Start <= '1';
		WAIT FOR 100 ns;
		tb_Start <= '0';
		WAIT FOR 100000 ns;
	
		WAIT;
	END PROCESS;
END ARCHITECTURE test;