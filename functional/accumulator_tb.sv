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

        // Wait for 3 clock edges:
        // 1. First posedge: Reset deasserted
        // 2. Second posedge: Inputs captured, multiplier/adder compute
        // 3. Third posedge: Accumulator updates
        @(posedge clk); // Reset deasserted
        @(posedge clk); // Inputs sampled, computation starts
        en = 1;
        @(posedge clk); // accu updates here
        en = 0;
        
        #1; // Small delay to see stable output
        
        $display("Inputs: x=%0d, weight=%0d, bias=%0d", x, weight, bias);
        $display("Accumulator output: accu = %0d", accu);

        // Verify the result
        if (accu !== 11) begin
            $display("ERROR: Expected 11, got %0d", accu);
            $finish(1);
        end
        else begin
            $display("TEST PASSED");
            $finish;
        end
    end
endmodule