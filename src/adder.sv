module adder(
    input logic [15:0] in1,
    input logic [15:0] in2,
    output logic [15:0] sum,
    output logic carry
);

    logic [15:0] carry_in;

    half_adder ha0(
        .a(in1[0]),
        .b(in2[0]),
        .ha_sum(sum[0]),
        .ha_carry(carry_in[0])
    );

    genvar i;
    generate
        for (i=1;i<16;i++) begin: full_adder_loop
            full_adder fa1(
                .a(in1[i]),
                .b(in2[i]),
                .cin(carry_in[i-1]),
                .fa_sum(sum[i]),
                .fa_carry(carry_in[i])
            );  

        end
    endgenerate
    assign carry = carry_in[15];
    

endmodule



module full_adder(
    input logic a,
    input logic b,
    input logic cin,
    output logic fa_sum,
    output logic fa_carry
);

    assign fa_sum = a ^ b ^ cin; 
    assign fa_carry = (a&b) | (a&cin) | (b&cin);

endmodule


// Half adder
module half_adder(
    input logic a,
    input logic b,
    output logic ha_sum,
    output logic ha_carry

);

    assign ha_sum = a^b;
    assign ha_carry = a & b; 
endmodule
