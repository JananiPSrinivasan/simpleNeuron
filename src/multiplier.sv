module multiplier(
    input logic signed [7:0] weight,
    input logic signed [7:0] x,
    output logic signed [15:0] mul
);

always_comb begin  
    mul = weight * x;  
end
endmodule