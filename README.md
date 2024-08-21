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
      2. Extract it into your home directory (not the install directory) and change into the extracted directory

   Or
    - Clone this repository into your home directory (not the install directory) and change into the cloned directory:
        ```bash
        $ git clone https://github.com/jonicho/logisim-evolution-basys3
        $ cd logisim-evolution-basys3
        ```
3. Download the "Linux Self Extracting Web Installer" from https://www.xilinx.com/support/download.html (requires an account) (not necessary if Vivado is already installed)
4. Run the install script:
    ```bash
    $ ./install.sh <install directory> [Vivado installer file]
    ```
    Where `<install directory>` is the directory where Java, Vivado and Logisim Evolution will be installed (e.g. `/etc/opt/logisim-evolution-basys3`) and `[Vivado installer file]` is the path to the downloaded Vivado installer file (e.g. `~/Downloads/FPGAs_AdaptiveSoCs_Unified_2024.1_0522_2023_Lin64.bin`).

    Note: When updating or when Vivado is already installed for another reason, providing the Vivado installer file is optional.

### Error when downloading to the Basys3 board

On some systems the download to the Basys3 board may fail with the error message `There is no current hw_target.` If this is the case for you, the udev rules in `<install directory>/Xilinx/Vivado/<installed Vivado version>/data/xicom/cable_drivers/lin64/install_script/install_drivers/52-xilinx-digilent-usb.rules` need to be installed. You can do this either manually by copying that file into `/etc/udev/rules.d/` and setting the permissions to 644, or run the following script as root:
```bash
# <install directory>/Xilinx/Vivado/<installed Vivado version>/data/xicom/cable_drivers/lin64/install_script/install_drivers/install_digilent.sh
```

## Updating
To update Logisim Evolution, simply follow the installation instructions again. The installation script will detect if Java or Vivado are already installed and only reinstall Logisim Evolution.

## Usage
After installing, you can run Logisim Evolution by running the run script in the `logisim-evolution` directory:
```bash
$ <install directory>/logisim-evolution/run.sh
```
For example:
```bash
$ /etc/opt/logisim-evolution-basys3/logisim-evolution/run.sh
```
For more information on how to synthesize and download circuits to the Basys3 FPGA board, see the [User Manual](USER_MANUAL.md), which also gets installed into the `logisim-evolution` directory.

## Example
An example circuit that demonstrates the usage of the Basys3 board and the Keyboard and Video components can be found in the `example.circ` file in the installed `logisim-evolution` directory. Simply run Logisim Evolution as described above and open the `example.circ` file and follow the instructions in the [User Manual](USER_MANUAL.md) to synthesize and download the circuit to the Basys3 FPGA board.
