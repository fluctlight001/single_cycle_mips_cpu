module regfile(
    input wire clk,
    input wire rst,
    input wire [4:0] reg1, // reg1 addr
    input wire [4:0] reg2, // reg2 addr
    output reg [31:0] data1,
    output reg [31:0] data2,

    input wire we, // write enable
    input wire [4:0] waddr, // write addr
    input wire [31:0] wdata // write data
);
    reg [31:0] rf [31:0];
    always @ (posedge clk) begin
        if (we == 1'b1 && waddr != 5'b0) begin
            rf[waddr] <= wdata;
        end
    end

    always @ (*) begin
        if (rst == 1'b1) begin
            data1 = 32'b0;
        end
        else if (reg1 == 4'b0) begin
            data1 = 32'b0;
        end
        else begin
            data1 = rf[reg1];
        end
    end

    always @ (*) begin
        if (rst == 1'b1) begin
            data2 = 32'b0;
        end
        else if (reg2 == 4'b0) begin
            data2 = 32'b0;
        end
        else begin
            data2 = rf[reg2];
        end
    end
endmodule