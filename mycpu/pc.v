`include "defines.vh"
module pc(
    input wire clk,
    input wire rst,
    output reg [31:0] inst_addr,

    input wire branch_flag_i,
    input wire [`RegBus] branch_target_address_i
);
    always @ (posedge clk) begin
        if (rst == 1'b1) begin
            inst_addr <= 32'b0;
        end
        else if (branch_flag_i == `True_v) begin
            inst_addr <= branch_target_address_i;
        end
        else begin
            inst_addr <= inst_addr + 32'd4;
        end
    end
endmodule