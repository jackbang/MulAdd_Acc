///////////////////////////////////////////////////////////
// Author: Jackbang
///////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////
// ┌─┐
// │┼│
// └─┘
// 
//                      ┌─────────┐
//  16 bits ────────────│         │                 ┌─────────┐
//                      │   Mul   │────32 bits──────│         │
//  16 bits ────────────│         │                 │         │
//                      └─────────┘                 │   Reg   │
//      clk ────────────────────────────────────────│         │
//                                                  └─────────┘
//  懒得画了。
///////////////////////////////////////////////////////////

module process_element #(
    parameter WIDTH_DATA  = 16,
    parameter WIDTH_MDATA = 32
) (
    input                       clk         ,
    input                       rst_n       ,
    input                       format_en_i ,
    input   [WIDTH_DATA-1 : 0]  data_a_i    ,
    input   [WIDTH_DATA-1 : 0]  data_b_i    ,
    input   [WIDTH_MDATA-1 : 0] data_m_i    ,
    output  [WIDTH_MDATA-1 : 0] data_m_o    ,
    output  [WIDTH_DATA-1 : 0]  data_o
);

///////////////////////////////////////////////////////////
// multiplier
///////////////////////////////////////////////////////////
logic   [WIDTH_DATA - 1 : 0]    mul_data_a_i;
logic   [WIDTH_DATA - 1 : 0]    mul_data_b_i;
logic   [WIDTH_MDATA - 1 : 0]   mul_data_o, mul_data_o_reg;

fixedpoint_multiplier #(
    .WIDTH_INPUT(WIDTH_DATA),
    .WIDTH_OUTPUT(WIDTH_MDATA)
) fixedpoint_multiplier_inst (
    .data_a_i(mul_data_a_i),
    .data_b_i(mul_data_b_i),
    .data_o(mul_data_o)
);

always_ff @( posedge clk ) begin
    if (rst_n) begin
        mul_data_a_i <= data_a_i;
        mul_data_b_i <= data_b_i;
        mul_data_o_reg <= mul_data_o;
    end else begin
        // reset
        mul_data_a_i <= 'b0;
        mul_data_b_i <= 'b0;
        mul_data_o_reg <= 'b0;
    end   
end

///////////////////////////////////////////////////////////
// adder
///////////////////////////////////////////////////////////
logic   [WIDTH_MDATA - 1 : 0]   add_data_a_i;
logic   [WIDTH_MDATA - 1 : 0]   add_data_b_i;
logic   [WIDTH_MDATA - 1 : 0]   add_data_o, add_data_o_reg;

fixedpoint_adder #(
    .WIDTH_INPUT(WIDTH_MDATA),
    .WIDTH_OUTPUT(WIDTH_MDATA)
) fixedpoint_adder_inst (
    .data_a_i(add_data_a_i),
    .data_b_i(add_data_b_i),
    .data_o(add_data_o)
);

assign add_data_a_i = mul_data_o_reg;
assign add_data_b_i = data_m_i;

always_ff @( posedge clk ) begin
    if (rst_n) begin
        add_data_o_reg <= add_data_o;
    end else begin
        // reset
        add_data_o_reg <= 'b0;
    end   
end

///////////////////////////////////////////////////////////
// formatter
///////////////////////////////////////////////////////////
logic                           fmt_en_i;
logic   [WIDTH_MDATA - 1 : 0]   fmt_data_i;
logic   [WIDTH_DATA - 1 : 0]    fmt_data_o, fmt_data_o_reg; 

fixedpoint_formatter #(
    .WIDTH_INPUT(WIDTH_MDATA),
    .WIDTH_OUTPUT(WIDTH_DATA),
    .WIDTH_INTEGER(6),
    .WIDTH_FRACTION(7)
) fixedpoint_formatter_inst (
    .data_i(fmt_data_i),
    .data_o(fmt_data_o)
);

always_comb begin
    if (fmt_en_i) begin
        fmt_data_i = add_data_o_reg;
    end else begin
        fmt_data_i = 'b0;
    end
end

always_ff @( posedge clk ) begin
    if (rst_n) begin
        fmt_en_i <= format_en_i;
        fmt_data_o_reg <= fmt_data_o;
    end else begin
        // reset
        fmt_en_i <= 'b0;
        fmt_data_o_reg <= 'b0;
    end   
end

///////////////////////////////////////////////////////////
// result
///////////////////////////////////////////////////////////
assign data_m_o = add_data_o_reg;
assign data_o   = fmt_data_o_reg;
    
endmodule