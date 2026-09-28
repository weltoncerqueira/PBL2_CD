// =====================================================================
// divider_structural.v
// Divisor binario NAO-SINALIZADO 8 bits
// =====================================================================


// ---------------------------------------------------------------------
// Subtrator de 5 bits: dif = a - b  (complemento de 2: a + ~b + 1)
// sel = 1 se a < b (subtracao "invalida", precisa restaurar)
// ---------------------------------------------------------------------
module subtrator (
    input  [8:0] a,
    input  [8:0] b,
    output [8:0] dif,
    output sel
);

    wire [8:0] nb;   // complemento bit a bit de b
    wire [7:0] c;    // carries internos
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
	 

    somador_completo soma0(a[0], nb[0], 1'b1, dif[0], c[0]);
    somador_completo soma1(a[1], nb[1], c[0], dif[1], c[1]);
    somador_completo soma2(a[2], nb[2], c[1], dif[2], c[2]);
    somador_completo soma3(a[3], nb[3], c[2], dif[3], c[3]);
	 somador_completo soma4(a[4], nb[4], c[3], dif[4], c[4]);
	 somador_completo soma5(a[5], nb[5], c[4], dif[5], c[5]);
	 somador_completo soma6(a[6], nb[6], c[5], dif[6], c[6]);
	 somador_completo soma7(a[7], nb[7], c[6], dif[7], c[7]);
    somador_completo soma8(a[8], nb[8], c[7], dif[8], cout);

    not (sel, cout);

endmodule


// ---------------------------------------------------------------------

// ---------------------------------------------------------------------
module divisor (
    input  Abit,
    input  [7:0] R_in,
    input  [7:0] B,
    output [7:0] Resto,
    output Qbit
);

    wire [8:0] Rshift;  // R_in deslocado 1 bit p/ esquerda + Abit entrando no LSB
    wire [8:0] B_extendido;    // B estendido para 9 bits (bit extra = 0)
    wire [8:0] dif;
    wire sel;

    // Rshift = {R_in[3:0], Abit}
    buf (Rshift[0], Abit);
    buf (Rshift[1], R_in[0]);
    buf (Rshift[2], R_in[1]);
    buf (Rshift[3], R_in[2]);
    buf (Rshift[4], R_in[3]);
	 buf (Rshift[5], R_in[4]);
	 buf (Rshift[6], R_in[5]);
	 buf (Rshift[7], R_in[6]);
	 buf (Rshift[8], R_in[7]);
	 

    // B_extendido = {1'b0, B[3:0]}
    buf (B_extendido[0], B[0]);
    buf (B_extendido[1], B[1]);
    buf (B_extendido[2], B[2]);
    buf (B_extendido[3], B[3]);
	 buf (B_extendido[4], B[4]);
	 buf (B_extendido[5], B[5]);
	 buf (B_extendido[6], B[6]);
	 buf (B_extendido[7], B[7]);
    buf (B_extendido[8], 1'b0);

    subtrator sub0(Rshift, B_extendido, dif, sel);

    // Se sel=1 (deu negativo), restaura Rshift; senao usa dif
    mux_2x1 m0(.A(dif[0]), .B(Rshift[0]), .S(sel), .Y(Resto[0]));
    mux_2x1 m1(.A(dif[1]), .B(Rshift[1]), .S(sel), .Y(Resto[1]));
    mux_2x1 m2(.A(dif[2]), .B(Rshift[2]), .S(sel), .Y(Resto[2]));
    mux_2x1 m3(.A(dif[3]), .B(Rshift[3]), .S(sel), .Y(Resto[3]));
	 mux_2x1 m4(.A(dif[4]), .B(Rshift[4]), .S(sel), .Y(Resto[4]));
	 mux_2x1 m5(.A(dif[5]), .B(Rshift[5]), .S(sel), .Y(Resto[5]));
	 mux_2x1 m6(.A(dif[6]), .B(Rshift[6]), .S(sel), .Y(Resto[6]));
	 mux_2x1 m7(.A(dif[7]), .B(Rshift[7]), .S(sel), .Y(Resto[7]));

    not (Qbit, sel);   // sel=0 -> Qbit=1 ; sel=1 -> Qbit=0
	 
endmodule


// ---------------------------------------------------------------------
// Divisor 8x8 completo: 8 estagios em cascata
// ---------------------------------------------------------------------
module divisor_8bits (
    input  [7:0] A,   // dividendo
    input  [7:0] B,   // divisor (nao usar B = 0)
    output [7:0] Q,   // quociente = floor(A/B)
    output [7:0] R   // resto     = A mod B
);
    wire [7:0] R0;         					 // resto inicial, tied em 0000
    wire [7:0] R1, R2, R3, R4, R5, R6, R7; // restos intermediarios entre estagios

    buf (R0[0], 1'b0);
    buf (R0[1], 1'b0);
    buf (R0[2], 1'b0);
    buf (R0[3], 1'b0);
	 buf (R0[4], 1'b0);
	 buf (R0[5], 1'b0);
	 buf (R0[6], 1'b0);
	 buf (R0[7], 1'b0);
	 
    // Processa do bit mais significativo (A[7]) ao menos significativo (A[0])
	 divisor div7(.R_in(R0), .Abit(A[7]), .B(B), .Resto(R1), .Qbit(Q[7]));
	 divisor div6(.R_in(R1), .Abit(A[6]), .B(B), .Resto(R2), .Qbit(Q[6]));
	 divisor div5(.R_in(R2), .Abit(A[5]), .B(B), .Resto(R3), .Qbit(Q[5]));
	 divisor div4(.R_in(R3), .Abit(A[4]), .B(B), .Resto(R4), .Qbit(Q[4]));
	 divisor div3(.R_in(R4), .Abit(A[3]), .B(B), .Resto(R5), .Qbit(Q[3]));
	 divisor div2(.R_in(R5), .Abit(A[2]), .B(B), .Resto(R6), .Qbit(Q[2]));
	 divisor div1(.R_in(R6), .Abit(A[1]), .B(B), .Resto(R7), .Qbit(Q[1]));
	 divisor div0(.R_in(R7), .Abit(A[0]), .B(B), .Resto(R),  .Qbit(Q[0]));
	 
endmodule
