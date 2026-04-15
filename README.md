# ECE4300_Execute_JesusR  
**Execute Stage of Pipeline for ECE4300 – Computer Architecture**

## Overview
This project implements the **Execute (EX) stage** of a MIPS-style pipelined processor.  
The Execute stage performs arithmetic and logical operations, selects operands, computes branch addresses, and forwards results to the next pipeline stage (EX/MEM).

---

## Architecture

### ALU Control Logic
![ALU Control Table](https://github.com/user-attachments/assets/8a3eaffb-58a4-4ffd-8cbd-89cf55a22e49)

The ALU control unit determines which operation the ALU performs based on:
- `ALUOp` (from the control unit)
- `funct` field (derived from `s_extendout[5:0]` in this design)

| ALUOp | Instruction Type | ALU Operation |
|------|----------------|--------------|
| 00   | LW / SW        | ADD          |
| 01   | BEQ            | SUBTRACT     |
| 10   | R-type         | Based on funct |

**Funct Field Mapping:**
- `100000` → ADD  
- `100010` → SUB  
- `100100` → AND  
- `100101` → OR  
- `101010` → SLT  

---

### Execute Stage Datapath
![Execute Stage Diagram](https://github.com/user-attachments/assets/1e6fbba9-31ff-4ab2-82d1-5ef41768742c)

The datapath includes:
- Adder for branch target calculation  
- ALU for arithmetic and logic operations  
- Multiplexers for operand and destination selection  
- ALU control logic  
- EX/MEM pipeline register  

---

## Design Description

The Execute stage combines multiple modules into a single datapath:

### 1. Adder
Computes the branch target address:

adder_out = npcout + s_extendout
---

### 2. ALU Operand Selection (Top MUX)
Selects the second ALU operand:
- `rdata2` when `alusrc = 0`
- `s_extendout` when `alusrc = 1`
funct = s_extendout[5:0]
---

### 3. ALU
Performs operations based on the control signal:
- ADD
- SUB
- AND
- OR
- SLT

Also generates a **zero flag**, used for branch decisions.

---

### 4. ALU Control
Generates a 3-bit control signal for the ALU using:
- `aluop`
- `s_extendout[5:0]` (used as the funct field in this design)

---

### 5. Destination Register Selection (Bottom MUX)
Selects which register will receive the result:
- `instrout_1511` (rd) when `regdst = 1`
- `instrout_2016` (rt) when `regdst = 0`

---

### 6. EX/MEM Pipeline Register
Stores results on the rising clock edge and forwards them to the next stage:
- ALU result  
- Branch target address  
- Zero flag  
- Register data (`rdata2out`)  
- Destination register  
- Control signals (`wb_ctl`, `m_ctl`)  

---

## Key Design Note

In this implementation, the **funct field is taken from `s_extendout[5:0]`** instead of a separate instruction input.  

This differs from a standard MIPS implementation, but matches the provided datapath diagram where:



---

## Testbench Behavior

The testbench verifies:
- R-type operations (ADD, SUB, AND, OR, SLT)
- Branch comparisons (BEQ)
- Immediate operations (ADDI-style behavior)

### Important:
- R-type instructions use:
alusrc = 0
- Immediate instructions use:
alusrc = 1
- Function codes are encoded in:
s_extendout[5:0]

## Summary

This Execute stage correctly:
- Performs ALU operations based on control logic  
- Selects correct operands and destination registers  
- Computes branch addresses  
- Passes results through a pipeline register  

The design demonstrates a working implementation of the EX stage in a pipelined processor datapath.
