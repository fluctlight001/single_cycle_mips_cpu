module soc_top(
    input wire clk,
    input wire rst
);
    wire [31:0] inst_addr;
    wire [31:0] inst;
    wire [31:0] debug_inst_addr;
    wire [31:0] debug_wdata;
    // reg [31:0] rom [7:0];
    wire mem_cs;
    wire mem_rw;
    wire [31:0] mem_addr;
    wire [31:0] mem_wdata;
    wire [31:0] mem_rdata;

    mycpu_top u_mycpu_top(
    	.clk             (clk             ),
        .rst             (rst             ),
        .inst_addr_o     (inst_addr       ),
        .inst_i          (inst            ),
        .mem_cs          (mem_cs          ),
        .mem_rw          (mem_rw          ),
        .mem_addr        (mem_addr        ),
        .mem_wdata       (mem_wdata       ),
        .mem_rdata       (mem_rdata       ),
        .debug_inst_addr (debug_inst_addr ),
        .debug_wdata     (debug_wdata     )
    );
    
    rom u_rom(
    	.clk  (clk  ),
        .rst  (rst  ),
        .addr (inst_addr ),
        .data (inst )
    );
    
    ram u_ram(
    	.clk    (clk    ),
        .rst    (rst    ),
        .cs     (mem_cs     ),
        .rw     (mem_rw     ),
        .addr   (mem_addr   ),
        .data_i (mem_wdata  ),
        .data_o (mem_rdata  )
    );
endmodule 
