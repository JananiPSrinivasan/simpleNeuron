`timescale 1ns/1ps

module adder_sim_tb;

    logic clk = 0;
    logic signed [7:0] in1, in2;
    logic signed [7:0] sum;
    logic carry;

    // Clock generation
    always #5 clk = ~clk;  // 100 MHz clock

    // DUT instantiation
    adder dut (
        .in1(in1),
        .in2(in2),
        .sum(sum),
        .carry(carry)
    );

    initial begin
        $dumpfile("adder.vcd");      // for power estimation
        $dumpvars(0, adder_sim_tb);

        in1 = 0;
        in2 = 0;

        repeat (1000) begin
            @(posedge clk);
            in1 = $random;
            in2 = $random;
        end

        $finish;
    end
endmodule
