
module tb_MulAdd_top ();

logic           clk_data;
logic           clk_pe;

logic           rst_n;

logic           load_en_i;
logic  [31:0]   load_payload_i;

logic           result_valid_o;
logic  [31:0]   result_payload_o;
    
MulAdd_top MulAdd_top_inst (
    .clk_data(clk_data),
    .clk_pe(clk_pe),
    .rst_n(rst_n),
    .load_en_i(load_en_i),
    .load_payload_i(load_payload_i),
    .result_valid_o(result_valid_o),
    .result_payload_o(result_payload_o)
);

initial begin
    clk_data = 0;
    forever #5 clk_data = ~clk_data;
end

initial begin
    clk_pe = 0;
    #5;
    clk_pe = 1;
    #5;
    clk_pe = 0;
    #76;
    forever #40 clk_pe = ~clk_pe;
end

integer i, k;

initial begin
    rst_n = 0;
    load_payload_i = 0;
    load_en_i = 0;
    #100;
    rst_n = 1;
    #10;
    load_en_i = 1;
    for (k = 0; k<32 ; k++) begin
        for (i = 1; i<9 ; i++ ) begin
            load_payload_i = i+k+64;
            #10;
        end
    end
    #240;
    for (k = 0; k<16 ; k++) begin
        for (i = 1; i<9 ; i++ ) begin
            load_payload_i = i+k+64;
            #10;
        end
    end
    #240;
    for (k = 0; k<16 ; k++) begin
        for (i = 1; i<9 ; i++ ) begin
            load_payload_i = i+k+64;
            #10;
        end
    end
    #240;
    for (k = 0; k<16 ; k++) begin
        for (i = 1; i<9 ; i++ ) begin
            load_payload_i = i+k+64;
            #10;
        end
    end
    #240;
    for (k = 0; k<16 ; k++) begin
        for (i = 1; i<9 ; i++ ) begin
            load_payload_i = i+k+64;
            #10;
        end
    end
    #240;
    for (k = 0; k<16 ; k++) begin
        for (i = 1; i<9 ; i++ ) begin
            load_payload_i = i+k+64;
            #10;
        end
    end
    #240;
    for (k = 0; k<16 ; k++) begin
        for (i = 1; i<9 ; i++ ) begin
            load_payload_i = i+k+64;
            #10;
        end
    end
    #240;
    for (k = 0; k<16 ; k++) begin
        for (i = 1; i<9 ; i++ ) begin
            load_payload_i = i+k+64;
            #10;
        end
    end
    #10000;
    $finish;
end

initial begin
    $dumpfile("./out/tb_MulAdd_top.vcd");
    $dumpvars(0, tb_MulAdd_top);
end

endmodule

