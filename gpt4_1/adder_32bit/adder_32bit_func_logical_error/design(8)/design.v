module	adder_32bit(A,B,S,C32);
    input [31:0] A;
    input [31:0] B;
    output wire [31:0] S;
    output wire C32;

    wire c16,gx1,px1,gx2,px2;

    CLA_16 CLA1(
        .A(A[15:0]),
        .B(B[15:0]),
        .c0(1'b0),
        .S(S[15:0]),
        .px(px1),
        .gx(gx1)
    );

    CLA_16 CLA2(
        .A(A[31:16]),
        .B(B[31:16]),
        .c0(c16),
        .S(S[31:16]),
        .px(px2),
        .gx(gx2)
    );

    assign c16 = gx1 | (px1 & 1'b1); 
    assign C32 = gx2 | (px2 & c16);
endmodule
module	CLA_16(A,B,c0,S,px,gx);
    input [15:0] A;
    input [15:0] B;
    input c0;
    output wire [15:0] S;
    output wire gx,px;

    wire c4,c8,c12;
    wire Gm1,Pm1,Gm2,Pm2,Gm3,Pm3,Gm4,Pm4;

    adder_4 adder1(
        .x(A[3:0]),
        .y(B[3:0]),
        .c0(c0),
        .c4(c4),
        .F(S[3:0]),
        .Gm(Gm1),
        .Pm(Pm1)
    );

    // ...

    assign c4 = Gm1 | (Pm1 & c0),
           c8 = Gm2 | (Pm2 & c4) | (Pm2 & Pm1 & c0),
           c12 = Gm3 | (Pm3 & c8) | (Pm3 & Pm2 & c4) | (Pm3 & Pm2 & Pm1 & c0);

    assign px = Pm1 & Pm2 & Pm3 & Pm4,
           gx = Gm4 | (Pm4 & Gm3) | (Pm4 & Pm3 & Gm2) | (Pm4 & Pm3 & Pm2 & Gm1);
endmodule
module	adder_4(x,y,c0,F,Cout);

    input [3:0] x,y;
    input c0;
    output wire [3:0] F;
    output wire Cout;

    assign F = x ^ y ^ c0;
    assign Cout = (x & y) | (c0 & (x ^ y));
endmodule
