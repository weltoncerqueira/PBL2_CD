// x1 = (−b + √Δ) / (2a)
module calcula_x1 (
    input  [7:0]  a, 
    input  [7:0]  b,
    input  [17:0] delta,
    output [8:0]  x1,
    output        ov_soma, 
    output        delta_negativo
);

    wire [8:0] raiz, b9, b_neg9;

    // Aumentando o tamanho de 'b' para 9 bits (extensão de sinal)
    buf (b9[0], b[0]);
    buf (b9[1], b[1]);
    buf (b9[2], b[2]);
    buf (b9[3], b[3]);
    buf (b9[4], b[4]);
    buf (b9[5], b[5]);
    buf (b9[6], b[6]);
    buf (b9[7], b[7]);
    buf (b9[8], b[7]);

    // Negando b9 (Complemento de 2)
    complementoDe2_9bits comp (.A(b9), .bs(1'b1), .out(b_neg9));

    // Verifica se delta é menor que zero (bit de sinal)
    buf (delta_negativo, delta[17]);

    // Cálculo da raiz quadrada de delta √Δ
    raiz_Quadrada raiz_1 (.X(delta), .root(raiz));

    // Soma (−b + √Δ)
    wire [8:0] c;
    wire [8:0] soma;

    somador_completo s0 (.A(b_neg9[0]), .B(raiz[0]), .cin(1'b0), .S(soma[0]), .cout(c[0]));
    somador_completo s1 (.A(b_neg9[1]), .B(raiz[1]), .cin(c[0]), .S(soma[1]), .cout(c[1]));
    somador_completo s2 (.A(b_neg9[2]), .B(raiz[2]), .cin(c[1]), .S(soma[2]), .cout(c[2]));
    somador_completo s3 (.A(b_neg9[3]), .B(raiz[3]), .cin(c[2]), .S(soma[3]), .cout(c[3]));
    somador_completo s4 (.A(b_neg9[4]), .B(raiz[4]), .cin(c[3]), .S(soma[4]), .cout(c[4]));
    somador_completo s5 (.A(b_neg9[5]), .B(raiz[5]), .cin(c[4]), .S(soma[5]), .cout(c[5]));
    somador_completo s6 (.A(b_neg9[6]), .B(raiz[6]), .cin(c[5]), .S(soma[6]), .cout(c[6]));
    somador_completo s7 (.A(b_neg9[7]), .B(raiz[7]), .cin(c[6]), .S(soma[7]), .cout(c[7]));
    somador_completo s8 (.A(b_neg9[8]), .B(raiz[8]), .cin(c[7]), .S(soma[8]), .cout(c[8]));

    // Overflow da soma (c[7] XOR c[8])
    xor (ov_soma, c[7], c[8]);

    // Multiplicação (2 x a) adicionando bit 0 no LSB (Shift Left)
    wire [8:0] ax2;

    buf (ax2[8], a[7]);
    buf (ax2[7], a[6]);
    buf (ax2[6], a[5]);
    buf (ax2[5], a[4]);
    buf (ax2[4], a[3]);
    buf (ax2[3], a[2]);
    buf (ax2[2], a[1]);
    buf (ax2[1], a[0]);
    buf (ax2[0], 1'b0);

    // Verifica se "a" é zero
    wire a_zero;
    nor (a_zero, a[0], a[1], a[2], a[3], a[4], a[5], a[6], a[7]);

    // Divisão (−b + √Δ) / (2a)
    wire [8:0] resto;

    divisor_9x9_sinalizado div_1 (
        .A(soma),
        .B(ax2),
        .S(x1),
        .resto(resto)
    );

endmodule


module complementoDe2_9bits (
    input  wire [8:0] A,
    input  wire       bs,
    output wire [8:0] out
);
    wire [8:0] notA, carry;

    xor x0 (notA[0], A[0], bs);
    xor x1 (notA[1], A[1], bs);
    xor x2 (notA[2], A[2], bs);
    xor x3 (notA[3], A[3], bs);
    xor x4 (notA[4], A[4], bs);
    xor x5 (notA[5], A[5], bs);
    xor x6 (notA[6], A[6], bs);
    xor x7 (notA[7], A[7], bs);
    xor x8 (notA[8], A[8], bs);

    somador_completo fa1 (.A(notA[0]), .B(1'b0), .cin(bs),       .S(out[0]), .cout(carry[0]));
    somador_completo fa2 (.A(notA[1]), .B(1'b0), .cin(carry[0]), .S(out[1]), .cout(carry[1]));
    somador_completo fa3 (.A(notA[2]), .B(1'b0), .cin(carry[1]), .S(out[2]), .cout(carry[2]));
    somador_completo fa4 (.A(notA[3]), .B(1'b0), .cin(carry[2]), .S(out[3]), .cout(carry[3]));
    somador_completo fa5 (.A(notA[4]), .B(1'b0), .cin(carry[3]), .S(out[4]), .cout(carry[4]));
    somador_completo fa6 (.A(notA[5]), .B(1'b0), .cin(carry[4]), .S(out[5]), .cout(carry[5]));
    somador_completo fa7 (.A(notA[6]), .B(1'b0), .cin(carry[5]), .S(out[6]), .cout(carry[6]));
    somador_completo fa8 (.A(notA[7]), .B(1'b0), .cin(carry[6]), .S(out[7]), .cout(carry[7]));
    somador_completo fa9 (.A(notA[8]), .B(1'b0), .cin(carry[7]), .S(out[8]), .cout(carry[8]));

endmodule
