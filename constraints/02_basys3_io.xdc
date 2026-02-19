# --------------------------------------------------------------------------------
# Archivo: 02_basys3_io.xdc
# Descripción: Asignación de pines y configuración de voltaje para Basys3
# --------------------------------------------------------------------------------

## Switches (Entrada SW)


## Botones (Entrada BTND, RST)

## Salida TX

## Reloj Principal (Entrada CLK)
set_property PACKAGE_PIN    W5  [get_ports {CLK}]

# --------------------------------------------------------------------------
# Configuración Eléctrica y de Dispositivo
# --------------------------------------------------------------------------

# Estándar I/O: Aplicamos LVCMOS33 a todos los puertos
# Configuración para Entradas (Switches y Botones)
set_property IOSTANDARD LVCMOS33 [get_ports {SW[*] BTND RST CLK}]
# Configuración para Salidas (LEDs)
set_property IOSTANDARD LVCMOS33 [get_ports {TX}]

# Configuración de compresión de Bitstream y Voltaje de Bancos
set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]

# --------------------------------------------------------------------------
# NOTA SOBRE LA ASIGNACIÓN DE PINES:
# La asignación de pines y la configuración eléctrica aquí definidas
# están específicamente adaptadas para la placa Basys3. Al utilizar
# una FPGA diferente o una placa distinta, es necesario consultar la
# documentación del fabricante para asegurar una asignación correcta
# de pines y una configuración adecuada de los estándares eléctricos.

