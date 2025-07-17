module multiplier_formal;

logic signed [7:0] weight;
logic signed [7:0] input;
logic signed [15:0] output;

multiplier dut (
    .weight(weight),
    .x(x),
    .mul (output)
);

initial begin
    assume (property($stable(weight)));
    assume(property($stable(x)));

    assert property (
        mul === weight*x
    );
end

endmodule