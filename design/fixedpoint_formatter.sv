///////////////////////////////////////////////////////////
// Author: Jackbang
///////////////////////////////////////////////////////////

module fixedpoint_formatter #(
    parameter WIDTH_INPUT       = 32,
    parameter WIDTH_OUTPUT      = 16,
    parameter WIDTH_INTEGER     = 6,
    parameter WIDTH_FRACTION    = 9
) (
    input   [WIDTH_INPUT - 1 : 0]   data_i,
    output  [WIDTH_OUTPUT - 1 : 0]  data_o  
);

///////////////////////////////////////////////////////////
// necessary vars
///////////////////////////////////////////////////////////
logic frac_carry_bit;
logic [WIDTH_INPUT - WIDTH_FRACTION : 0] rounded_data;

// assign frac_carry_bit = data_i[WIDTH_INPUT-1] ? (data_i[WIDTH_FRACTION-1] & (|data_i[0 +: WIDTH_FRACTION-1])) : data_i[WIDTH_FRACTION-1];
assign frac_carry_bit = data_i[WIDTH_FRACTION-1];
// may optimize?
assign rounded_data = {data_i[WIDTH_INPUT-1], data_i[WIDTH_INPUT-1 : WIDTH_FRACTION]} + frac_carry_bit;

///////////////////////////////////////////////////////////
// saturation rounding
///////////////////////////////////////////////////////////
logic sign_bit;
logic [WIDTH_INPUT - 2*WIDTH_FRACTION - WIDTH_INTEGER - 1 : 0] overflow_bits;

assign sign_bit = rounded_data[WIDTH_INPUT - WIDTH_FRACTION];
assign overflow_bits =  rounded_data[WIDTH_INPUT - WIDTH_FRACTION - 1 -: WIDTH_INPUT - 2*WIDTH_FRACTION - WIDTH_INTEGER];

///////////////////////////////////////////////////////////
// results
///////////////////////////////////////////////////////////
logic and_sig;
logic or_sig;

assign and_sig = &overflow_bits;
assign or_sig  = |overflow_bits;

logic [WIDTH_OUTPUT - 1 : 0] normal_result;
assign normal_result = {sign_bit, rounded_data[0 +: WIDTH_OUTPUT-1]};

logic [WIDTH_OUTPUT - 1 : 0] data_o_reg;
always_comb begin
    if (sign_bit) begin
        // neg number
        if (and_sig) begin
            // all 1
            data_o_reg = normal_result;
        end else begin
            // not all 1
            data_o_reg = {sign_bit, {(WIDTH_OUTPUT-1){1'b0}}};
        end
    end else begin
        // pos number
        if (or_sig) begin
            // 1 sta
            data_o_reg = {sign_bit, {(WIDTH_OUTPUT-1){1'b1}}};
        end else begin
            // not sta
            data_o_reg = normal_result;
        end
    end
end

assign data_o = data_o_reg;

endmodule