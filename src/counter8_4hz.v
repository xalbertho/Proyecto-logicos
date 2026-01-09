module counter8_4hz #(
    parameter integer F_CLK_HZ = 50_000_000    // ajusta a tu FPGA
)(
    input  wire       clk,
    input  wire       rst_n,
    output reg [7:0]  q
);

`ifdef SIM
    // En simulación, acelera muchísimo para que CI no tarde
    localparam integer TICKS_PER_STEP = 100;   // q++ cada 100 clocks
`else
    // En hardware real: 4 Hz
    localparam integer TICKS_PER_STEP = F_CLK_HZ / 4;
`endif

    reg [31:0] div_cnt;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            div_cnt <= 32'd0;
            q       <= 8'd0;
        end else begin
            if (div_cnt == TICKS_PER_STEP - 1) begin
                div_cnt <= 32'd0;
                if (q == 8'd255) q <= 8'd0;
                else             q <= q + 8'd1;
            end else begin
                div_cnt <= div_cnt + 32'd1;
            end
        end
    end
endmodule
