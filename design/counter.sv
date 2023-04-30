///////////////////////////////////////////////////////////
// Author: Jackbang
///////////////////////////////////////////////////////////

module counter #(
    parameter WIDTH_CNT = 5
) (
    input                   clk             ,
    input                   rst_n           ,
    input                   en_i            ,
    input [WIDTH_CNT-1 : 0] clear_period_i  ,
    input [WIDTH_CNT-1 : 0] interrupt_num_i ,
    output                  ready_o
);

logic [WIDTH_CNT-1 : 0] counter, counter_r;
logic ready_o_r;

always_ff @( posedge clk ) begin
    if (rst_n) begin
        counter_r <= counter;
    end else begin
        // reset
        counter_r <= -1;
    end   
end

always_comb begin
    if (en_i) begin
        if (counter_r == clear_period_i) begin
            counter = 0;
        end else begin
            counter = counter_r + 1'b1; 
        end
    end else begin
        counter = counter_r;
    end

    if (counter_r == interrupt_num_i) begin
        ready_o_r = 1;
    end else begin
        ready_o_r = 0;
    end
end

assign ready_o = ready_o_r;
    
endmodule