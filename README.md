# Digital Alarm Clock

## Project Overview

This project involves designing and implementing a digital alarm clock using the BASYS-3 FPGA board. The project was completed as part of the Digital Design 1 course at The American University in Cairo, under the supervision of Dr. Mohamed Shalan. The goal was to create a functional and user-friendly alarm clock utilizing the BASYS-3 board's peripherals.

## Contributors

- **Aly Elaswad (900225517)**
- **Islam Abdeen (900225835)**
- **Ismail Sabry (900222002)**

## Project Description

The digital alarm clock project includes the following features and components:

### Hardware Components

- **LEDs:**
  - **LD0:** Blinks when the alarm is active, steady on in adjust mode.
  - **LD12:** Adjust the time hour parameter.
  - **LD13:** Adjust the time minutes parameter.
  - **LD14:** Adjust the alarm hour parameter.
  - **LD15:** Adjust the alarm minutes parameter.

- **Buttons:**
  - **BTNU:** Increment the selected parameter.
  - **BTND:** Decrement the selected parameter.
  - **BTNR:** Switch to the next parameter on the right.
  - **BTNL:** Switch to the next parameter on the left.
  - **BTNC:** Toggle between clock and adjust mode.

- **7-Segment Display:**
  - Displays the current time or alarm time in a 24-hour format.
  - The two leftmost digits show hours.
  - The two rightmost digits show minutes.
  - The decimal point represents the seconds; when on, it indicates the clock is enabled.

### Operating Modes

- **Clock/Alarm Mode (Default Mode):**
  - **LED LD0:** OFF
  - **Second Decimal Point:** Blinks at a frequency of 1Hz.
  - **Alarm Activation:** When the current time matches the set alarm time, LD0 blinks. Pressing any button stops the blinking.

- **Adjust Mode:**
  - **LED LD0:** ON
  - **Second Decimal Point:** Does not blink.
  - **Parameter Selection:** Use BTNL or BTNR to cycle through the parameters: "time hour", "time minute", "alarm hour", and "alarm minute".
  - **LED Indicators:** LD12, LD13, LD14, and LD15 indicate the current parameter being adjusted.

## Challenges Faced

- **Logisim Issues:** Difficulty saving large files; required multiple attempts to save.
- **Implementation Problems:** Issues with counter operations, FSM adjustments, and button press handling.
- **Data Retention:** Ensuring register values persisted across clock cycles.

## Milestones

### ASM Design
- Specified states: Clock, Time hour, Time minute, Alarm hour, and Alarm minute.
- Designed the block diagrams for the datapath and control unit based on ASM.

### Logisim Implementation
- Tested the circuit with a multiplexed display for seconds, minutes, and hours.
- Implemented a Clock-Alarm demo with counters and up-and-down increment logic.
<img width="990" src=(https://github.com/alyelaswad/Project1DigitalDesign/assets/124714695/454ce4ed-c2e8-47c3-a1cc-2c2a9bd504d6)>


### Vivado Implementation
- Developed Verilog modules: Debouncer, MUX4x1, Clock Divider, Synchronizer, Rising Edge Detector, Push Button, HoursMin Counter, and Digital Clock.
- Validated the design by ensuring correct time increment/decrement and proper alarm activation.
<img src=(https://github.com/alyelaswad/Project1DigitalDesign/assets/124714695/8b41730d-2ac3-4956-a462-94aa1537f645)>


## Conclusion

The digital alarm clock project successfully demonstrated the application of digital design principles using the BASYS-3 FPGA board. Despite various challenges, the project provided valuable hands-on experience in FPGA-based design and Verilog programming.


