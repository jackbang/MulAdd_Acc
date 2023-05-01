
module tb_counter ();

parameter WIDTH_CNT = 5;

logic                       clk             ;
logic                       cnt_rst_i       ;
logic                       cnt_en_i        ;
logic [WIDTH_CNT-1 : 0]     cnt_o           ;

counter #(
    .WIDTH_CNT(WIDTH_CNT)
) counter_inst (
    .clk(clk),
    .cnt_rst_i(cnt_rst_i),
    .cnt_en_i(cnt_en_i),
    .cnt_o(cnt_o)
);

initial begin
    $dumpfile("./out/tb_counter.vcd");
    $dumpvars(0, tb_counter);
end

initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

integer i;

initial begin
    cnt_rst_i = 1;
    cnt_en_i = 0;
    #100;
    cnt_rst_i = 0;
    #10;
    cnt_en_i = 1;
    #100;
    cnt_rst_i = 1;
    #10;
    cnt_rst_i = 0;
    #1000;
    $finish;
end
    
endmodule