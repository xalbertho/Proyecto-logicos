module sevenseg_mux4_ca #(
    parameter F_CLK_HZ   = 50000000,
    parameter REFRESH_HZ = 4000
)(
    input  wire clk,
    input  wire rst_n,     
    input  wire [3:0] bcd3,
    input  wire [3:0] bcd2,
    input  wire [3:0] bcd1,
    input  wire [3:0] bcd0,
    output wire [6:0] seg, 
    output reg  [3:0] an   
);

   
    localparam TICKS = F_CLK_HZ / REFRESH_HZ;

    
    reg [13:0] div;
    reg [1:0]  sel;

    // seleccion del dígito actual
    reg [3:0] bcd_curr;
    always @(*) begin
        case(sel)
            2'd0: bcd_curr = bcd0;
            2'd1: bcd_curr = bcd1;
            2'd2: bcd_curr = bcd2;
            2'd3: bcd_curr = bcd3;
            default: bcd_curr = 4'd0;
        endcase
    end

    // decodificador → wire intermedio
    wire [6:0] seg_dec;

    sevenseg_decoder_ca u_dec(
        .bcd(bcd_curr),
        .seg(seg_dec)
    );

    // salida final de segmentos (activa en 0, ánodo común)
    assign seg = seg_dec;

    // multiplexado de anodos (activos en 0)
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            div <= 14'd0;
            sel <= 2'd0;
            an  <= 4'b1111; // todos apagados
        end
        else begin
            // divisor de refresco
            if(div == TICKS - 1) begin
                div <= 14'd0;
                sel <= sel + 2'd1;
            end
            else begin
                div <= div + 14'd1;
            end

            // activar solo un dígito a la vez (0 = encendido)
            case(sel)
                2'd0: an <= 4'b1110; // unidades
                2'd1: an <= 4'b1101; // decenas
                2'd2: an <= 4'b1011; // centenas
                2'd3: an <= 4'b0111; // miles
            endcase
        end
    end

endmodule
