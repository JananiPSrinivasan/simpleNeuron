`timescale 1ps/1ps

module neuron_tb();

    // DUT I/O
    logic               clk;
    logic               rst_n;      // active-low reset
    logic signed [7:0]  x;
    logic signed [7:0]  w;
    logic signed [7:0]  b;
    logic signed [17:0] y;        // 18-bit output

    // Counters
    integer total_tests  = 0;
    integer test_nums =0;
    // Instantiate the neuron
    neuron dut (
        .clk  (clk),
        .rst_n  (rst_n),
        .x    (x),
        .w    (w),
        .bias (b),
        .y    (y)
    );

    always #5 clk = ~clk;


    task test(
        input logic signed  [7:0] a,
        input logic signed [7:0] weight,
        input logic signed [7:0] bias
    ); 
        logic signed [15:0] product;
        logic signed [16:0] accumulate;
        logic signed [17:0] activate;
        logic signed [17:0] out;
        logic signed [17:0] expected;

        logic signed [16:0] product_ext;
        logic signed [16:0] bias_ext;

        begin 
            accumulate = 16'sd0;
            total_tests ++;
            test_nums ++;
            x = a;
            w = weight;
            b = bias;
            
            product = a * w;
            product_ext = {{1{product[15]}},product};
            accumulate = product_ext + accumulate;
            #1;
            bias_ext = {{9{bias[7]}},bias};
            activate = accumulate + bias_ext;
            #1;
            // activate and assign to the output
            if (activate [17])
                out = 18'sd0;
            else
                out = activate;
            #1;
            expected = out;
            
            #1;

            repeat (7) @(posedge clk); #1;
            if (y!==expected)
                $display ("Testcase Failed (%0d/%0d) \n Expected:  %0d\n Obtained: %0d",
                        test_nums, total_tests, expected, y);

            else
                $display  ("Testcase Passed (%0d/%0d) \n Expected:  %0d\n Obtained: %0d ",
                    test_nums, total_tests, expected, y);
           
        end         
    endtask

    initial begin
        $dumpfile("neuron.vcd");
        $dumpvars(0, neuron_tb);

        // Initialize
        clk = 0;
        rst_n = 0;
        x = 0;
        w = 0;
        b = 0;

       #10;
       rst_n = 1;

        // Run tests
        test(8'sb00000011, 8'sb00000010, 8'sb00000001);                 //  3*2 + 1 = 7 → y = 7
        #1;
        rst_n = 0;
        #1;
        rst_n = 1;

        test(8'sb00001010, 8'sb00001010, 8'sb11111011);              // 10*10 - 5 = 95 → y = 95
        #1;
        rst_n = 0;
        #1;
        rst_n = 1;

        test(8'sb11111011, 8'sb00000101, 8'sb00000100);              // -5*5 + 4 = -21 → y = 0 (ReLU)
        #1;
        rst_n = 0;
        #1;
        rst_n = 1;

        test(8'sb01100100, 8'sb00000001, 8'sb10000000);              // 100 - 128 = -28 → y = 0 (ReLU)
        #1;
        rst_n = 0;
        #1;
        rst_n = 1;

        test(8'sb00000100, 8'sb00000100, 8'sb00000100);                // 4*4 + 4 = 20 → y = 20


        $display("Neuron Testbench complete: %0d tests run", total_tests);
        $finish;
    end


endmodule