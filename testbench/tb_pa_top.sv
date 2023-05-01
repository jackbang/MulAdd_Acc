
module tb_pa_top ();
parameter WIDTH_LBIT_CNT = 6;
parameter WIDTH_HBIT_CNT = 3;
parameter SIZE_MAT = 16;
parameter WIDTH_DATA  = 16;
parameter WIDTH_MDATA = 32;

logic                               clk         ;
logic                               rst_n       ;
logic                               data_rdy_i  ;
logic [SIZE_MAT*WIDTH_DATA-1 : 0]   v_bus_i     ;
logic [SIZE_MAT*WIDTH_DATA-1 : 0]   h_bus_i     ;
logic [SIZE_MAT*WIDTH_DATA-1 : 0]   v_bus_r     ;
logic [SIZE_MAT*WIDTH_DATA-1 : 0]   h_bus_r     ;
logic                               read_en_o   ;

pa_top #(
    .WIDTH_LBIT_CNT(WIDTH_LBIT_CNT),
    .WIDTH_HBIT_CNT(WIDTH_HBIT_CNT),
    .SIZE_MAT(SIZE_MAT),
    .WIDTH_DATA(WIDTH_DATA),
    .WIDTH_MDATA(WIDTH_MDATA)
) pa_top_inst (
    .clk(clk),
    .rst_n(rst_n),
    .data_rdy_i(data_rdy_i),
    .v_bus_i(v_bus_i),
    .h_bus_i(h_bus_i),
    .read_en_o(read_en_o)
);

initial begin
    $dumpfile("./out/tb_pa_top.vcd");
    $dumpvars(0, tb_pa_top);
end

initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

always_ff @( posedge clk ) begin
    if (rst_n) begin
        if (read_en_o) begin
            v_bus_i <= v_bus_r;
            h_bus_i <= h_bus_r;
        end
    end else begin
        v_bus_i <= 0;
        h_bus_i <= 0;
    end
end

logic [15:0] i;

