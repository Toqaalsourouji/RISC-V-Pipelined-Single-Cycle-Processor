# RISC-V FPGA Implementation

This repository contains the implementation of a RISC-V processor designed for the **CSCE 3301 – Computer Architecture** course. The project targets the **Nexys A7 trainer kit** and supports the RV32I instruction set with pipeline implementation and hazard handling.

## Project Overview
- **Processor**: RISC-V RV32I (Base Integer Instruction Set)  
- **Pipeline**: 3-stage pipelined with every-other-cycle instruction issuing  
- **Memory**: Single-ported, byte-addressable unified memory for both instructions and data  
- **Hazard Handling**: Structural hazards managed by issuing instructions every two cycles (CPI = 2)  
- **Unsupported Instructions**: ECALL (halts execution), EBREAK, PAUSE, FENCE, and FENCE.TSO (treated as no-ops)  



