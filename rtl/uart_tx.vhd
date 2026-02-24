-- ==============================================================
--  Lab 2 - VHDL Template
--  Descripcion: Esqueleto de la entidad y arquitectura.
--  TODO: Completar descripcion funcional del diseno.
-- ==============================================================

-- TODO: Anadir librerias necesarias.

entity uart_tx is
    port (
        -- TODO: Anadir puertos de entrada/salida.

    );
end entity uart_tx;

architecture RTL of uart_tx is

    -- ============================================================================
    -- DETECCION DE FLANCO DE SUBIDA DEL BOTON
    -- ============================================================================
    -- TODO: Declarar constantes y tipos.
    -- TODO: Declarar senales internas.

    -- ============================================================================
    -- REGISTRO DE DESPLAZAMIENTO UART (Formato: 1 STOP + 8 DATOS + 1 START = 10 bits)
    -- ============================================================================

    -- TODO: Declarar constantes y tipos.
    -- TODO: Declarar senales internas.

    -- ============================================================================
    -- TEMPORIZADOR DE BIT (Controla duracion de cada bit a 19200 baud)
    -- Periodo de bit = 100 MHz / 19200 = 5208 ciclos, limitado a 5207 = 13 bits
    -- ============================================================================

    -- TODO: Declarar constantes y tipos.
    -- TODO: Declarar senales internas.

begin

    -- ============================================================================
    -- DETECCION DE FLANCO DE SUBIDA DEL BOTON
    -- ============================================================================
    -- ETAPA 1: SINCRONIZACION DEL BOTON (2 registros de metaestabilidad)
    -- ETAPA 2: DEBOUNCING DEL BOTON (Muestreo cada ~5 ms)
    -- ETAPA 3: DETECCION DE FLANCO DE SUBIDA

    -- TODO: Implementar el modelo separando parte combinacional de secuencial.


    -- ============================================================================
    -- REGISTRO DE DESPLAZAMIENTO UART
    -- ============================================================================

    -- TODO: Implementar el modelo separando parte combinacional de secuencial.

    -- ============================================================================
    -- TEMPORIZADOR DE BIT (timer para controlar duracion de cada bit)
    -- ============================================================================

    -- TODO: Implementar el modelo separando parte combinacional de secuencial.

    -- ============================================================================
    -- SALIDAS DEL MODULO
    -- ============================================================================


    -- TODO: Asignar valores a los puertos de salida

end architecture;
