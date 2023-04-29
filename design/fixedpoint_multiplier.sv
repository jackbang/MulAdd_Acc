///////////////////////////////////////////////////////////
// Author: Jackbang
///////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////
// DATA FORMAT:
//
// |----|--------------|------------------|
// 15 S 14   INTEGER  9|8    FRACTION     0
// SIGNED         : 1 bits
// WIDTH_INTEGER  : 6 bits
// WIDTH_FRACTION : 9 bits
//
// (-1)^(S)*INT.FRAC * (-1)^(S)*INT.FRAC
//
///////////////////////////////////////////////////////////

module fixedpoint_multiplier #(
    parameter WIDTH_INPUT  = 16,
    parameter WIDTH_OUTPUT = 32
) (
    input   [WIDTH_INPUT - 1 : 0]   data_a_i,
    input   [WIDTH_INPUT - 1 : 0]   data_b_i,
    output  [WIDTH_OUTPUT - 1 : 0]  data_o  
);

///////////////////////////////////////////////////////////
// extend bits
///////////////////////////////////////////////////////////
logic [WIDTH_OUTPUT - 1 : 0] extended_data_a;
logic [WIDTH_OUTPUT - 1 : 0] extended_data_b;

assign extended_data_a = {{(WIDTH_OUTPUT - WIDTH_INPUT){data_a_i[WIDTH_INPUT - 1]}}, data_a_i};
assign extended_data_b = {{(WIDTH_OUTPUT - WIDTH_INPUT){data_b_i[WIDTH_INPUT - 1]}}, data_b_i};

///////////////////////////////////////////////////////////
// calculate
///////////////////////////////////////////////////////////
assign data_o = extended_data_a * extended_data_b;

endmodule