-- ==============================================================
--  Lab 2 - VHDL Template
--  Descripción: Esqueleto de la entidad y arquitectura.
--  TODO: Completar descripción funcional del diseño.
-- ==============================================================

-- TODO: Añadir librerías necesarias.

entity uart_tx is
    port (
        -- TODO: Añadir puertos de entrada/salida.

    );
end entity uart_tx;

architecture RTL of uart_tx is

    -- ============================================================================
    -- DETECCIÓN DE FLANCO DE SUBIDA DEL BOTÓN
    -- ============================================================================
    -- TODO: Declarar constantes y tipos.
    -- TODO: Declarar señales internas.

    -- ============================================================================
    -- REGISTRO DE DESPLAZAMIENTO UART (Formato: 1 STOP + 8 DATOS + 1 START = 10 bits)
    -- ============================================================================
    -- TODO: Declarar constantes y tipos.
    -- TODO: Declarar señales internas.

    -- ============================================================================
    -- TEMPORIZADOR DE BIT (Controla duración de cada bit a 19200 baud)
    -- Período de bit = 100 MHz / 19200 = 5208 ciclos, limitado a 5207 = 13 bits
    -- ============================================================================
    -- TODO: Declarar constantes y tipos.
    -- TODO: Declarar señales internas.

begin

    -- ============================================================================
    -- DETECCIÓN DE FLANCO DE SUBIDA DEL BOTÓN
    -- ============================================================================
    -- ETAPA 1: SINCRONIZACIÓN DEL BOTÓN (2 registros de metaestabilidad)
    -- ETAPA 2: DEBOUNCING DEL BOTÓN (Muestreo cada ~5 ms)
    -- ETAPA 3: DETECCIÓN DE FLANCO DE SUBIDA

    -- TODO: Implementar el modelo separando parte combinacional de secuencial.


    -- ============================================================================
    -- REGISTRO DE DESPLAZAMIENTO UART
    -- ============================================================================

    -- TODO: Implementar el modelo separando parte combinacional de secuencial.

    -- ============================================================================
    -- TEMPORIZADOR DE BIT (timer para controlar duración de cada bit)
    -- ============================================================================

    -- TODO: Implementar el modelo separando parte combinacional de secuencial.

    -- ============================================================================
    -- SALIDAS DEL MÓDULO
    -- ============================================================================

    -- TODO: Asignar valores a los puertos de salida

end architecture;

