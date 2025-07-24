`timescale 1ps/1ps

module neuron_tb();

    // DUT I/O
    logic               clk;
    logic               rst;      // active-low reset
    logic signed [7:0]  x;
    logic signed [7:0]  w;
    logic signed [7:0]  bias;
    logic signed [16:0] y;        // 17-bit output

    // Counters
    integer total_tests   = 0;
    integer tests_passed  = 0;

    // Instantiate the neuron
    neuron dut (
        .clk  (clk),
        .rst  (rst),
        .x    (x),
        .w    (w),
        .bias (bias),
        .y    (y)
    );

    // 10 GHz clock: 100 ps period → toggle every 50 ps
    initial begin
        clk = 0;
        forever #50 clk = ~clk;
    end

    // Reset pulse (active-low)
    initial begin
        rst = 0;
        #200;
        rst = 1;
    end

    // Simple test task
    task automatic test;
        input logic signed [7:0] tx, tw, tb;
        logic signed [16:0]      expected;
        begin
            total_tests++;

            // golden MAC + bias (8×8→16 bits, +8→17 bits)
            expected = tx * tw + tb;

            // drive inputs
            x    = tx;
            w    = tw;
            bias = tb;

            // wait one cycle for pipeline
            @(posedge clk);
            #1;

            if (y === expected) begin
                $display("[PASS] x=%0d w=%0d bias=%0d -> y=%0d", tx, tw, tb, y);
                tests_passed++;
            end else begin
                $display("[FAIL] x=%0d w=%0d bias=%0d -> y=%0d (exp %0d)", tx, tw, tb, y, expected);
            end
        end
    endtask

    // Test sequence
    initial begin
        // wait for reset release
        @(posedge rst);
        #20;

        $display("\nStarting neuron tests...");

        test( 8'sd  2,  8'sd  3,  8'sd  1);
        test(-8'sd  5,  8'sd  2,  8'sd  4);
        test( 8'sd 10, -8'sd  1,  8'sd  2);
        test( 8'sd  0,  8'sd  0,  8'sd  0);
        test( 8'sd127,  8'sd127,  8'sd127);

        $display("\nTest summary: %0d/%0d passed", tests_passed, total_tests);
        if (tests_passed != total_tests)
            $display("Some tests failed.");
        else
            $finish;
    end

endmodule
