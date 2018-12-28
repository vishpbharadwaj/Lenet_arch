// Author : Saurabh Patil

//  Description : This module contains a generic ram logic to infer M512
//  NOTE        : M512 doesnt have reset
// -----------------------------------------------------------------------------


module mem_block #(
                   parameter RAM_DEPTH = 512,
		   parameter RAM_ADDRW = 8,   //TODO : Write clog2 function and call it here
                   parameter RAM_WIDTH = 32,
                   parameter MEM_INIT_FILE = "mem_load_hex.hex"
  )( input  logic                 clk_i,
     input  logic                 ram_wren_i,
     input  logic [RAM_ADDRW-1:0] ram_wr_addr_i,
     input  logic [RAM_WIDTH-1:0] ram_wr_data_i,
     input  logic [RAM_ADDRW-1:0] ram_rd_addr_i,
     output logic [RAM_WIDTH-1:0] ram_rd_data_o
   );


logic [RAM_WIDTH-1:0] mem_block [RAM_DEPTH-1:0] /* synthesis ramstyle = "M20K" */;

//initial begin
//    $readmemh(MEM_INIT_FILE, mem_block);
//end

//always_ff @ (posedge clk_i) begin
//    if (ram_wren_i) begin
//        mem_block[ram_wr_addr_i] <= ram_wr_data_i;
//    end
//    //ram_rd_data_o <= mem_block[ram_rd_addr_i];    // Use this for flopped read data 
//end 

assign ram_rd_data_o = mem_block[ram_rd_addr_i];    // Use this for unflopped read data

endmodule        
