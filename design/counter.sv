///////////////////////////////////////////////////////////
// Author: Jackbang
///////////////////////////////////////////////////////////

module counter #(
    parameter WIDTH_CNT = 5
) (
    input                       clk             ,
    input                       cnt_rst_i       ,
    input                       cnt_en_i        ,
    output [WIDTH_CNT-1 : 0]    cnt_o
);

logic [WIDTH_CNT-1 : 0] counter, counter_r;

always_ff @( posedge clk ) begin
    if (cnt_rst_i) begin
        counter_r <= 0;
    end else begin
        // reset
        counter_r <= counter;
    end   
end

always_comb begin
    if (cnt_en_i) begin
        counter = counter_r + 1'b1; 
    end else begin
        counter = counter_r;
    end
end

assign cnt_o = counter_r;
    
endmodule