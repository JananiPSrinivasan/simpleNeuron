# RTL Design of a Configurable Neuron with Formal Verification

This project implements a **simple neuron** module in **SystemVerilog**. The neuron performs a weighted sum of input values, adds a bias, and passes the result through a **tanh activation function** using a lookup table (LUT) and using CORDIC algorithm. The design is modular, parameterized, and supports **formal verification** to ensure correctness.

---

## Problem Statement

Design and implement a neuron module in SystemVerilog that:
- Accepts a vector of input values and a corresponding set of weights (including a bias)
- Computes the weighted sum of inputs + bias
- Passes the result through a tanh function implemented via a ROM-based LUT / cordic algorithm
- Outputs an 8-bit activated result (range: 0 to 255)
- Supports formal verification using industry-standard tools

---
