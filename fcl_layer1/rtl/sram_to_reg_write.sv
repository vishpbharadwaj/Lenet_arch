//

module sram_to_reg_write #(
                    parameter NUM_FILTER= 6,
                    parameter CNT_WIDTH = 3,
                    parameter RAM_DEPTH = 5,
                    parameter RAM_ADDRW = 3,
                    parameter RAM_WIDTH = 40
)(
    input logic  reg_write_clk,
    input logic  reg_write_rst_b,
    input logic  reg_write_en_i,
    output logic reg_write_cnt_done_o

);


//signals
logic [CNT_WIDTH-1 : 0]                     cnt_out_addr_sig; //count out acts as address
logic [NUM_FILTER-1 : 0][RAM_WIDTH-1 : 0]   ram_data_out_sig; //ram out i.e. 40 bits for each filter

//REG declaration
logic [RAM_WIDTH-1 : 0] conv1_wght_reg [NUM_FILTER-1 : 0][RAM_DEPTH-1 : 0];

//up counter for address generation 
upcounter #(
        .CNT_WIDTH  (CNT_WIDTH)
)
add_gen_counter(
    .cnt_clk       (reg_write_clk),
    .cnt_rst_b     (reg_write_rst_b),
    .cnt_en        (reg_write_en_i),
    .cnt_ld_en     (1'b0),
    .cnt_ld_val    ({(CNT_WIDTH){1'b0}}),
    .cnt_upto      (3'b100), //till 5
    .cnt_out       (cnt_out_addr_sig),
    .cnt_done      (reg_write_cnt_done_o)
);


//6 SRAMs of depth 5 for 6 filter
genvar i;
generate
    for (i=0; i<NUM_FILTER; i++) begin : wght_mem_inst
        mem_block #(
                    .RAM_DEPTH  (RAM_DEPTH),
                    .RAM_ADDRW  (RAM_ADDRW),
                    .RAM_WIDTH  (RAM_WIDTH)
        )
        sram_weight_mems(
            .clk_i           (reg_write_clk),
            .ram_wren_i      (1'b0),
            .ram_wr_addr_i   ({(RAM_ADDRW){1'b0}}),
            .ram_wr_data_i   ({(RAM_ADDRW){1'b0}}),
            .ram_rd_addr_i   (cnt_out_addr_sig),
            .ram_rd_data_o   (ram_data_out_sig[i])
        );
    end
endgenerate

//writing to regs
genvar j;
generate
    for (j=0; j<NUM_FILTER; j++) begin
        always_latch begin
            if (reg_write_en_i) begin
                conv1_wght_reg[j][cnt_out_addr_sig] <= ram_data_out_sig[j];
            end
        end
    end
endgenerate

endmodule
