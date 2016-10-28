
.SILENT:

all: synthesize

synthesize:
	yosys -q -p "synth_ice40 -blif $(PROJECT).blif" $(PARTS)

bin: synthesize
	arachne-pnr -d $(DEVICE) -P $(FOOTPRINT) -p wiring.pcf $(PROJECT).blif -o $(PROJECT).txt
	icepack $(PROJECT).txt $(PROJECT).bin

simulate: bin
	iverilog -o $(PROJECT) $(PARTS)
	vvp $(PROJECT)

upload: bin
	iceprog -S $(PROJECT).bin

clean:
	rm -f $(PROJECT).bin $(PROJECT).txt $(PROJECT).blif $(PROJECT)

