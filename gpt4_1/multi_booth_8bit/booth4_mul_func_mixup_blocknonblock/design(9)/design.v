module	multi_booth_8bit (
    input wire clk,
    input wire reset,
    input wire [7:0] a,
    input wire [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

    reg [17:0] multiplier; // Extend register to 18 bits for booth encoding
    reg [17:0] multiplicand;
    reg [4:0] ctr;
    reg [2:0] multiplier_lsb; 

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            rdy <= 0;
            p <= 0;
            ctr <= 0;
            multiplier <= {1'b0, a, 1'b0};  // append one 0 on left and right
            multiplicand <= {b, 9'b0};  // append 9'b0 to most significant bit
            multiplier_lsb <= 3'b000;
        end 
        else begin 
            if(ctr < 16) begin
                multiplier_lsb <= multiplier[2:0];
                case (multiplier_lsb) 
                    3'b001: p = p + multiplicand;
                    3'b010: p = p - multiplicand;
                    3'b100: p = p - multiplicand;
                    3'b101: p = p + multiplicand;
                    default: ;
                endcase

                multiplier <= {1'b0, multiplier[16:1]}; // Shift right by appending 0 to MSB
                multiplicand <= {multiplicand[16:1], 1'b0}; // Shift left by appending 0 to LSB
                ctr <= ctr + 1;
            end
            else begin
                rdy <= 1;
            end
        end
    end
endmodule
