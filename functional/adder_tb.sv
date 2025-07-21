`timescale 1ps/1ps

module adder_tb();

logic signed [15:0]  in1; 
logic signed [7:0] in2;
logic signed[7:0]  sum;
logic signed carry;

adder dut (
    .in1(in1),
    .in2(in2),
    .sum(sum),
    .carry(carry)
);

task test(input logic signed[15:0]a,
          input logic signed [7:0]b
        );

    logic signed [16:0]full_sum;    
    logic signed[8:0] expected;
    logic signed [8:0] result;

    begin 
        in1 = a;
        in2 = b;
        #1 ;

        full_sum = $signed({{8{b[7]}}, b}) +$signed(a);
        result = {carry,sum};

        expected = full_sum[15:7];
        if (full_sum[6])
            expected = expected +1;

        if (result != expected) begin 
            $display ("Error \n Expected : %0d + %0d = 0%d \n Obtained : %0d + %0d = %0d",a,b, expected, in1,in2,result );
        end 
        else begin 
            $display ("Test cases passed!\n Expected : %0d + %0d = 0%d \n Obtained : %0d + %0d = 0%d",a,b, expected, in1,in2,result);
        end

    end
endtask

//Main testing procedure

initial begin
        $display("Starting adder functional verification...");

        // Basic cases
        test(8'sd0, 8'sd0);
        test(8'sd5, 8'sd10);
        test(8'sd127, 8'sd1);
        test(8'sd200, 8'sd100);


        // Randomized testing
        repeat (10) begin
            test($urandom_range(-128,127), $urandom_range(-128,127));
        end

        $display("Testbench completed.");
        $finish;
    end

endmodule

