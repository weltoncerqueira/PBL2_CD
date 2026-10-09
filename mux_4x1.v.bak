
module mux_4x1 (
    input  [6:0] a,
    input  [6:0] b,
    input  [6:0] c,
    input  [6:0] d,
    input  [1:0] sel,
    output [6:0] S
);

    wire nsel0, nsel1;

    wire [6:0] w_a;
    wire [6:0] w_b;
    wire [6:0] w_c;
    wire [6:0] w_d;

    // Inversores dos bits de seleção
    not (nsel0, sel[0]);
    not (nsel1, sel[1]);

    // Termo correspondente a a: ~sel1 & ~sel0 & a
    and (w_a[0], nsel1, nsel0, a[0]);
    and (w_a[1], nsel1, nsel0, a[1]);
    and (w_a[2], nsel1, nsel0, a[2]);
    and (w_a[3], nsel1, nsel0, a[3]);
    and (w_a[4], nsel1, nsel0, a[4]);
    and (w_a[5], nsel1, nsel0, a[5]);
    and (w_a[6], nsel1, nsel0, a[6]);

    // Termo correspondente a b: ~sel1 & sel0 & b
    and (w_b[0], nsel1, sel[0], b[0]);
    and (w_b[1], nsel1, sel[0], b[1]);
    and (w_b[2], nsel1, sel[0], b[2]);
    and (w_b[3], nsel1, sel[0], b[3]);
    and (w_b[4], nsel1, sel[0], b[4]);
    and (w_b[5], nsel1, sel[0], b[5]);
    and (w_b[6], nsel1, sel[0], b[6]);

    // Termo correspondente a c: sel1 & ~sel0 & c
    and (w_c[0], sel[1], nsel0, c[0]);
    and (w_c[1], sel[1], nsel0, c[1]);
    and (w_c[2], sel[1], nsel0, c[2]);
    and (w_c[3], sel[1], nsel0, c[3]);
    and (w_c[4], sel[1], nsel0, c[4]);
    and (w_c[5], sel[1], nsel0, c[5]);
    and (w_c[6], sel[1], nsel0, c[6]);

    // Termo correspondente a d: sel1 & sel0 & d
    and (w_d[0], sel[1], sel[0], d[0]);
    and (w_d[1], sel[1], sel[0], d[1]);
    and (w_d[2], sel[1], sel[0], d[2]);
    and (w_d[3], sel[1], sel[0], d[3]);
    and (w_d[4], sel[1], sel[0], d[4]);
    and (w_d[5], sel[1], sel[0], d[5]);
    and (w_d[6], sel[1], sel[0], d[6]);

    // Soma lógica dos quatro termos
    or (S[0], w_a[0], w_b[0], w_c[0], w_d[0]);
    or (S[1], w_a[1], w_b[1], w_c[1], w_d[1]);
    or (S[2], w_a[2], w_b[2], w_c[2], w_d[2]);
    or (S[3], w_a[3], w_b[3], w_c[3], w_d[3]);
    or (S[4], w_a[4], w_b[4], w_c[4], w_d[4]);
    or (S[5], w_a[5], w_b[5], w_c[5], w_d[5]);
    or (S[6], w_a[6], w_b[6], w_c[6], w_d[6]);

endmodule
