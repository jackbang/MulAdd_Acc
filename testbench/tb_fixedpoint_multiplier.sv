
module tb_fixedpoint_multiplier ();

parameter WIDTH_INPUT       = 16;
parameter WIDTH_OUTPUT      = 32;

logic   [WIDTH_INPUT - 1 : 0]   data_a_i;
logic   [WIDTH_INPUT - 1 : 0]   data_b_i;
logic   [WIDTH_OUTPUT - 1 : 0]  data_o  ;

fixedpoint_multiplier #(
    .WIDTH_INPUT(WIDTH_INPUT),
    .WIDTH_OUTPUT(WIDTH_OUTPUT)
) fixedpoint_multiplier_inst (
    .data_a_i(data_a_i),
    .data_b_i(data_b_i),
    .data_o(data_o)
);

initial begin
    data_a_i = 0;
    data_b_i = 0;
    #10;
    data_a_i = -1;
    data_b_i = 73;
    #10;
    data_a_i = -1;
    data_b_i = -1;
    #10;
    data_a_i = 16'b1000_0000_0000_0000;
    data_b_i = 16'b1000_0000_0000_0000;
    #10;
    data_a_i = 16'b1000_0000_0000_0001;
    data_b_i = 16'b1000_0000_0000_0001;
    #10;
    data_a_i = 16'b1000_0000_0000_0000;
    data_b_i = 16'b0100_0000_0000_0000;
    #10;
    data_a_i = 16'b1111_1111_1111_1111;
    data_b_i = 16'b0111_1111_1111_1111;
    #10;
    data_a_i = 16'b0111_1111_1111_1111;
    data_b_i = 16'b0111_1111_1111_1111;
    #10;
    data_a_i = 16'b1000_0000_0000_0000;
    data_b_i = 16'b0111_1111_1111_1111;
    #10;
    data_a_i = 0;
    data_b_i = 0;
end

initial begin
    $dumpfile("./out/tb_fixedpoint_multiplier.vcd");
    $dumpvars(0, tb_fixedpoint_multiplier);
end
    
endmodule