module accumulate (
    input logic clk,
    input logic rst,
    input logic en,
    input logic signed [7:0] x,
    input logic signed [7:0] weight,
    input logic signed [7:0] bias,
    output logic signed [7:0] accu
);

// internal wires
    logic signed [15:0] product;
    logic signed [15:0] new_sum;

// internal accumulator

    logic signed [15:0] accumulator;
    multiplier u_mul (
        .weight(weight),
        .x(x),
        .mul (product)
    );
    adder u_add (
        .in1(product),
        .in2(bias),
        .sum(new_sum)
    );

    always_ff @( posedge clk ) begin 
        if (rst) begin
            accumulator <= 8'sd0;
        end        
        else if (en) begin
            accumulator <= new_sum;
        end
    end

    assign accu = accumulator[15:8];

endmodule

