`timescale 1ns/1ps
module adder (
    input  logic                clk,
    input  logic                rst_n,
    input  logic signed [15:0]  in1,
    input  logic signed [7:0]   in2,
    output logic signed [15:0]  sum,
    output logic                carry,
    output logic signed [16:0] total
);

    wire signed [15:0] sign_ext = {{8{in2[7]}}, in2};
    logic signed [16:0] temp;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            temp <= 17'sd0;
        else
            temp <= in1 + sign_ext;
    end
   
    assign sum   = temp[15:0];
    assign carry = temp[16];
    assign total = {temp[16], temp[15:0]};

endmodule

