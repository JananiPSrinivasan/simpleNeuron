module adder(
    input  logic signed [7:0] in1,
    input  logic signed [15:0] in2,
    output logic signed [15:0] sum,
    output logic carry  
);

    logic signed [16:0] full_result;
    logic signed [15:0]in1_ext;

    assign in1_ext = {{8{in1[7]}},in1};  
    
    always_comb begin
        full_result =  in2 +in1_ext ;  
    end

    assign sum = full_result[15:0];
    assign carry = full_result[16];

endmodule
