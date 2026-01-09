module bin8_to_bcd3(
    input  wire [7:0] bin,     // 0..255
    output reg  [3:0] bcd2,    // centenas
    output reg  [3:0] bcd1,    // decenas
    output reg  [3:0] bcd0     // unidades
);
    integer i;
    // 8 bits bin + 12 bits bcd = 20 bits
    reg [19:0] shift;

    always @(*) begin
        // Inicializar: BCD=0, bin al lsb
        shift = {12'd0, bin};

        // Algoritmo double dabble para 8 bits
        for (i = 0; i < 8; i = i + 1) begin
            // ajustar unidades
            if (shift[11:8] >= 5)
                shift[11:8] = shift[11:8] + 4'd3;
            // decenas
            if (shift[15:12] >= 5)
                shift[15:12] = shift[15:12] + 4'd3;
            //  centenas
            if (shift[19:16] >= 5)
                shift[19:16] = shift[19:16] + 4'd3;

            // desplazar todo a la izquierda
            shift = shift << 1;
        end

        // Extraer BCD
        bcd0 = shift[11:8];   
        bcd1 = shift[15:12];  
        bcd2 = shift[19:16];  
    end
endmodule
