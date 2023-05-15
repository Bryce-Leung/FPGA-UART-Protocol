# **FPGA UART Protocol**

Authors:
[Bryce Leung](https://github.com/Bryce-Leung),
[Sahaj Singh](https://github.com/SatireSage)

UART Protocol made for Altera DE2-115 FPGA in VHDL

# Contents:
- [General Design Overview](#General-Design-Overview)
- [UART Controller](#UART-Controller)
- [TX](#TX)
  - [TX Testbench](#TX-Testbench)
- [RX](#RX)
  - [RX Testbench](#RX-Testbench)

# **FPGA UART Protocol Documentation:**

### **General Design Overview**

### **UART Controller**
----
<p align="center"><img width="900" alt="Controller Datapath" src="https://github.com/Bryce-Leung/FPGA-UART-Protocol/assets/74439762/e4dc9ed9-b872-41ff-911b-2d08bc8f5458"></p>

<p align="center"><img width="900" alt="UART Controller FSM" src="https://github.com/Bryce-Leung/FPGA-UART-Protocol/assets/74439762/cc615c0c-fd58-4119-8c93-189fc531fd8c"></p>

### **TX**
----
<p align="center"><img width="900" alt="TX Datapath" src="https://github.com/Bryce-Leung/FPGA-UART-Protocol/assets/74439762/e4bd9da2-f107-4a8e-a36e-a3bcc590030b"></p>

<p align="center"><img width="900" alt="TX FSM" src="https://github.com/Bryce-Leung/FPGA-UART-Protocol/assets/74439762/34255100-4467-4b7f-aebe-d78556784ec4"></p>

#### **TX Testbench**
The testbench for the TX component tested the transmission of data, with the following waveform output obtained from Modelsim Altera:



### **RX**
----
<p align="center"><img width="900" alt="RX Datapath" src="https://github.com/Bryce-Leung/FPGA-UART-Protocol/assets/74439762/98efb400-ac64-4c70-9354-a6581d9e5414"></p>

<p align="center"><img width="900" alt="RX FSM" src="https://github.com/Bryce-Leung/FPGA-UART-Protocol/assets/74439762/d96716f0-babf-415f-8cbb-4e5cbdab7934"></p>

#### **RX Testbench**
The testbench for the RX component tested different cases of recieving correct and incorrect data, with the following waveform output obtained from Modelsim Altera:


