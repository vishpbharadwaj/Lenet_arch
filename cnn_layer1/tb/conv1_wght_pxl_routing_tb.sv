
module conv1_wght_pxl_routing_tb; 

localparam OPERAND_WIDTH = 19;
localparam OUTPUT_WIDTH  = 22;
localparam NUM_FILT_ROWS = 5;
localparam DATA_WIDTH = 64;
localparam PXL_WIDTH = 8;
localparam WEIGHT_WIDTH = 8;
localparam NUM_PXL = DATA_WIDTH/PXL_WIDTH;
localparam NUM_WGHT_PER_FILT_ROW = 5;
localparam FILT_INST = 4; //No. of times a filter is operated on the row data
localparam NUM_FILT = 6;
localparam NUM_PXL_PER_FILT = 5;
localparam PXL_DATA_PER_FILT_STRD = FILT_INST * NUM_FILT_ROWS * NUM_PXL_PER_FILT;
localparam WEIGHT_WIDTH_BYTE = 40; //5 Bytes, i.e. 5x5 filter


reg signed [NUM_FILT_ROWS-1 : 0][DATA_WIDTH-1 : 0]                         intm_row_data_i;//5 rows of 64 bits
reg signed [NUM_FILT-1 : 0][NUM_FILT_ROWS-1 : 0][WEIGHT_WIDTH_BYTE-1 : 0]  filt_wght_matx_i; // i.e. 4 x 5*5

wire signed [PXL_DATA_PER_FILT_STRD-1 : 0][PXL_WIDTH-1 : 0]                pxl_data_out_o; //pixel data 100x8 i.e including 4 inst of data
wire signed [NUM_FILT-1 : 0][NUM_WGHT_PER_FILT_ROW*NUM_FILT_ROWS-1 : 0][WEIGHT_WIDTH-1 : 0]      filt_wght_matx_o; //weight data 6x5*5

integer i;


conv1_wght_pxl_routing #(
                      NUM_FILT_ROWS,
                      DATA_WIDTH,
                      PXL_WIDTH,
                      WEIGHT_WIDTH,
                      NUM_PXL,
                      NUM_WGHT_PER_FILT_ROW,
                      FILT_INST, //No. of times a filter is operated on the row data
                      NUM_FILT,
                      NUM_PXL_PER_FILT,
                      PXL_DATA_PER_FILT_STRD,
                      WEIGHT_WIDTH_BYTE
)
uut(
    .intm_row_data_i    (intm_row_data_i),
    .filt_wght_matx_i   (filt_wght_matx_i),
    .pxl_data_out_o     (pxl_data_out_o),
    .filt_wght_matx_o   (filt_wght_matx_o)
);





initial begin
	#5
//	intm_row_data_i = '{64'haabbccddeeff0011, 64'h0000000000000000, 64'h1111111111111111,64'h1100110011001100,64'h1111111111111111};
	intm_row_data_i[0]= 64'haabbccddeeff0011;
    intm_row_data_i[1]= 64'h0000000000000000;
	intm_row_data_i[2]= 64'h1111111111111111;
	intm_row_data_i[3]= 64'h1010101010101010;
	intm_row_data_i[4]= 64'h1111111111111111;

//	#10
//	filt_wght_matx_i = {
//
//	#10
       // for(j=0 ;j<4 ;j++) begin;
    for (i=0 ; i<6 ;i++) begin
	    filt_wght_matx_i[i][0]= 40'haa00110011;
	    filt_wght_matx_i[i][1]= 40'hbb00110011;
	    filt_wght_matx_i[i][2]= 40'hcc00110011;
	    filt_wght_matx_i[i][3]= 40'hdd00110011;
	    filt_wght_matx_i[i][4]= 40'hee00110011;
	 end   
    
  #100 $finish;

end  
	
endmodule  
