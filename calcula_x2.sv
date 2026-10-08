// x2 = (−b − √Δ) / (2a)
module calcula_x2 (
    input  [7:0]  a, 
    input  [7:0]  b,
    input  [17:0] delta,
    output [8:0]  x2,
    output        overflow,
	 output        delta_negativo
);

    // x2 = (−b - √Δ) / (2a)

    wire [8:0] raiz, b9, raiz_neg, b_neg9;

    // Verifica se delta é menor que zero
    buf (delta_negativo, delta[17]);

    // Aumentando o tamanho do b para 9 bits (extensão de sinal)
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

    // Cálculo da raiz de delta √Δ
    raiz_Quadrada raiz_1 (.X(delta), .root(raiz));

    // Negação da raiz de delta (−√Δ)
    complementoDe2_9bits complemento3 (.A(raiz), .bs(1'b1), .out(raiz_neg));

    // Subtração via soma: (−b + (−√Δ))
    wire [8:0] c;
    wire [8:0] soma;
    wire ovf_Soma;

    somador_completo s0 (.A(b_neg9[0]), .B(raiz_neg[0]), .cin(1'b0), .S(soma[0]), .cout(c[0]));
    somador_completo s1 (.A(b_neg9[1]), .B(raiz_neg[1]), .cin(c[0]), .S(soma[1]), .cout(c[1]));
    somador_completo s2 (.A(b_neg9[2]), .B(raiz_neg[2]), .cin(c[1]), .S(soma[2]), .cout(c[2]));
    somador_completo s3 (.A(b_neg9[3]), .B(raiz_neg[3]), .cin(c[2]), .S(soma[3]), .cout(c[3]));
    somador_completo s4 (.A(b_neg9[4]), .B(raiz_neg[4]), .cin(c[3]), .S(soma[4]), .cout(c[4]));
    somador_completo s5 (.A(b_neg9[5]), .B(raiz_neg[5]), .cin(c[4]), .S(soma[5]), .cout(c[5]));
    somador_completo s6 (.A(b_neg9[6]), .B(raiz_neg[6]), .cin(c[5]), .S(soma[6]), .cout(c[6]));
    somador_completo s7 (.A(b_neg9[7]), .B(raiz_neg[7]), .cin(c[6]), .S(soma[7]), .cout(c[7]));
    somador_completo s8 (.A(b_neg9[8]), .B(raiz_neg[8]), .cin(c[7]), .S(soma[8]), .cout(c[8]));

    xor (ovf_Soma, c[7], c[8]);

    // Multiplicação (2 x a) adicionando 1 bit 0 à direita (Shift Left)
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

    // Divisão (−b − √Δ) / (2a)
    wire [8:0] resto;

    divisor_9x9_sinalizado div_1 (
        .A(soma),
        .B(ax2),
        .S(x2),
        .resto(resto)
    );

    // Overflow é ativado se houver estouro na soma ou se delta for negativo
    or (overflow, ovf_Soma, delta_negativo);

endmodule