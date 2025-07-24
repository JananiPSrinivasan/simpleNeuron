/*Concept of relu

Relu is most common activation function that is applied 
at the sumed output of the inputs weights and bias

It is used to transform the inputs

Mathematically 
f(x) = max(0,x)
x - input of the neuron

the output of the Relu will be x if the input is a positive number
the output will be zero if the input is a negative number


so to map it in hardware we can use a comparator logic on the sign bit

if the sign bit is positive i.e 0, the y = the input
if the sign bit is negative i.e 1, the y = 0;\


*/


`timescale 1ps/1ps

module activate (
    input logic clk, 
    input logic rst_n,
    input logic signed [17:0] in,
    output logic signed [17:0] out
);

    logic signed [17:0] temp;
    logic signed [17:0] in_ext = in;
    always @ (posedge clk) begin 
        if(!rst_n) begin 
           temp <= 17'sd0;
        end else begin 
             if (in[17]) begin 
                temp <= 18'sd0;
            end
            else begin 
                temp <= in;
            end
        end
    end

    assign out = temp;


endmodule