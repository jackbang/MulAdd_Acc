///////////////////////////////////////////////////////////
// Author: Jackbang
///////////////////////////////////////////////////////////

module MulAdd_top (
    input           clk_data,
    input           clk_pe,

    input           rst_n,

    input           load_en_i,
    input  [31:0]   load_payload_i,

    output          result_valid_o,
    output [31:0]   result_payload_o
);

///////////////////////////////////////////////////////////
// shift buffer
///////////////////////////////////////////////////////////
logic [31:0]    shift_buf_data_i      ;
logic           shift_buf_wr_en_i     ;
logic [255:0]   shift_buf_data_o      ;
logic           shift_buf_data_valid_o;

shift_buffer shift_buffer_inst (
    .clk_data(clk_data),
    .rst_n(rst_n),
    .data_i(shift_buf_data_i),
    .wr_en_i(shift_buf_wr_en_i),
    .data_o(shift_buf_data_o),
    .data_valid_o(shift_buf_data_valid_o)
);

assign shift_buf_data_i = load_payload_i;
assign shift_buf_wr_en_i = load_en_i;

///////////////////////////////////////////////////////////
// clock syncer
///////////////////////////////////////////////////////////
logic           syncer_data_valid_i;
logic  [255:0]  syncer_data_i;
logic           syncer_data_valid_o;
logic  [255:0]  syncer_data_o;

clk_syncer clk_syncer_inst (
    .clk_data(clk_data),
    .clk_pe(clk_pe),
    .rst_n(rst_n),
    .data_valid_i(syncer_data_valid_i),
    .data_i(syncer_data_i),
    .data_valid_o(syncer_data_valid_o),
    .data_o(syncer_data_o)
);

assign syncer_data_valid_i = shift_buf_data_valid_o;
assign syncer_data_i = shift_buf_data_o;

///////////////////////////////////////////////////////////
// processor array
///////////////////////////////////////////////////////////
parameter WIDTH_LBIT_CNT = 6;
parameter WIDTH_HBIT_CNT = 3;
parameter SIZE_MAT = 16;
parameter WIDTH_DATA  = 16;
parameter WIDTH_MDATA = 32;

logic                               pe_data_rdy_i  ;
logic [SIZE_MAT*WIDTH_DATA-1 : 0]   pe_v_bus_i     ;
logic [SIZE_MAT*WIDTH_DATA-1 : 0]   pe_h_bus_i     ;
logic [SIZE_MAT*WIDTH_DATA-1 : 0]   pe_v_bus_r     ;
logic [SIZE_MAT*WIDTH_DATA-1 : 0]   pe_h_bus_r     ;
logic                               pe_read_en_o   ;
logic [WIDTH_MDATA-1:0]             pa_output_o    ;
logic                               pa_output_valid_o;

pa_top #(
    .WIDTH_LBIT_CNT(WIDTH_LBIT_CNT),
    .WIDTH_HBIT_CNT(WIDTH_HBIT_CNT),
    .SIZE_MAT(SIZE_MAT),
    .WIDTH_DATA(WIDTH_DATA),
    .WIDTH_MDATA(WIDTH_MDATA)
) pa_top_inst (
    .clk(clk_pe),
    .rst_n(rst_n),
    .data_rdy_i(pe_data_rdy_i),
    .v_bus_i(pe_v_bus_i),
    .h_bus_i(pe_h_bus_i),
    .read_en_o(pe_read_en_o),
    .pa_output_o(pa_output_o),
    .pa_output_valid_o(pa_output_valid_o)
);

assign pe_data_rdy_i = syncer_data_valid_o;

always_ff @( posedge clk_pe ) begin
    if (rst_n) begin
        pe_h_bus_r <= syncer_data_o;
        pe_v_bus_r <= pe_h_bus_r;  
        if (pe_read_en_o) begin
            pe_v_bus_i <= pe_v_bus_r;
            pe_h_bus_i <= pe_h_bus_r;
        end
    end else begin
        pe_h_bus_r <= 0;
        pe_v_bus_r <= 0;
        pe_v_bus_i <= 0;
        pe_h_bus_i <= 0;
    end  
end

assign result_valid_o = pa_output_valid_o;
assign result_payload_o = pa_output_o;
    
endmodule