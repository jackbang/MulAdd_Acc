
module tb_FSM ();

parameter WIDTH_LBIT_CNT = 6;
parameter WIDTH_HBIT_CNT = 3;

logic                           clk             ;
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

logic                           rcnt_rst_i      ;
logic                           rcnt_en_i       ;
logic [WIDTH_LBIT_CNT-1 : 0]    rcnt_o          ;

counter #(
    .WIDTH_CNT(WIDTH_HBIT_CNT)
) counter_rinst (
    .clk(clk),
    .cnt_rst_i(rcnt_rst_i),
    .cnt_en_i(rcnt_en_i),
    .cnt_o(rcnt_o)
);

logic                           rst_n           ;
logic                           data_rdy_i      ;

logic                           read_en_o       ;
logic  [1:0]                    wire_connect_o  ;

accelerator_FSM #(
    .WIDTH_LBIT_CNT(WIDTH_LBIT_CNT),
    .WIDTH_HBIT_CNT(WIDTH_HBIT_CNT)
) accelerator_FSM_inst (
    .clk(clk),
    .rst_n(rst_n),
    .data_rdy_i(data_rdy_i),
    .LCNT_en_o(lcnt_en_i),
    .LCNT_rst_o(lcnt_rst_i),
    .LCNT_data_i(lcnt_o),
    .HCNT_en_o(rcnt_en_i),
    .HCNT_rst_o(rcnt_rst_i),
    .HCNT_data_i(rcnt_o),
    .read_en_o(read_en_o),
    .wire_connect_o(wire_connect_o)
);

initial begin
    $dumpfile("./out/tb_FSM.vcd");
    $dumpvars(0, tb_FSM);
end

initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

initial begin
    rst_n = 0;
    data_rdy_i = 0;
    #100;
    rst_n = 1;
    #100;
    data_rdy_i = 1;
    #10000;
    $finish;
end
    
endmodule