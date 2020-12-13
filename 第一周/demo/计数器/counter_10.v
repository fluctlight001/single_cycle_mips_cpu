module counter_10(
    input wire clk,
    input wire rst,
    output reg outa
);
    reg [3:0] sum;
    always @ (posedge clk or posedge rst)begin
        if (rst == 1'b1) begin
            sum <= 4'b0;
            outa <= 1'b0;
        end
        else if (sum == 4'd9) begin
            sum <= 4'b0;
            outa <= 1'b1;
        end
        else begin
            sum <= sum + 1'b1;
            outa <= 1'b0;
        end
    end
endmodule