///////////////////////////////////////////////////////////
// Author: Jackbang
///////////////////////////////////////////////////////////

module clk_syncer (
    input           clk_data,
    input           clk_pe,

    input           rst_n,

    input           data_valid_i,
    input  [255:0]  data_i,

    output          data_valid_o,
    output [255:0]  data_o
);

///////////////////////////////////////////////////////////
// handshake
///////////////////////////////////////////////////////////
logic [3:0] delay_cnt, delay_cnt_reg;
logic clk_data_ready, clk_pe_valid;
logic data_valid_d1, data_valid_d2, data_valid_d3, data_valid_d4;

always_ff @( posedge clk_data ) begin
    if (rst_n) begin
        delay_cnt_reg <= delay_cnt;
        if (data_valid_i) begin
            clk_data_ready <= 1;
        end
        data_valid_d1 <= data_valid_i;
        data_valid_d2 <= data_valid_d1;
        data_valid_d3 <= data_valid_d2;
        data_valid_d4 <= data_valid_d3;
    end else begin
        // reset
        delay_cnt_reg <= 4'd0;
        clk_data_ready <= 0;
        data_valid_d1 <= 0;
        data_valid_d2 <= 0;
        data_valid_d3 <= 0;
        data_valid_d4 <= 0;
    end   
end

always_ff @( posedge clk_pe ) begin
    if (rst_n) begin
        if (clk_data_ready) begin
            clk_pe_valid <= 1;
        end
    end else begin
        // reset
        clk_pe_valid <= 0;
    end   
end

always_comb begin
    // calculate the delay
    if (clk_data_ready) begin
        if (clk_pe_valid) begin
            delay_cnt = delay_cnt_reg;
        end else begin
            delay_cnt = delay_cnt_reg + 1'b1;
        end
    end else begin
        delay_cnt = delay_cnt_reg;
    end
end

///////////////////////////////////////////////////////////
// extend the data
///////////////////////////////////////////////////////////
logic [255:0] extended_data_r;
logic [255:0] data_o_r;
logic         data_valid_o_r;

always_ff @( posedge clk_data ) begin
    if (rst_n) begin
        if (data_valid_d4) begin
            extended_data_r <= data_i;
        end
    end else begin
        // reset 
        extended_data_r <= 'b0;
    end
end

always_ff @( posedge clk_pe ) begin
    if (rst_n) begin
        if (clk_data_ready) begin
            if (delay_cnt_reg > 1 | delay_cnt_reg < 6) begin
                // use the original
                data_o_r <= data_i;
                data_valid_o_r <= 1;
            end else begin
                // use the extended
                data_o_r <= extended_data_r;
                data_valid_o_r <= 1;
            end
        end
    end else begin
        // reset
        data_o_r <= 'b0;
        data_valid_o_r <= 0;
    end
end

assign data_o = data_o_r;
assign data_valid_o = data_valid_o_r;

endmodule