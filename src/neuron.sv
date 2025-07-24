/*
    A neuron uses multiply and accumulate logic for calculating the weights with  the inputs and then add the 
    bias to it.

    So, to think of it logically if we have m layers, and each layer has n neurons, 
    the bias has to be applied to the sum of all n neurons in an m layer

    If we take a particular neuron wich has to recieve the weights and input from three other neurons, then 
    assume temp to be the temporary output  from one particular neuron thus 
    
    temp = (input0 * weight0 + input1 * weight1 + input2*weight2  )+bias

    it is this temp which passes through the ativation funtion

    so output y will be

    y = activation factor * temp 


    To map it to hardware, 
    the temp is done in three stages
        1. multipy the input with the bias
        2. accumulate it in hardware
        3. Add it with bias
    then,
    output = y * temp;

    to build this we will use four modules
    multiplier - to multiply the inputs with weight
    accumulator - to accumulate the total inputs
    adder - to sum with the bias
    output - multipy activation with adder 
      
*/

module neuron(
    input logic clk,
    input logic rst_n,
    input logic signed [7:0] x, // input
    input logic signed [7:0] w, // weights
    input logic signed [7:0] bias, // bias
    output logic signed [17:0] y // output
); 
    // wires to propogate through modules
    logic signed [16:0] accumulated; // accumulated output -> accumulated register -> adder module
    logic signed [17:0] partial_output; // adder_partial_output -> partial_output register -> activation module 
    logic signed [17:0] activated_output; // activated_output -> y

    // registers to store the intermidiate values
    logic signed [16:0] accumulated_reg;
    logic signed [17:0] partial_output_reg;
    logic signed [17:0] activated_output_reg;

    mac mac_u(
    .clk(clk),
    .rst_n(rst_n),
    .x(x),
    .weight(w),
    .out(accumulated)
);

    adder add_u(
        .clk(clk),
        .rst_n(rst_n),
        .in1(accumulated_reg),
        .in2(bias),
        .sum(),         // not used
        .carry(),       // not used
        .total(partial_output)
    );

    activate act_u(
        .clk(clk),
        .rst_n(rst_n),
        .in(partial_output_reg),
        .out(activated_output)
);


    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin 
            accumulated_reg <= 16'sd0;
        end
        else begin 
            //#1;
            accumulated_reg <= accumulated;
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin 
            partial_output_reg <= 17'sd0;
        end
        else begin 
            //#2;
            partial_output_reg <= partial_output;
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin 
            activated_output_reg <= 17'sd0;
        end
        else begin 
            activated_output_reg <= activated_output;
        end
    end

    assign y = activated_output_reg;


endmodule