
module tb_process_element ();

parameter WIDTH_DATA  = 16;
parameter WIDTH_MDATA = 32;

logic                       clk         ;
logic                       rst_n       ;
logic                       format_en_i ;
logic                       keep_data_i ;
logic   [WIDTH_DATA-1 : 0]  data_a_i    ;
logic   [WIDTH_DATA-1 : 0]  data_b_i    ;
logic   [WIDTH_DATA-1 : 0]  data_o      ;

process_element #(
    .WIDTH_DATA(WIDTH_DATA),
    .WIDTH_MDATA(WIDTH_MDATA)
) process_element_inst (
    .clk        (   clk         ),
    .rst_n      (   rst_n       ),
    .format_en_i(   format_en_i ),
    .keep_data_i(   keep_data_i ),
    .data_a_i   (   data_a_i    ),
    .data_b_i   (   data_b_i    ),
    .data_o     (   data_o      )
);

initial begin
    $dumpfile("./out/tb_process_element.vcd");
    $dumpvars(0, tb_process_element);
end

initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

integer i;

initial begin
    rst_n = 0;
    format_en_i = 0;
    
    data_a_i = 16'b0_000000_000000000;
    data_b_i = 16'b0_000000_000000000;
    keep_data_i = 0;
    #100;
    rst_n = 1;
    keep_data_i = 1;
    for (i = 1; i <= 16 ; i++ ) begin
        #10;
        data_a_i = i;
        data_b_i = i;
        #10;
    end
    format_en_i = 1;
    data_a_i = 16'b0_000000_000000000;
    data_b_i = 16'b0_000000_000000000;
    #10;
    format_en_i = 0;
    data_a_i = 16'b0_000000_000000000;
    data_b_i = 16'b0_000000_000000000;
    #10;
    keep_data_i = 0;
    for (i = 1; i <= 16 ; i++ ) begin
        data_a_i = i;
        data_b_i = i;
        #10;
    end
    format_en_i = 1;
    data_a_i = 16'b0_000000_000000000;
    data_b_i = 16'b0_000000_000000000;
    #10;
    data_a_i = 16'b0_000000_000000000;
    data_b_i = 16'b0_000000_000000000;
    #10;
    data_a_i = 16'b0_000000_000000000;
    data_b_i = 16'b0_000000_000000000;
    #10;
    data_a_i = 16'b0_000000_000000000;
    data_b_i = 16'b0_000000_000000000;
    #10;
    $finish;
end

endmodule