initial begin
    rst_n = 0;
    data_rdy_i = 0;
    v_bus_r = 'b0;
    h_bus_r = 'b0;
    #100;
    rst_n = 1;
    #10;
    data_rdy_i = 1;
    #10
    for (i = 0; i < 16 ; i++ ) begin
        v_bus_r = { 16'd0+i, 16'd1+i, 16'd2+i, 16'd3+i, 16'd4+i,
                    16'd5+i, 16'd6+i, 16'd7+i, 16'd8+i, 16'd9+i,
                    16'd10+i, 16'd11+i, 16'd12+i, 16'd13+i, 16'd14+i,
                    16'd15+i};
        h_bus_r = { 16'd0+i, 16'd1+i, 16'd2+i, 16'd3+i, 16'd4+i,
                    16'd5+i, 16'd6+i, 16'd7+i, 16'd8+i, 16'd9+i,
                    16'd10+i, 16'd11+i, 16'd12+i, 16'd13+i, 16'd14+i,
                    16'd15+i};
        #20;
    end
    #30;
    for (i = 100; i < 116 ; i++ ) begin
        v_bus_r = { 16'd0+i, 16'd1+i, 16'd2+i, 16'd3+i, 16'd4+i,
                    16'd5+i, 16'd6+i, 16'd7+i, 16'd8+i, 16'd9+i,
                    16'd10+i, 16'd11+i, 16'd12+i, 16'd13+i, 16'd14+i,
                    16'd15+i};
        h_bus_r = { 16'd0+i, 16'd1+i, 16'd2+i, 16'd3+i, 16'd4+i,
                    16'd5+i, 16'd6+i, 16'd7+i, 16'd8+i, 16'd9+i,
                    16'd10+i, 16'd11+i, 16'd12+i, 16'd13+i, 16'd14+i,
                    16'd15+i};
        #10;
    end
    #30;
    for (i = 0; i < 16 ; i++ ) begin
        v_bus_r = { 16'd0+i, 16'd1+i, 16'd2+i, 16'd3+i, 16'd4+i,
                    16'd5+i, 16'd6+i, 16'd7+i, 16'd8+i, 16'd9+i,
                    16'd10+i, 16'd11+i, 16'd12+i, 16'd13+i, 16'd14+i,
                    16'd15+i};
        h_bus_r = { 16'd0+i, 16'd1+i, 16'd2+i, 16'd3+i, 16'd4+i,
                    16'd5+i, 16'd6+i, 16'd7+i, 16'd8+i, 16'd9+i,
                    16'd10+i, 16'd11+i, 16'd12+i, 16'd13+i, 16'd14+i,
                    16'd15+i};
        #10;
    end
    #30;
    for (i = 100; i < 116 ; i++ ) begin
        v_bus_r = { 16'd0+i, 16'd1+i, 16'd2+i, 16'd3+i, 16'd4+i,
                    16'd5+i, 16'd6+i, 16'd7+i, 16'd8+i, 16'd9+i,
                    16'd10+i, 16'd11+i, 16'd12+i, 16'd13+i, 16'd14+i,
                    16'd15+i};
        h_bus_r = { 16'd0+i, 16'd1+i, 16'd2+i, 16'd3+i, 16'd4+i,
                    16'd5+i, 16'd6+i, 16'd7+i, 16'd8+i, 16'd9+i,
                    16'd10+i, 16'd11+i, 16'd12+i, 16'd13+i, 16'd14+i,
                    16'd15+i};
        #10;
    end
    #30;
    for (i = 0; i < 16 ; i++ ) begin
        v_bus_r = { 16'd0+i, 16'd1+i, 16'd2+i, 16'd3+i, 16'd4+i,
                    16'd5+i, 16'd6+i, 16'd7+i, 16'd8+i, 16'd9+i,
                    16'd10+i, 16'd11+i, 16'd12+i, 16'd13+i, 16'd14+i,
                    16'd15+i};
        h_bus_r = { 16'd0+i, 16'd1+i, 16'd2+i, 16'd3+i, 16'd4+i,
                    16'd5+i, 16'd6+i, 16'd7+i, 16'd8+i, 16'd9+i,
                    16'd10+i, 16'd11+i, 16'd12+i, 16'd13+i, 16'd14+i,
                    16'd15+i};
        #10;
    end
    #30;
    for (i = 100; i < 116 ; i++ ) begin
        v_bus_r = { 16'd0+i, 16'd1+i, 16'd2+i, 16'd3+i, 16'd4+i,
                    16'd5+i, 16'd6+i, 16'd7+i, 16'd8+i, 16'd9+i,
                    16'd10+i, 16'd11+i, 16'd12+i, 16'd13+i, 16'd14+i,
                    16'd15+i};
        h_bus_r = { 16'd0+i, 16'd1+i, 16'd2+i, 16'd3+i, 16'd4+i,
                    16'd5+i, 16'd6+i, 16'd7+i, 16'd8+i, 16'd9+i,
                    16'd10+i, 16'd11+i, 16'd12+i, 16'd13+i, 16'd14+i,
                    16'd15+i};
        #10;
    end
    #30;
    for (i = 0; i < 16 ; i++ ) begin
        v_bus_r = { 16'd0+i, 16'd1+i, 16'd2+i, 16'd3+i, 16'd4+i,
                    16'd5+i, 16'd6+i, 16'd7+i, 16'd8+i, 16'd9+i,
                    16'd10+i, 16'd11+i, 16'd12+i, 16'd13+i, 16'd14+i,
                    16'd15+i};
        h_bus_r = { 16'd0+i, 16'd1+i, 16'd2+i, 16'd3+i, 16'd4+i,
                    16'd5+i, 16'd6+i, 16'd7+i, 16'd8+i, 16'd9+i,
                    16'd10+i, 16'd11+i, 16'd12+i, 16'd13+i, 16'd14+i,
                    16'd15+i};
        #10;
    end
    #30;
    for (i = 100; i < 116 ; i++ ) begin
        v_bus_r = { 16'd0+i, 16'd1+i, 16'd2+i, 16'd3+i, 16'd4+i,
                    16'd5+i, 16'd6+i, 16'd7+i, 16'd8+i, 16'd9+i,
                    16'd10+i, 16'd11+i, 16'd12+i, 16'd13+i, 16'd14+i,
                    16'd15+i};
        h_bus_r = { 16'd0+i, 16'd1+i, 16'd2+i, 16'd3+i, 16'd4+i,
                    16'd5+i, 16'd6+i, 16'd7+i, 16'd8+i, 16'd9+i,
                    16'd10+i, 16'd11+i, 16'd12+i, 16'd13+i, 16'd14+i,
                    16'd15+i};
        #10;
    end
    #30;
    #1000;
    $finish;
end
    
endmodule