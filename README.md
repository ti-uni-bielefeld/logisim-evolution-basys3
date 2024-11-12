# logisim-evolution-basys3

A set of scripts, manuals and patches to make synthesizing and downloading circuits from [Logisim Evolution](https://github.com/logisim-evolution/logisim-evolution) onto the [Basys3 FPGA board](https://digilent.com/reference/programmable-logic/basys-3/start) on Linux easier and more seamless, including an exemplary setup with a display and a keyboard.

![Example Setup](example_setup/images/setup.jpg)

## Features
- FPGA support for Keyboard and Video components (see [Keyboard and Video components](#fpga-support-for-the-keyboard-and-video-components))
- [User Manual](user_manual/USER_MANUAL.md) with instructions on how to synthesize and download circuits to the Basys3 FPGA board
- Installer for Java, Vivado and Logisim Evolution into a directory of your choice
- Instructions for an exemplary setup of the Basys3 board with a display and a keyboard (see [Example Setup](#example-setup))
- Additional patches onto Logisim Evolution 3.9.0 for easier to synthesizing and downloading of circuits to the Basys3 FPGA board. These patches include:
    - Timer component (see [Timer component](user_manual/USER_MANUAL.md#timer-component))
    - Only show Basys3 board in FPGA menu
    - Automatically set Vivado tool path
    - Fix for asynchronous RAM

## Example Setup

This repo was developed with a specific exemplary setup in mind which is described in more detail [here](example_setup/README.md). However, the specific parts are not necessary, any setup with a Basys3 FPGA board, a display and a keyboard should work.

## Installation
1. Get a copy of this repository by doing either of the following:
    - 1. Download the repository as a ZIP file with this link: https://github.com/ti-uni-bielefeld/logisim-evolution-basys3/archive/refs/heads/main.zip
      2. Extract it into your home directory (not the install directory) and change into the extracted directory

   Or
    - Clone this repository into your home directory (not the install directory) and change into the cloned directory:
        ```bash
        $ git clone https://github.com/ti-uni-bielefeld/logisim-evolution-basys3
        $ cd logisim-evolution-basys3
        ```
3. If Vivado should be installed and linked with Logisim (this is only necessary if you want to synthesize and download circuits onto the Basys3 board and if Vivado isn't already installed in the install directory), download Vivado 2023.2 from https://account.amd.com/en/forms/downloads/xef.html?filename=FPGAs_AdaptiveSoCs_Unified_2023.2_1013_2256_Lin64.bin (requires an account)
4. Run the install script and provide the install directory and the Vivado installer file (if downloaded in the previous step):
    ```bash
    $ ./install.sh <install directory> [Vivado 2023.2 installer file]
    ```
    Where `<install directory>` is the directory where Java, Vivado and Logisim Evolution will be installed (e.g. `/etc/opt/logisim-evolution-basys3`) and `[Vivado 2023.2 installer file]` is the optional path to the downloaded Vivado 2023.2 installer file (e.g. `~/Downloads/FPGAs_AdaptiveSoCs_Unified_2023.2_1013_2256_Lin64.bin`).

### Common Errors

#### Error when downloading to the Basys3 board

On some systems the download to the Basys3 board may fail with the error message `There is no current hw_target.` If this is the case for you, the udev rules in `<install directory>/Xilinx/Vivado/2023.2/data/xicom/cable_drivers/lin64/install_script/install_drivers/52-xilinx-digilent-usb.rules` need to be installed. You can do this either manually by copying that file into `/etc/udev/rules.d/` and setting the permissions to 644, or run the install script as root:
```bash
$ sudo <install directory>/Xilinx/Vivado/2023.2/data/xicom/cable_drivers/lin64/install_script/install_drivers/install_drivers
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
After installing, you can run Logisim Evolution by running the run script in the installed directory:
```bash
$ <install directory>/run.sh
```
For example:
```bash
$ /etc/opt/logisim-evolution-basys3/run.sh
```
For more information on how to synthesize and download circuits to the Basys3 FPGA board, see the [User Manual](user_manual/USER_MANUAL.md), which also gets installed into the install directory.

## Example Circuit

An example circuit that demonstrates the usage of the Basys3 board and the Keyboard, Video and Timer components can be found in the `example.circ` file in the install directory.

The example circuit simply reads values from the Keyboard component and displays them bitwise on the Video component and lets a pixel in the bottom middle of the screen blink every second between red and green.

Simply run Logisim Evolution as described above and open the `example.circ` file and follow the instructions in the [User Manual](user_manual/USER_MANUAL.md) to synthesize and download the circuit to the Basys3 FPGA board.

## FPGA support for the Keyboard and Video components

The Keyboard and Video components are not supported for synthesis by stock Logisim Evolution, so they have been patched to be supported.

### Keyboard component

The FPGA support for the Keyboard component is implemented to accept a PS/2 keyboard input. The Keyboard works exactly the same on an FPGA as it does in simulation. It can be mapped to the internal PS/2 controller of the Basys3 board to use it with a USB keyboard connected to the Basys3 board.

### Video component

The FPGA support for the Video component is implemented to output a VGA signal (1024x600 at 61Hz). Some functions of the Video component are not supported on the FPGA, which are:
- There is no cursor on the VGA output, regardless of the cursor setting in the Video component.
- Only the following color models are supported:
    - 888 RGB (24 bit)
    - 555 RGB (15 bit)
    - 565 RGB (16 bit)
    - 8-Color RGB (3 bit)
    - Grayscale (4 bit)

The Video component can be mapped to the internal VGA controller of the Basys3 board to use it with a VGA monitor connected to the Basys3 board.

## Authors and Contributors

Most of the work was done by [Jonas Keller](https://github.com/jonicho) on behalf of the [Computer Engineering Group (AG Technische Informatik) of Bielefeld University](https://www.ti.uni-bielefeld.de/).

The example setup was designed by [Klaus Kulitza](https://ekvv.uni-bielefeld.de/pers_publ/publ/PersonDetail.jsp?personId=5314955) on behalf of the [Computer Engineering Group (AG Technische Informatik) of Bielefeld University](https://www.ti.uni-bielefeld.de/).

The patches for the [Keyboard](install_files/logisim-evolution-patches/keyboard-fpga-support.patch) and [Video](install_files/logisim-evolution-patches/video-fpga-support.patch) components contain modified code from DigiKey ([Keyboard](https://forum.digikey.com/t/ps-2-keyboard-to-ascii-converter-vhdl/12616) and [Video](https://forum.digikey.com/t/vga-controller-vhdl/12794)).

The project was initiated and supervised by [Prof. Dr.-Ing. Ralf Möller](https://www.ti.uni-bielefeld.de/html/people/moeller/). Software and setup are used for the course ["Technische Informatik" (Computer Engineering)](https://www.ti.uni-bielefeld.de/html/teaching/) at the Faculty of Technology, Bielefeld University. Financial support was kindly provided by the "Qualitätsfonds Lehre" (Teaching Quality Fund) of Bielefeld University.

## Bugs and Feature Requests

If you find any bugs or have any feature requests, please open an issue on the [Issues](https://github.com/ti-uni-bielefeld/logisim-evolution-basys3/issues) page.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
