-- Project Group #11
-- Sahaj Singh Student#: 301437700
-- Bryce Leung Student#: 301421630 

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;    
USE IEEE.NUMERIC_STD.ALL;
 
ENTITY tb_TX IS
END tb_TX;

ARCHITECTURE test OF tb_TX IS 
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
 
	 -- Initialize signals
	CONSTANT PERIOD : time := 5 ns;
	SIGNAL tb_clk : STD_LOGIC := '0';
	SIGNAL tb_reset : STD_LOGIC := '1';
	SIGNAL tb_Start : STD_LOGIC := '0';
	SIGNAL tb_Baud_Rate : INTEGER := 115200;
	signal tb_Data : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL tb_Done : STD_LOGIC := '0';
	SIGNAL tb_Running : STD_LOGIC;
	SIGNAL tb_TX_Data : STD_LOGIC;
	

BEGIN
	
	 -- Port map the TX component
	DUT: TX 
	PORT MAP (tb_clk, tb_reset, tb_Start, tb_Baud_Rate, tb_Data, tb_Done, tb_Running, tb_TX_Data);
 
	
	 -- Setting the clock to toggle after the set period
	tb_clk <= not(tb_clk) after PERIOD;

	 -- Initialization reset
	tb_reset <= '1', '0' AFTER 400 ns;
	
	PROCESS IS
	BEGIN
		
		 -- Transmit first packet (Parity bit 0)
		tb_Data <= "01010101";
		WAIT FOR 5000ns;
		tb_Start <= '1';
		WAIT FOR 100ns;
		tb_Start <= '0';
		WAIT FOR 50000 ns;
		
		 -- Transmit second packet (Parity bit 1)
		tb_Data <= "01011000";
		WAIT FOR 5000ns;
		tb_Start <= '1';
		WAIT FOR 100ns;
		tb_Start <= '0';
		WAIT FOR 50000 ns;
		
		 -- Transmit second packet (Parity bit 0)
		tb_Data <= "01111011";
		WAIT FOR 5000ns;
		tb_Start <= '1';
		WAIT FOR 100ns;
		tb_Start <= '0';
		WAIT FOR 50000 ns;
		
		 -- Transmit third packet (Parity bit 0)
		tb_Data <= "11111111";
		WAIT FOR 5000ns;
		tb_Start <= '1';
		WAIT FOR 100ns;
		tb_Start <= '0';
		WAIT FOR 50000 ns;
		
		 -- Transmit fourth packet (Parity bit 1)
		tb_Data <= "11100011";
		WAIT FOR 5000ns;
		tb_Start <= '1';
		WAIT FOR 100ns;
		tb_Start <= '0';
		WAIT FOR 50000 ns;
		
		 -- Transmit fifth packet (Parity bit 0)
		tb_Data <= "10000001";
		WAIT FOR 5000ns;
		tb_Start <= '1';
		WAIT FOR 100ns;
		tb_Start <= '0';
		WAIT FOR 50000 ns;
		
		 -- Transmit sixth packet (Parity bit 1)
		tb_Data <= "10010010";
		WAIT FOR 5000ns;
		tb_Start <= '1';
		WAIT FOR 100ns;
		tb_Start <= '0';
		WAIT FOR 50000 ns;
		
		WAIT;
	END PROCESS;
END ARCHITECTURE test;
