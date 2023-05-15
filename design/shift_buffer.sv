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

logic [31:0] data_i_d1, data_i_d2, data_i_d3, data_i_d4, data_i_d5, data_i_d6, data_i_d7, data_i_d8;
logic [3:0] cnt, cnt_reg;
logic cnt_full;
logic [255:0] data_o_combine, data_o_r;
logic wr_en_i_r;

always_ff @( posedge clk_data ) begin
    if (rst_n) begin
        wr_en_i_r <= wr_en_i;
        data_i_d1 <= data_i;
        data_i_d2 <= data_i_d1;
        data_i_d3 <= data_i_d2;
        data_i_d4 <= data_i_d3;
        data_i_d5 <= data_i_d4;
        data_i_d6 <= data_i_d5;
        data_i_d7 <= data_i_d6;
        data_i_d8 <= data_i_d7;
        cnt_reg <= cnt;
        if (cnt_full) begin
            data_o_r <= data_o_combine;
        end
    end else begin
        // reset
        wr_en_i_r <= 1'b0;
        data_i_d1 <= 32'b0;
        data_i_d2 <= 32'b0;
        data_i_d3 <= 32'b0;
        data_i_d4 <= 32'b0;
        data_i_d5 <= 32'b0;
        data_i_d6 <= 32'b0;
        data_i_d7 <= 32'b0;
        data_i_d8 <= 32'b0;
        cnt_reg <= 4'b0;
        data_o_r <= 256'b0;
    end
end

always_comb begin
    data_o_combine = {data_i_d8, data_i_d7, data_i_d6, data_i_d5, data_i_d4, data_i_d3, data_i_d2, data_i_d1};
    cnt = cnt_reg;
    cnt_full = cnt_reg == 7;
    if (wr_en_i_r) begin
        cnt = cnt_reg + 1'b1;
        if (cnt_full) begin
            cnt = 0;
        end
    end
end

assign data_valid_o = (cnt_full);
assign data_o = data_o_r;
    
endmodule