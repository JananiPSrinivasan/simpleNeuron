# Neuron Hardware Module

This project implements a hardware model of a **neuron** using Verilog. The neuron uses a **Multiply-and-Accumulate (MAC)** logic to compute weighted inputs, adds a bias, and finally multiplies the result with an activation factor to produce the output.

---

## Neuron Logic

A neuron performs the following operations:

temp = (input0 * weight0 + input1 * weight1 + input2 * weight2) + bias
y = activation_factor * temp


This is logically split into **three main stages**:

1. **Multiply** each input with its corresponding weight.
2. **Accumulate** the products in hardware.
3. **Add** the bias to the final accumulated result.

Finally, the result (`temp`) is passed through an **activation stage**, where it is multiplied by an activation factor to produce the final output `y`.

---

## Hardware Mapping

To implement this behavior in hardware, the design uses **four key modules**:

- `multiplier`: Multiplies each input with its weight.
- `accumulator`: Accumulates the product of inputs and weights over multiple cycles or instances.
- `adder`: Adds the bias to the accumulated result.
- `output`: Multiplies the final value with an activation factor (scaled activation output).

Each of these modules can be instantiated and pipelined to build more complex multi-neuron or multi-layer networks.

