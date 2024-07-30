# logisim-evolution-basys3

A set of scripts, manuals and patches to make synthesizing and downloading circuits from [Logisim Evolution](https://github.com/logisim-evolution/logisim-evolution) onto the [Basys3 FPGA board](https://digilent.com/reference/programmable-logic/basys-3/start) on Linux easier and more seamless.

## Installation

1. Clone this repository into the directory where you want to install Logisim Evolution and Vivado and change into the cloned directory:
    ```bash
    $ git clone https://github.com/jonicho/logisim-evolution-basys3
    $ cd logisim-evolution-basys3
    ```
2. Download the "Linux Self Extracting Web Installer" from https://www.xilinx.com/support/download.html (requires an account)
3. Install Vivado by running the install script and providing the path to the downloaded installer (requires an account):
    ```bash
    $ ./install_vivado.sh <path to Vivado installer>
    ```
4. Install Logisim Evolution by running the install script:
    ```bash
    $ ./install_logisim-evolution.sh
    ```

## Usage
After installing, you can run Logisim Evolution by running the run script in the `logisim-evolution` directory:
```bash
$ ./logisim-evolution/run.sh
```
For more information on how to synthesize and download circuits to the Basys3 FPGA board, see the [User Manual](USER_MANUAL.md).

## Updating
To update Logisim Evolution, pull the latest changes from the repository and run the install script again:
```bash
$ git pull
$ ./install_logisim-evolution.sh
```
