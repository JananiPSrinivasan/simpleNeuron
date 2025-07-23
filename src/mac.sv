module mac(
    input logic clk,
    input logic rst_n,
    input logic signed [7:0] x,
    input logic signed [7:0] weight,
    output logic signed [15:0] out
);

    
    logic signed [15:0] accumulator ;

    always @ (posedge clk or negedge rst_n) begin
        if (!rst_n) begin 
            accumulator <= 16'sd0;
        end else begin 
            accumulator <= x * weight + accumulator;
        end
    end

    assign out = accumulator;

 



endmodule