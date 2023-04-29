
module tb_counter ();

parameter WIDTH_CNT = 5;

logic                   clk             ;
logic                   rst_n           ;
logic                   en_i            ;
logic [WIDTH_CNT-1 : 0] interrupt_num_i ;
logic                   ready_o         ;

counter #(
    .WIDTH_CNT(WIDTH_CNT)
) counter_inst (
    .clk(clk),
    .rst_n(rst_n),
    .en_i(en_i),
    .interrupt_num_i(interrupt_num_i),
    .ready_o(ready_o)
);

initial begin
    $dumpfile("./out/tb_counter.vcd");
    $dumpvars(0, tb_counter);
end

initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

initial begin
    rst_n = 0;
    en_i = 0;
    interrupt_num_i = 0;
    #100;
    rst_n = 1;
    interrupt_num_i = 2;
    #10;
    en_i = 1;
    #10000;
    $finish;
end
    
endmodule