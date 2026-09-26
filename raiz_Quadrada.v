// =====================================================================
// sqrt8.v
// Raiz quadrada inteira de um numero de 8 bits, 100% ESTRUTURAL.
//
// Regras seguidas: nenhuma linha usa 'always', 'if' ou 'assign'.
// Apenas: module/endmodule, input/output, wire e portas/submodulos.
//
// Entrada:  X[7:0]    -> 0 a 255
// Saida:    root[3:0] -> floor(sqrt(X)), de 0 a 15
//
// Algoritmo: "digito por digito" (metodo classico de raiz quadrada
// binaria), desenrolado em 4 estagios fixos com as constantes
// 64, 16, 4 e 1 (potencias de 4, sempre nessa ordem):
//
//   soma = resultado + bit
//   se x >= soma:  x = x - soma ; resultado = (resultado >> 1) + bit
//   senao:                        resultado = (resultado >> 1)
//
// Verificado manualmente com X = 0, 1, 16, 200 e 255 -> todos corretos.
// =====================================================================


// ---------------------------------------------------------------------
// Somador completo (bloco basico)
// ---------------------------------------------------------------------
module full_adder(a, b, cin, s, cout);
    input  a, b, cin;
    output s, cout;

    wire ab_xor, ab_and, cin_and;

    xor (ab_xor, a, b);
    xor (s, ab_xor, cin);

    and (ab_and, a, b);
    and (cin_and, cin, ab_xor);
    or  (cout, ab_and, cin_and);
endmodule


// ---------------------------------------------------------------------
// Multiplexador 2:1 de 1 bit -- y = sel ? d1 : d0
// ---------------------------------------------------------------------
module mux2(d0, d1, sel, y);
    input  d0, d1, sel;
    output y;

    wire nsel, t0, t1;

    not (nsel, sel);
    and (t0, d0, nsel);
    and (t1, d1, sel);
    or  (y, t0, t1);
endmodule


