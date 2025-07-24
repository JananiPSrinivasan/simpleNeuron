`timescale 1ns/1ps

module adder_tb;

    // Testbench signals
    logic clk;
    logic rst_n;
    logic signed [16:0] in1;
    logic signed [7:0]  in2;
    logic signed [16:0] sum;
    logic carry;

    // Expected output
    logic signed [16:0] expected_sum;
    logic expected_carry;

    // Counters
    integer total_tests = 0;
    integer passed_tests = 0;

    // Instantiate DUT
    adder dut (
        .clk(clk),
        .rst_n(rst_n),
        .in1(in1),
        .in2(in2),
        .sum(sum),
        .carry(carry)
    );

    // Clock generation
    always #5 clk = ~clk;

    // Apply inputs and check results after clock
    task automatic run_test(
        input logic signed [16:0] a,
        input logic signed [7:0]  b
    );
        logic signed [17:0] temp;
        begin
            in1 = a;
            in2 = b;
            temp = a + $signed({{9{b[7]}}, b}); // manual sign extension
            expected_sum = temp[16:0];
            expected_carry = temp[17];

            @(posedge clk); #1; // Wait for result update

            total_tests++;
            if (sum === expected_sum && carry === expected_carry) begin
                $display("Passed: %0d + %0d = %0d, carry = %0b", a, b, sum, carry);
                passed_tests++;
            end else begin
                $display(" Failed: %0d + %0d", a, b);
                $display("   Expected sum = %0d, carry = %0b", expected_sum, expected_carry);
                $display("   Got      sum = %0d, carry = %0b", sum, carry);
            end
        end
    endtask

    initial begin
        $dumpfile("adder.vcd");
        $dumpvars(0, adder_tb);

        // Init
        clk = 0;
        rst_n = 0;
        in1 = 0;
        in2 = 0;

        #10;
        rst_n = 1;

        // Basic tests
        run_test(16'sd100, 8'sd27);       // 100 + 27 = 127
        run_test(16'sd50, -8'sd20);       // 50 + (-20) = 30
        run_test(-16'sd120, 8'sd50);      // -120 + 50 = -70
        run_test(-16'sd128, -8'sd1);      // -128 -1 = -129
        run_test(16'sd32767, 8'sd1);      // overflow case: 32767 + 1

        // Randomized tests
        repeat (10) begin
            run_test($random, $random);
        end

        $display("Testbench finished: %0d/%0d passed", passed_tests, total_tests);
        $finish;
    end

endmodule
