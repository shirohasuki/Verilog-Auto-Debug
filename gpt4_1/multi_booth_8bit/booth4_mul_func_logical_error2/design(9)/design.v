module	multi_booth_8bit (p, rdy, clk, reset, a, b);
   input clk, reset;
   input [7:0] a, b;
   output reg [15:0] p;
   output reg rdy;
   
   reg [15:0] multiplier;
   reg [15:0] multiplicand;
   reg [4:0] ctr;
   reg [1:0] booth_code;
   
   always @(posedge clk or posedge reset) begin
      if (reset) 
      begin
         rdy     <= 0;
         p       <= 0;
         ctr     <= 0;
         multiplier <= {8'b0, a};
         multiplicand <= {8'b0, b};
         booth_code <= 2'b00;
      end 
      else 
      begin 
         if(ctr < 16) 
         begin
            booth_code <= {multiplier[0], booth_code[1]};
			case(booth_code)
				2'b01: p <= p + multiplicand;
				2'b10: p <= p - multiplicand;
				default: p <= p;
			endcase
			p <= p >> 1;
			multiplier <= multiplier >> 1;
			multiplicand <= multiplicand << 1;
			ctr <= ctr + 1;
         end
         else 
         begin
            rdy <= 1;
         end
      end
   end 
endmodule
