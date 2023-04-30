
module tb_pe_top ();

parameter WIDTH_DATA  = 16;
parameter WIDTH_MDATA = 32;

logic                       clk             ;
logic                       rst_n           ;

logic [WIDTH_DATA-1 : 0]    v_bus_data_i    ;
logic [WIDTH_DATA-1 : 0]    h_bus_data_i    ;
logic [WIDTH_DATA-1 : 0]    top_data_i      ;
logic [WIDTH_DATA-1 : 0]    bot_data_o      ;

logic [1:0]                 wire_connection_i;

pe_top #(
    .WIDTH_DATA(WIDTH_DATA),
    .WIDTH_MDATA(WIDTH_MDATA)
) pe_top_inst (
    .clk(clk),
    .rst_n(rst_n),
    .v_bus_data_i(v_bus_data_i),
    .h_bus_data_i(h_bus_data_i),
    .top_data_i(top_data_i),
    .bot_data_o(bot_data_o),
    .wire_connection_i(wire_connection_i)
);

logic [WIDTH_DATA-1 : 0]    sur_v_bus_data_i    ;
logic [WIDTH_DATA-1 : 0]    sur_h_bus_data_i    ;
logic [WIDTH_DATA-1 : 0]    sur_top_data_i      ;
logic [WIDTH_DATA-1 : 0]    sur_bot_data_o      ;

logic [1:0]                 sur_wire_connection_i;

pe_top #(
    .WIDTH_DATA(WIDTH_DATA),
    .WIDTH_MDATA(WIDTH_MDATA)
) pe_top_inst_sur (
    .clk(clk),
    .rst_n(rst_n),
    .v_bus_data_i(sur_v_bus_data_i),
    .h_bus_data_i(sur_h_bus_data_i),
    .top_data_i(sur_top_data_i),
    .bot_data_o(sur_bot_data_o),
    .wire_connection_i(sur_wire_connection_i)
);

initial begin
    $dumpfile("./out/tb_pe_top.vcd");
    $dumpvars(0, tb_pe_top);
end

initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

integer i;

assign sur_top_data_i = bot_data_o;

initial begin
    rst_n = 0;
    v_bus_data_i = 99;
    h_bus_data_i = 99;
    top_data_i = 1;
    wire_connection_i = 3;
    sur_v_bus_data_i = 0;
    sur_h_bus_data_i = 0;
    sur_wire_connection_i = 3;
    #100;
    rst_n = 1;
    #6;
    // test first layer calculate
    wire_connection_i = 0;
    sur_wire_connection_i = 0;
    #10;
    for (i = 1; i <= 16 ; i++ ) begin
        v_bus_data_i = i;
        h_bus_data_i = i;
        #10;
        sur_v_bus_data_i = 2*i;
        sur_h_bus_data_i = 2*i;
        #10;
    end
    wire_connection_i = 3;
    sur_wire_connection_i = 3;
    v_bus_data_i = 0;
    h_bus_data_i = 0;
    #10;
    sur_v_bus_data_i = 0;
    sur_h_bus_data_i = 0;
    #10;

    #10;

    wire_connection_i = 1;
    sur_wire_connection_i = 1;
    h_bus_data_i = 20;
    sur_h_bus_data_i = 20;
    #10;

    wire_connection_i = 2;
    sur_wire_connection_i = 2;
    #10;
    for (i = 1; i <= 15 ; i++ ) begin
        top_data_i = 2*i;
        h_bus_data_i = i;
        sur_h_bus_data_i = i;
        #10;
    end
    wire_connection_i = 3;
    sur_wire_connection_i = 3;
    h_bus_data_i = 0;
    sur_h_bus_data_i = 0;
    #30;

    wire_connection_i = 1;
    sur_wire_connection_i = 1;
    h_bus_data_i = 20;
    sur_h_bus_data_i = 20;
    #10;

    wire_connection_i = 2;
    sur_wire_connection_i = 2;
    #10;
    for (i = 1; i <= 15 ; i++ ) begin
        top_data_i = 2*i;
        h_bus_data_i = i;
        sur_h_bus_data_i = i;
        #10;
    end
    wire_connection_i = 3;
    sur_wire_connection_i = 3;
    h_bus_data_i = 0;
    sur_h_bus_data_i = 0;
    #30;
    #1000;
    $finish;
end
    
endmodule