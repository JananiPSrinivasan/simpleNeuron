module neuron(
    input logic clk,
    input logic rst_n,
    input logic signed [7:0] x,       // input
    input logic signed [7:0] w,       // weights
    input logic signed [7:0] bias,    // bias
    output logic signed [17:0] y      // output
); 
    // Wires between modules
    logic signed [16:0] accumulated;         // mac output
    logic signed [17:0] partial_output;      // adder output
    logic signed [17:0] activated_output;    // activate output

    // Registers for pipelining
    logic signed [7:0] x_reg, w_reg;                 // stage 1 registers
    logic signed [16:0] accumulated_reg;            // stage 2
    logic signed [17:0] partial_output_reg;         // stage 3
    logic signed [17:0] activated_output_reg;       // stage 4

    // Stage 1: Register inputs
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            x_reg <= 8'sd0;
            w_reg <= 8'sd0;
        end else begin
            x_reg <= x;
            w_reg <= w;
        end
    end

    // Stage 2: Multiply (MAC)
    mac mac_u(
        .clk(clk),
        .rst_n(rst_n),
        .x(x_reg),
        .weight(w_reg),
        .out(accumulated)
    );

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            accumulated_reg <= 17'sd0;
        else
            accumulated_reg <= accumulated;
    end

    // Stage 3: Add bias
    adder add_u(
        .clk(clk),
        .rst_n(rst_n),
        .in1(accumulated_reg),
        .in2(bias),
        .sum(),         // not used
        .carry(),       // not used
        .total(partial_output)
    );

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            partial_output_reg <= 17'sd0;
        else
            partial_output_reg <= partial_output;
    end

    // Stage 4: Activation
    activate act_u(
        .clk(clk),
        .rst_n(rst_n),
        .in(partial_output_reg),
        .out(activated_output)
    );

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            activated_output_reg <= 17'sd0;
        else
            activated_output_reg <= activated_output;
    end

    assign y = activated_output_reg;

endmodule
