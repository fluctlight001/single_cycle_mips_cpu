module counter_tb();
    reg clk;
    reg rst;
    wire outa;
    counter_top unit(.clk(clk), .rst(rst), .outa(outa));

    initial begin
        clk = 1'b0;
        rst = 1'b0;
        #10
        rst = 1'b1;
        #30 
        rst = 1'b0;
    end

    always #10 clk = ~clk;
endmodule