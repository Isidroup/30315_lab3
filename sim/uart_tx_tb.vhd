--------------------------------------------------------------------------------
-- Design Name   : Test bench uart_tx
-- File Name     : uart_tx_tb.vhd
-- Description   : Testbench funcional para verificar el modulo UART_TX
-- Created       :
-- Last modified :
-- Author        :
-- Version       :
--------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity uart_tx_tb is
end;

architecture Behavioral of uart_tx_tb is
    -- Declaración de los componentes
    component uart_tx
        port (
            RST  : in std_logic;
            CLK  : in std_logic;
            SW   : in std_logic_vector (7 downto 0);
            BTND : in std_logic;
            TX   : out std_logic
        );
    end component;

    -- Declaración de constantes
    --     periodo de la señal de reloj
    constant C_CLK_PERIOD    : time := 10 ns;
    --     tiempo de bit
    constant C_BIT_TIME : time := 1 sec/19200;
    --     tiempo de rebotes
    constant C_DEBOUNCE_TIME : time := 5 ms;
    --     tiempo total de una trama UART (1 start + 8 data + 1 stop)
    constant C_FRAME_TIME : time := 10 * C_BIT_TIME;

    -- Declaración de señales
    --     señal de reloj
    signal clk_tb : std_logic := '0';
    --     señal de reset
    signal rst_tb : std_logic := '1';
    --     señal de entrada/salida del dispositivo bajo prueba
    signal sw_tb   : std_logic_vector(7 downto 0) := x"55"; -- Valor inicial (puede ser modificado en los casos de test)
    signal btnd_tb : std_logic := '0';
    signal tx_tb   : std_logic;
    --     señales utilizadas para la reconstrucción de la trama transmitida
    signal dtxaux: std_logic_vector(7 downto 0); -- señal auxiliar para reconstruir la trama
    signal tx_reconstruido : std_logic_vector(7 downto 0);  -- último dato procesado (reconstruido a partir de la trama transmitida)
