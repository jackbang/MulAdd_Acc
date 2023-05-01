///////////////////////////////////////////////////////////
// Author: Jackbang
///////////////////////////////////////////////////////////

module pa_top #(
    parameter WIDTH_LBIT_CNT = 6,
    parameter WIDTH_HBIT_CNT = 3,
    parameter SIZE_MAT = 16,
    parameter WIDTH_DATA  = 16,
    parameter WIDTH_MDATA = 32
) (
    input                               clk         ,
    input                               rst_n       ,
    input                               data_rdy_i  ,
    input [SIZE_MAT*WIDTH_DATA-1 : 0]   v_bus_i     ,
    input [SIZE_MAT*WIDTH_DATA-1 : 0]   h_bus_i     ,
    output                              read_en_o
);

///////////////////////////////////////////////////////////
// low bits counter
///////////////////////////////////////////////////////////
logic                           lcnt_rst_i      ;
logic                           lcnt_en_i       ;
logic [WIDTH_LBIT_CNT-1 : 0]    lcnt_o          ;

counter #(
    .WIDTH_CNT(WIDTH_LBIT_CNT)
) counter_linst (
    .clk(clk),
    .cnt_rst_i(lcnt_rst_i),
    .cnt_en_i(lcnt_en_i),
    .cnt_o(lcnt_o)
);

///////////////////////////////////////////////////////////
// high bits counter
///////////////////////////////////////////////////////////
logic                           hcnt_rst_i      ;
logic                           hcnt_en_i       ;
logic [WIDTH_LBIT_CNT-1 : 0]    hcnt_o          ;

counter #(
    .WIDTH_CNT(WIDTH_HBIT_CNT)
) counter_hinst (
    .clk(clk),
    .cnt_rst_i(hcnt_rst_i),
    .cnt_en_i(hcnt_en_i),
    .cnt_o(hcnt_o)
);

///////////////////////////////////////////////////////////
// accelerator finite state machine
///////////////////////////////////////////////////////////
logic                           FSM_data_rdy_i      ;
logic                           FSM_read_en_o       ;
logic  [1:0]                    FSM_wire_connect_o  ;

accelerator_FSM #(
    .WIDTH_LBIT_CNT(WIDTH_LBIT_CNT),
    .WIDTH_HBIT_CNT(WIDTH_HBIT_CNT)
) accelerator_FSM_inst (
    .clk(clk),
    .rst_n(rst_n),
    .data_rdy_i(FSM_data_rdy_i),
    .LCNT_en_o(lcnt_en_i),
    .LCNT_rst_o(lcnt_rst_i),
    .LCNT_data_i(lcnt_o),
    .HCNT_en_o(hcnt_en_i),
    .HCNT_rst_o(hcnt_rst_i),
    .HCNT_data_i(hcnt_o),
    .read_en_o(FSM_read_en_o),
    .wire_connect_o(FSM_wire_connect_o)
);

assign read_en_o = FSM_read_en_o;
assign FSM_data_rdy_i = data_rdy_i;

///////////////////////////////////////////////////////////
// processor array
///////////////////////////////////////////////////////////

genvar w, h;
generate
    for (w = 0; w < SIZE_MAT; w = w + 1) begin : PE_W
        wire [WIDTH_DATA-1 : 0] top2bot [SIZE_MAT-1 : 0];
        for (h = 0; h < SIZE_MAT; h = h + 1) begin : PE_H
            if (h == 0) begin
                pe_top #(
                    .WIDTH_DATA(WIDTH_DATA),
                    .WIDTH_MDATA(WIDTH_MDATA)
                ) pe_top_inst (
                    .clk(clk),
                    .rst_n(rst_n),
                    .v_bus_data_i(v_bus_i[WIDTH_DATA*w +: WIDTH_DATA]),
                    .h_bus_data_i(h_bus_i[WIDTH_DATA*h +: WIDTH_DATA]),
                    .top_data_i(top2bot[SIZE_MAT-1]),
                    .bot_data_o(top2bot[h]),
                    .wire_connection_i(FSM_wire_connect_o)
                );
            end else begin
                pe_top #(
                    .WIDTH_DATA(WIDTH_DATA),
                    .WIDTH_MDATA(WIDTH_MDATA)
                ) pe_top_inst (
                    .clk(clk),
                    .rst_n(rst_n),
                    .v_bus_data_i(v_bus_i[WIDTH_DATA*w +: WIDTH_DATA]),
                    .h_bus_data_i(h_bus_i[WIDTH_DATA*h +: WIDTH_DATA]),
                    .top_data_i(top2bot[h-1]),
                    .bot_data_o(top2bot[h]),
                    .wire_connection_i(FSM_wire_connect_o)
                );
            end
        end
    end
endgenerate

endmodule