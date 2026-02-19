# --------------------------------------------------------------------------------
# Archivo: timing_constraints.xdc
# Descripción: Restricciones de temporización para diseño con UART y Entradas Asíncronas
# --------------------------------------------------------------------------------

# 1. Definición del Reloj Principal sys_clk en el pin CLK
# --------------------------------------------------------------------------------
# Se define el reloj principal del sistema con una frecuencia de 100 MHz.
# Este comando establece la referencia base para todo el análisis de timing interno.
# Periodo: 10ns | Duty Cycle: 50%
create_clock -add -name sys_clk -period 10.00 -waveform {0 5} [get_ports CLK]


# 2. Entradas Asíncronas (Switches, Pulsadores y Reset)
# --------------------------------------------------------------------------------
# Las señales SW, BTND y RST son asíncronas: no tienen una relación de fase fija
# con el reloj del sistema y su cambio depende de la interacción humana.
#
# Se aplica 'set_false_path' para indicar a Vivado que no intente cumplir tiempos
# de setup/hold en estos puertos, ya que físicamente es imposible garantizarlos.
set_false_path -from [get_ports {SW[*] BTND RST}]


# 3. Sincronización y Prevención de Metaestabilidad
# --------------------------------------------------------------------------------
# Para evitar fallos por metaestabilidad al leer señales externas (como BTND),
# se utiliza una cadena de registros (sincronizador).
#
# Restringimos el camino hacia el primer registro (meta_reg) como 'false_path'
# para que el analizador de tiempos ignore las violaciones en ese nodo específico.

set_false_path -to [get_cells *_meta_*]

# NOTA TÉCNICA: Se recomienda que en el código HDL se aplique el atributo
# (* ASYNC_REG = "TRUE" *) a los registros de sincronización para que el
# "Placer" los ubique lo más cerca posible entre sí.


# 4. Interfaz Serie UART (Salida TX)
# --------------------------------------------------------------------------------
# La señal TX pertenece a un protocolo de comunicación asíncrono. Dado que el
# receptor externo utiliza su propio reloj independiente para muestrear los datos,
# no existe una relación de tiempo síncrona con nuestro reloj interno.
#
# Declaramos 'false_path' para liberar al compilador de optimizaciones innecesarias
# en esta señal de baja velocidad.
set_false_path -to [get_ports TX]


# 5. Configuración de sincronización: Pulsador (btnd)
# ASYNC_REG identifica registros de sincronización para maximizar el MTBF (tiempo entre fallos),
# forzando su proximidad física y desactivando optimizaciones lógicas (retiming) que
# podrían comprometer la resolución de metaestabilidad.
set_property ASYNC_REG TRUE [get_cells {*_meta_* *_sync_*}]

# --------------------------------------------------------------------------------
# RESUMEN DE ESTRATEGIA:
# - Reloj: Única restricción estricta para asegurar que la lógica interna funcione.
# - False Paths: Se aplican a todas las I/O que no comparten un reloj común con
#   dispositivos externos, optimizando el tiempo de compilación y el uso de recursos.
# --------------------------------------------------------------------------------

