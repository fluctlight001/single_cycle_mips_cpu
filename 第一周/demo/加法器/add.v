module add(
    input wire a,
    input wire b,
    input wire cin,
    output wire s,
    output wire cout
);
    assign {cout,s} = a + b + cin;
    // ��ѧϰ{}���÷�
endmodule