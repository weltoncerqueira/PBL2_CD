
module divisor_9x9_sinalizado (
	input  [8:0] A,
	input  [8:0] B,
	output [8:0] S,
	output [8:0] resto 
	
);
	
	wire [8:0] A_final, B_final, div_result, resto_sem_sinal;
	wire sinal;
	 
	// Sinais iguais = 0, Sinais diferentes = 1
	xor (sinal, A[8], B[8]);
	
	numero_Final_9b num1 (.entrada(A), .valor_absoluto(A_final));
   numero_Final_9b num2 (.entrada(B), .valor_absoluto(B_final));
	
	divisor_9bits div1(
		.A(A_final),
		.B(B_final),
		.Q(div_result),
		.R(resto_sem_sinal)
	);
	
  complementoDe2_9bits complemento4 (
		 .A(div_result), 
		 .bs(sinal),
		 .out(S)
	 );
	 
	complementoDe2_9bits complemento2 (
       .A(resto_sem_sinal),
       .bs(A[8]),            // resto segue APENAS o sinal do dividendo
       .out(resto)
    );
	 
	 
endmodule

// =====================================================================
// divider_structural_9bits.v
// Divisor binário NÃO-SINALIZADO de 9 bits
// =====================================================================

// ---------------------------------------------------------------------
// Subtrator de 10 bits: dif = a - b (Complemento de 2: a + ~b + 1)
// sel = 1 se a < b (subtração "inválida", precisa restaurar)
// ---------------------------------------------------------------------
module subtrator (
    input  [9:0] a,
    input  [9:0] b,
    output [9:0] dif,
    output sel
);

    wire [9:0] nb;
    wire [8:0] c;
    wire cout;

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

    somador_completo soma0(a[0], nb[0], 1'b1, dif[0], c[0]);
    somador_completo soma1(a[1], nb[1], c[0], dif[1], c[1]);
    somador_completo soma2(a[2], nb[2], c[1], dif[2], c[2]);
    somador_completo soma3(a[3], nb[3], c[2], dif[3], c[3]);
    somador_completo soma4(a[4], nb[4], c[3], dif[4], c[4]);
    somador_completo soma5(a[5], nb[5], c[4], dif[5], c[5]);
    somador_completo soma6(a[6], nb[6], c[5], dif[6], c[6]);
    somador_completo soma7(a[7], nb[7], c[6], dif[7], c[7]);
    somador_completo soma8(a[8], nb[8], c[7], dif[8], c[8]);
    somador_completo soma9(a[9], nb[9], c[8], dif[9], cout);

    not (sel, cout);

endmodule


// ---------------------------------------------------------------------
// Estágio da Divisão Restauradora (1 Bit)
// ---------------------------------------------------------------------
module divisor (
    input  Abit,
    input  [8:0] R_in,
    input  [8:0] B,
    output [8:0] Resto,
    output Qbit
);

    wire [9:0] Rshift;       // R_in deslocado 1 bit p/ esquerda + Abit no LSB
    wire [9:0] B_extendido;  // B estendido para 10 bits com 0 no MSB
    wire [9:0] dif;
    wire sel;

    // Rshift = {R_in[7:0], Abit}
    buf (Rshift[0], Abit);
    buf (Rshift[1], R_in[0]);
    buf (Rshift[2], R_in[1]);
    buf (Rshift[3], R_in[2]);
    buf (Rshift[4], R_in[3]);
    buf (Rshift[5], R_in[4]);
    buf (Rshift[6], R_in[5]);
    buf (Rshift[7], R_in[6]);
    buf (Rshift[8], R_in[7]);
    buf (Rshift[9], R_in[8]);

    // B_extendido = {1'b0, B[8:0]}
    buf (B_extendido[0], B[0]);
    buf (B_extendido[1], B[1]);
    buf (B_extendido[2], B[2]);
    buf (B_extendido[3], B[3]);
    buf (B_extendido[4], B[4]);
    buf (B_extendido[5], B[5]);
    buf (B_extendido[6], B[6]);
    buf (B_extendido[7], B[7]);
    buf (B_extendido[8], B[8]);
    buf (B_extendido[9], 1'b0);

    subtrator sub0(Rshift, B_extendido, dif, sel);

    // Se sel=1 (deu negativo), restaura Rshift; senão usa dif
    mux_2x1 m0(.A(dif[0]), .B(Rshift[0]), .S(sel), .Y(Resto[0]));
    mux_2x1 m1(.A(dif[1]), .B(Rshift[1]), .S(sel), .Y(Resto[1]));
    mux_2x1 m2(.A(dif[2]), .B(Rshift[2]), .S(sel), .Y(Resto[2]));
    mux_2x1 m3(.A(dif[3]), .B(Rshift[3]), .S(sel), .Y(Resto[3]));
    mux_2x1 m4(.A(dif[4]), .B(Rshift[4]), .S(sel), .Y(Resto[4]));
    mux_2x1 m5(.A(dif[5]), .B(Rshift[5]), .S(sel), .Y(Resto[5]));
    mux_2x1 m6(.A(dif[6]), .B(Rshift[6]), .S(sel), .Y(Resto[6]));
    mux_2x1 m7(.A(dif[7]), .B(Rshift[7]), .S(sel), .Y(Resto[7]));
    mux_2x1 m8(.A(dif[8]), .B(Rshift[8]), .S(sel), .Y(Resto[8]));

    not (Qbit, sel);

endmodule


// ---------------------------------------------------------------------
// Divisor 9x9 completo: 9 estágios em cascata
// ---------------------------------------------------------------------
module divisor_9bits (
    input  [8:0] A,   // Dividendo (9 bits: A[8:0])
    input  [8:0] B,   // Divisor   (9 bits: B[8:0])
    output [8:0] Q,   // Quociente (9 bits: Q[8:0])
    output [8:0] R    // Resto     (9 bits: R[8:0])
);

    wire [8:0] R0, R1, R2, R3, R4, R5, R6, R7, R8;

    // Resto inicial zerado (9 bits)
    buf (R0[0], 1'b0);
    buf (R0[1], 1'b0);
    buf (R0[2], 1'b0);
    buf (R0[3], 1'b0);
    buf (R0[4], 1'b0);
    buf (R0[5], 1'b0);
    buf (R0[6], 1'b0);
    buf (R0[7], 1'b0);
    buf (R0[8], 1'b0);

    // 9 estágios em cascata: do bit mais significativo (A[8]) ao menos significativo (A[0])
    divisor div8(.R_in(R0), .Abit(A[8]), .B(B), .Resto(R1), .Qbit(Q[8]));
    divisor div7(.R_in(R1), .Abit(A[7]), .B(B), .Resto(R2), .Qbit(Q[7]));
    divisor div6(.R_in(R2), .Abit(A[6]), .B(B), .Resto(R3), .Qbit(Q[6]));
    divisor div5(.R_in(R3), .Abit(A[5]), .B(B), .Resto(R4), .Qbit(Q[5]));
    divisor div4(.R_in(R4), .Abit(A[4]), .B(B), .Resto(R5), .Qbit(Q[4]));
    divisor div3(.R_in(R5), .Abit(A[3]), .B(B), .Resto(R6), .Qbit(Q[3]));
    divisor div2(.R_in(R6), .Abit(A[2]), .B(B), .Resto(R7), .Qbit(Q[2]));
    divisor div1(.R_in(R7), .Abit(A[1]), .B(B), .Resto(R8), .Qbit(Q[1]));
    divisor div0(.R_in(R8), .Abit(A[0]), .B(B), .Resto(R),  .Qbit(Q[0]));

endmodule



// valor_absoluto.v
// Função: Retorna o valor absoluto de um número em complemento de 2, seja o valor negativo ou positivo

module numero_Final_9b (
    input  wire [8:0] entrada,
    output wire [8:0] valor_absoluto
);
    wire bs;
    
    // captura o bit de sinal
	 buf b1 (bs, entrada[8]);
    
    // Calcula o complemento de 2 e verifica se usa o complemento ou não
    complementoDe2_9bits complemento_9bit (
	 .A(entrada), 
	 .bs(bs),
	 .out(valor_absoluto)
	 );
	 
endmodule
