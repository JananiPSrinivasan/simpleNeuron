`timescale 1ns/1ps
module adder (
    input  logic                clk,
    input  logic                rst_n,
    input  logic signed [16:0]  in1,
    input  logic signed [7:0]   in2,
    output logic signed [16:0]  sum,
    output logic                carry,
    output logic signed [17:0] total //18bits
);

    wire signed [16:0] sign_ext = {{9{in2[7]}}, in2};
    logic signed [17:0] temp;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            temp <= 18'sd0;
        else
            temp <= in1 + sign_ext;
    end
   
    assign sum   = temp[16:0];
    assign carry = temp[17];
    assign total = temp;

endmodule

