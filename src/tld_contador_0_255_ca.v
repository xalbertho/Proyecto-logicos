`default_nettype none
module tld_contador_0_255_ca #(
    parameter integer F_CLK_HZ   = 50_000_000,
    parameter integer REFRESH_HZ = 4000
)(
    input  wire       clk,
    input  wire       rst_n,      // btn  reset global 
    output wire [6:0] seg,        // segmentos a..g
    output wire [3:0] an          // anodos [3..0]
);

    //  contador 8 bits a 4 Hz

    wire [7:0] count_8b;

    counter8_4hz #(
        .F_CLK_HZ(F_CLK_HZ)
    ) u_cnt (
        .clk (clk),
        .rst_n(rst_n),
        .q   (count_8b)
    );

    // ----------------------------------------------------------------
    // 2) conversion binario 8 bits → 3×bcd (centenas, decenas, unidades)
    // ----------------------------------------------------------------
    wire [3:0] bcd2;  // centenas
    wire [3:0] bcd1;  // decenas
    wire [3:0] bcd0;  // unidades

    bin8_to_bcd3 u_b2b (
        .bin (count_8b),
        .bcd2(bcd2),
        .bcd1(bcd1),
        .bcd0(bcd0)
    );

    // para el dígito de miles
    wire [3:0] bcd3 = 4'd0;   // miles que no se usa
    //  driver 7 segmentos reutilizando sevenseg_mux4_ca

    sevenseg_mux4_ca #(
        .F_CLK_HZ  (F_CLK_HZ),
        .REFRESH_HZ(REFRESH_HZ)
    ) u_7seg (
        .clk (clk),
        .rst_n(rst_n),
        .bcd3(bcd3),  // miles 
        .bcd2(bcd2),  // centenas
        .bcd1(bcd1),  // decenas
        .bcd0(bcd0),  // unidades
        .seg (seg),
        .an  (an)
    );

endmodule
