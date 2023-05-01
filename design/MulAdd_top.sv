///////////////////////////////////////////////////////////
// Author: Jackbang
///////////////////////////////////////////////////////////

module MulAdd_top (
    input           clk_data,
    input           clk_pe,

    input           rst_n,

    input           load_en_i,
    input  [31:0]   load_payload_i,

    output          result_valid_o,
    output [31:0]   result_payload_o
);

///////////////////////////////////////////////////////////
// shift buffer
///////////////////////////////////////////////////////////
logic [31:0]    shift_buf_data_i      ;
logic           shift_buf_wr_en_i     ;
logic [255:0]   shift_buf_data_o      ;
logic [255:0]   shift_buf_data_o_d1   ;
logic           shift_buf_data_valid_o;

shift_buffer shift_buffer_inst (
    .clk_data(clk_data),
    .rst_n(rst_n),
    .data_i(shift_buf_data_i),
    .wr_en_i(shift_buf_wr_en_i),
    .data_o(shift_buf_data_o),
    .data_valid_o(shift_buf_data_valid_o)
);

assign shift_buf_data_i = load_payload_i;
assign shift_buf_wr_en_i = load_en_i;

///////////////////////////////////////////////////////////
// handshake
///////////////////////////////////////////////////////////
logic [3:0] delay_cnt, delay_cnt_reg;
logic [2:0] d_cnt, d_cnt_reg;
logic clk_data_ready, clk_pe_valid;

always_ff @( posedge clk_data ) begin
    if (rst_n) begin
        d_cnt_reg <= d_cnt;
        delay_cnt_reg <= delay_cnt;
        if (shift_buf_data_valid_o) begin
            clk_data_ready <= 1;
        end

        if (d_cnt_reg == 3) begin
            shift_buf_data_o_d1 <= shift_buf_data_o;
        end
    end else begin
        // reset
        d_cnt_reg <= 3'd0;
        delay_cnt_reg <= 4'd0;
        clk_data_ready <= 0;
        shift_buf_data_o_d1 <= 0;
    end   
end

always_ff @( posedge clk_pe ) begin
    if (rst_n) begin
        if (clk_data_ready) begin
            clk_pe_valid <= 1;
        end
    end else begin
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

    if (shift_buf_data_valid_o) begin
        d_cnt = 0;
    end else begin
        d_cnt = d_cnt_reg + 1'b1;
    end
end

///////////////////////////////////////////////////////////
// slow clk get data
///////////////////////////////////////////////////////////
logic slow_clk_load_en;
logic [255:0]   slow_clk_get_data ;

always_ff @( posedge clk_pe ) begin
    if (rst_n) begin
        slow_clk_load_en <= load_en_i;
        if ((delay_cnt_reg > 6) | (delay_cnt_reg < 2)) begin
            if (slow_clk_load_en) begin
                slow_clk_get_data <= shift_buf_data_o_d1; 
            end
        end else begin
            if (load_en_i) begin
                slow_clk_get_data <= shift_buf_data_o;
            end
        end
    end else begin
        slow_clk_load_en <= 0;
        slow_clk_get_data <= 0;
    end
end
    
endmodule