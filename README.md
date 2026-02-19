# Lab 3 - Transmisor UART (uart_tx)

Módulo transmisor UART implementado en VHDL para FPGA Xilinx Basys3. El diseño implementa un transmisor serie asíncrono completo con sincronización de entrada, eliminación de rebotes (debouncing) y detección de flancos.

## 📋 Descripción General

Este proyecto implementa un **transmisor UART completo** con manejo robusto de entradas asíncronas y transmisión serie a 19200 baud.

### Características Principales

- **Velocidad de transmisión**: 19200 baud @ 100 MHz
- **Formato de trama**: START (0) + 8 DATA + STOP (1) = 10 bits totales
- **Sincronización**: 2 registros de metaestabilidad para entrada limpia
- **Debouncing**: Muestreo cada 5 ms para eliminar rebotes del botón
- **Detección de flancos**: Flanco de subida para disparar transmisión
- **Control**: Botón BTND y datos desde switches SW[7:0]
- **Plataforma**: FPGA Xilinx Basys3 (Artix-7)

---

## 📁 Estructura del Proyecto

```
30315_lab3/
├── README.md                     # Este archivo
├── constraints/                  # Restricciones de diseño
│   ├── 01_timing.xdc             # Restricciones de timing
│   └── 02_basys3_io.xdc          # Mapeo de I/O Basys3
├── doc/                          # Documentación
│   ├── TEST_PLAN.md              # Plan de pruebas detallado
│   └── TEST_PLAN.rst             # Plan de pruebas (formato RST)
├── rtl/                          # Código RTL
│   └── uart_tx.vhd               # Módulo transmisor UART
├── sim/                          # Simulación
│   ├── uart_tx_tb.vhd            # Testbench principal
│   ├── uart_tx_tb_fixed.vhd      # Testbench corregido
│   ├── uart_tx_tb_behav.wcfg     # Configuración de onda (Vivado)
│   └── .modelsim/                # Configuración ModelSim
│       ├── Makefile              # Automatización de simulación
│       └── wave.do               # Script de visualización de ondas
├── scripts/                      # Scripts de automatización
│   └── lab.tcl                   # Script TCL para crear proyecto Vivado
├── vivado/                       # Proyecto Vivado (generado)
│   ├── lab.xpr                   # Archivo de proyecto
│   ├── lab.srcs/                 # Fuentes del proyecto
│   ├── lab.runs/                 # Resultados de síntesis e implementación
│   └── lab.hw/                   # Hardware
└── README.md                     # Este archivo
```

---

## 🔧 Especificaciones Técnicas

### Entradas

| Puerto | Ancho  | Tipo | Descripción                                   |
|--------|--------|------|-----------------------------------------------|
| `CLK`  | 1 bit  | in   | Reloj del sistema (100 MHz)                   |
| `RST`  | 1 bit  | in   | Reset asíncrono activo en alto                |
| `BTND` | 1 bit  | in   | Botón de disparo (detección flanco de subida) |
| `SW`   | 8 bits | in   | Datos a transmitir (switches SW[7:0])         |

### Salidas

| Puerto | Ancho | Tipo | Descripción                            |
|--------|-------|------|----------------------------------------|
| `TX`   | 1 bit | out  | Línea de transmisión UART (reposo='1') |

### Parámetros de Tiempo

| Parámetro                  | Valor      | Cálculo                   |
|----------------------------|------------|---------------------------|
| **Frecuencia del reloj**   | 100 MHz    | Reloj del sistema         |
| **Baud rate**              | 19200 baud | Velocidad de transmisión  |
| **Período de bit UART**    | 52.08 µs   | 1 / 19200 baud = 52.08 µs |
| **Ciclos por bit**         | 5208       | 100 MHz × 52.08 µs        |
| **Período debouncing**     | ~5 ms      | Contador 0 a 2^19-1       |
| **Bits de contador UART**  | 13 bits    | log₂(5208) ≈ 13 bits      |
| **Bits contador debounce** | 19 bits    | Para ~5 ms @ 100 MHz      |
| **Tiempo sincronización**  | 20 ns      | 2 ciclos de CLK           |

### Información del Dispositivo

- **FPGA**: Xilinx Artix-7 (xc7a35tcpg236-1)
- **Placa**: Digilent Basys3
- **Lenguaje**: VHDL
- **Reloj del sistema**: 100 MHz

---

## Formato de Trama UART

```
Bit:    0    1    2    3    4    5    6    7    8    9
      ┌────┬────┬────┬────┬────┬────┬────┬────┬────┬────┐
      │ 0  │ D0 │ D1 │ D2 │ D3 │ D4 │ D5 │ D6 │ D7 │ 1  │
      └────┴────┴────┴────┴────┴────┴────┴────┴────┴────┘
      START      8 BITS DE DATOS (LSB primero)      STOP

      Estado de reposo: TX = '1'
```

---

## 🚀 Uso

### Crear el Proyecto en Vivado

#### Opción 1: Usar el script TCL desde Vivado GUI

1. Abrir **Vivado**
2. Seleccionar **Tools → Run Tcl Script**
3. Navegar a `scripts/lab.tcl` y ejecutarlo
4. El proyecto se creará automáticamente en `vivado/`

#### Opción 2: Ejecutar el script desde línea de comandos

