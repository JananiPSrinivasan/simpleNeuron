module adder(
    input  logic signed [7:0] in1,
    input  logic signed [7:0] in2,
    output logic signed [7:0] sum,
    output logic carry  
);

    logic signed [8:0] full_result;

    always_comb begin
        full_result = in1 + in2;
        
    end
    assign sum = full_result[7:0];
    assign carry = full_result[8];

endmodule
