module	CLA_16 (
    input [15:0] A, B, 
    input c0, 
    output [15:0] S, 
    output px, gx, 
    output c16
);
   // CLA_16 implementation here.
endmodule
module	adder_32bit(
    input [31:0] A,
    input [31:0] B,
    output [31:0] S,
    output C32
);

wire px1,gx1,px2,gx2;
wire c16;

CLA_16 CLA1(
    .A(A[15:0]),
    .B(B[15:0]),
    .c0(1'b0),
    .S(S[15:0]),
    .px(px1),
    .gx(gx1),
    .c16(c16)
);

CLA_16 CLA2(
    .A(A[31:16]),
    .B(B[31:16]),
    .c0(c16),
    .S(S[31:16]),
    .px(px2),
    .gx(gx2),
    .c16(C32)
);

assign c16 = gx1 ^ (px1 && 1'b0); //c0 = 0
assign C32 = gx2 ^ (px2 && c16);

endmodule
