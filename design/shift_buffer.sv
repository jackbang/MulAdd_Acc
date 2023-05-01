///////////////////////////////////////////////////////////
// Author: Jackbang
///////////////////////////////////////////////////////////

module shift_buffer (
    input           clk_data,
    input           rst_n   ,
    input [31:0]    data_i  ,
    input           wr_en_i ,
    output [255:0]  data_o  ,
    output          data_valid_o
);

logic [255:0] buffer, buffer_reg;
logic [3:0] cnt, cnt_reg;
logic [255:0] data_o_r;

always_ff @( posedge clk_data ) begin
    if (rst_n) begin
        buffer_reg <= buffer;
        cnt_reg <= cnt;
        if (cnt_reg == 7) begin
            data_o_r <= buffer;
        end
    end else begin
        // reset
        buffer_reg <= 256'b0;
        cnt_reg <= 0;
        data_o_r <= 256'b0;
    end
end

always_comb begin
    buffer = buffer_reg;
    cnt = cnt_reg;
    if (wr_en_i) begin
        buffer = {buffer_reg[223:0], data_i};
        cnt = cnt_reg + 1'b1;
    end

    if (cnt_reg == 7) begin
        cnt = 0;
    end
end

assign data_valid_o = (cnt_reg == 7);
assign data_o = data_o_r;
    
endmodule