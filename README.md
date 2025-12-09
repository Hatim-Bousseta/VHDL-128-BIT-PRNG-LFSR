#  128-bit Pseudo-Random Number Generator (PRNG)



This repository contains the VHDL implementation of a **Pseudo-Random Number Generator (PRNG)** based on a **128-bit Linear Feedback Shift Register (LFSR)**.

This module is designed for hardware applications (FPGA) where high-speed, resource-efficient key generation is required, such as in the key expansion stage for AES encryption on embedded systems (e.g., drones).





The generator uses the **Fibonacci Configuration** for its feedback mechanism.



| Feature | Detail |
| :--- | :--- |
| **Type** | 128-bit LFSR (Fibonacci Configuration) |
| **Feedback Taps** | $127, 125, 100, 98$ |
| **Feedback Equation** | $f = a_{127} \oplus a_{125} \oplus a_{100} \oplus a_{98}$ |
| **Clock (`clk`)** | Synchronous |
| **Reset (`rst`)** | Asynchronous (Priority reset) |
| **Static Seed (Testing)** | `x"00112233445566778899aabbccddeeff"` |

### Hardware Architecture

The design consists of a 128-bit shift register, an XOR logic network, and an implicit multiplexer that handles the priority reset logic.

**Architectural Diagram:**
![LFSR Architecture Diagram](<img width="1356" height="571" alt="GIT_sgn" src="https://github.com/user-attachments/assets/6c537472-8efd-49c3-a406-945456b01be9" />
) 


* **Asynchronous Reset:** When `rst = '1'`, the register is immediately forced to the `DEFAULT_SEED` value, bypassing the clock.
* **Synchronous Operation:** When `rst = '0'`, the register shifts and inserts the calculated feedback bit (`v_feedback`) only on the **rising edge** of the `clk`.

---



The Testbench is used to prove that the LFSR loads the seed correctly and generates the sequence as expected.




### How to Run Simulation (ModelSim)

1.  Clone this repository.
2.  Compile both `PRNG_128.vhd` and `tb_PRNG_128.vhd`.
3.  Run the simulation on the testbench entity: `tb_PRNG_128`.
4.  Run the simulation for sufficient time (e.g., `run 300 ns`) to observe the key sequence.

---

## 🛑 Security Note

This LFSR implements a basic **PRNG**. While efficient in hardware, it is **not cryptographically secure (CSPRNG)** on its own. For production cryptographic applications, this module should be seeded by a **TRNG (True Random Number Generator)** and/or integrated into a more complex, non-linear architecture to prevent sequence prediction.
