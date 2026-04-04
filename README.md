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
**Timing:** 10ns to 30ns  
The CPU computes an addition using two registers ($15 + 25$).

- **Setup:** Inputs `rdata1=15` and `rdata2=25` are provided. The signal `alusrc=0` passes the value in `rdata2` to the ALU. `alu_op=10` (R-type) and `funct=32` (ADD) configure the ALU for addition. The destination register is set to `3` (`regdst=1` selecting `instr_1511`).
- **Result (at 30ns):** The ALU successfully computes `40` (`alu_result_out`). The branch adder computes `104` (`adder_out`), and the destination register `3` is securely latched (`muxout_out`).

### Test Case 2: I-Type Instruction (Load Word/Immediate)
**Timing:** 30ns to 50ns  
The CPU calculates a memory address by adding a register to a constant offset ($15 + 8$).

- **Setup:** `alusrc=1` switches the ALU to accept the immediate value `s_extend=8`. `alu_op=0` sets the ALU logic to addition for address calculation. The destination changes to register `4` (`regdst=0` selecting `instr_2016`).
- **Result (at 50ns):** The calculated memory address is `23` (`alu_result_out`). The branch adder outputs `108` (`adder_out`), and the destination register updates to `4` (`muxout_out`).

