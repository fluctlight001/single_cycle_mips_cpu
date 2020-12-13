module counter_top(
    input wire clk,
    input wire rst,
    output wire outa
);
    wire counter_6_out;
    counter_6 unit1(.clk(clk), .rst(rst), .outa(counter_6_out));
    counter_10 unit2(.clk(counter_6_out), .rst(rst), .outa(outa));
endmodule 