module multiplier(
    input logic signed [7:0] weight,
    input logic signed [7:0] x,
    output logic signed [8:0] mul
);
    logic signed [15:0]  temp;

    always_comb begin  
        temp = weight * x; 
        
    end

    assign mul = temp [15:7];

endmodule