`timescale 1ps/1ps

module activate_tb();

    // DUT I/O
    logic               clk;
    logic               rst_n;
    logic signed [16:0] in;
    logic signed [16:0] out;

    // Counters
    integer total_tests   = 0;
    integer tests_passed  = 0;

    // Instantiate the ReLU module
    activate dut (
        .clk   (clk),
        .rst_n (rst_n),
        .in    (in),
        .out   (out)
    );

    // 10 GHz clock: 100 ps period → toggle every 50 ps
    initial begin
        clk = 0;
        forever #50 clk = ~clk;
    end

    // A simple task to apply one test vector and check the result
    task automatic test;
        input  logic signed [7:0] a;
        logic signed [16:0] expected;
        begin
            total_tests++;
           
            // compute expected ReLU in the testbench
            if (a[16])
                expected = 17'sd0;
            else
                expected = a;

            // drive the input
            in = a;

            // wait one clock for the pipeline register
            @(posedge clk);
            #1;

            if (out === expected) begin
                $display("  [PASS] in=%0d out=%0d", a, out);
                tests_passed++;
            end else begin
                $display("  [FAIL] in=%0d out=%0d (expected %0d)", a, out, expected);
            end
        end
    endtask

    // Test sequence
    initial begin
  
        rst_n      = 1;
        in         = 0;
        #20;

        $display("\nStarting ReLU tests...");

        test(17'sd0);       // zero
        test(17'sd12345);   // positive
        test(-17'sd1);      // -1
        test(-17'sd32768);  // large negative
        test(17'sd32767);   // large positive

        $display("\nTest summary: %0d/%0d passed", tests_passed, total_tests);
        if (tests_passed != total_tests)
            $display("Some tests failed.");
        else
            $finish;
    end

endmodule
