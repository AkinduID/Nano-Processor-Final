# 4-bit Nano Processor

[![VHDL](https://img.shields.io/badge/VHDL-007ACC?style=flat&logoColor=white)](https://en.wikipedia.org/wiki/VHDL)
[![Vivado](https://img.shields.io/badge/Xilinx%20Vivado-FF0000?style=flat&logoColor=white)](https://www.xilinx.com/products/design-tools/vivado.html)
[![FPGA](https://img.shields.io/badge/Basys3%20FPGA-0066CC?style=flat&logoColor=white)](https://digilent.com/reference/programmable-logic/basys-3/start)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

A fully functional **4-bit single-cycle processor** designed in VHDL, synthesised on a **Basys3 (Artix-7) FPGA**. Built as part of CS1050 – Computer Organisation and Digital Design, this project implements a minimal but complete instruction set covering data movement, arithmetic, bitwise negation, and conditional branching, with output visualised on the board's 7-segment display.

<img src="https://github.com/AkinduID/Nano-Processor-Final/blob/main/block_diagram.jpg" alt="Block diagram of the Nano Processor">

---

## Table of Contents

1. [Features](#features)
2. [Repository Structure](#repository-structure)
3. [Architecture Overview](#architecture-overview)
4. [Instruction Set Architecture (ISA)](#instruction-set-architecture-isa)
5. [Component Reference](#component-reference)
6. [Demo Program](#demo-program)
7. [Simulation & Testing](#simulation--testing)
8. [FPGA Deployment](#fpga-deployment)
9. [Pin Constraints](#pin-constraints)

---

## Features

- **4-bit data path** with 8 general-purpose registers (R0–R7)
- **4-instruction ISA**: `MOV`, `ADD`, `NEG`, `JZR`
- **Single-cycle execution** – no pipeline stages
- **8-instruction program ROM** (hardcoded counter demo)
- **Conditional jump** based on zero flag (`JZR`)
- **7-segment display** output for real-time result observation
- **Clock divider** scales 100 MHz FPGA oscillator to ≈1.67 Hz for human-visible operation
- **14 testbenches** covering every sub-component

---

## Repository Structure

```
Nano-Processor-Final/
├── README.md                          # This file
├── block_diagram.jpg                  # System-level block diagram
├── Basys3Labs.xdc                     # Vivado pin-constraint file for Basys3
├── Nano Processor Final.xpr           # Vivado project file
└── Nano Processor Final.srcs/
    ├── sources_1/new/                 # RTL source files (18 VHDL files)
    │   ├── System.vhd                 # Top-level FPGA wrapper
    │   ├── Nano_Processor.vhd         # Processor top-level
    │   ├── Program_ROM.vhd            # 8×12-bit instruction memory
    │   ├── Instruction_Decoder.vhd    # Control logic / opcode decoder
    │   ├── Register_Bank.vhd          # 8×4-bit register file
    │   ├── AS_4bit.vhd                # 4-bit Arithmetic/Shift Unit
    │   ├── Adder_3bit.vhd             # 3-bit PC incrementer
    │   ├── FA.vhd                     # Full Adder
    │   ├── HA.vhd                     # Half Adder
    │   ├── Mux_8_to_1_4bit.vhd        # 8-to-1 multiplexer (4-bit)
    │   ├── Mux_2_to_1_4bit.vhd        # 2-to-1 multiplexer (4-bit)
    │   ├── Mux_2_to_1_3bit.vhd        # 2-to-1 multiplexer (3-bit, PC select)
    │   ├── Decoder_3_to_8.vhd         # 3-to-8 register-enable decoder
    │   ├── Decoder_2_to_4.vhd         # 2-to-4 opcode decoder
    │   ├── Reg_4bit.vhd               # 4-bit register with enable & reset
    │   ├── Reg_3bit.vhd               # 3-bit program counter register
    │   ├── Slow_Clock.vhd             # Clock frequency divider
    │   └── LUT_16_7.vhd               # 4-bit → 7-segment display LUT
    └── sim_1/new/                     # Testbench files (14 VHDL files)
        ├── Nano_Processor_TB.vhd
        ├── System_TB.vhd
        ├── Instruction_Decoder_TB.vhd
        ├── Register_Bank_TB.vhd
        ├── AS_4bit_TB.vhd
        ├── Mux_8_to_1_4bit_TB.vhd
        ├── Mux_2_to_1_4bit_TB.vhd
        ├── Mux_2_to_1_3bit_TB.vhd
        ├── Reg_4bit_TB.vhd
        ├── Reg_3bit_TB.vhd
        ├── Adder_3bit_TB.vhd
        ├── Decoder_2_to_4_TB.vhd
        ├── Decoder_3_to_8_TB.vhd
        └── Slow_Clock_TB.vhd
```

---

## Architecture Overview

The processor follows a classic **fetch → decode → execute** single-cycle model. All combinational paths complete within one clock period; registers and the PC update on the rising edge.

```
              ┌──────────────────────────────────────────────────────────┐
              │                  Nano_Processor (top-level)              │
              │                                                          │
  Reset ──►   │  ┌─────────┐    ┌─────────────┐    ┌────────────────┐  │
  Clk   ──►   │  │  Reg_3bit│───►│ Program_ROM │───►│ Instr_Decoder  │  │
              │  │  (PC)   │◄──┐│  (8×12-bit) │    │  (Control)    │  │
              │  └─────────┘   ││             │    └───────┬────────┘  │
              │                ││             │            │           │
              │  ┌──────────┐  ││             │     Ctrl signals       │
              │  │Adder_3bit│──┘│             │            │           │
              │  │  (PC+1)  │   └─────────────┘            ▼           │
              │  └──────────┘                      ┌────────────────┐  │
              │        ▲                           │ Register_Bank  │  │
              │        │   ┌──────────────┐        │  (8 × 4-bit)   │  │
              │  ┌─────┴───┤Mux_2_to_1_3b │        │  R0 = const 0  │  │
              │  │         │  (PC select) │        └───────┬────────┘  │
              │  │  Jmp ──►│              │                │           │
              │  │         └──────────────┘       Mux_A / Mux_B       │
              │  │                                        │            │
              │  │                              ┌─────────▼──────────┐ │
              │  │                              │     ASU_4bit        │ │
              │  │                              │  (Add / Negate)    │ │
              │  │                              └──────┬─────────────┘ │
              │  │        ┌─────────────────┐          │               │
              │  │        │ Mux_2_to_1_4bit │◄─────────┘               │
              │  │        │ (Imm / ASU out) │                          │
              │  │        └────────┬────────┘                          │
              │  │                 │  Write-back                       │
              │  │                 └──────────────► Register_Bank      │
              │  └─────────────────────────────────────────────────────│
              │                                                        │
  Zero ◄──────│  (combinational flag from ASU)                        │
  Overflow ◄──│  (carry-out from ASU)                                 │
  R7 ◄────────│  (direct register output)                             │
              └────────────────────────────────────────────────────────┘
```

### Datapath Widths

| Signal              | Width   | Notes                              |
|---------------------|---------|------------------------------------|
| Program Counter     | 3 bits  | Addresses 8 instructions (0–7)     |
| Instruction word    | 12 bits | opcode[2] + regA[3] + regB[3] + val[4]      |
| Register data       | 4 bits  | R0–R7                              |
| ASU operands/result | 4 bits  |                                    |
| Jump address        | 3 bits  | Embedded in instruction bits [2:0] |

---

## Instruction Set Architecture (ISA)

### Instruction Encoding (12 bits)

```
 11 10 | 9  8  7 | 6  5  4 | 3  2  1  0
  OP   |  Reg A  |  Reg B  |   Value
```

| Field   | Bits     | Description                                      |
|---------|----------|--------------------------------------------------|
| `OP`    | [11:10]  | 2-bit opcode                                     |
| `Reg A` | [9:7]    | Destination register address (and source for NEG)|
| `Reg B` | [6:4]    | Source register B (used by ADD)                  |
| `Value` | [3:0]    | 4-bit immediate (MOV) or jump target bits [2:0]  |

### Instruction Summary

| Opcode | Mnemonic        | Operation                                  | Flags updated |
|--------|-----------------|---------------------------------------------|--------------|
| `00`   | `ADD Ra, Rb`    | `Ra ← Ra + Rb`                              | Zero, Overflow |
| `01`   | `NEG Ra`        | `Ra ← 0 - Ra` (two's complement negation)  | Zero, Overflow |
| `10`   | `MOV Ra, #imm`  | `Ra ← imm` (4-bit immediate)               | –             |
| `11`   | `JZR Ra, addr`  | `if Ra == 0: PC ← addr`                    | –             |

> **R0** is hardwired to `0000` and cannot be written; it serves as a zero constant useful for `JZR`.

### Flags

| Flag       | Source              | Description                                  |
|------------|---------------------|----------------------------------------------|
| `Zero`     | ASU combinational   | High when last ADD/NEG result is `0000`      |
| `Overflow` | ASU carry-out       | High when addition produces a carry out of bit 3 |

---

## Component Reference

### System.vhd — FPGA Top-Level Wrapper

Instantiates the processor, clock divider, and 7-segment LUT for FPGA deployment.

| Port          | Direction | Width | Description                      |
|---------------|-----------|-------|----------------------------------|
| `Clk`         | in        | 1     | 100 MHz board oscillator         |
| `Reset_Push`  | in        | 1     | Active-high synchronous reset (button) |
| `Seg_7`       | out       | 7     | 7-segment display cathode outputs |
| `Reg_7`       | out       | 4     | R7 value mirrored to LEDs        |
| `Overflow`    | out       | 1     | Carry flag                       |
| `Zero`        | out       | 1     | Zero flag                        |

---

### Nano_Processor.vhd — Processor Top-Level

Wires all sub-components together into the fetch/decode/execute datapath.

| Port       | Direction | Width | Description                   |
|------------|-----------|-------|-------------------------------|
| `Clk`      | in        | 1     | Processor clock               |
| `Reset`    | in        | 1     | Synchronous reset (PC → 0, registers → 0) |
| `Zero`     | out       | 1     | Zero flag from last ASU result|
| `Overflow` | out       | 1     | Carry-out from last ASU result|
| `R7`       | out       | 4     | Value of register R7          |

---

### Program_ROM.vhd — Instruction Memory

8-entry × 12-bit read-only look-up table. The address is the 3-bit program counter value.

| Port           | Direction | Width | Description               |
|----------------|-----------|-------|---------------------------|
| `Mem_Select`   | in        | 3     | Program counter address   |
| `Instruction`  | out       | 12    | Fetched instruction word  |

---

### Instruction_Decoder.vhd — Control Unit

Decodes a 12-bit instruction into control signals that drive the datapath.

| Port           | Direction | Width | Description                                  |
|----------------|-----------|-------|----------------------------------------------|
| `Instruction`  | in        | 12    | Raw instruction word                         |
| `Jmp_Reg_Val`  | in        | 4     | Value of register Ra (for JZR zero-check)    |
| `Reg_En`       | out       | 3     | Destination register address                 |
| `Load_Selector`| out       | 1     | `0` = write immediate; `1` = write ASU result|
| `Immediate_Val`| out       | 4     | 4-bit immediate value                        |
| `Mux_A`        | out       | 3     | Register select for ASU operand A            |
| `Mux_B`        | out       | 3     | Register select for ASU operand B            |
| `AS_Sel`       | out       | 1     | `0` = ADD; `1` = NEG (negate B)              |
| `Jmp_Flag`     | out       | 1     | `1` = take sequential path; `0` = jump       |
| `Jmp_Address`  | out       | 3     | Branch target address                        |

---

### Register_Bank.vhd — Register File

8 × 4-bit register file. R0 is permanently `0000`; R1–R7 are writable.

| Port        | Direction | Width | Description                               |
|-------------|-----------|-------|-------------------------------------------|
| `En`        | in        | 1     | Global write enable                       |
| `Clk`       | in        | 1     | Clock (write on rising edge)              |
| `Res`       | in        | 1     | Synchronous reset – clears all registers  |
| `Reg_En`    | in        | 3     | 3-bit address of register to write        |
| `Reg_Input` | in        | 4     | Data to write                             |
| `R0`–`R7`   | out       | 4 ea. | Current value of each register            |

---

### AS_4bit.vhd — Arithmetic/Shift Unit

Performs 4-bit addition or two's complement negation using four cascaded full adders.

| Port    | Direction | Width | Description                                     |
|---------|-----------|-------|-------------------------------------------------|
| `A`     | in        | 4     | Operand A                                       |
| `B`     | in        | 4     | Operand B                                       |
| `Ctrl`  | in        | 1     | `0` = compute `A + B`; `1` = compute `A - B`   |
| `S`     | out       | 4     | Result                                          |
| `C_out` | out       | 1     | Carry out (Overflow)                            |
| `Zero`  | out       | 1     | High when `S == 0000`                           |

When `Ctrl = 1`, each bit of B is XOR-inverted and `Ctrl` is injected as the initial carry, implementing two's complement subtraction (`A + (~B) + 1`).

---

### Adder_3bit.vhd — PC Incrementer

Adds a fixed constant of `001` to the 3-bit program counter to compute `PC + 1`.

---

### Mux_8_to_1_4bit.vhd — Register Read Multiplexer

Two instances exist in the processor (`Mux_A`, `Mux_B`), each independently selecting one of the eight register outputs as an ASU operand.

---

### Mux_2_to_1_3bit.vhd — PC Source Multiplexer

Selects between `PC + 1` (sequential) and the decoded jump address based on `Jmp_Flag`.

---

### Mux_2_to_1_4bit.vhd — Write-Back Multiplexer

Selects between the 4-bit immediate value and the ASU result as the data written to the register file.

---

### Decoder_3_to_8.vhd — Register Enable Decoder

Converts the 3-bit destination register address from the instruction into a one-hot 8-bit enable vector applied to the register bank. Composed of two `Decoder_2_to_4` instances.

---

### Decoder_2_to_4.vhd — Opcode Decoder

Converts the 2-bit opcode into a one-hot 4-bit operation-enable vector (`add_en`, `neg_en`, `mov_en`, `jnz_en`). Note: `jnz_en` is the internal VHDL signal name; the corresponding instruction `JZR` jumps when the register value **is** zero.

---

### Reg_4bit.vhd — 4-bit General Register

Synchronous register with active-high enable and reset. Captures `D` on the rising edge only when `En = 1`; resets to `0000` when `Res = 1`.

---

### Reg_3bit.vhd — 3-bit Program Counter Register

Synchronous register (no enable; always updates). Captures `D` on every rising edge; resets to `000` when `Res = 1`.

---

### Slow_Clock.vhd — Clock Divider

Divides the 100 MHz board clock to approximately 1.67 Hz by toggling the output every 30,000,000 input cycles. Used only in the `System` wrapper for FPGA demonstration.

---

### LUT_16_7.vhd — 7-Segment Display Encoder

Maps a 4-bit value (0–15) to a 7-bit active-low cathode pattern for the Basys3 seven-segment display.

---

### FA.vhd / HA.vhd — Adder Primitives

| Component | Inputs          | Outputs           |
|-----------|-----------------|-------------------|
| HA        | A, B            | Sum, Carry        |
| FA        | A, B, Carry_in  | Sum, Carry_out    |

The Full Adder is composed of two Half Adders plus an OR gate for carry.

---

## Demo Program

The ROM contains a fixed counter program that accumulates R1, R2, and R3 into R7 in a loop, demonstrating all four instruction types.

| Address | Binary            | Assembly       | Description                       |
|---------|-------------------|----------------|-----------------------------------|
| 0       | `100010000001`    | `MOV R1, 1`   | Load constant 1 into R1           |
| 1       | `100100000010`    | `MOV R2, 2`   | Load constant 2 into R2           |
| 2       | `100110000011`    | `MOV R3, 3`   | Load constant 3 into R3           |
| 3       | `001110010000`    | `ADD R7, R1`  | R7 ← R7 + R1                      |
| 4       | `001110100000`    | `ADD R7, R2`  | R7 ← R7 + R2                      |
| 5       | `001110110000`    | `ADD R7, R3`  | R7 ← R7 + R3                      |
| 6       | `110000000110`    | `JZR R0, 6`   | R0 is always 0 → infinite self-loop at address 6 |
| 7       | `000000000000`    | *(unreachable)*| NOP / padding                     |

**Execution trace (first iteration):**  
`R7 = 0 → 1 → 3 → 6`, then the `JZR R0, 6` at address 6 keeps jumping back to itself because R0 is permanently zero, freezing the display at `R7 = 6` (shown as `6` on the 7-segment display).

> To run a different program, update the `Instruction_ROM` constant inside `Program_ROM.vhd`.

---

## Simulation & Testing

The project includes **14 VHDL testbenches**, one per RTL component. All testbenches are located in `Nano Processor Final.srcs/sim_1/new/`.

### Running Simulations in Vivado

1. Open `Nano Processor Final.xpr` in Xilinx Vivado.
2. In the **Flow Navigator**, expand **Simulation** and click **Run Simulation → Run Behavioral Simulation**.
3. Select the desired testbench from the simulation sources tree.
4. The waveform viewer will open; verify signal values against expected outputs.

### Key Test Scenarios

| Testbench                    | Validates                                          |
|------------------------------|----------------------------------------------------|
| `Nano_Processor_TB.vhd`      | Full fetch/decode/execute cycle; counter program   |
| `System_TB.vhd`              | End-to-end system including clock divider and 7-seg|
| `Instruction_Decoder_TB.vhd` | Correct control signal generation for all opcodes  |
| `Register_Bank_TB.vhd`       | Read/write, R0 immutability, synchronous reset     |
| `AS_4bit_TB.vhd`             | ADD and NEG operations, Zero and Overflow flags    |

---

## FPGA Deployment

### Prerequisites

- Xilinx Vivado (≥ 2020.x recommended)
- Digilent Basys3 board (Artix-7 XC7A35T)
- Digilent USB cable

### Steps

1. **Open the project** – launch Vivado and open `Nano Processor Final.xpr`.
2. **Run Synthesis** – *Flow Navigator → Synthesis → Run Synthesis*.
3. **Run Implementation** – *Flow Navigator → Implementation → Run Implementation*.
4. **Generate Bitstream** – *Flow Navigator → Program and Debug → Generate Bitstream*.
5. **Program the device** – connect the Basys3 board, open *Hardware Manager*, click **Program Device**, and select the generated `.bit` file.

### Board Operation

| Control        | Board Element | Function                             |
|----------------|---------------|--------------------------------------|
| `Clk`          | W5 (100 MHz)  | System clock – `Slow_Clock` toggles every 30,000,000 cycles to produce ≈1.67 Hz |
| `Reset_Push`   | T18 (BTNC)    | Resets PC and all registers to 0     |
| `Seg_7[6:0]`   | 7-seg display | Shows current R7 value in hex        |
| `Reg_7[3:0]`   | LEDs LD3–LD0  | Binary value of R7                   |
| `Zero`         | LED LD15      | Illuminated when last result is zero |
| `Overflow`     | LED LD14      | Illuminated on arithmetic carry-out  |

---

## Pin Constraints

Pin assignments are defined in `Basys3Labs.xdc`. Key mappings:

| Signal        | FPGA Pin | Board Resource         |
|---------------|----------|------------------------|
| `Clk`         | W5       | 100 MHz oscillator     |
| `Reset_Push`  | T18      | Centre push-button     |
| `Seg_7[0]`–`[6]` | various | 7-segment cathodes  |
| `Reg_7[0]`–`[3]` | various | On-board LEDs        |

Refer to `Basys3Labs.xdc` for the complete pin-to-signal mapping.
