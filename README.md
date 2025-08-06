
# FPGA Frogger Game – DE1-SoC Edition 🐸🚗

A Verilog-based implementation of the classic **Frogger** game on the **DE1-SoC FPGA board** using a 16x16 LED matrix display. This project was developed by Morris Huang and Hudson Wong.

---

## 🕹️ Gameplay Overview

- **Objective**: Guide the frog across a road full of cars to reach the top of the screen.
- **Lose Condition**: Colliding with a red (car) LED.
- **Win Condition**: Reach the topmost row and press `UP`.
- **Difficulty**: Speeds up after each win. Resets on game over.
- **Controls**:
  - `KEY[0]` – Right
  - `KEY[1]` – Up
  - `KEY[2]` – Down
  - `KEY[3]` – Left
  - `SW[9]` – Reset

---

##  System Architecture

```

+-------------------+

| DE1\_SoC              |
| --------------------- |
| - clock\_divider      |
| - LEDDriver           |
| - frog\_LED Grid      |
| - frog\_LED\_start    |
| - crossy\_road        |
| - seeded\_LFSR        |
| - comparator          |
| - user\_input         |
| - victory logic       |
| - testbench           |
| +-------------------+ |

```

###  Core Modules

| Module          | Function                                                  |
|-----------------|-----------------------------------------------------------|
| `frog_LED`      | FSM for frog movement across matrix                       |
| `crossy_road`   | FSM for car movement (red LEDs shift right)              |
| `user_input`    | Button debounce – registers only on rising edge          |
| `clock_divider` | Provides clocks of varying frequencies                    |
| `seeded_LFSR`   | Random car spawn logic                                    |
| `comparator`    | Compares LFSR output to threshold                         |
| `three_bit_counter` | Increments difficulty up to 8 levels                 |
| `victory`       | Detects win/loss and triggers playfield reset            |
| `LEDDriver`     | Drives 16x16 dual-color LED matrix via GPIO              |

---

##  Testbenches Included

Each module has its own testbench verifying:

- FSM transitions
- Clock/reset behavior
- Boundary conditions
- Debounce correctness
- Randomness from LFSR
- Playthrough simulation in `DE1_SoC_testbench`

---

##  How It Works

- **Movement** is processed via FSMs in each grid tile.
- **Red LEDs** represent cars spawned randomly by LFSRs and move right.
- **Green LEDs** represent the frog; only one tile is green at a time.
- **Win logic** increases difficulty via a 3-bit counter.
- **Game resets** on collision or after reaching the top.

---

## 🔧 Build and Run Instructions

1. Open your **Intel Quartus** project with a DE1-SoC setup.
2. Add all Verilog source files:
   - `DE1_SoC.sv`
   - All module files (e.g., `frog_LED.sv`, `user_input.sv`, etc.)
3. Compile and program onto the FPGA.
4. Use the physical board’s:
   - **KEYs** for control
   - **SW[9]** for reset
   - **GPIO_1** for LED matrix output
5. Run testbenches using **ModelSim** for simulation.

---

## 👥 Authors

- **Morris Huang**
- **Hudson Wong**

June 2025

---

## Repository Structure

## 📂 Repository Structure

```text
.
├── DE1_SoC.sv              # Top-level module
├── frog_LED.sv             # FSM logic for frog tiles
├── crossy_road.sv          # FSM logic for moving cars
├── user_input.sv           # Debouncing for key inputs
├── clock_divider.sv        # Clock divider logic
├── seeded_LFSR.sv          # Random number generation
├── comparator.sv           # LFSR threshold comparison
├── three_bit_counter.sv    # Difficulty counter
├── victory.sv              # Win/loss/reset controller
├── LEDDriver.sv            # 16x16 LED matrix driver
├── *_testbench.sv          # Testbenches for each module
└── README.md               # Project overview


##  Demo 

Youtube Link:  
