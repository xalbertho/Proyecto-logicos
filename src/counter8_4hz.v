module counter8_4hz #(
    parameter integer F_CLK_HZ = 50_000_000    // ajusta a tu FPGA
)(
    input  wire       clk,
    input  wire       rst_n,    // reset asíncrono activo en 0
    output reg [7:0]  q         // cuenta 0..255
);
    // ciclos por paso de conteo (4 pasos/segundo)
    localparam integer TICKS_PER_STEP = F_CLK_HZ / 4;

    reg [31:0] div_cnt;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            div_cnt <= 32'd0;
            q       <= 8'd0;
        end else begin
            if (div_cnt == TICKS_PER_STEP - 1) begin
                div_cnt <= 32'd0;
                // Incrementar cuenta 0..255 y regresar a 0
                if (q == 8'd255)
                    q <= 8'd0;
                else
                    q <= q + 8'd1;
            end else begin
                div_cnt <= div_cnt + 32'd1;
            end
        end
    end
endmodule
