# --------------------------------------------------------------------------------
# Archivo: 01_timing.xdc
# Descripcion: Restricciones de temporizacion para diseno con UART y Entradas Asincronas
# --------------------------------------------------------------------------------

# 1. Definicion del Reloj Principal sys_clk en el pin CLK
# --------------------------------------------------------------------------------
# Se define el reloj principal del sistema con una frecuencia de 100 MHz.
# Este comando establece la referencia base para todo el analisis de timing interno.
# Periodo: 10ns | Duty Cycle: 50%
create_clock -add -name sys_clk -period 10.00 -waveform {0 5} [get_ports CLK]


# 2. Entradas Asincronas (Switches, Pulsadores y Reset)
# --------------------------------------------------------------------------------
# Las senales SW, BTND y RST son asincronas: no tienen una relacion de fase fija
# con el reloj del sistema y su cambio depende de la interaccion humana.
#
# Se aplica 'set_false_path' para indicar a Vivado que no intente cumplir tiempos
# de setup/hold en estos puertos, ya que fisicamente es imposible garantizarlos.
set_false_path -from [get_ports {SW[*] BTND RST}]


# 3. Sincronizacion y Prevencion de Metaestabilidad
# --------------------------------------------------------------------------------
# Para evitar fallos por metaestabilidad al leer senales externas (como BTND),
# se utiliza una cadena de registros (sincronizador).
#
# Restringimos el camino hacia el primer registro (meta_reg) como 'false_path'
# para que el analizador de tiempos ignore las violaciones en ese nodo especifico.

set_false_path -to [get_cells *_meta_*]

# NOTA TECNICA: Se recomienda que en el codigo HDL se aplique el atributo
# (* ASYNC_REG = "TRUE" *) a los registros de sincronizacion para que el
# "Placer" los ubique lo mas cerca posible entre si.


# 4. Interfaz Serie UART (Salida TX)
# --------------------------------------------------------------------------------
# La senal TX pertenece a un protocolo de comunicacion asincrono. Dado que el
# receptor externo utiliza su propio reloj independiente para muestrear los datos,
# no existe una relacion de tiempo sincrona con nuestro reloj interno.
#
# Declaramos 'false_path' para liberar al compilador de optimizaciones innecesarias
# en esta senal de baja velocidad.
set_false_path -to [get_ports TX]


# 5. Configuracion de sincronizacion: Pulsador (btnd)
# ASYNC_REG identifica registros de sincronizacion para maximizar el MTBF (tiempo entre fallos),
# forzando su proximidad fisica y desactivando optimizaciones logicas (retiming) que
# podrian comprometer la resolucion de metaestabilidad.
set_property ASYNC_REG TRUE [get_cells {*_meta_* *_sync_*}]

# --------------------------------------------------------------------------------
# RESUMEN DE ESTRATEGIA:
# - Reloj: Unica restriccion estricta para asegurar que la logica interna funcione.
# - False Paths: Se aplican a todas las I/O que no comparten un reloj comun con
#   dispositivos externos, optimizando el tiempo de compilacion y el uso de recursos.
# --------------------------------------------------------------------------------
