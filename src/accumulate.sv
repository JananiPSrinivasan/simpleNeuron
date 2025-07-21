module accumulate (
    input  logic clk,
    input  logic rst,
    input  logic en,
    input  logic signed [7:0] x,
    input  logic signed [7:0] weight,
    input  logic signed [7:0] bias,
    output logic signed [7:0] accu
);

    // Internal signals
    logic signed [15:0] product;
    logic signed [7:0] add_out;
    logic              carry;
    logic signed [7:0] accumulator;
    logic signed [7:0]  add_out_reg;


    // Debug signals
    logic signed [15:0] debug_product;
    logic signed [7:0] debug_add_out;
    
    // Use multiplier module
    multiplier u_mul (
        .weight(weight),
        .x(x),
        .mul(product)
    );
    assign debug_product = product;  // For debugging

    // Use adder module (it handles rounding and truncation)
    adder u_add (
        .in1(product),
        .in2(bias),
        .sum(add_out),
        .carry(carry)
    );
    assign debug_add_out = add_out;  // For debugging

    // pipeline the adder output
    always_ff @(posedge clk) begin
        if (rst)
            add_out_reg <= 0;
        else
            add_out_reg <= add_out;
    end
    // Accumulate the truncated + rounded result from adder
    always_ff @(posedge clk) begin 
        if (rst)
            accumulator <= 8'sd0;
        else if (en)
            accumulator <= accumulator + add_out_reg;
    end
    assign accu = accumulator;

endmodule
module multiplier(
    input logic signed [7:0] weight,
    input logic signed [7:0] x,
    output logic signed [15:0] mul
);
    logic signed [15:0]  temp;

    always_comb begin  
        temp = weight * x;     
    end
    assign mul = temp;

endmodule

module adder(
    input  logic signed [15:0] in1,
    input  logic signed [7:0]  in2,
    output logic signed [7:0]  sum,
    output logic              carry  
);

    logic signed [16:0] temp;
    // sign-extend bias to 16 bits
    wire signed [15:0] in2_ext = {{8{in2[7]}}, in2};

    always@(*) begin
        temp = in1 + in2_ext;
        sum  = temp[7:0];     // take the low 8 bits
    end

    // carry out is the top bit of the 17-bit result
    assign carry = temp[16];
endmodule
