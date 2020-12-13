module testbench();
    reg clk;
    reg rst;
    wire [31:0] inst_addr;
    reg [31:0] inst;
    wire [31:0] debug_inst_addr;
    wire [31:0] debug_wdata;
    reg [31:0] rom [7:0];
    mycpu_top u_mycpu_top(
    	.clk             (clk             ),
        .rst             (rst             ),
        .inst_addr_o     (inst_addr       ),
        .inst_i          (inst            ),
        .debug_inst_addr (debug_inst_addr ),
        .debug_wdata     (debug_wdata     )
    );

    initial begin
        clk = 1'b0;
        rst = 1'b0;
        rom[0] = 31'b00111100000000100000000000000001;
        rom[1] = 31'b00111100000000010000000000000001;
        rom[2] = 31'b00000000010000010001000000100001;
        rom[3] = 31'b00000000010000010000100000100001;
        rom[4] = 31'b00000000010000010001000000100001;
        rom[5] = 31'b00000000010000010000100000100001;
        rom[6] = 31'b00000000010000010001000000100001;
        rom[7] = 31'b00000000010000010000100000100001;
        #10
        rst = 1'b1;
        #30
        rst = 1'b0;    
    end

    always # 5 clk = ~clk;
    always @ (*) begin
        inst = rom[inst_addr[4:2]];
    end

endmodule 