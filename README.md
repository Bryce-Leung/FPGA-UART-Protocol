# **FPGA UART Protocol**

Authors:
[Bryce Leung](https://github.com/Bryce-Leung),
[Sahaj Singh](https://github.com/SatireSage)

UART Protocol made for Altera DE2-115 FPGA in VHDL

# Contents:

- [General Design Overview](#General-Design-Overview)
  - [How to Use](#How-to-Use)
- [UART Controller](#UART-Controller)
  - [Baud Rate Generation](#Baud-Rate-Generation)
  - [Data Framing](#Data-Framing)
  - [Error Detetion and Correction](#Error-Detetion-and-Correction)
  - [Handshaking](#Handshaking)
- [TX](#TX)
  - [TX Testbench](#TX-Testbench)
- [RX](#RX)
  - [RX Testbench](#RX-Testbench)

# **FPGA UART Protocol Documentation:**

## **General Design Overview**

The UART system is designed with the following subsystems:

- Baud Rate Generation
- Data Framing
- Error Detection and Correction
- Handshaking

These subsystems work together to enable synchronous data transmission between UART devices.

### **How to Use**

Steps to prepare the FPGA UART Module:

1. Clone this repository to your local machine.
2. Ensure that you have the necessary FPGA development tools installed.
3. Open the project with your preferred FPGA development environment.
4. Run the provided testbenches to verify the functionality of the UART protocol.
5. Synthesize the design and program your FPGA board with the generated bitstream.

Operating the Module:

- To use the UART Module use the onboard **switches 0 to 7** and then press **Key 0** to **transmit the data**.
- To set the BAUD Rate use the onboard **switches 0 to 17** and then press **Key 1** to **set the baud rate**.
- To **reset the module** simply press **Key 3**.

## **UART Controller**

---

The UART controller is the central component of the system, managing the communication between the transmitter and receiver modules. The controller uses a state machine to handle the different stages of data transmission and reception.

### Baud Rate Generation

The baud rate generation subsystem is responsible for synchronizing the transmitter and receiver modules. It calculates the number of clock cycles required to send one bit of data and ensures that both devices operate at the same baud rate.

### Data Framing

The data framing subsystem adds start and stop bits to each data byte for synchronization purposes. It also adds a parity bit for error detection and correction.

### Error Detection and Correction

The error detection and correction subsystem uses parity checking to ensure the integrity of the transmitted data. If an error is detected, the system can perform error correction or request retransmission of the data.

### Handshaking

The handshaking subsystem controls the flow of data between devices.

<p align="center"><img width="900" alt="Controller Datapath" src="https://github.com/Bryce-Leung/FPGA-UART-Protocol/assets/74439762/e4dc9ed9-b872-41ff-911b-2d08bc8f5458"></p>

<p align="center"><img width="900" alt="UART Controller FSM" src="https://github.com/Bryce-Leung/FPGA-UART-Protocol/assets/74439762/cc615c0c-fd58-4119-8c93-189fc531fd8c"></p>

## **TX**

---

The transmitter module is responsible for sending data serially to the receiver. It includes the following components:

- Data framing
- Baud rate generation
- Handshaking

<p align="center"><img width="900" alt="TX Datapath" src="https://github.com/Bryce-Leung/FPGA-UART-Protocol/assets/74439762/e4bd9da2-f107-4a8e-a36e-a3bcc590030b"></p>

<p align="center"><img width="900" alt="TX FSM" src="https://github.com/Bryce-Leung/FPGA-UART-Protocol/assets/74439762/34255100-4467-4b7f-aebe-d78556784ec4"></p>

### **TX Testbench**

The TX testbench verifies the functionality of the transmitter module. It simulates various scenarios, including different data patterns, baud rates, and handshaking methods.

## **RX**

---

<p align="center"><img width="900" alt="RX Datapath" src="https://github.com/Bryce-Leung/FPGA-UART-Protocol/assets/74439762/98efb400-ac64-4c70-9354-a6581d9e5414"></p>

<p align="center"><img width="900" alt="RX FSM" src="https://github.com/Bryce-Leung/FPGA-UART-Protocol/assets/74439762/d96716f0-babf-415f-8cbb-4e5cbdab7934"></p>

#### **RX Testbench**

The testbench for the RX component tested different cases of recieving correct and incorrect data.
