# UART Protocol Implementation in Verilog

## Overview
This project implements a complete **UART (Universal Asynchronous Receiver Transmitter) Protocol** in **Verilog HDL**. The design includes separate modules for **UART Transmitter (TX)**, **UART Receiver (RX)**, and a **Baud Rate Generator**, integrated through a top module.

The project demonstrates serial communication using UART protocol with configurable baud-rate ticks and successful transmission/reception of 8-bit data.

---

## Features
- UART Transmitter (TX)
- UART Receiver (RX)
- Baud Rate Generator
- Configurable serial communication
- Modular Verilog design
- Synthesizable RTL
- Top-level integration of all UART blocks

---

## Project Structure

```text
UART_Protocol/
│── transmitter.v              # UART transmitter module
│── Receiver.v                 # UART receiver module
│── baud_rate_generater.v      # Baud rate generator
│── top_module.v               # Top-level integration module
│── README.md                  # Project documentation
```

---

## UART Frame Format

This implementation follows the standard UART frame structure:

```text
| Start Bit | Data Bits (8-bit) | Stop Bit |
|     0     |      LSB First    |     1    |
```

### Transmission Process
1. UART line stays in **Idle State (Logic 1)**.
2. Transmission begins with a **Start Bit (0)**.
3. **8-bit data** is transmitted **LSB first**.
4. Transmission ends with a **Stop Bit (1)**.

---

## Modules Description

### 1. UART Transmitter (`transmitter.v`)
Responsible for serially transmitting input data.

#### Inputs
- `clk` → System clock
- `rst` → Reset signal
- `tx_start` → Starts transmission
- `tx_din[7:0]` → Input data
- `s_tick` → Baud rate tick

#### Outputs
- `tx` → Serial output line
- `tx_done_tick` → Transmission complete signal

#### Functionality
- Sends start bit
- Serializes 8-bit parallel data
- Sends stop bit
- Generates completion tick

---

### 2. UART Receiver (`Receiver.v`)
Responsible for receiving serial UART data.

#### Inputs
- `clk`
- `rst`
- `rx` → Serial input
- `s_tick` → Baud rate tick

#### Outputs
- `dout[7:0]` → Received parallel data
- `rx_done_tick` → Reception complete signal

#### Functionality
- Detects start bit
- Samples incoming serial data
- Converts serial to parallel data
- Detects stop bit
- Generates receive completion signal

---

### 3. Baud Rate Generator (`baud_rate_generater.v`)
Generates timing signals for UART communication.

#### Inputs
- `clk`

#### Outputs
- `tx_enb`
- `rx_enb`

#### Functionality
- Generates baud-rate ticks
- Synchronizes transmitter and receiver timing

---

### 4. Top Module (`top_module.v`)
Integrates transmitter, receiver, and baud rate generator.

#### Connections
- Transmitter connected with baud-rate enable
- Receiver connected with baud-rate enable
- Unified UART operation

---

## Simulation Flow

### UART Transmission
```text
tx_start = 1
        ↓
Start Bit Generated
        ↓
8-bit Data Transmission
        ↓
Stop Bit Sent
        ↓
tx_done_tick = 1
```

### UART Reception
```text
Start Bit Detection
        ↓
Data Sampling
        ↓
8-bit Data Collection
        ↓
Stop Bit Validation
        ↓
rx_done_tick = 1
```

---

## Tools Used
- **Verilog HDL**
- **Xilinx Vivado**
- **RTL Schematic Viewer**
- **Simulation & Synthesis**

---

## Future Improvements
- Configurable baud rate
- UART parity bit support
- Multiple stop bits
- FIFO buffering
- APB/AXI interface integration
- FPGA hardware implementation

---

## Learning Outcomes
Through this project, I learned:
- Finite State Machine (FSM) design
- Serial communication protocols
- UART frame structure
- RTL design in Verilog
- Module integration
- Timing synchronization using baud generators
- FPGA synthesis and debugging

---

## Author
**Shlok Mahajan**  
Automation & Robotics Engineer | Digital Design Enthusiast | Verilog & VLSI Learner
