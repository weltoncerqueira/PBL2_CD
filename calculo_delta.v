
// MÓDULO QUE CALCULA  Δ = b² − 4ac
module calculo_delta (
	input [7:0] a,
	input [7:0] b,
	input [7:0] c,
	output [17:0] delta,
	output overflow
);
	
	wire [15:0] bQuadrado, axc;
	wire [17:0] Shift4;
	wire [17:0] bQuadrado18;
	
	// b²
	multiplicador_8x8_sinalizado mult_1(
		.A(b),
		.B(b),
		.S(bQuadrado)
	);
	
	//a x c
	multiplicador_8x8_sinalizado mult_2(
		.A(a),
		.B(c),
		.S(axc)
	);
	
	// Multiplicação de (axc x 4) adicionando 2 bits à direita
	buf (Shift4[0], 1'b0);
	buf (Shift4[1], 1'b0);
	buf (Shift4[2], axc[0]);
	buf (Shift4[3], axc[1]);
	buf (Shift4[4], axc[2]);
	buf (Shift4[5], axc[3]);
	buf (Shift4[6], axc[4]);
	buf (Shift4[7], axc[5]);
	buf (Shift4[8], axc[6]);
	buf (Shift4[9], axc[7]);
	buf (Shift4[10], axc[8]);
	buf (Shift4[11], axc[9]);
	buf (Shift4[12], axc[10]);
	buf (Shift4[13], axc[11]);
	buf (Shift4[14], axc[12]);
	buf (Shift4[15], axc[13]);
	buf (Shift4[16], axc[14]);
	buf (Shift4[17], axc[15]);
	
	// Extensão de b² de 16 para 18 bits
	buf (bQuadrado18[0], bQuadrado[0]);
	buf (bQuadrado18[1], bQuadrado[1]);
	buf (bQuadrado18[2], bQuadrado[2]);
	buf (bQuadrado18[3], bQuadrado[3]);
	buf (bQuadrado18[4], bQuadrado[4]);
	buf (bQuadrado18[5], bQuadrado[5]);
	buf (bQuadrado18[6], bQuadrado[6]);
	buf (bQuadrado18[7], bQuadrado[7]);
	buf (bQuadrado18[8], bQuadrado[8]);
	buf (bQuadrado18[9], bQuadrado[9]);
	buf (bQuadrado18[10], bQuadrado[10]);
	buf (bQuadrado18[11], bQuadrado[11]);
	buf (bQuadrado18[12], bQuadrado[12]);
	buf (bQuadrado18[13], bQuadrado[13]);
	buf (bQuadrado18[14], bQuadrado[14]);
	buf (bQuadrado18[15], bQuadrado[15]);
	buf (bQuadrado18[16], bQuadrado[15]);
	buf (bQuadrado18[17], bQuadrado[15]);
	
	// bQuadrado18 - Shift4
	subtrator_18bits sub_18bits (
		.a(bQuadrado18),
		.b( Shift4),
		.dif(delta),
		.overflow(overflow)
	);
	
	
endmodule



module subtrator_18bits (
    input  [17:0] a,
    input  [17:0] b,
    output [17:0] dif,
	 output overflow
);

    wire [17:0] nb;   // complemento bit a bit de b
    wire [17:0] c;    // carries internos

    not (nb[0], b[0]);
    not (nb[1], b[1]);
    not (nb[2], b[2]);
    not (nb[3], b[3]);
    not (nb[4], b[4]);
	 not (nb[5], b[5]);
	 not (nb[6], b[6]);
	 not (nb[7], b[7]);
	 not (nb[8], b[8]);
	 not (nb[9], b[9]);
	 not (nb[10], b[10]);
	 not (nb[11], b[11]);
	 not (nb[12], b[12]);
	 not (nb[13], b[13]);
	 not (nb[14], b[14]);
	 not (nb[15], b[15]);
	 not (nb[16], b[16]);
	 not (nb[17], b[17]);
	 
    somador_completo soma0  (a[0], nb[0], 1'b1, dif[0], c[0]);
    somador_completo soma1  (a[1], nb[1], c[0], dif[1], c[1]);
    somador_completo soma2  (a[2], nb[2], c[1], dif[2], c[2]);
    somador_completo soma3  (a[3], nb[3], c[2], dif[3], c[3]);
	 somador_completo soma4  (a[4], nb[4], c[3], dif[4], c[4]);
	 somador_completo soma5  (a[5], nb[5], c[4], dif[5], c[5]);
	 somador_completo soma6  (a[6], nb[6], c[5], dif[6], c[6]);
	 somador_completo soma7  (a[7], nb[7], c[6], dif[7], c[7]);
    somador_completo soma8  (a[8], nb[8], c[7], dif[8], c[8]);
	 somador_completo soma9  (a[9], nb[9], c[8], dif[9], c[9]);
	 somador_completo soma10 (a[10], nb[10], c[9], dif[10], c[10]);
	 somador_completo soma11 (a[11], nb[11], c[10], dif[11], c[11]);
	 somador_completo soma12 (a[12], nb[12], c[11], dif[12], c[12]);
	 somador_completo soma13 (a[13], nb[13], c[12], dif[13], c[13]);
	 somador_completo soma14 (a[14], nb[14], c[13], dif[14], c[14]);
	 somador_completo soma15 (a[15], nb[15], c[14], dif[15], c[15]);
	 somador_completo soma16 (a[16], nb[16], c[15], dif[16], c[16]);
	 somador_completo soma17 (a[17], nb[17], c[16], dif[17], c[17]);
	 
	 // Tratamento de overflow
	 wire sinal_diferente;
	 wire resultado_invalido;

	 xor (sinal_diferente, a[17], b[17]);
	 xor (resultado_invalido, dif[17], a[17]);
	 and (overflow, sinal_diferente, resultado_invalido);

endmodule
 


