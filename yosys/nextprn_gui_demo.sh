git clone https://github.com/YosysHQ/nextpnr.git
cd /nextpnr/ice40/examples/blinky
./blinky.sh
nextpnr-ice40 --json blinky.json --pcf blinky.pcf --asc blinky.asc --gui
