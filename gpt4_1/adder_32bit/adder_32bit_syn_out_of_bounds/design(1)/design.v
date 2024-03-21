module	adder_32bit(A,B,S,C32);
    input [31:0] A;
    input [31:0] B;
    output [31:0] S;
    output C32;

    wire px1,gx1,px2,gx2;
    wire c16;

    CLA_16 CLA1(
        .A(A[15:0]),
        .B(B[15:0]),
        .c0(0),
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

    assign c16 = gx1 ^ (px1 && 0), //c0 = 0
           C32 = gx2 ^ (px2 && c16);
endmodule
module	CLA_16(A,B,c0,S,px,gx);
    input [15:0] A;
    input [15:0] B;
    input c0;
    output gx,px;
    output [15:0] S;

    wire c4,c8,c12;
    wire Pm1,Gm1,Pm2,Gm2,Pm3,Gm3,Pm4,Gm4;

    adder_4 adder1(
         .x(A[3:0]),
          .y(B[3:0]),
          .c0(c0),
          .c4(),
          .F(S[3:0]),
          .Gm(Gm1),
          .Pm(Pm1)
    );

    // repeat this for adder2, adder3, adder4 with the proper adjustments

    assign   c4 = Gm1 ^ (Pm1 & c0),
             c8 = Gm2 ^ (Pm2 & Gm1) ^ (Pm2 & Pm1 & c0),
             c12 = Gm3 ^ (Pm3 & Gm2) ^ (Pm3 & Pm2 & Gm1) ^ (Pm3 & Pm2 & Pm1 & c0);

    assign  px = Pm1 & Pm2 & Pm3 & Pm4,
            gx = Gm4 ^ (Pm4 & Gm3) ^ (Pm4 & Pm3 & Gm2) ^ (Pm4 & Pm3 & Pm2 & Gm1);
endmodule
module	adder_4(x,y,c0,c4,F,Gm,Pm);
    input [3:0] x;
    input [3:0] y;
    input c0;
    output c4,Gm,Pm;
    output [3:0] F;

    // repeat the same changes for rest of the code
endmodule
module	adder(X,Y,Cin,F,Cout);

    input X,Y,Cin;
    output F,Cout;

    assign F = X ^ Y ^ Cin;
    assign Cout = (X ^ Y) & Cin | X & Y;
endmodule
