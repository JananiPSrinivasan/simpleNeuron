`timescale 1ns/1ps

module mac_tb();

    logic clk;
    logic rst_n;
    logic signed [7:0] weight;
    logic signed [7:0] in;
    logic signed [15:0] out;

    mac dut (
        .clk(clk),
        .rst_n(rst_n),
        .weight(weight),
        .x(in),
        .out(out) 
    );

    integer test_num = 0;
    integer total_tests = 0;
    logic signed [15:0] expected;

    always #5 clk = ~clk;

    task test (
        input logic signed [7:0] a,
        input logic signed [7:0] b
    );
        
        begin
            test_num++;
            total_tests++;
            in = a;
            weight = b;
            // Wait for the next rising edge of the clock — this is when the MAC output updates
            @(posedge clk); 
            #1; // wait for an delay for signals to stabilize
            expected = a*b + expected ; // Compute expected output

            if (out !== expected) begin
                $display ("Testcase Failed (%0d/%0d) \n Expected: %0d*%0d = %0d\n Obtained: %0d*%0d = %0d",
                    test_num, total_tests, a, b, expected, weight, in, out);
            end else begin
                $display ("Testcase Passed (%0d/%0d)\n Expected: %0d*%0d+%0d = %0d\n Obtained: %0d*%0d+%0d = %0d",
                    test_num, total_tests, a, b, expected,expected, weight, in, out, out);
            end
        end
    endtask

    initial begin

        $dumpfile("mac.vcd");
        $dumpvars(0, mac_tb);
        
        clk=0;
        rst_n=0;
        in=0;
        weight=0;
        expected=0;

        #10 rst_n=1;

        // Basic test cases 
        test(8'sb00000010, 8'sb00000010); // small number
        test(8'sb01000000, 8'sb01000000); // large number
        test(8'sb00000000, 8'sb00000001); // multiplied with zero
        test(8'sb00000001, 8'sb00000010); // multiplied with one

        // Edge case
        test(8'sb10000001, 8'sb10000001); // -127 * -127
        test(8'sb10000001, 8'sb00000010); // -127 * 2
        test(8'sb00000001, 8'sb10000001); // 1 * -127
        test(8'sb01111111, 8'sb01111111); // 127 * 127
        test(8'sb00000000, 8'sb00000000); // 0 * 0

        `ifdef VERILATOR
            test(-8'sd5, 8'sd3);
            test(8'sd2, -8'sd2);
        `else

        repeat(10) begin
            test($signed($urandom_range(-128, 127)), $signed($urandom_range(-128, 127)));
        end
        `endif 

        $display ("Testbench Complete");
        $finish;
    end

endmodule
