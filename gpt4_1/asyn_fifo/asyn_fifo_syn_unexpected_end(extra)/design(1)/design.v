module	declaration. This often happens when there is a typo or misplaced punctuation. 

After reviewing your code, it seems that there's a comma at the end of the port list in the "asyn_fifo" module declaration which is causing the problem. Here is the corrected code:

```verilog
`timescale 1ns/1ns

/***************************************RAM*****************************************/
module dual_port_RAM #(parameter DEPTH = 16,  parameter WIDTH = 8)
(
	 input wclk	,
	 input wenc	,
	 input [$clog2(DEPTH)-1:0] waddr  ,
	 input [WIDTH-1:0] wdata ,
	 input rclk	,
	 input renc	,
	 input [$clog2(DEPTH)-1:0] raddr ,
	 output reg [WIDTH-1:0] rdata 		
);

reg [WIDTH-1:0] RAM_MEM [0:DEPTH-1];

always @(posedge wclk) begin
	if(wenc)
		RAM_MEM[waddr] <= wdata;
end 

always @(posedge rclk) begin
	if(renc)
		rdata <= RAM_MEM[raddr];
end 

endmodule
module	 


/**************************************AFIFO*****************************************/
module asyn_fifo#(
	parameter	WIDTH = 8,
	parameter 	DEPTH = 16
)(
	input 					wclk	, 
	input 					rclk	,   
	input 					wrstn	,
	input					rrstn	,
	input 					winc	,
	input 			 		rinc	,
	input 		[WIDTH-1:0]	wdata	,

	output wire				wfull	,
	output wire				rempty	,
	output wire [WIDTH-1:0]	rdata      
);

// Rest of the code remains the same

endmodule
