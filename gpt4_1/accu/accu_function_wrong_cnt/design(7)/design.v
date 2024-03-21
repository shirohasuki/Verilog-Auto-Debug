module	accu(
    input               clk         ,   
    input               rst_n       ,
    input       [7:0]   data_in     ,
    input               valid_in     ,

    output  reg         valid_out     ,
    output  reg [9:0]   data_out
);

    reg [1:0] count;
    reg [9:0]   data_out_reg;

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            count <= 2'b00;
            valid_out <= 1'b0; 
            data_out_reg <= 10'b0;
        end
        else if(valid_in) begin
            data_out_reg <= data_out_reg + data_in;
            count <= count + 1;
            if (count == 2'b11) begin
                data_out <= data_out_reg;
                valid_out <= 1'b1;
                count <= 2'b00;
                data_out_reg <= 10'b0;
            end
            else begin
                valid_out <= 1'b0;
            end
        end
    end
endmodule
