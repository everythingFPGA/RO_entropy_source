# Ring Oscillator Entropy Source

Vivado 2025.2

Zedboard - Zynq 7020

---

## Project Setup Guide

### 1. Clone the Repository
Use:
```sh
git clone https://github.com/everythingFPGA/RO_entropy_source.git
```

or if you have ssh key configured:

```sh
git clone git@github.com:everythingFPGA/RO_entropy_source.git
```
### 2. Customize the Project
 - For a `different Vivado version`, change the first line of [hog.conf](./Top/RO_entropy_source/hog.conf)

 - For a `different board`, change **BOARD_PART** and **PART** parameters in [hog.conf](./Top/RO_entropy_source/hog.conf)

*This may not work with all the boards but is worth trying..*

### 3. Create the Vivado Project

Make sure vivado is sourced. Generate the Vivado project with:
```sh
./Hog/Do CREATE RO_entropy_source
```
The Vivado project will be created inside the `Projects` directory.