///////////////////////////////////////////////////////////
// Author: Jackbang
///////////////////////////////////////////////////////////

module pe_top #(
    parameter WIDTH_DATA  = 16,
    parameter WIDTH_MDATA = 32
) (
    input                       clk             ,
    input                       rst_n           ,

    input [WIDTH_DATA-1 : 0]    v_bus_data_i    ,
    input [WIDTH_DATA-1 : 0]    h_bus_data_i    ,
    input [WIDTH_DATA-1 : 0]    top_data_i      ,
    output [WIDTH_DATA-1 : 0]   bot_data_o      ,

    input                       output_en_i     ,
    input [1:0]                 wire_connection_i
);

///////////////////////////////////////////////////////////
// process element
///////////////////////////////////////////////////////////
logic                       pe_format_en_i, pe_format_en_r ;
logic                       pe_keep_data_i, pe_keep_data_r ;
logic   [WIDTH_DATA-1 : 0]  pe_data_a_i   , pe_data_a_r    ;
logic   [WIDTH_DATA-1 : 0]  pe_data_b_i   , pe_data_b_r    ;
logic   [WIDTH_DATA-1 : 0]  pe_data_o      ;

process_element #(
    .WIDTH_DATA(WIDTH_DATA),
    .WIDTH_MDATA(WIDTH_MDATA)
) process_element_inst (
    .clk        (   clk             ),
    .rst_n      (   rst_n           ),
    .format_en_i(   pe_format_en_r  ),
    .keep_data_i(   pe_keep_data_r  ),
    .data_a_i   (   pe_data_a_r     ),
    .data_b_i   (   pe_data_b_r     ),
    .data_o     (   pe_data_o       )
);

always_ff @( posedge clk ) begin
    if (rst_n) begin
        pe_format_en_r <= pe_format_en_i;
        pe_keep_data_r <= pe_keep_data_i;
        pe_data_a_r <= pe_data_a_i;
        pe_data_b_r <= pe_data_b_i;
    end else begin
        // reset
        pe_format_en_r <= 0;
        pe_keep_data_r <= 0;
        pe_data_a_r <= 0;
        pe_data_b_r <= 0;
    end   
end

///////////////////////////////////////////////////////////
// decode wire connection 
//
// wire_connect_o description:
//  0:  data_a = v_bus
//      data_b = h_bus
//
//  1:  data_a = formatted_result
//      data_b = h_bus
//
//  2:  data_a = top_module
//      data_b = h_bus
//      buttom_data = data_a
//  
//  3:  data_a = 0
//      data_b = 0
///////////////////////////////////////////////////////////
logic [WIDTH_DATA-1 : 0]   bot_data_r;
logic [1:0] wire_connection_r;

assign bot_data_o = bot_data_r;

always_ff @( posedge clk ) begin
    wire_connection_r <= wire_connection_i;
end

always_comb begin
    pe_format_en_i = pe_format_en_r;
    pe_keep_data_i = pe_keep_data_r;
    pe_data_a_i = pe_data_a_r;
    pe_data_b_i = pe_data_b_r;
    bot_data_r = (output_en_i) ? pe_data_o : pe_data_a_r;
    case (wire_connection_r)
        0 : begin
            pe_data_a_i = v_bus_data_i;
            pe_data_b_i = h_bus_data_i;
            pe_keep_data_i = 1;
            pe_format_en_i = 0;
        end
        1 : begin
            pe_data_a_i = pe_data_o;
            pe_data_b_i = h_bus_data_i;
            pe_keep_data_i = 0;
            pe_format_en_i = 0;
        end
        2 : begin
            pe_data_a_i = top_data_i;
            pe_data_b_i = h_bus_data_i;
            pe_keep_data_i = 0;
            pe_format_en_i = 0;
        end
        3 : begin
            pe_data_a_i = 0;
            pe_data_b_i = 0;
            pe_format_en_i = 1;
        end
    endcase
end

///////////////////////////////////////////////////////////
// output part
///////////////////////////////////////////////////////////

    
endmodule