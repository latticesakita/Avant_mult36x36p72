
# mult36x36p72 — 36×36 Multiplier + 72‑bit Post Adder Using Lattice Avant DSP Blocks

[![License](https://img.shields.io/badge/license-Lattice%20Reference%20Design-blue.svg)]()
[![Verilog](https://img.shields.io/badge/HDL-Verilog-orange.svg)]()
[![FPGA](https://img.shields.io/badge/FPGA-Lattice%20Avant-green.svg)]()
[![Build Status](https://img.shields.io/badge/build-passing-brightgreen.svg)]()
[![Contributions Welcome](https://img.shields.io/badge/contributions-welcome-ff69b4.svg)]()

This repository provides a Verilog implementation of a **36‑bit × 36‑bit multiplier** combined with a **72‑bit post adder**, constructed using **four Lattice Avant MULTADDSUB18X18A DSP blocks**.

## Features
- Four‑stage cascaded DSP implementation
- 72‑bit post adder with 73‑bit final output
- Signed/unsigned operand control
- Flexible pipelining parameters
- Active‑low asynchronous reset

## Block Architecture
```
A[35:0] ─┬─────────────┐
B[35:0] ─┼─────────────┤   4 × MULTADDSUB18X18A (m0..m3)  ───► result[72:0]
C[71:0] ─┴───────┐     │
                 ▼     ▼
    m0: A[17:0]  × B[17:0]  + C[17:0]
    m1: A[35:18] × B[17:0]
    m2: A[17:0]  × B[35:18] + C[35:18]
    m3: A[35:18] × B[35:18] + C[72:36]
```

## File Structure
- `mult36x36p72.v` — main module

## License
This module incorporates content governed by the **Lattice Reference Design License Agreement**.

## Contributing
Issues and PRs are welcome.
