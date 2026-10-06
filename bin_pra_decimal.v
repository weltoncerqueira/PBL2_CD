
// ============================================================
// COMPARADOR: verifica se um número BCD de 4 bits é >= 5
// ============================================================
module bcd_maior_igual_5 (
    input  wire [3:0] bcd,
    output wire       maior_igual_5
);

    wire w1, w2;

    or  (w1, bcd[1], bcd[0]);
    and (w2, bcd[2], w1);
    or  (maior_igual_5, bcd[3], w2);

endmodule



// ============================================================
// SOMADOR DE 4 BITS
// ============================================================
module somador_4bits (
    input  wire [3:0] A,
    input  wire [3:0] B,
    output wire [3:0] S
);

    wire c1, c2, c3, c4;

    somador_completo FA0 (
        .A(A[0]),
        .B(B[0]),
        .cin(1'b0),
        .S(S[0]),
        .cout(c1)
    );

    somador_completo FA1 (
        .A(A[1]),
        .B(B[1]),
        .cin(c1),
        .S(S[1]),
        .cout(c2)
    );

    somador_completo FA2 (
        .A(A[2]),
        .B(B[2]),
        .cin(c2),
        .S(S[2]),
        .cout(c3)
    );

    somador_completo FA3 (
        .A(A[3]),
        .B(B[3]),
        .cin(c3),
        .S(S[3]),
        .cout(c4)
    );

endmodule


// ============================================================
// MUX 4 BITS
// ============================================================
module mux2_1_4bits (
    input  wire [3:0] A,
    input  wire [3:0] B,
    input  wire       SEL,
    output wire [3:0] Y
);

    mux_2x1 M0 (
        .A(A[0]),
        .B(B[0]),
        .S(SEL),
        .Y(Y[0])
    );

    mux_2x1 M1 (
        .A(A[1]),
        .B(B[1]),
        .S(SEL),
        .Y(Y[1])
    );

    mux_2x1 M2 (
        .A(A[2]),
        .B(B[2]),
        .S(SEL),
        .Y(Y[2])
    );

    mux_2x1 M3 (
        .A(A[3]),
        .B(B[3]),
        .S(SEL),
        .Y(Y[3])
    );

endmodule


// ============================================================
// AJUSTE BCD
//
// Se BCD >= 5:
//      BCD = BCD + 3
//
// Caso contrário:
//      BCD permanece igual
// ============================================================
module ajuste_bcd (
    input  wire [3:0] bcd_in,
    output wire [3:0] bcd_out
);

    wire       corrige;
    wire [3:0] soma3;

    // Detecta BCD >= 5
    bcd_maior_igual_5 COMP (
        .bcd(bcd_in),
        .maior_igual_5(corrige)
    );

    // Soma 3
    somador_4bits ADD3 (
        .A(bcd_in),
        .B(4'b0011),
        .S(soma3)
    );

    // Escolhe BCD original ou BCD + 3
    mux2_1_4bits MUX (
        .A(bcd_in),
        .B(soma3),
        .SEL(corrige),
        .Y(bcd_out)
    );

endmodule


// ============================================================
// UM ESTÁGIO DO DOUBLE DABBLE
//
// Entrada:
//   - 5 dígitos BCD
//   - 1 bit binário
//
// Processo:
//   1. Corrige cada BCD
//   2. Desloca os dígitos
// ============================================================
module double_dabble_stage (
    input  wire [3:0] bcd4_in,
    input  wire [3:0] bcd3_in,
    input  wire [3:0] bcd2_in,
    input  wire [3:0] bcd1_in,
    input  wire [3:0] bcd0_in,

    input  wire       bit_bin,

    output wire [3:0] bcd4_out,
    output wire [3:0] bcd3_out,
    output wire [3:0] bcd2_out,
    output wire [3:0] bcd1_out,
    output wire [3:0] bcd0_out
);

    // --------------------------------------------------------
    // BCDs corrigidos
    // --------------------------------------------------------

    wire [3:0] bcd4_corr;
    wire [3:0] bcd3_corr;
    wire [3:0] bcd2_corr;
    wire [3:0] bcd1_corr;
    wire [3:0] bcd0_corr;

    ajuste_bcd AJ4 (
        .bcd_in(bcd4_in),
        .bcd_out(bcd4_corr)
    );

    ajuste_bcd AJ3 (
        .bcd_in(bcd3_in),
        .bcd_out(bcd3_corr)
    );

    ajuste_bcd AJ2 (
        .bcd_in(bcd2_in),
        .bcd_out(bcd2_corr)
    );

    ajuste_bcd AJ1 (
        .bcd_in(bcd1_in),
        .bcd_out(bcd1_corr)
    );

    ajuste_bcd AJ0 (
        .bcd_in(bcd0_in),
        .bcd_out(bcd0_corr)
    );


    // --------------------------------------------------------
    // SHIFT LEFT
    //
    // bcd4 <- bcd4[2:0] + bcd3[3]
    // bcd3 <- bcd3[2:0] + bcd2[3]
    // bcd2 <- bcd2[2:0] + bcd1[3]
    // bcd1 <- bcd1[2:0] + bcd0[3]
    // bcd0 <- bcd0[2:0] + bit_bin
    // --------------------------------------------------------

    assign bcd4_out = {
        bcd4_corr[2:0],
        bcd3_corr[3]
    };

    assign bcd3_out = {
        bcd3_corr[2:0],
        bcd2_corr[3]
    };

    assign bcd2_out = {
        bcd2_corr[2:0],
        bcd1_corr[3]
    };

    assign bcd1_out = {
        bcd1_corr[2:0],
        bcd0_corr[3]
    };

    assign bcd0_out = {
        bcd0_corr[2:0],
        bit_bin
    };

endmodule


// ============================================================
// BINÁRIO -> DECIMAL
//
// Entrada:
//     valor_bin[15:0]
//
// Saídas:
//     dez_milhar
//     milhar
//     centena
//     dezena
//     unidade
//
// IMPLEMENTAÇÃO PURAMENTE ESTRUTURAL
// ============================================================
module bin_pra_decimal (
    input  wire [15:0] valor_bin,

    output wire [3:0] dez_milhar,
    output wire [3:0] milhar,
    output wire [3:0] centena,
    output wire [3:0] dezena,
    output wire [3:0] unidade
);

    // ========================================================
    // ESTÁGIOS DO DOUBLE DABBLE
    // ========================================================

    wire [3:0] d4_15, d3_15, d2_15, d1_15, d0_15;
    wire [3:0] d4_14, d3_14, d2_14, d1_14, d0_14;
    wire [3:0] d4_13, d3_13, d2_13, d1_13, d0_13;
    wire [3:0] d4_12, d3_12, d2_12, d1_12, d0_12;
    wire [3:0] d4_11, d3_11, d2_11, d1_11, d0_11;
    wire [3:0] d4_10, d3_10, d2_10, d1_10, d0_10;
    wire [3:0] d4_9,  d3_9,  d2_9,  d1_9,  d0_9;
    wire [3:0] d4_8,  d3_8,  d2_8,  d1_8,  d0_8;
    wire [3:0] d4_7,  d3_7,  d2_7,  d1_7,  d0_7;
    wire [3:0] d4_6,  d3_6,  d2_6,  d1_6,  d0_6;
    wire [3:0] d4_5,  d3_5,  d2_5,  d1_5,  d0_5;
    wire [3:0] d4_4,  d3_4,  d2_4,  d1_4,  d0_4;
    wire [3:0] d4_3,  d3_3,  d2_3,  d1_3,  d0_3;
    wire [3:0] d4_2,  d3_2,  d2_2,  d1_2,  d0_2;
    wire [3:0] d4_1,  d3_1,  d2_1,  d1_1,  d0_1;
    wire [3:0] d4_0,  d3_0,  d2_0,  d1_0,  d0_0;


    // ========================================================
    // ESTÁGIO 15
    // ========================================================

    double_dabble_stage STAGE15 (
        .bcd4_in(4'b0000),
        .bcd3_in(4'b0000),
        .bcd2_in(4'b0000),
        .bcd1_in(4'b0000),
        .bcd0_in(4'b0000),

        .bit_bin(valor_bin[15]),

        .bcd4_out(d4_15),
        .bcd3_out(d3_15),
        .bcd2_out(d2_15),
        .bcd1_out(d1_15),
        .bcd0_out(d0_15)
    );


    // ========================================================
    // ESTÁGIO 14
    // ========================================================

    double_dabble_stage STAGE14 (
        .bcd4_in(d4_15),
        .bcd3_in(d3_15),
        .bcd2_in(d2_15),
        .bcd1_in(d1_15),
        .bcd0_in(d0_15),

        .bit_bin(valor_bin[14]),

        .bcd4_out(d4_14),
        .bcd3_out(d3_14),
        .bcd2_out(d2_14),
        .bcd1_out(d1_14),
        .bcd0_out(d0_14)
    );


    // ========================================================
    // ESTÁGIO 13
    // ========================================================

    double_dabble_stage STAGE13 (
        .bcd4_in(d4_14),
        .bcd3_in(d3_14),
        .bcd2_in(d2_14),
        .bcd1_in(d1_14),
        .bcd0_in(d0_14),

        .bit_bin(valor_bin[13]),

        .bcd4_out(d4_13),
        .bcd3_out(d3_13),
        .bcd2_out(d2_13),
        .bcd1_out(d1_13),
        .bcd0_out(d0_13)
    );


    // ========================================================
    // ESTÁGIO 12
    // ========================================================

    double_dabble_stage STAGE12 (
        .bcd4_in(d4_13),
        .bcd3_in(d3_13),
        .bcd2_in(d2_13),
        .bcd1_in(d1_13),
        .bcd0_in(d0_13),

        .bit_bin(valor_bin[12]),

        .bcd4_out(d4_12),
        .bcd3_out(d3_12),
        .bcd2_out(d2_12),
        .bcd1_out(d1_12),
        .bcd0_out(d0_12)
    );


    // ========================================================
    // ESTÁGIO 11
    // ========================================================

    double_dabble_stage STAGE11 (
        .bcd4_in(d4_12),
        .bcd3_in(d3_12),
        .bcd2_in(d2_12),
        .bcd1_in(d1_12),
        .bcd0_in(d0_12),

        .bit_bin(valor_bin[11]),

        .bcd4_out(d4_11),
        .bcd3_out(d3_11),
        .bcd2_out(d2_11),
        .bcd1_out(d1_11),
        .bcd0_out(d0_11)
    );


    // ========================================================
    // ESTÁGIO 10
    // ========================================================

    double_dabble_stage STAGE10 (
        .bcd4_in(d4_11),
        .bcd3_in(d3_11),
        .bcd2_in(d2_11),
        .bcd1_in(d1_11),
        .bcd0_in(d0_11),

        .bit_bin(valor_bin[10]),

        .bcd4_out(d4_10),
        .bcd3_out(d3_10),
        .bcd2_out(d2_10),
        .bcd1_out(d1_10),
        .bcd0_out(d0_10)
    );


    // ========================================================
    // ESTÁGIO 9
    // ========================================================

    double_dabble_stage STAGE9 (
        .bcd4_in(d4_10),
        .bcd3_in(d3_10),
        .bcd2_in(d2_10),
        .bcd1_in(d1_10),
        .bcd0_in(d0_10),

        .bit_bin(valor_bin[9]),

        .bcd4_out(d4_9),
        .bcd3_out(d3_9),
        .bcd2_out(d2_9),
        .bcd1_out(d1_9),
        .bcd0_out(d0_9)
    );


    // ========================================================
    // ESTÁGIO 8
    // ========================================================

    double_dabble_stage STAGE8 (
        .bcd4_in(d4_9),
        .bcd3_in(d3_9),
        .bcd2_in(d2_9),
        .bcd1_in(d1_9),
        .bcd0_in(d0_9),

        .bit_bin(valor_bin[8]),

        .bcd4_out(d4_8),
        .bcd3_out(d3_8),
        .bcd2_out(d2_8),
        .bcd1_out(d1_8),
        .bcd0_out(d0_8)
    );


    // ========================================================
    // ESTÁGIO 7
    // ========================================================

    double_dabble_stage STAGE7 (
        .bcd4_in(d4_8),
        .bcd3_in(d3_8),
        .bcd2_in(d2_8),
        .bcd1_in(d1_8),
        .bcd0_in(d0_8),

        .bit_bin(valor_bin[7]),

        .bcd4_out(d4_7),
        .bcd3_out(d3_7),
        .bcd2_out(d2_7),
        .bcd1_out(d1_7),
        .bcd0_out(d0_7)
    );


    // ========================================================
    // ESTÁGIO 6
    // ========================================================

    double_dabble_stage STAGE6 (
        .bcd4_in(d4_7),
        .bcd3_in(d3_7),
        .bcd2_in(d2_7),
        .bcd1_in(d1_7),
        .bcd0_in(d0_7),

        .bit_bin(valor_bin[6]),

        .bcd4_out(d4_6),
        .bcd3_out(d3_6),
        .bcd2_out(d2_6),
        .bcd1_out(d1_6),
        .bcd0_out(d0_6)
    );


    // ========================================================
    // ESTÁGIO 5
    // ========================================================

    double_dabble_stage STAGE5 (
        .bcd4_in(d4_6),
        .bcd3_in(d3_6),
        .bcd2_in(d2_6),
        .bcd1_in(d1_6),
        .bcd0_in(d0_6),

        .bit_bin(valor_bin[5]),

        .bcd4_out(d4_5),
        .bcd3_out(d3_5),
        .bcd2_out(d2_5),
        .bcd1_out(d1_5),
        .bcd0_out(d0_5)
    );


    // ========================================================
    // ESTÁGIO 4
    // ========================================================

    double_dabble_stage STAGE4 (
        .bcd4_in(d4_5),
        .bcd3_in(d3_5),
        .bcd2_in(d2_5),
        .bcd1_in(d1_5),
        .bcd0_in(d0_5),

        .bit_bin(valor_bin[4]),

        .bcd4_out(d4_4),
        .bcd3_out(d3_4),
        .bcd2_out(d2_4),
        .bcd1_out(d1_4),
        .bcd0_out(d0_4)
    );


    // ========================================================
    // ESTÁGIO 3
    // ========================================================

    double_dabble_stage STAGE3 (
        .bcd4_in(d4_4),
        .bcd3_in(d3_4),
        .bcd2_in(d2_4),
        .bcd1_in(d1_4),
        .bcd0_in(d0_4),

        .bit_bin(valor_bin[3]),

        .bcd4_out(d4_3),
        .bcd3_out(d3_3),
        .bcd2_out(d2_3),
        .bcd1_out(d1_3),
        .bcd0_out(d0_3)
    );


    // ========================================================
    // ESTÁGIO 2
    // ========================================================

    double_dabble_stage STAGE2 (
        .bcd4_in(d4_3),
        .bcd3_in(d3_3),
        .bcd2_in(d2_3),
        .bcd1_in(d1_3),
        .bcd0_in(d0_3),

        .bit_bin(valor_bin[2]),

        .bcd4_out(d4_2),
        .bcd3_out(d3_2),
        .bcd2_out(d2_2),
        .bcd1_out(d1_2),
        .bcd0_out(d0_2)
    );


    // ========================================================
    // ESTÁGIO 1
    // ========================================================

    double_dabble_stage STAGE1 (
        .bcd4_in(d4_2),
        .bcd3_in(d3_2),
        .bcd2_in(d2_2),
        .bcd1_in(d1_2),
        .bcd0_in(d0_2),

        .bit_bin(valor_bin[1]),

        .bcd4_out(d4_1),
        .bcd3_out(d3_1),
        .bcd2_out(d2_1),
        .bcd1_out(d1_1),
        .bcd0_out(d0_1)
    );


    // ========================================================
    // ESTÁGIO 0
    // ========================================================

    double_dabble_stage STAGE0 (
        .bcd4_in(d4_1),
        .bcd3_in(d3_1),
        .bcd2_in(d2_1),
        .bcd1_in(d1_1),
        .bcd0_in(d0_1),

        .bit_bin(valor_bin[0]),

        .bcd4_out(d4_0),
        .bcd3_out(d3_0),
        .bcd2_out(d2_0),
        .bcd1_out(d1_0),
        .bcd0_out(d0_0)
    );


    // ========================================================
    // SAÍDAS
    // ========================================================

    assign dez_milhar = d4_0;
    assign milhar     = d3_0;
    assign centena    = d2_0;
    assign dezena     = d1_0;
    assign unidade    = d0_0;

endmodule
