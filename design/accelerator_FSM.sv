///////////////////////////////////////////////////////////
// Author: Jackbang
///////////////////////////////////////////////////////////

module accelerator_FSM #(
    parameter WIDTH_LBIT_CNT = 5,
    parameter WIDTH_HBIT_CNT = 3
) (
    input                           clk             ,
    input                           rst_n           ,
    input                           data_rdy_i      ,

    // Low bit counter
    output                          LCNT_en_o       ,
    output [WIDTH_LBIT_CNT-1 : 0]   LCNT_period_o   ,
    output [WIDTH_LBIT_CNT-1 : 0]   LCNT_interrupt_o,
    input                           LCNT_ready_i    ,
    // High bit counter
    output                          HCNT_en_o       ,
    output [WIDTH_HBIT_CNT-1 : 0]   HCNT_period_o   ,
    output [WIDTH_HBIT_CNT-1 : 0]   HCNT_interrupt_o,
    input                           HCNT_ready_i    ,

    output [1:0]                    wire_connect_o
);

localparam [2:0] // for 8 states
    IDLE = 0,
    FIRST_LAYER_NORMAL = 1, //repeat 32 cycle
    FIRST_LAYER_FORMAT = 2, //start format module
    OTHER_LAYER_GETDAT = 3, //get the formatted data
    OTHER_LAYER_NORMAL = 4, //repeat 16 cycle
    OTHER_LAYER_FORMAT = 5, //start format module
    OUTPUT = 6;
    
reg[1:0] state_cur, state_next;

always_ff @( posedge clk ) begin
    if (rst_n) begin
        state_cur <= state_next;
    end else begin
        // reset
        state_cur <= IDLE;
    end
end

always_comb begin
    state_next = state_cur;
    case (state_cur)
        IDLE : begin
            state_next = (data_rdy_i) ? FIRST_LAYER_NORMAL : IDLE;
        end
        FIRST_LAYER_NORMAL : begin
            state_next = (LCNT_ready_i && HCNT_ready_i) ? FIRST_LAYER_FORMAT : FIRST_LAYER_NORMAL;
        end
        FIRST_LAYER_FORMAT : begin
            state_next = OTHER_LAYER_GETDAT;
        end
        OTHER_LAYER_GETDAT : begin
            state_next = OTHER_LAYER_NORMAL;
        end
        OTHER_LAYER_NORMAL : begin
            state_next = (LCNT_ready_i) ? OTHER_LAYER_FORMAT : OTHER_LAYER_NORMAL;
        end
        OTHER_LAYER_FORMAT : begin
            state_next = (HCNT_ready_i) ? OUTPUT : OTHER_LAYER_GETDAT;
        end
        OUTPUT : begin
            state_next = OUTPUT;
        end
        default: state_next = IDLE;
    endcase
end

///////////////////////////////////////////////////////////
// output assign
///////////////////////////////////////////////////////////
logic                           LCNT_en_o_r         ;
logic [WIDTH_LBIT_CNT-1 : 0]    LCNT_period_o_r     ;
logic [WIDTH_LBIT_CNT-1 : 0]    LCNT_interrupt_o_r  ;

logic                           HCNT_en_o_r         ;
logic [WIDTH_HBIT_CNT-1 : 0]    HCNT_period_o_r     ;
logic [WIDTH_HBIT_CNT-1 : 0]    HCNT_interrupt_o_r  ;

logic [1:0]                     wire_connect_o_r    ;

assign LCNT_en_o = LCNT_en_o_r;
assign LCNT_period_o = LCNT_period_o_r;
assign LCNT_interrupt_o = LCNT_interrupt_o_r;

assign HCNT_en_o = HCNT_en_o_r;
assign HCNT_period_o = HCNT_period_o_r;
assign HCNT_interrupt_o = HCNT_interrupt_o_r;

assign wire_connect_o = wire_connect_o_r;

///////////////////////////////////////////////////////////
// wire_connect_o description:
//  0:  data_a = v_bus
//      data_b = h_bus
//
//  1:  data_a = formatted_result
//      data_b = h_bus
//
//  2:  data_a = top_module
//      data_b = h_bus
//      buttom_data = data_a
//  
//  3:  data_a = 0
//      data_b = 0
///////////////////////////////////////////////////////////

always_comb begin
    LCNT_en_o_r = 0;
    LCNT_period_o_r = 31;
    LCNT_interrupt_o_r = 31;
    HCNT_en_o_r = 0;
    HCNT_period_o_r = 7;
    HCNT_interrupt_o_r = 7;
    wire_connect_o_r = 3;
    case (state_cur)
        IDLE : begin
            LCNT_en_o_r = 0;
            LCNT_interrupt_o_r = 2;
            HCNT_en_o_r = 0;
            HCNT_interrupt_o_r = 1;
            wire_connect_o_r = 3;
        end
        FIRST_LAYER_NORMAL : begin
            LCNT_en_o_r = 1;
            LCNT_interrupt_o_r = 2;
            HCNT_en_o_r = 1;
            HCNT_interrupt_o_r = 1;
            wire_connect_o_r = 0;
        end
        FIRST_LAYER_FORMAT : begin
            LCNT_en_o_r = 0;
            LCNT_interrupt_o_r = 16;
            LCNT_period_o_r = 16;
            HCNT_en_o_r = 0;
            HCNT_interrupt_o_r = 7;
            wire_connect_o_r = 3;
        end
        OTHER_LAYER_GETDAT : begin
            LCNT_en_o_r = 1;
            LCNT_interrupt_o_r = 16;
            LCNT_period_o_r = 16;
            HCNT_en_o_r = 0;
            HCNT_interrupt_o_r = 7;
            wire_connect_o_r = 1;
        end
        OTHER_LAYER_NORMAL : begin
            LCNT_en_o_r = 1;
            LCNT_interrupt_o_r = 16;
            LCNT_period_o_r = 16;
            HCNT_en_o_r = 0;
            HCNT_interrupt_o_r = 7;
            wire_connect_o_r = 2;
        end
        OTHER_LAYER_FORMAT : begin
            LCNT_en_o_r = 0;
            LCNT_interrupt_o_r = 16;
            LCNT_period_o_r = 16;
            HCNT_en_o_r = 1;
            HCNT_interrupt_o_r = 7;
            HCNT_period_o_r = 7;
            wire_connect_o_r = 3;
        end
        OUTPUT : begin
            
        end
    endcase
end
    
endmodule