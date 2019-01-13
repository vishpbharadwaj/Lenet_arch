# Lenet_arch
System verilog implementation of Lenet CNN architecture for mnist dataset

Working for CNN layer 1 of Lenet architecture, FCL layer1 needs testing

Directory structure:
- cnn_layer1
	- rtl:				has .sv source files
	- tb:				has .sv testbench files
	- hex_files:		hex files having weights and images for loading and calculation
	- mod_hex_files:	hex files having weights and images for loading and calculation
	- build:			for compile and elab
	- tools:			for synthesis

- fcl_layer1
	- rtl:				has .sv source files
	- tb:				has .sv testbench files
	- hex_files:		hex files having weights and images for loading and calculation
	- mod_hex_files:	hex files having weights and images for loading and calculation
	- build:			for compile and elab

- images
	- contains images for Readme file