```bash
# Desde el directorio del proyecto
vivado -mode batch -source scripts/lab.tcl
```

#### Opción 3: Ejecutar manualmente en la consola TCL de Vivado

1. Abrir Vivado
2. En la **TCL Console**, ejecutar:
   ```tcl
   source scripts/lab.tcl
   ```

### Simulación

#### Con Vivado

1. Abrir el proyecto: `vivado vivado/lab.xpr`
2. En Flow Navigator → Simulation → **Run Behavioral Simulation**
3. Observar las formas de onda (configuración disponible en `uart_tx_tb_behav.wcfg`)

#### Con ModelSim

```bash
# Desde el directorio sim/.modelsim/
make
```

### Síntesis e Implementación

1. **Run Synthesis** - Sintetiza el diseño
2. **Run Implementation** - Implementa en el dispositivo target
3. **Generate Bitstream** - Genera el archivo `.bit`

### Programación de la Basys3

1. Conectar la placa Basys3 por USB
2. Abrir **Hardware Manager** en Vivado
3. Programar el dispositivo con el bitstream generado

### Operación en Hardware

1. Configurar los **datos a transmitir** en switches **SW[7:0]**
2. Presionar el botón **BTND** para iniciar la transmisión
3. La trama UART aparecerá en la salida **TX** a 19200 baud
4. Conectar a un terminal serial/USB para verificar la recepción de datos
5. Configurar el terminal a: 19200 baud, 8 bits de datos, sin paridad, 1 bit de parada

---

## 🔌 Mapeo de Hardware (Basys3)

| Señal     | Hardware       | Pin    | Descripción                       |
|-----------|----------------|--------|-----------------------------------|
| `CLK`     | Reloj sistema  | W5     | Reloj de 100 MHz de la placa      |
| `RST`     | Botón reset    | T18    | Reset del sistema (activo alto)   |
| `BTND`    | Botón inferior | U17    | Botón de disparo de transmisión   |
| `SW[7:0]` | Switches 7-0   | V17... | Datos a transmitir (8 bits)       |
| `TX`      | Pin TX         | A18    | Salida UART (conectar a terminal) |

**Ubicación de constraints**: [02_basys3_io.xdc](constraints/02_basys3_io.xdc)

---

## 📚 Documentación

### Archivos Principales

| Archivo                                                      | Descripción                               |
|--------------------------------------------------------------|-------------------------------------------|
| [rtl/uart_tx.vhd](rtl/uart_tx.vhd)                           | Implementación del módulo transmisor UART |
| [sim/uart_tx_tb.vhd](sim/uart_tx_tb.vhd)                     | Testbench principal                       |
| [sim/uart_tx_tb_fixed.vhd](sim/uart_tx_tb_fixed.vhd)         | Testbench corregido                       |
| [doc/TEST_PLAN.md](doc/TEST_PLAN.md)                         | Plan exhaustivo de pruebas (478 líneas)   |
| [scripts/lab.tcl](scripts/lab.tcl)                           | Script de creación del proyecto           |
| [constraints/02_basys3_io.xdc](constraints/02_basys3_io.xdc) | Mapeo de pines I/O                        |
| [constraints/01_timing.xdc](constraints/01_timing.xdc)       | Restricciones de timing                   |

### Plan de Pruebas

El documento [TEST_PLAN.md](doc/TEST_PLAN.md) incluye:

- **GRUPO T1**: Reset y condiciones iniciales
- **GRUPO T2**: Sincronización del botón
- **GRUPO T3**: Debouncing
- **GRUPO T4**: Detección de flancos
- **GRUPO T5**: Transmisión de datos
- **GRUPO T6**: Pruebas de estrés
- **GRUPO T7**: Casos límite

---

## 📋 Requisitos

### Hardware
- FPGA Xilinx Basys3
- Cable USB para programación
- Terminal serial (opcional, para visualizar datos transmitidos)
- Adaptador USB-UART (opcional, para conectar TX)

### Software
- Vivado Design Suite (2019.x o superior)
- ModelSim (opcional, para simulación)
- VHDL-93/2008 compatible
- Terminal serial (PuTTY, Tera Term, etc.)

---

## 📝 Notas Importantes

⚠️ **Sincronización obligatoria**: Todas las entradas asíncronas (como BTND) pasan por un sincronizador de 2 flip-flops para evitar metaestabilidad.

⚠️ **Debouncing necesario**: Los botones mecánicos generan rebotes de 10-20 ms. El diseño implementa un debouncer de ~5 ms para filtrarlos.

⚠️ **Formato de trama fijo**: La trama UART es de 10 bits: START(0) + 8 DATOS (LSB primero) + STOP(1)

⚠️ **Estado de reposo**: La línea TX permanece en '1' cuando no hay transmisión activa.

⚠️ **Detección de flancos**: La transmisión se dispara únicamente con el flanco ascendente del botón (transición 0→1).

---

## 👨‍🏫 Información del Curso

**Asignatura**: 30315 - Electrónica Digital (EDIG)
**Laboratorio**: Lab 3 - Transmisor UART
**Plataforma**: Basys3 (Artix-7 XC7A35T)


---

*Última actualización: Febrero 2026*

Para más información, consulta el [Plan de Pruebas Detallado](doc/TEST_PLAN.md).
