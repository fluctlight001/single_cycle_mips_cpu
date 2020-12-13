`include "defines.vh"
module ram(
    input wire clk,
    input wire rst,
    input wire cs,// chipsel
    input wire rw,// 1-read 0-write
    input wire [31:0] addr,
    input wire [31:0] data_i,
    output reg [31:0] data_o
);
    reg [31:0] ram [31:0];
    always @ (posedge clk) begin
        if (rst == `RstEnable) begin
            ram[ 0] <= 32'd0;
            ram[ 1] <= 32'd0;
            ram[ 2] <= 32'd0;
            ram[ 3] <= 32'd0;
            ram[ 4] <= 32'd0;
            ram[ 5] <= 32'd0;
            ram[ 6] <= 32'd0;
            ram[ 7] <= 32'd0;
            ram[ 8] <= 32'd0;
            ram[ 9] <= 32'd0;
            ram[10] <= 32'd0;
            ram[11] <= 32'd0;
            ram[12] <= 32'd0;
            ram[13] <= 32'd0;
            ram[14] <= 32'd0;
            ram[15] <= 32'd0;
            ram[16] <= 32'd0;
            ram[17] <= 32'd0;
            ram[18] <= 32'd0;
            ram[19] <= 32'd0;
            ram[20] <= 32'd0;
            ram[21] <= 32'd0;
            ram[22] <= 32'd0;
            ram[23] <= 32'd0;
            ram[24] <= 32'd0;
            ram[25] <= 32'd0;
            ram[26] <= 32'd0;
            ram[27] <= 32'd0;
            ram[28] <= 32'd0;
            ram[29] <= 32'd0;
            ram[30] <= 32'd0;
            ram[31] <= 32'd0;
        end
        else if(cs == `True_v && rw == `False_v) begin
            ram[addr[6:2]] <= data_i;
        end
    end

    always @ (*) begin
        if (cs == `True_v && rw == `True_v) begin
            data_o = ram[addr[6:2]]; 
        end
        else if (cs == `True_v && rw == `False_v) begin
            data_o = data_i;
        end 
        else begin
            data_o = `ZeroWord;
        end
    end
endmodule 