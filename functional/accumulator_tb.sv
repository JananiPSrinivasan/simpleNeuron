`timescale 1ns/1ps

module accumulator_tb();

    logic clk;
    logic rst;
    logic en;

    logic signed [7:0] x;
    logic signed [7:0] weight;
    logic signed [7:0] bias;
    logic signed [7:0] accu;

    // Instantiate DUT
    accumulate dut (
        .clk(clk),
        .rst(rst),
        .en(en),
        .x(x),
        .weight(weight),
        .bias(bias),
        .accu(accu)
    );

    // Clock generation: 10ns period
    always #5 clk = ~clk;

    initial begin
        $display("Starting single accumulate test...");
        clk = 0;
        rst = 1;
        en = 0;
        x = 0;
        weight = 0;
        bias = 0;

        // Initial reset
        #10;
        rst = 0;

        // Test values
        x = 8'sd5;
        weight = 8'sd2;
        bias = 8'sd1;
        en = 1;

        // One accumulate operation
        @(posedge clk); // capture inputs
        @(posedge clk); // update accumulator
        #1;
        en = 0;

        $display("Inputs: x=%0d, weight=%0d, bias=%0d", x, weight, bias);
        $display("Accumulator output: accu = %0d", accu);

        $finish;
    end

endmodule
