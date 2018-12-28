//


module conv1_wght_pxl_routing #(
                        parameter NUM_FILT_ROWS             = 5,
                        parameter DATA_WIDTH                = 64,
                        parameter PXL_WIDTH                 = 8,
                        parameter WEIGHT_WIDTH              = 8,
                        parameter NUM_PXL                   = DATA_WIDTH / PXL_WIDTH,
                        parameter NUM_WGHT_PER_FILT_ROW     = 5,
                        parameter FILT_INST                 = 4, //No. of times a filter is operated on the row data
                        parameter NUM_FILT                  = 6,
                        parameter NUM_PXL_PER_FILT          = 5,
                        parameter PXL_DATA_PER_FILT_STRD    = FILT_INST * NUM_FILT_ROWS * NUM_PXL_PER_FILT,
                        parameter WEIGHT_WIDTH_BYTE         = 40 //5 Bytes, i.e. 5x5 filter
)(
    input logic [NUM_FILT-1 : 0][PXL_DATA_PER_FILT_STRD-1 : 0][PXL_WIDTH-1 : 0]                                     intm_row_data_i, //5 rows of 64 bits
    input logic [NUM_FILT*FILT_INST-1 : 0][NUM_FILT_ROWS-1 : 0][WEIGHT_WIDTH_BYTE-1 : 0]                            filt_wght_matx_i, // i.e. 4 x 5*5
    output logic [NUM_FILT-1 : 0][PXL_DATA_PER_FILT_STRD-1 : 0][PXL_WIDTH-1 : 0]                                    pxl_data_out_o, //pixel data 6x100x8 i.e including 4 inst of data
    output logic [NUM_FILT-1 : 0][FILT_INST-1 : 0][NUM_WGHT_PER_FILT_ROW*NUM_FILT_ROWS-1 : 0][WEIGHT_WIDTH-1 : 0]   filt_wght_matx_o //weight data 6x5*5
);


//signals
logic [NUM_FILT_ROWS-1 : 0][NUM_PXL-1 : 0][PXL_WIDTH-1 : 0]                                  pxl_data_filt_3d; //slicing for data for the same filter to operate 4 times
logic [FILT_INST-1 : 0][NUM_FILT_ROWS-1 : 0][NUM_PXL_PER_FILT-1 : 0][PXL_WIDTH-1 : 0]        pxl_data_filt_4d; //slicing for data for the same filter to operate 4 times
logic [PXL_DATA_PER_FILT_STRD-1 : 0][PXL_WIDTH-1 : 0]                                        pxl_data_filt_2d; //pixel data 100x8 i.e including 4 inst of data

logic [NUM_FILT-1 : 0][FILT_INST-1 : 0][NUM_FILT_ROWS-1 : 0][WEIGHT_WIDTH_BYTE-1 : 0]                                   filt_wght_4d; //slicing [6][5][40] to [6][5][5][8]
logic [NUM_FILT-1 : 0][FILT_INST-1 : 0][NUM_FILT_ROWS-1 : 0][NUM_WGHT_PER_FILT_ROW-1 : 0][NUM_WGHT_PER_FILT_ROW-1 : 0]  filt_wght_5d; //slicing [6][5][40] to [6][5][5][8]
logic [NUM_FILT-1 : 0][FILT_INST-1 : 0][NUM_WGHT_PER_FILT_ROW*NUM_FILT_ROWS-1 : 0][WEIGHT_WIDTH-1 : 0]                  filt_wght_matx_sig; //weight data 6x5*5


/********************* Pixels for filters *************************/
//////pxl data 2d to 3d i.e. [5][64] = [5][8][8]
////genvar p,q;
////generate
////    for (p=0; p<NUM_FILT_ROWS; p=p+1) begin
////        for(q=0; q<NUM_PXL; q=q+1) begin
////            assign pxl_data_filt_3d[p][q] =  intm_row_data_i[p][NUM_PXL*(q+1) -1 : NUM_PXL*q];
////        end
////    end
////endgenerate
////
//////pxl data 3d to 4d i.e. [5][8][8] = [4][5][5][8]
////genvar m,n,o;
////generate
////    for (m=0; m<FILT_INST; m=m+1) begin
////        for(n=0; n<NUM_FILT_ROWS; n=n+1) begin
////            assign pxl_data_filt_4d[m][n] = pxl_data_filt_3d[n][m+4 : m]; //4 is used as we need 5 values
////        end
////    end
////endgenerate
////
////// pxl data has to be converted from 4d to 2d i.e [4][5][5][8] = [100][8]. reshape and concatenation
////genvar a,b,c;
////generate
////    for (a=0; a<FILT_INST; a=a+1) begin 
////        for (b=0; b<NUM_FILT_ROWS; b=b+1) begin
////            for (c=0; c<NUM_PXL_PER_FILT; c=c+1) begin
////                assign pxl_data_filt_2d[(NUM_FILT_ROWS*NUM_PXL_PER_FILT)*a + NUM_FILT_ROWS*b + c] = pxl_data_filt_4d[a][b][c];
////            end
////        end
////    end
////endgenerate
////
////// pxl data has to be converted from 2d to 3d i.e [100][8] = [6][100][8]
////genvar j;
////generate
////    for (j=0; j<NUM_FILT; j++) begin
////        assign pxl_data_out_o[j] = pxl_data_filt_2d;
////    end
////endgenerate
assign pxl_data_out_o = intm_row_data_i;


/****************** weights for convolution ***********************/
//converting [24][5][40] to [6][4][5][40]
genvar i_cnt, j_cnt;
generate
    for (i_cnt=0; i_cnt<NUM_FILT; i_cnt++) begin
        for (j_cnt=0; j_cnt<FILT_INST; j_cnt++) begin
            assign filt_wght_4d[i_cnt][j_cnt] = filt_wght_matx_i[FILT_INST*i_cnt+ j_cnt];
        end
    end
endgenerate


// converting [6][4][5][40] to [6][4][5][5][8]
genvar x,y,z,w;
generate
    for (x=0; x<NUM_FILT; x=x+1) begin 
        for (w=0; w<FILT_INST; w++) begin
            for (y=0; y<NUM_FILT_ROWS; y=y+1) begin
                for (z=0; z<NUM_WGHT_PER_FILT_ROW; z=z+1) begin
                    assign filt_wght_5d[x][w][y][z] = filt_wght_4d[x][w][y][(WEIGHT_WIDTH*(z+1) -1) : WEIGHT_WIDTH*z];
                end
            end
        end
    end
endgenerate

//converting [6][4][5][5][8] to [6][4][25][8]
genvar d,e,f,g;
generate
    for (d=0; d<NUM_FILT; d++) begin
        for (f=0; f<FILT_INST; f++) begin
            for (e=0; e<NUM_FILT_ROWS; e++) begin
                for (g=0; g<NUM_WGHT_PER_FILT_ROW; g=g+1) begin
                    assign filt_wght_matx_sig[d][f][(NUM_FILT_ROWS*e)+g] = filt_wght_5d[d][f][e][g];
                end
            end
        end
    end
endgenerate

////2,3,4 inst of reg same as 1
//genvar u,v;
//generate
//    for (u=0; u<NUM_FILT; u++) begin
//        for (v=0; v<FILT_INST; v++) begin //1 because to make the remaining same as 1
//            assign filt_wght_matx_o[u][v] = filt_wght_matx_sig[u][0];
//        end
//    end
//endgenerate
assign filt_wght_matx_o = filt_wght_matx_sig;

endmodule
