# ECE4300_Execute Pipeline Stage

This repository contains the Verilog design source files and simulation test code for the Execute stage of a MIPS-like processor pipeline.

## Verilog Code Analysis

The design implements the Execute (EX) stage, integrating an Arithmetic Logic Unit (ALU), an adder for branch address calculation, a register destination multiplexer, and an EX/MEM pipeline latch to pass computed values and control signals to the next stage.

### Key Components

- **`execute.v`**: The main top-level module connecting all the components in the Execute stage.
- **`adder.v`**: Computes the branch target address (`npc_plus_offset`), adding the next PC and the sign-extended immediate offset.
- **`alu.v` & `alu_control.v`**: Perform arithmetic operations like ADD and LW address calculation based on the `alu_op` and `funct` fields. 
- **`bottom_mux.v`**: Chooses the destination register (`rd` or `rt`) depending on the `regdst` control signal.
- **`ex_mem.v`**: Pipeline registers capturing and synchronizing signals out of the Execute stage.

## Simulation Timing Diagram and Test Cases

![Simulation Timeline](executeTB_waveform.png)

### Test Case 1: R-Type Instruction (ADD)
**Timing Window:** 10ns to 30ns (Calculations) -> 30ns (Latched Output)  
In this scenario, the CPU is performing an arithmetic operation using two registers (15 + 25).

#### The Inputs (The "Set-up")
* **Registers:** `rdata1` (Index 5) is 15 and `rdata2` (Index 6) is 25.
* **ALU Choice:** `alusrc` (Index 12) is 0, telling the Mux to pick the register value (25) instead of the immediate value (4).
* **The Operation:** `alu_op` (Index 10) is -2 (which is binary 10 for R-type) and `funct` (Index 11) is -32 (binary 100000 for ADD).
* **Destination:** `regdst` (Index 13) is 1, selecting `instr_1511` (Index 9) which is register 3 as the destination.

#### The Results (At the 30ns Clock Tick)
* **ALU Result:** `alu_result_out` (Index 17) updates to 40 (15 + 25).
* **Branch Adder:** `adder_out` (Index 16) updates to 104 (100 + 4).
* **Destination Register:** `muxout_out` (Index 19) locks in as register 3.

### Test Case 2: I-Type Instruction (Load Word/Immediate)
**Timing Window:** 30ns to 50ns (Calculations) -> 50ns (Latched Output)  
Here, the CPU switches to logic used for memory access or "Add Immediate." It calculates an address by adding a register to a constant offset (15 + 8).

#### The Inputs (The "Change")
* **The Switch:** `alusrc` (Index 12) flips to 1. This tells the ALU: "Ignore register 2, use the `s_extend` value instead".
* **Immediate Value:** `s_extend` (Index 7) has updated to 8.
* **The Operation:** `alu_op` (Index 10) changes to 0 (binary 00), which defaults the ALU to "Addition" for address calculation.
* **New Destination:** `regdst` (Index 13) flips to 0, selecting `instr_2016` (Index 8) which is register 4 as the destination.

#### The Results (At the 50ns Clock Tick)
* **ALU Result:** `alu_result_out` (Index 17) transitions to 23 (15 from register + 8 from immediate).
* **Branch Adder:** `adder_out` (Index 16) updates to 108 (100 + 8).
* **Destination Register:** `muxout_out` (Index 19) updates to register 4.

