module adder(
    input  logic signed [7:0] in1,
    input  logic signed [15:0] in2,
    output logic signed [7:0] sum,
    output logic carry  
);

    logic signed [15:0]in1_ext;
    assign in1_ext = {{8{in1[7]}},in1};  
    logic signed [8:0] trunc;
    logic signed [16:0] temp;
    
    always@(*) begin
        temp =  in2 + in1_ext ; 
        trunc = temp[15:7];
        if (temp[6]) begin
            sum[7:0] = trunc+1;
        end else begin
            sum[7:0] = trunc;
    end
    //assign carry = temp[16]; 
    end


    assign carry = temp[16];

endmodule