// ---------------------------------------------------------------------
// Somador de 8 bits: soma = a + b  (sem subtracao, carry-in = 0)
// ---------------------------------------------------------------------
module adder8(a, b, soma, cout);
    input  [7:0] a;
    input  [7:0] b;
    output [7:0] soma;
    output cout;

    wire [6:0] c;

    full_adder fa0(a[0], b[0], 1'b0, soma[0], c[0]);
    full_adder fa1(a[1], b[1], c[0], soma[1], c[1]);
    full_adder fa2(a[2], b[2], c[1], soma[2], c[2]);
    full_adder fa3(a[3], b[3], c[2], soma[3], c[3]);
    full_adder fa4(a[4], b[4], c[3], soma[4], c[4]);
    full_adder fa5(a[5], b[5], c[4], soma[5], c[5]);
    full_adder fa6(a[6], b[6], c[5], soma[6], c[6]);
    full_adder fa7(a[7], b[7], c[6], soma[7], cout);
endmodule


// ---------------------------------------------------------------------
// Subtrator de 8 bits: dif = a - b  (complemento de 2: a + ~b + 1)
// borrow = 1 se a < b
// ---------------------------------------------------------------------
module sub8(a, b, dif, borrow);
    input  [7:0] a;
    input  [7:0] b;
    output [7:0] dif;
    output borrow;

    wire [7:0] nb;
    wire [6:0] c;
    wire cout;

    not (nb[0], b[0]);
    not (nb[1], b[1]);
    not (nb[2], b[2]);
    not (nb[3], b[3]);
    not (nb[4], b[4]);
    not (nb[5], b[5]);
    not (nb[6], b[6]);
    not (nb[7], b[7]);

    full_adder fa0(a[0], nb[0], 1'b1, dif[0], c[0]);
    full_adder fa1(a[1], nb[1], c[0], dif[1], c[1]);
    full_adder fa2(a[2], nb[2], c[1], dif[2], c[2]);
    full_adder fa3(a[3], nb[3], c[2], dif[3], c[3]);
    full_adder fa4(a[4], nb[4], c[3], dif[4], c[4]);
    full_adder fa5(a[5], nb[5], c[4], dif[5], c[5]);
    full_adder fa6(a[6], nb[6], c[5], dif[6], c[6]);
    full_adder fa7(a[7], nb[7], c[6], dif[7], cout);

    not (borrow, cout);
endmodule


// ---------------------------------------------------------------------
// Um estagio da raiz quadrada. B eh a constante fixa deste estagio
// (64, 16, 4 ou 1, dependendo da posicao na cascata).
// ---------------------------------------------------------------------
module sqrt_stage(x_in, result_in, B, x_out, result_out);
    input  [7:0] x_in;
    input  [7:0] result_in;
    input  [7:0] B;
    output [7:0] x_out;
    output [7:0] result_out;

    wire [7:0] soma;             // result_in + B
    wire [7:0] dif;              // x_in - soma
    wire borrow;                 // 1 se x_in < soma
    wire [7:0] result_shifted;   // result_in >> 1 (logico)
    wire [7:0] result_candidato; // result_shifted + B
    wire cout1, cout2;           // carries finais (nao usados)

    adder8 add1(result_in, B, soma, cout1);
    sub8   sub1(x_in, soma, dif, borrow);

    // result_shifted = result_in >> 1  (so fiacao, MSB entra com 0)
    buf (result_shifted[7], 1'b0);
    buf (result_shifted[6], result_in[7]);
    buf (result_shifted[5], result_in[6]);
    buf (result_shifted[4], result_in[5]);
    buf (result_shifted[3], result_in[4]);
    buf (result_shifted[2], result_in[3]);
    buf (result_shifted[1], result_in[2]);
    buf (result_shifted[0], result_in[1]);

    adder8 add2(result_shifted, B, result_candidato, cout2);

    // x_out = borrow ? x_in (sem alteracao) : dif (subtraiu)
    mux2 mx0(dif[0], x_in[0], borrow, x_out[0]);
    mux2 mx1(dif[1], x_in[1], borrow, x_out[1]);
    mux2 mx2(dif[2], x_in[2], borrow, x_out[2]);
    mux2 mx3(dif[3], x_in[3], borrow, x_out[3]);
    mux2 mx4(dif[4], x_in[4], borrow, x_out[4]);
    mux2 mx5(dif[5], x_in[5], borrow, x_out[5]);
    mux2 mx6(dif[6], x_in[6], borrow, x_out[6]);
    mux2 mx7(dif[7], x_in[7], borrow, x_out[7]);

    // result_out = borrow ? result_shifted : result_candidato
    mux2 mr0(result_candidato[0], result_shifted[0], borrow, result_out[0]);
    mux2 mr1(result_candidato[1], result_shifted[1], borrow, result_out[1]);
    mux2 mr2(result_candidato[2], result_shifted[2], borrow, result_out[2]);
    mux2 mr3(result_candidato[3], result_shifted[3], borrow, result_out[3]);
    mux2 mr4(result_candidato[4], result_shifted[4], borrow, result_out[4]);
    mux2 mr5(result_candidato[5], result_shifted[5], borrow, result_out[5]);
    mux2 mr6(result_candidato[6], result_shifted[6], borrow, result_out[6]);
    mux2 mr7(result_candidato[7], result_shifted[7], borrow, result_out[7]);
endmodule


// ---------------------------------------------------------------------
// Modulo topo: raiz quadrada de 8 bits, 4 estagios em cascata
// (constantes fixas 64, 16, 4, 1 -- nessa ordem)
// ---------------------------------------------------------------------
module raiz_Quadrada(X, root);
    input  [7:0] X;      // radicando (0 a 255)
    output [3:0] root;   // floor(sqrt(X)), de 0 a 15

    wire [7:0] r0, r1, r2, r3, r4; // "resultado" apos cada estagio
    wire [7:0] x1, x2, x3, x4;     // "x" apos cada estagio

    // resultado inicial = 0
    buf (r0[0], 1'b0);
    buf (r0[1], 1'b0);
    buf (r0[2], 1'b0);
    buf (r0[3], 1'b0);
    buf (r0[4], 1'b0);
    buf (r0[5], 1'b0);
    buf (r0[6], 1'b0);
    buf (r0[7], 1'b0);

    sqrt_stage stage1(X,  r0, 8'b01000000, x1, r1);  // B = 64
    sqrt_stage stage2(x1, r1, 8'b00010000, x2, r2);  // B = 16
    sqrt_stage stage3(x2, r2, 8'b00000100, x3, r3);  // B = 4
    sqrt_stage stage4(x3, r3, 8'b00000001, x4, r4);  // B = 1

    // resposta final = 4 bits mais baixos do resultado do ultimo estagio
    buf (root[0], r4[0]);
    buf (root[1], r4[1]);
    buf (root[2], r4[2]);
    buf (root[3], r4[3]);
endmodule
