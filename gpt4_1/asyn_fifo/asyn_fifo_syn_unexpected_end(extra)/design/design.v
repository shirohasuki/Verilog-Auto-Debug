module	dual_port_RAM #(
  parameter DEPTH = 16, 
  parameter WIDTH = 8
) (
  input wclk, 
  input wenc, 
  input [$clog2(DEPTH)-1:0] waddr, 
  input [WIDTH-1:0] wdata,
  input rclk, 
  input renc, 
  input [$clog2(DEPTH)-1:0] raddr,
  output [WIDTH-1:0] rdata
);
  reg [WIDTH-1:0] RAM_MEM [0:DEPTH-1];
  wire [WIDTH-1:0] rdata_wire;

  assign rdata = rdata_wire;
  
  always @(posedge wclk) begin
    if (wenc) RAM_MEM[waddr] <= wdata;
  end
  
  always @(posedge rclk) begin
    if (renc) rdata_wire <= RAM_MEM[raddr];
  end
endmodule
module	asyn_fifo #(
  parameter DEPTH = 16, 
  parameter WIDTH = 8
) (
  input wclk, 
  input rclk, 
  input wrstn, 
  input rrstn, 
  input winc, 
  input rinc,
  input [WIDTH-1:0] wdata, 
  output reg wfull, 
  output reg rempty,
  output reg [WIDTH-1:0] rdata
);
  reg [$clog2(DEPTH)-1:0] waddr_bin, raddr_bin, waddr_gray, raddr_gray;
  reg [$clog2(DEPTH)-1:0] waddr_bin_buf, raddr_bin_buf, wptr, rptr;
  
  always @(posedge wclk or negedge wrstn) begin
    if (~wrstn) waddr_bin <= 0;
    else if (winc) waddr_bin <= waddr_bin + 1;
  end
  
  always @(posedge rclk or negedge rrstn) begin
    if (~rrstn) raddr_bin <= 0;
    else if (rinc) raddr_bin <= raddr_bin + 1;
  end
  
  always @(posedge wclk or negedge wrstn) begin
    if (~wrstn) waddr_gray <= 0;
    else waddr_gray <= waddr_bin ^ (waddr_bin >> 1);
  end

  always @(posedge rclk or negedge rrstn) begin
    if (~rrstn) raddr_gray <= 0;
    else raddr_gray <= raddr_bin ^ (raddr_bin >> 1);
  end

  always @(posedge wclk or negedge wrstn) begin
    if (~wrstn) waddr_bin_buf <= 0;
    else waddr_bin_buf <= waddr_gray;
  end
  
  always @(posedge rclk or negedge rrstn) begin
    if (~rrstn) raddr_bin_buf <= 0;
    else raddr_bin_buf <= raddr_gray;
  end
  
  always @(posedge rclk) rptr <= waddr_bin_buf;
  always @(posedge wclk) wptr <= raddr_bin_buf;
  
  always @(posedge wclk or posedge rclk or negedge wrstn or negedge rrstn) begin
    if (~wrstn || ~rrstn) begin
      wfull <= 0;
      rempty <= 1;
    end else begin
      wfull <= (wptr == ({rptr[DEPTH-2:0], ~rptr[DEPTH-1]}));
      rempty <= (rptr == wptr);
    end
  end

  dual_port_RAM #(.DEPTH(DEPTH), .WIDTH(WIDTH)) RAM (
    .wclk(wclk), 
    .wenc(winc & ~wfull), 
    .waddr(waddr_gray), 
    .wdata(wdata), 
    .rclk(rclk), 
    .renc(rinc & ~rempty), 
    .raddr(raddr_gray), 
    .rdata(rdata)
  );
endmodule
