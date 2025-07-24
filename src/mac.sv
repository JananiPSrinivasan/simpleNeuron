`timescale 1ns/1ps
module mac(
    input logic clk,
    input logic rst_n,
    input logic signed [7:0] x,
    input logic signed [7:0] weight,
    output logic signed [16:0] out
);

    
    logic signed [16:0] accumulator ;

    always @ (posedge clk or negedge rst_n) begin
        if (!rst_n) begin 
            accumulator <= 17'sd0;
        end else begin 
            accumulator <= x * weight + accumulator;
        end
    end

    assign out = accumulator;

 



endmodule