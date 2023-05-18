
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
    forever #1 clk_data = ~clk_data;
end

initial begin
    clk_pe = 0;
    #1;
    clk_pe = 1;
    #1;
    clk_pe = 0;
    #14;
    forever #8 clk_pe = ~clk_pe;
end

logic [15:0] i, k,high,low;
reg[255:0][15:0] Input = 0;
reg[7:0][255:0][15:0] Weight = 0;

logic [255:0][15:0] result_data;
logic [15:0] result_high, result_low;
logic [31:0] check_data;

logic result_equal;

integer fd_read, fd_result;

assign result_high = result_payload_o[31:16];
assign result_low  = result_payload_o[15:0];

initial begin
    readOneRow(1);
    readOneRow(0);
    
    
    rst_n = 0;
    load_payload_i = 0;
    load_en_i = 0;
    #20;
    rst_n = 1;
    #2;
    load_en_i = 1;
    for (k = 0; k<32 ; k++) begin
        // k even Input row
        // k odd Weight col
        for (i = 1; i<9 ; i++ ) begin
            if(k%2==0) begin
                load_payload_i = {Input[(k/2+1)*16-i*2+1], Input[(k/2+1)*16-i*2]};
            end else begin 
                load_payload_i = {Weight[0][(17-2*i)*16+(k-1)/2], Weight[0][(16-2*i)*16+(k-1)/2]};
            end
            #2;
        end
    end
    #48;
    // the second level
    for (k = 0; k<256 ; k++) begin
        //$display("%b", Weight[1][k]);
    end


    for (k = 0; k<16 ; k++) begin
        for (i = 1; i<9 ; i++ ) begin
            high=(k+2*i-2)%16;
            low=(k+2*i-1)%16;
            load_payload_i = {Weight[1][(18-2*i)*16-high-1], Weight[1][(17-2*i)*16-low-1]};
            #2;
        end
    end
    #48;
    for (k = 0; k<16 ; k++) begin
        for (i = 1; i<9 ; i++ ) begin
            high=(k+2*i-2)%16;
            low=(k+2*i-1)%16;
            load_payload_i = {Weight[2][(18-2*i)*16-high-1], Weight[2][(17-2*i)*16-low-1]};
            #2;
        end
    end
    #48;
    for (k = 0; k<16 ; k++) begin
        for (i = 1; i<9 ; i++ ) begin
            high=(k+2*i-2)%16;
            low=(k+2*i-1)%16;
            load_payload_i = {Weight[3][(18-2*i)*16-high-1], Weight[3][(17-2*i)*16-low-1]};
            #2;
        end
    end
    #48;
    for (k = 0; k<16 ; k++) begin
        for (i = 1; i<9 ; i++ ) begin
            high=(k+2*i-2)%16;
            low=(k+2*i-1)%16;
            load_payload_i = {Weight[4][(18-2*i)*16-high-1], Weight[4][(17-2*i)*16-low-1]};
            #2;
        end
    end
    #48;
    for (k = 0; k<16 ; k++) begin
        for (i = 1; i<9 ; i++ ) begin
            high=(k+2*i-2)%16;
            low=(k+2*i-1)%16;
            load_payload_i = {Weight[5][(18-2*i)*16-high-1], Weight[5][(17-2*i)*16-low-1]};
            #2;
        end
    end
    #48;
    for (k = 0; k<16 ; k++) begin
        for (i = 1; i<9 ; i++ ) begin
            high=(k+2*i-2)%16;
            low=(k+2*i-1)%16;
            load_payload_i = {Weight[6][(18-2*i)*16-high-1], Weight[6][(17-2*i)*16-low-1]};
            #2;
        end
    end
    #48;
    for (k = 0; k<16 ; k++) begin
        for (i = 1; i<9 ; i++ ) begin
            high=(k+2*i-2)%16;
            low=(k+2*i-1)%16;
            load_payload_i = {Weight[7][(18-2*i)*16-high-1], Weight[7][(17-2*i)*16-low-1]};
            #2;
        end
    end
    #130;
    fd_result=$fopen("../testcase/Output.txt","r");
    for (k = 0; k<256 ; k++) begin
        $fscanf(fd_result,"%b/n", result_data[k]);
    end
    #1;
    for (k = 0; k<16 ; k++) begin
        for (i = 0; i<8 ; i++ ) begin
            check_data[15:0] = result_data[2*i*16+k];
            check_data[31:16] = result_data[(2*i+1)*16+k];
            #16;
        end
    end
    #10000;
    $fclose(fd_result);
    $finish;
end

logic same_result;

assign same_result = result_payload_o == check_data;

always_ff@(posedge clk_pe) begin 
    result_equal <= same_result & result_valid_o;
end

initial begin
    $dumpfile("./out/tb_MulAdd_top.vcd");
    $dumpvars(0, tb_MulAdd_top);
end

function integer readOneRow(logic IorW);
    integer fd;
    logic [15:0] i;
    logic [15:0] j;
    begin
        if (IorW) begin
            fd=$fopen("../testcase/Input.txt","r");
            for(i=0;i<256;i++) begin
                $fscanf(fd,"%b/n",Input[i]);
                //$display("%b", Input[i]);
            end
            $fclose(fd);
        end else begin
            fd=$fopen("../testcase/Weight.txt","r");
            for(j=0;j<8;j++) begin
                for(i=0;i<256;i++) begin
                    $fscanf(fd,"%b/n",Weight[j][i]);
                end
            end
            
            $fclose(fd);
        end
    end
endfunction


endmodule

