# logisim-evolution-basys3

A set of scripts, manuals and patches to make synthesizing and downloading circuits from [Logisim Evolution](https://github.com/logisim-evolution/logisim-evolution) onto the [Basys3 FPGA board](https://digilent.com/reference/programmable-logic/basys-3/start) on Linux easier and more seamless.

## Features
- Installs Java, Vivado and Logisim Evolution into a directory of your choice
- Script to start Logisim Evolution
- User Manual with instructions on how to synthesize and download circuits to the Basys3 FPGA board
- Additional patches onto Logisim Evolution 3.9.0 to make it easier to synthesize and download circuits to the Basys3 FPGA board. These patches include:
    - FPGA support for Keyboard and Video components
    - Only show Basys3 board in FPGA menu
    - Fix for asynchronous RAM
    - Automatically set Vivado tool path

## Installation
1. Get a copy of this repository by doing either of the following:
    - 1. Download the repository as a ZIP file with this link: https://github.com/jonicho/logisim-evolution-basys3/archive/refs/heads/main.zip
      2. Extract it into your home directory and change into the extracted directory

   Or
    - Clone this repository into your home directory and change into the cloned directory:
        ```bash
        $ git clone https://github.com/jonicho/logisim-evolution-basys3
        $ cd logisim-evolution-basys3
        ```
3. Download the "Linux Self Extracting Web Installer" from https://www.xilinx.com/support/download.html (requires an account) (not necessary if Vivado is already installed)
4. Run the install script and provide the filename to the downloaded installer and the directory where you want to install Java, Vivado and Logisim Evolution:
    ```bash
    $ ./install.sh <Install directory> [Vivado installer file]
    ```
    Note: When updating or when Vivado is already install for another reason, providing the vivado installer file is optional.

## Updating
To update Logisim Evolution, simply follow the installation instructions again. The installation script will detect if Java or Vivado are already installed and only reinstall Logisim Evolution.

## Usage
After installing, you can run Logisim Evolution by running the run script in the `logisim-evolution` directory:
```bash
$ ./logisim-evolution/run.sh
```
For more information on how to synthesize and download circuits to the Basys3 FPGA board, see the [User Manual](USER_MANUAL.md), which also gets installed into the `logisim-evolution` directory.

## Example
An example circuit that demonstrates the usage of the Basys3 board and the Keyboard and Video components can be found in the `example.circ` file in the installed `logisim-evolution` directory. Simply run Logisim Evolution as described above and open the `example.circ` file and follow the instructions in the [User Manual](USER_MANUAL.md) to synthesize and download the circuit to the Basys3 FPGA board.
