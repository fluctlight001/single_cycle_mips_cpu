module pc(
    input wire clk,
    input wire rst,
    output reg [31:0] inst_addr
);
    always @ (posedge clk) begin
        if (rst == 1'b1) begin
            inst_addr <= 32'b0;
        end
        else begin
            inst_addr <= inst_addr + 32'd4;
        end
    end
endmodule