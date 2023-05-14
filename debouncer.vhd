LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE IEEE.NUMERIC_STD.all;

ENTITY debouncer IS
    GENERIC(
        Timeout_Cycles : POSITIVE);
    PORT(
        CLK               : IN STD_LOGIC;
        Reset               : IN STD_LOGIC;
        Button            : IN STD_LOGIC;
        Button_Debounced  : OUT STD_LOGIC);
END debouncer;

ARCHITECTURE rtl OF debouncer IS
    SIGNAL Debounced : STD_LOGIC;
    SIGNAL Counter : INTEGER RANGE 0 TO Timeout_Cycles - 1;
BEGIN
    Button_Debounced <= Debounced;
    DEBOUNCE_PROC : PROCESS (CLK)
    BEGIN
        IF RISING_EDGE(CLK) THEN
            IF Reset = '1' THEN
                Counter <= 0;
                Debounced <= Button;
            ELSE
                IF Counter < Timeout_Cycles - 1 THEN
                    Counter <= Counter + 1;
                ELSIF Button /= Debounced THEN
                    Counter <= 0;
                    Debounced <= Button;
                END IF;
            END IF;
        END IF;
    END PROCESS;
END ARCHITECTURE;