begin

    -- instanciación del dispositivo bajo prueba
    uart_tx_inst : uart_tx
        port map
        (
            RST  => rst_tb,
            CLK  => clk_tb,
            SW   => sw_tb,
            BTND => btnd_tb,
            TX   => tx_tb
        );

    -- Generación de la señal de reloj
    clk_tb <= not clk_tb after C_CLK_PERIOD / 2;

    -- Reconstrucción del dato presente en la trama transmitida
    process
    begin
        wait until tx_tb = '0'; -- Espera el bit de start
        wait for C_BIT_TIME/2;    -- Espera ½ bit
        -- bit de start
        if (tx_tb /= '0') then
            tx_reconstruido <= (others => 'X'); -- Error, bit de start
        else
            -- 8 bits del caracter
            for i in 0 to 7 loop
                wait for C_BIT_TIME;      -- Espera 1 bit
                dtxaux(i) <= tx_tb;       -- bit i
            end loop;

            wait for C_BIT_TIME;      -- Espera 1 bit
            -- bit de stop
            if (tx_tb /= '1') then
                tx_reconstruido <= (others => 'X'); -- Error, bit de stop
            else
                tx_reconstruido <= dtxaux;
            end if;
        end if;
    end process;

    -- Casos de test
    process
    begin
        -- T1: Reset y condiciones iniciales
        rst_tb <= '1';  -- activa reset
        wait for 5 * C_CLK_PERIOD; -- duración del pulso de reset
        rst_tb <= '0';  -- desactiva reset
        wait for 0 ns; -- Delta delay: permite que otros procesos ejecuten y propaguen cambios
        -- >>> Pon un breakpoint en la línea anterior y Comprueba T1

        -- Test 2: Transmision 0x55
        sw_tb <= x"55"; -- Dato de entrada
        --  patron de pulsación:
        btnd_tb <= '0', '1' after C_DEBOUNCE_TIME + 1 ms;
        wait for 2 * C_DEBOUNCE_TIME + 2 ms;  -- espera fin de pulsacion
        rst_tb <= '0';  -- desactiva reset
        wait for 0 ns; -- Delta delay: permite que otros procesos ejecuten y propaguen cambios
        -- >>> Pon un breakpoint en la línea anterior y Comprueba T2

        -- Test 3: Transmision 0xAA
        sw_tb <= x"AA"; -- Dato de entrada
        --  patron de pulsación:
        btnd_tb <= '0', '1' after C_DEBOUNCE_TIME + 1 ms;
        wait for 2 * C_DEBOUNCE_TIME + 2 ms;  -- espera fin de pulsacion
        rst_tb <= '0';  -- desactiva reset
        wait for 0 ns; -- Delta delay: permite que otros procesos ejecuten y propaguen cambios
        -- >>> Pon un breakpoint en la línea anterior y Comprueba T3

        -- Test 4: Transmision 0x00
        sw_tb <= x"00"; -- Dato de entrada
        --  patron de pulsación:
        btnd_tb <= '0', '1' after C_DEBOUNCE_TIME + 1 ms;
        wait for 2 * C_DEBOUNCE_TIME + 2 ms;  -- espera fin de pulsacion
        rst_tb <= '0';  -- desactiva reset
        wait for 0 ns; -- Delta delay: permite que otros procesos ejecuten y propaguen cambios
        -- >>> Pon un breakpoint en la línea anterior y Comprueba T4

        -- Test 5: Transmision 0xFF
        sw_tb <= x"FF"; -- Dato de entrada
        --  patron de pulsación:
        btnd_tb <= '0', '1' after C_DEBOUNCE_TIME + 1 ms;
        wait for 2 * C_DEBOUNCE_TIME + 2 ms;  -- espera fin de pulsacion
        rst_tb <= '0';  -- desactiva reset
        wait for 0 ns; -- Delta delay: permite que otros procesos ejecuten y propaguen cambios
        -- >>> Pon un breakpoint en la línea anterior y Comprueba T5

        -- Test 6: Debouncing
        sw_tb <= x"99"; -- Dato de entrada
        --  patron de pulsación:
        btnd_tb <=  '0',
                    '1' after C_DEBOUNCE_TIME,
                    '0' after C_DEBOUNCE_TIME + 400 * C_CLK_PERIOD,
                    '1' after C_DEBOUNCE_TIME + 1000 * C_CLK_PERIOD,
                    '0' after C_DEBOUNCE_TIME + 2000 * C_CLK_PERIOD,
                    '1' after C_DEBOUNCE_TIME + 4000 * C_CLK_PERIOD,
                    '0' after C_DEBOUNCE_TIME + 7000 * C_CLK_PERIOD,
                    '1' after C_DEBOUNCE_TIME + 10000 * C_CLK_PERIOD;
        wait for 2 * C_DEBOUNCE_TIME + 2 ms;  -- espera fin de pulsacion
        rst_tb <= '0';  -- desactiva reset
        wait for 0 ns; -- Delta delay: permite que otros procesos ejecuten y propaguen cambios
        -- >>> Pon un breakpoint en la línea anterior y Comprueba T6

        -- Test 7: Reset durante la transmisión
        sw_tb <= x"77"; -- Dato de entrada
        --  patron de pulsación:
        btnd_tb <= '0', '1' after C_DEBOUNCE_TIME  + 1 ms;
        wait until tx_tb = '0'; -- Espera el bit de start

        wait for 0.25 * C_BIT_TIME;
        rst_tb <= '1';
        wait for 3 * C_CLK_PERIOD;
        rst_tb <= '0';
        wait for C_DEBOUNCE_TIME;
        wait for 0 ns; -- Delta delay: permite que otros procesos ejecuten y propaguen cambios
        -- >>> Pon un breakpoint en la línea anterior y Comprueba T6

        -- Test 8: Transmision 0xEA
        sw_tb <= x"EA"; -- Dato de entrada
        --  patron de pulsación:
        btnd_tb <= '0', '1' after C_DEBOUNCE_TIME + 1 ms;
        wait for 2 * C_DEBOUNCE_TIME + 2 ms;  -- espera fin de pulsacion
        rst_tb <= '0';  -- desactiva reset
        wait for 0 ns; -- Delta delay: permite que otros procesos ejecuten y propaguen cambios
        -- >>> Pon un breakpoint en la línea anterior y Comprueba T5

        wait;

    end process;


end architecture Behavioral;

