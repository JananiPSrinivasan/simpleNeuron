`timescale 1ps/1ps

module adder_tb();

logic [7:0] in1, in2;
logic [7:0] sum;
logic carry;

adder dut (
    .in1(in1),
    .in2(in2),
    .sum(sum),
    .carry(carry)
);

task test(input [7:0]a , input [7:0]b);
    logic [7:0] expected;

    begin 
        in1 = a;
        in2 =b;
        #1 ;

        expected = a+b;

        if ({carry , sum} != expected ) begin 
            $display ("Error \n Expected : %0d+%0d = 0%d \n Obtained : %0d+%0d = 0%d",a,b, expected, in1,in2,{carry,sum} );
        end 
        else begin 
            $display ("Test cases passed!");
        end

    end
endtask

//Main testing procedure

initial begin
        $display("Starting adder functional verification...");

        // Basic cases
        test(8'd0, 8'd0);
        test(8'd5, 8'd10);
        test(8'd127, 8'd1);
        test(8'd255, 8'd1);
        test(8'd200, 8'd100);
        test(8'd255, 8'd255);

        // Randomized testing
        repeat (10) begin
            test($urandom_range(0, 255), $urandom_range(0, 255));
        end

        $display("Testbench completed.");
        $finish;
    end

endmodule

