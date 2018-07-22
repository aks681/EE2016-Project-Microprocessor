# EE2016 Project Microprocessor

The project was to create a microprocessor simulation from scratch, in Verilog HDL, and have it recognize some basic commands and simulate the results.
As an added bonus, an "assembler" was also created with C++ which would take in human readable user inputs (like ADD) and convert it to binary commands which was then stored in output.txt. These commands can then be used as is by the written Verilog program to simulate the results.

The commands accepted by assembler.cpp are:

  - MOV Ri(from)  Rj(to)
  - LDI Ri(address of internal register) value
  - ILDI R(Rx) value
  - LOAD Ri(address of external ram from which to read) Xj(Address of internal register to which to write)
  - ST Ri(read address of internal register) Rj(write address of register in external ram)
  - INC Ri (increment value in internal register)
  - DEC Ri (increment value in internal register)
  - BRNZ location (Branch if not zero)
  - BRNN location (Branch if not negative)
  - BRNO location (Branch if not overflow)
  - BRNU location (Branch if not underflow (shift right underflow) )
  - END (end the program)

Following ALU operations read from memory locations Ri and Rj and store result in Rk

  - ADD Ri Rj Rk
  - SUB Ri Rj Rk
  - AND Ri Rj Rk
  - OR Ri Rj Rk
  - SLEFT Ri Rj Rk
  - SRIGHT Ri Rj Rk

## Structure
microprocessor.v and progmemory.v contain the modules required for running the full verilog project.
assembler.cpp modifies this progmemory.v by changing values stored in progmemory depending on assembly code given. 
