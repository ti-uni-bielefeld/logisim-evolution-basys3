# logisim-evolution-basys3

A set of scripts, manuals and patches to make synthesizing and downloading circuits from [Logisim Evolution](https://github.com/logisim-evolution/logisim-evolution) onto the [Basys3 FPGA board](https://digilent.com/reference/programmable-logic/basys-3/start) on Linux easier and more seamless.

## Features
- Installs Java, Vivado and Logisim Evolution into a directory of your choice
- Script to start Logisim Evolution
- User Manual with instructions on how to synthesize and download circuits to the Basys3 FPGA board
- Additional patches onto Logisim Evolution 3.9.0 to make it easier to synthesize and download circuits to the Basys3 FPGA board. These patches include:
    - FPGA support for Keyboard and Video components (see [Keyboard and Video components](#keyboard-and-video-components))
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
3. Download Vivado 2023.2 from https://account.amd.com/en/forms/downloads/xef.html?filename=FPGAs_AdaptiveSoCs_Unified_2023.2_1013_2256_Lin64.bin (requires an account) (not necessary if Vivado is already installed)
4. Run the install script:
    ```bash
    $ ./install.sh <install directory> [Vivado 2023.2 installer file]
    ```
    Where `<install directory>` is the directory where Java, Vivado and Logisim Evolution will be installed (e.g. `/etc/opt/logisim-evolution-basys3`) and `[Vivado 2023.2 installer file]` is the path to the downloaded Vivado 2023.2 installer file (e.g. `~/Downloads/FPGAs_AdaptiveSoCs_Unified_2023.2_1013_2256_Lin64.bin`).

    Note: When updating or when Vivado is already installed for another reason, providing the Vivado installer file is optional.

### Common Errors

#### Error when downloading to the Basys3 board

On some systems the download to the Basys3 board may fail with the error message `There is no current hw_target.` If this is the case for you, the udev rules in `<install directory>/Xilinx/Vivado/2023.2/data/xicom/cable_drivers/lin64/install_script/install_drivers/52-xilinx-digilent-usb.rules` need to be installed. You can do this either manually by copying that file into `/etc/udev/rules.d/` and setting the permissions to 644, or run the install script as root:
```bash
$ sudo <install directory>/Xilinx/Vivado/2023.2/data/xicom/cable_drivers/lin64/install_script/install_drivers/install_digilent.sh
```

#### Error when Creating Vivado project

On some systems the following error may occur when Logisim Evolution tries to create a Vivado project:
```
application-specific initialization failed: couldn't load file "librdi_commontasks.so": libtinfo.so.5: cannot open shared object file: No such file or directory
```

This error can be fixed by installing the `libtinfo5` package:
```bash
$ sudo apt install libtinfo5
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

## Keyboard and Video components

The Keyboard and Video components are not supported for synthesis by stock Logisim Evolution, so they have been patched to be supported. 

### Keyboard component

The FPGA support for the Keyboard component is implemented to accept a PS/2 keyboard input. The Keyboard works exactly the same on an FPGA as it does in simulation. It can be mapped to the internal PS/2 controller of the Basys3 board to use it with a USB keyboard connected to the Basys3 board.

### Video component

The FPGA support for the Video component is implemented to output a VGA signal (1024x600 at 61Hz). Some functions of the Video component are not supported on the FPGA, which are:
- There is no cursor on the VGA output, regardless of the cursor setting in the Video component.
- The reset input does not do anything, as the RAM on the FPGA cannot be reset all at once. Instead, the display has to be manually cleared by writing to Video component.
- Only the following color models are supported:
    - 888 RGB (24 bit)
    - 555 RGB (15 bit)
    - 565 RGB (16 bit)
    - 8-Color RGB (3 bit)
    - Grayscale (4 bit)

The Video component can be mapped to the internal VGA controller of the Basys3 board to use it with a VGA monitor connected to the Basys3 board.
