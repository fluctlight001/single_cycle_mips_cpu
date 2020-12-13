`include "defines.vh"
module mycpu_top(
    input wire clk,
    input wire rst,
    
    output wire [31:0] inst_addr_o,
    input wire [31:0] inst_i,

    output wire mem_cs,
    output wire mem_rw,
    output wire [31:0] mem_addr,
    output wire [31:0] mem_wdata,
    input wire [31:0] mem_rdata,
    
    output wire [31:0] debug_inst_addr,
    output wire [31:0] debug_wdata
);

wire [31:0] inst_addr;
assign inst_addr_o = inst_addr;
wire branch_flag;
wire [31:0] branch_target_address;


pc u_pc(
	.clk                     (clk                     ),
    .rst                     (rst                     ),
    .inst_addr               (inst_addr               ),
    .branch_flag_i           (branch_flag             ),
    .branch_target_address_i (branch_target_address   )
);


wire [4:0] reg1_addr;
wire [4:0] reg2_addr;

wire [31:0] reg1_data;
wire [31:0] reg2_data;
wire [31:0] reg1;
wire [31:0] reg2;

wire [`AluOpBus] aluop;
wire [`AluSelBus] alusel;

wire [4:0] waddr;
wire [31:0] wdata;


decoder u_decoder(
	.inst_i      (inst_i      ),
    .inst_addr_i (inst_addr   ),
    // .reg1_read_o (reg1_read_o ),
    // .reg2_read_o (reg2_read_o ),
    .reg1_addr_o (reg1_addr ),
    .reg2_addr_o (reg2_addr ),
    .reg1_data_i (reg1_data ),
    .reg2_data_i (reg2_data ),
    .aluop_o     (aluop     ),
    .alusel_o    (alusel    ),
    .reg1_o      (reg1      ),
    .reg2_o      (reg2      ),
    .we_o        (we        ),
    .waddr_o     (waddr     ),
    .branch_flag_o           (branch_flag           ),
    .branch_target_address_o (branch_target_address )
);

regfile u_regfile(
	.clk   (clk   ),
    .rst   (rst   ),
    .reg1  (reg1_addr  ),
    .reg2  (reg2_addr  ),
    .data1 (reg1_data ),
    .data2 (reg2_data ),
    .we    (we    ),
    .waddr (waddr ),
    .wdata (wdata )
);


ex u_ex(
    .inst_i      (inst_i    ),
	.aluop_i     (aluop     ),
    .alusel_i    (alusel    ),
    .reg1_i      (reg1      ),
    .reg2_i      (reg2      ),
    .wdata_o     (wdata     ),
    .mem_cs_o    (mem_cs    ),
    .mem_rw_o    (mem_rw    ),
    .mem_addr_o  (mem_addr  ),
    .mem_wdata_o (mem_wdata ),
    .mem_rdata_i (mem_rdata )
);


assign debug_inst_addr = inst_addr;
assign debug_wdata = wdata;

endmodule 