# --------------------------------------------------------------------------------
# Archivo: 02_basys3_io.xdc
# Descripcion: Asignacion de pines y configuracion de voltaje para Basys3
# --------------------------------------------------------------------------------

## Switches (Entrada SW)


## Botones (Entrada BTND, RST)

## Salida TX

## Reloj Principal (Entrada CLK)
set_property PACKAGE_PIN    W5  [get_ports {CLK}]

# --------------------------------------------------------------------------
# Configuracion Electrica y de Dispositivo
# --------------------------------------------------------------------------

# Estandar I/O: Aplicamos LVCMOS33 a todos los puertos
# Configuracion para Entradas (Switches y Botones)
set_property IOSTANDARD LVCMOS33 [get_ports {SW[*] BTND RST CLK}]
# Configuracion para Salidas (LEDs)
set_property IOSTANDARD LVCMOS33 [get_ports {TX}]

# Configuracion de compresion de Bitstream y Voltaje de Bancos
set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]

# --------------------------------------------------------------------------
# NOTA SOBRE LA ASIGNACION DE PINES:
# La asignacion de pines y la configuracion electrica aqui definidas
# estan especificamente adaptadas para la placa Basys3. Al utilizar
# una FPGA diferente o una placa distinta, es necesario consultar la
# documentacion del fabricante para asegurar una asignacion correcta
# de pines y una configuracion adecuada de los estandares electricos.
