`default_nettype none

module tt_um_alberto_counter255_7seg (
    input  wire [7:0] ui_in,    // inputs
    output wire [7:0] uo_out,    // outputs
    input  wire [7:0] uio_in,    // bidir input (no usado)
    output wire [7:0] uio_out,   // bidir output
    output wire [7:0] uio_oe,    // bidir output enable (1=salida)
    input  wire       ena,       // 1 cuando tu proyecto está seleccionado
    input  wire       clk,
    input  wire       rst_n
);

    // -------------------------
    // Reset: combinamos el reset global (rst_n) con un “botón” en ui_in[0]
    // Asumo ui_in[0] = 1 cuando PRESIONAS (reset).
    // Si tu botón llega invertido, cambia esta línea.
    // -------------------------
    wire rst_n_eff = rst_n & ena & ~ui_in[0];

    wire [6:0] seg;
    wire [3:0] an;

    // Tu diseño tal cual
    tld_contador_0_255_ca #(
        .F_CLK_HZ(50_000_000),   // pon el clock que vayas a usar en la demo board
        .REFRESH_HZ(4000)
    ) u_top (
        .clk  (clk),
        .rst_n(rst_n_eff),
        .seg  (seg),
        .an   (an)
    );

    // -------------------------
    // Mapeo de pines a Tiny Tapeout
    // uo_out: 8 salidas dedicadas
    // uio_* : 8 bidireccionales (pero OJO: sólo salen si uio_oe=1)
    // IMPORTANTE: no dejes salidas flotando; lo no usado a 0. :contentReference[oaicite:0]{index=0}
    // -------------------------

    // 7 segmentos a..g en uo_out[6:0]
    assign uo_out[6:0] = seg;

    // uo_out[7] no lo usas -> 0
    assign uo_out[7] = 1'b0;

    // an[3:0] a uio_out[3:0]
    assign uio_out[3:0] = an;

    // el resto de uio_out a 0
    assign uio_out[7:4] = 4'b0000;

    // habilitamos como salida uio[3:0]; el resto queda entrada
    assign uio_oe[3:0] = 4'b1111;
    assign uio_oe[7:4] = 4'b0000;

    // silenciar warning de no-uso
    wire _unused = &{uio_in, ui_in[7:1]};

endmodule

`default_nettype wire
