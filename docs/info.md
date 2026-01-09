# Tiny Tapeout project information

## Proyecto: Contador 0–255 con 7 segmentos (CA)

## How it works
Este diseño implementa un contador de 8 bits que incrementa de 0 a 255 y regresa a 0.
El valor se convierte a BCD (centenas, decenas y unidades) con el algoritmo “double dabble” y se muestra en un display de 7 segmentos multiplexado.
El multiplexado recorre 4 dígitos (miles/centenas/decenas/unidades), aunque miles se fija en 0.

- `counter8_4hz`: divide el reloj para incrementar a ~4 Hz (según `F_CLK_HZ`).
- `bin8_to_bcd3`: convierte 8-bit binario a 3 dígitos BCD.
- `sevenseg_mux4_ca`: multiplexa los 4 dígitos y usa `sevenseg_decoder_ca` para generar `seg`.

Reset:
- `rst_n` es activo-bajo. Al reset, el contador y el multiplex regresan a estado inicial.

## How to test
1) Simulación (opcional):
   - Aplica `rst_n=0` unos ciclos y luego `rst_n=1`.
   - Verifica que `count_8b` incremente y que `seg/an` cambien con el multiplexado.

2) En hardware / demo:
   - Configura el clock al valor usado en el parámetro `F_CLK_HZ`.
   - Observa que el valor muestre 000–255 (BCD) y que al llegar a 255 regrese a 000.
   - Presiona el reset (activo en bajo) y confirma que vuelva a 000.
