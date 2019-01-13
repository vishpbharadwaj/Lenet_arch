# Lenet_arch
System verilog implementation of Lenet CNN architecture for mnist dataset

Working for CNN layer 1 of Lenet architecture, FCL layer1 needs testing

Lenet architecture from 28x28 image's first CNN layer implementation in hardware is 
![Alt text](images/lenet_microarch.png?raw=true "microarchitecture of CNN layer 1")

<br />
<br />

FSM of layer 1 having 3 states is 
![Alt text](images/states_diag.png?raw=true "FSM of CNN layer 1")

<br />
<br />

Implementation waveform of the design is
![Alt text](images/waveform_ops.png?raw=true "Waveform CNN layer 1")

<br />
<br />

Resutls in waveform of hardware simulation of CNN layer 1 is
![Alt text](images/conv1_pool.png?raw=true "Simulation waveform CNN layer 1")

<br />
<br />

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
