# logisim-evolution-basys3

A set of scripts, manuals and patches to make synthesizing and downloading circuits from [Logisim Evolution](https://github.com/logisim-evolution/logisim-evolution) onto the [Basys3 FPGA board](https://digilent.com/reference/programmable-logic/basys-3/start) on Linux easier and more seamless.

## Logisim Features
Newest development version of Logisim Evolution with newest features and bug fixes with the following additional patches:
- FPGA support for Keyboard and Video components
- Only show Basys3 board in FPGA menu
- Fix for asynchronous RAM
- Automatically set Vivado tool path

## Installation
1. Clone this repository into the directory where you want to install Logisim Evolution and Vivado and change into the cloned directory:
    ```bash
    $ git clone https://github.com/jonicho/logisim-evolution-basys3
    $ cd logisim-evolution-basys3
    ```
2. Download the "Linux Self Extracting Web Installer" from https://www.xilinx.com/support/download.html (requires an account)
3. Install Vivado by running the install script and providing the filename to the downloaded installer (requires an account):
    ```bash
    $ ./install_vivado.sh <Vivado installer file>
    ```
4. Install Java by running the install script:
    ```bash
    $ ./install_java.sh
    ```
5. Install Logisim Evolution by running the install script:
    ```bash
    $ ./install_logisim-evolution.sh
    ```

## Usage
After installing, you can run Logisim Evolution by running the run script in the `logisim-evolution` directory:
```bash
$ ./logisim-evolution/run.sh
```
For more information on how to synthesize and download circuits to the Basys3 FPGA board, see the [User Manual](USER_MANUAL.md).

## Example
An example circuit that demonstrates the usage of the Basys3 board and the Keyboard and Video components can be found in the `example.circ` file. Simply run Logisim Evolution as described above and open the `example.circ` file and follow the instructions in the [User Manual](USER_MANUAL.md) to synthesize and download the circuit to the Basys3 FPGA board.

## Updating
To update Logisim Evolution, simply clean this repository, pull the latest changes and run the install script again:
```bash
$ git reset --hard
$ git clean -fd
$ git pull
$ ./install_logisim-evolution.sh
```
