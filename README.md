# Sequential Digital Combination Lock (FSM & Datapath)

A synthesizable Verilog implementation of a **Sequential Digital Electronic Combination Lock** utilizing a partitioned **Datapath + Finite State Machine (FSM) Control Path** architecture.

---

## 📌 Table of Contents
- [Overview](#overview)
- [Architecture & Design](#architecture--design)
  - [Datapath (`data_path.v`)](#datapath-data_pathv)
  - [Control Path (`control_path.v`)](#control-path-control_pathv)
  - [Top-Level Testbench (`lock_tb.v`)](#top-level-testbench-lock_tbv)
- [State Transitions & Key Sequence](#state-transitions--key-sequence)
- [FSM State Diagram](#fsm-state-diagram)
- [Simulation & Verification](#simulation--verification)
- [Verilog Source Reference](#verilog-source-reference)
- [How to Run Simulation](#how-to-run-simulation)

---

## 📖 Overview

The digital combination lock operates on consecutive 2-bit security key matching. To ensure modular design and clean hardware synthesis, the design separates the comparison logic (**Datapath**) from sequence tracking and lock actuation (**Control Path**).

---

## 🏗 Architecture & Design

### Datapath (`data_path.v`)
- **Role:** Pure combinational comparison logic.
- **Parameters:**
  - `key1 = 2'b01`
  - `key2 = 2'b00`
  - `key3 = 2'b11`
- **Operation:** Selects expected key based on `key_sel[1:0]` and outputs `data_valid = 1` if `data == expected_key`.

### Control Path (`control_path.v`)
- **Role:** 4-state Finite State Machine tracking key entry progress.
- **States:**
  - `S0 (2'b00)`: Initial state, expects Key 1 (`key_sel = 2'b00`).
  - `S1 (2'b01)`: Key 1 matched, expects Key 2 (`key_sel = 2'b01`).
  - `S2 (2'b10)`: Key 2 matched, expects Key 3 (`key_sel = 2'b10`).
  - `S3 (2'b11)`: Unlocked state (`unlock = 1'b1`).
- **Reset Behavior:** Asynchronous reset (`rst`) clears state to `S0`. Any invalid key mismatch immediately forces the FSM back to `S0`.

### Top-Level Testbench (`lock_tb.v`)
- Generates clock (`always #5 clk = ~clk;`) and stimulus sequence.
- Verifies both valid unlock execution and invalid sequence rejection.

---

## 🔑 State Transitions & Key Sequence

| Stage | Current State | `key_sel` | Expected `data` | Match (`data_valid=1`) | Mismatch (`data_valid=0`) | `unlock` |
| :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **Stage 1** | `S0 (2'b00)` | `2'b00` | `2'b01` (Key 1) | Go to `S1` | Stay in `S0` | `0` |
| **Stage 2** | `S1 (2'b01)` | `2'b01` | `2'b00` (Key 2) | Go to `S2` | Reset to `S0` | `0` |
| **Stage 3** | `S2 (2'b10)` | `2'b10` | `2'b11` (Key 3) | Go to `S3` | Reset to `S0` | `0` |
| **Unlocked**| `S3 (2'b11)` | `2'b00` | Any | Stay in `S3` | Stay in `S3` | `1` |

---

## 📊 FSM State Diagram

```text
       +---------------------------------------------------------------+
       |                                                               |
       |  [data_valid == 0] (Wrong key)                                |
       v                                                               |
   +--------+     data_valid == 1     +--------+     data_valid == 1   +--------+     data_valid == 1     +--------+
-->|   S0   | ----------------------> |   S1   | --------------------> |   S2   | ----------------------> |   S3   |--+
   | (Init) |                         | (Key1) |                       | (Key2) |                         |(Unlock)|  |
   +--------+                         +--------+                       +--------+                         +--------+  |
       ^                                  |                                |                                  ^       |
       |      [data_valid == 0]           |      [data_valid == 0]         |                                  +-------+
       +----------------------------------+--------------------------------+                              (unlock = 1)
