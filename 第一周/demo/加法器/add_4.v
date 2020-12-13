module add_4(
    input wire [3:0] a,
    input wire [3:0] b,
    output wire [3:0] s,
    output wire c
);
    wire [2:0] cin;
    add unit_0(.a(a[0]), .b(b[0]), .cin(0), .s(s[0]), .cout(cin[0]));
    add unit_1(.a(a[1]), .b(b[1]), .cin(cin[0]), .s(s[1]), .cout(cin[1]));
    add unit_2(.a(a[2]), .b(b[2]), .cin(cin[1]), .s(s[2]), .cout(cin[2]));
    add unit_3(.a(a[3]), .b(b[3]), .cin(cin[2]), .s(s[3]), .cout(c));
endmodule