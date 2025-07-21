`timescale 1ps/1ps

module multiplier_tb();

    logic signed [7:0] weight;
    logic signed [7:0] in;
    logic signed [15:0] out;

    multiplier dut (
        .weight(weight),
        .x(in),
        .mul(out)
    );
    integer test_num = 0;
    integer total_tests = 0;
    task test (
        input logic signed[7:0]a,
        input logic signed [7:0]b
        );
        logic signed [15:0] temp;
        logic signed[15:0] expected;

        begin
            test_num ++;
            total_tests ++;
            in = a;
            weight = b;
            #1;

            temp = a*b;
            expected = temp;
            
            if (out != expected) begin
                $display ("Testcase Failed (%0d/%0d) \n Expected : %0d*%0d = %0d\n Obtained : %0d*%0d = %0d",test_num, total_tests, a,b,expected,weight,in,out);
            end
            else begin
                $display ("Testcase Passed (%0d/%0d)\n Expected : %0d*%0d = %0d\n Obtained : %0d*%0d = %0d",test_num, total_tests, a,b,expected,weight,in,out);
            end

        end

    endtask

    initial begin



        //Basic test cases 
        test(8'sb00000010, 8'sb00000010); // small number
        test(8'sb01000000, 8'sb01000000); // large number
        test(8'sb00000000, 8'sb00000001); // multiplied with zero
        test(8'sb00000001, 8'sb00000010); // multiplied with one

        //Edge case
        test (8'sb10000001, 8'sb10000001); //negative * negative -1*-1 = 1
        test (8'sb10000001, 8'sb10000010); // negative * positive -1*2 = -2
        test (8'sb00000001, 8'sb10000001); // positive * negative 1*-1 = 1
        test (8'sb11111111, 8'sb11111111); // 127 * 127
        test (8'sb00000000, 8'sb00000000); // 0*0

        repeat(10) begin
            test($signed($urandom_range(-128,127)), $signed($urandom_range(-128,127) ));

        end

        $display ("Testbench Complete");
        $finish;
    end


endmodule