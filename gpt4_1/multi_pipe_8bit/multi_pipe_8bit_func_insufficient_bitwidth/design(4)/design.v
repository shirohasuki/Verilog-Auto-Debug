module	multi_pipe_8bit#(
    parameter size = 8
)(
    input clk,      
    input rst_n,       
    input mul_en_in,      
    input [size-1:0] mul_a,       
    input [size-1:0] mul_b,       

    output reg mul_en_out,      
    output reg [(size*2)-1:0] mul_out    
);

    reg [2:0] mul_en_out_reg;
    always@(posedge clk or negedge rst_n)
        if(!rst_n)begin
            mul_en_out_reg <= 3'd0;             
            mul_en_out     <= 1'b0;                           
        end
        else begin
            mul_en_out_reg <= {mul_en_out_reg[1:0],mul_en_in};            
            mul_en_out     <= mul_en_out_reg[2];                  
        end

    reg [7:0] mul_a_reg;
    reg [7:0] mul_b_reg;
    always @(posedge clk or negedge rst_n)
        if(!rst_n) begin
            mul_a_reg <= 8'd0;
            mul_b_reg <= 8'd0;
        end
        else begin
            mul_a_reg <= mul_en_in ? mul_a :8'd0;
            mul_b_reg <= mul_en_in ? mul_b :8'd0;
        end

    wire [15:0] temp [size-1:0];
    genvar i;
    generate
        for(i=0; i<size; i=i+1)
            assign temp[i] = mul_b_reg[i]? ({8'b0,mul_a_reg} << i) : 16'd0;
    endgenerate

	reg [15:0] sum [size-1:0];
    integer j;
    always @(posedge clk or negedge rst_n) 
        if(!rst_n) begin
            for (j = 0; j < size; j = j + 1) 
                sum[j] <= 16'd0;
        end 
        else begin
            for (j = 0; j < size; j = j + 1) 
                sum[j] <= j ? (sum[j-1] + temp[j]) : temp[j];
        end

    reg [15:0] mul_out_reg;
    always @(posedge clk or negedge rst_n) 
        if(!rst_n)
            mul_out_reg <= 16'd0;
        else 
            mul_out_reg <= sum[size-1];

    always @(posedge clk or negedge rst_n) 
        if(!rst_n)
            mul_out <= 16'd0;
        else if(mul_en_out)
            mul_out <= mul_out_reg;
        else
            mul_out <= 16'd0;

endmodule
