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

    // Use multiplier module
    multiplier u_mul (
        .weight(weight),
        .x(x),
        .mul(product)
    );

    // Use adder module (it handles rounding and truncation)
    adder u_add (
        .in1(product),
        .in2(bias),
        .sum(add_out),
        .carry(carry)
    );

    // Accumulate the truncated + rounded result from adder
    always_ff @(posedge clk) begin 
        if (rst)
            accumulator <= 8'sd0;
        else if (en)
            accumulator <= accumulator + add_out;
    end

    assign accu = accumulator;

endmodule
