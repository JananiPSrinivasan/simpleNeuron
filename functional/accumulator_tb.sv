`timescale 1ns/1ps

module accumulator_tb();


    logic clk;
    logic rst;
    logic en;

    logic signed [0:7] x;
    logic signed [0:7] weight;
    logic signed [0:7] bias;
    logic signed [0:7] y;

    logic signed [15:0] mul_out;
    logic signed [15:0] add_out;

    accumulator dut (
        .x(x),
        .weight(weight),
        .bias(bias),
        .accu(y),
        .clk(clk),
        .rst(rst),
        .en(en)
    );

    task test(
        input logic signed[7:0]a, 
        input logic signed[7:0]b,
        input logic signed [7:0]c 
    );

    logic [7:0] 

    endtask

endmodule