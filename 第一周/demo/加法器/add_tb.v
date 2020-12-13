module add_tb();
    reg [3:0] a;
    reg [3:0] b;
    wire [4:0] ans;

    add_4 unit(.a(a), .b(b), .s(ans[3:0]), .c(ans[4]));

    initial begin
        a = 4'd5;
        b = 4'd7;

        #10 
        a = 4'd6;
        b = 4'd8;
        
        #10
        a = 4'd10;
        b = 4'd9;
    end
endmodule