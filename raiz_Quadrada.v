// =====================================================================
// sqrt18.v
// Raiz quadrada inteira de um numero de 18 bits, 100% ESTRUTURAL.
//
// Regras seguidas: nenhuma linha usa 'always', 'if' ou 'assign'.
// Apenas: module/endmodule, input/output, wire e portas/submodulos.
//
// Entrada:  X[17:0]   -> 0 a 262143
// Saida:    root[8:0] -> floor(sqrt(X)), de 0 a 511
//
// Algoritmo "digito por digito", desenrolado em 9 estagios fixos
// com as constantes 4^8, 4^7, ..., 4^0 (nessa ordem):
//
//   soma = resultado + bit
//   se x >= soma:  x = x - soma ; resultado = (resultado >> 1) + bit
//   senao:                        resultado = (resultado >> 1)
// =====================================================================



// ---------------------------------------------------------------------
// Somador de 18 bits: soma = a + b  (carry-in = 0)
// ---------------------------------------------------------------------
module adder18(a, b, soma, cout);
    input  [17:0] a;
    input  [17:0] b;
    output [17:0] soma;
    output cout;

    wire [16:0] c;

    somador_completo sum0 (a[0],  b[0],  1'b0,  soma[0],  c[0]);
    somador_completo sum1 (a[1],  b[1],  c[0],  soma[1],  c[1]);
    somador_completo sum2 (a[2],  b[2],  c[1],  soma[2],  c[2]);
    somador_completo sum3 (a[3],  b[3],  c[2],  soma[3],  c[3]);
    somador_completo sum4 (a[4],  b[4],  c[3],  soma[4],  c[4]);
    somador_completo sum5 (a[5],  b[5],  c[4],  soma[5],  c[5]);
    somador_completo sum6 (a[6],  b[6],  c[5],  soma[6],  c[6]);
    somador_completo sum7 (a[7],  b[7],  c[6],  soma[7],  c[7]);
    somador_completo sum8 (a[8],  b[8],  c[7],  soma[8],  c[8]);
    somador_completo sum9 (a[9],  b[9],  c[8],  soma[9],  c[9]);
    somador_completo sum10(a[10], b[10], c[9],  soma[10], c[10]);
    somador_completo sum11(a[11], b[11], c[10], soma[11], c[11]);
    somador_completo sum12(a[12], b[12], c[11], soma[12], c[12]);
    somador_completo sum13(a[13], b[13], c[12], soma[13], c[13]);
    somador_completo sum14(a[14], b[14], c[13], soma[14], c[14]);
    somador_completo sum15(a[15], b[15], c[14], soma[15], c[15]);
    somador_completo sum16(a[16], b[16], c[15], soma[16], c[16]);
    somador_completo sum17(a[17], b[17], c[16], soma[17], cout);
endmodule


// ---------------------------------------------------------------------
// Subtrator de 18 bits: dif = a - b  (complemento de 2: a + ~b + 1)
// borrow = 1 se a < b
// ---------------------------------------------------------------------
module sub18(a, b, dif, borrow);
    input  [17:0] a;
    input  [17:0] b;
    output [17:0] dif;
    output borrow;

    wire [17:0] nb;
    wire [16:0] c;
    wire cout;

    not (nb[0],  b[0]);
    not (nb[1],  b[1]);
    not (nb[2],  b[2]);
    not (nb[3],  b[3]);
    not (nb[4],  b[4]);
    not (nb[5],  b[5]);
    not (nb[6],  b[6]);
    not (nb[7],  b[7]);
    not (nb[8],  b[8]);
    not (nb[9],  b[9]);
    not (nb[10], b[10]);
    not (nb[11], b[11]);
    not (nb[12], b[12]);
    not (nb[13], b[13]);
    not (nb[14], b[14]);
    not (nb[15], b[15]);
    not (nb[16], b[16]);
    not (nb[17], b[17]);

    somador_completo sum0 (a[0],  nb[0],  1'b1,  dif[0],  c[0]);
    somador_completo sum1 (a[1],  nb[1],  c[0],  dif[1],  c[1]);
    somador_completo sum2 (a[2],  nb[2],  c[1],  dif[2],  c[2]);
    somador_completo sum3 (a[3],  nb[3],  c[2],  dif[3],  c[3]);
    somador_completo sum4 (a[4],  nb[4],  c[3],  dif[4],  c[4]);
    somador_completo sum5 (a[5],  nb[5],  c[4],  dif[5],  c[5]);
    somador_completo sum6 (a[6],  nb[6],  c[5],  dif[6],  c[6]);
    somador_completo sum7 (a[7],  nb[7],  c[6],  dif[7],  c[7]);
    somador_completo sum8 (a[8],  nb[8],  c[7],  dif[8],  c[8]);
    somador_completo sum9 (a[9],  nb[9],  c[8],  dif[9],  c[9]);
    somador_completo sum10(a[10], nb[10], c[9],  dif[10], c[10]);
    somador_completo sum11(a[11], nb[11], c[10], dif[11], c[11]);
    somador_completo sum12(a[12], nb[12], c[11], dif[12], c[12]);
    somador_completo sum13(a[13], nb[13], c[12], dif[13], c[13]);
    somador_completo sum14(a[14], nb[14], c[13], dif[14], c[14]);
    somador_completo sum15(a[15], nb[15], c[14], dif[15], c[15]);
    somador_completo sum16(a[16], nb[16], c[15], dif[16], c[16]);
    somador_completo sum17(a[17], nb[17], c[16], dif[17], cout);

    not (borrow, cout);
endmodule


// ---------------------------------------------------------------------
// Um estagio da raiz quadrada. B eh a constante fixa deste estagio.
// ---------------------------------------------------------------------
module sqrt_stage(x_in, result_in, B, x_out, result_out);
    input  [17:0] x_in;
    input  [17:0] result_in;
    input  [17:0] B;
    output [17:0] x_out;
    output [17:0] result_out;

    wire [17:0] soma;             // result_in + B
    wire [17:0] dif;              // x_in - soma
    wire borrow;                  // 1 se x_in < soma
    wire [17:0] result_shifted;   // result_in >> 1 (logico)
    wire [17:0] result_candidato; // result_shifted + B
    wire cout1, cout2;            // carries finais (nao usados)

    adder18 add1(result_in, B, soma, cout1);
    sub18   sub1(x_in, soma, dif, borrow);

    // result_shifted = result_in >> 1  (so fiacao, MSB entra com 0)
    buf (result_shifted[17], 1'b0);
    buf (result_shifted[16], result_in[17]);
    buf (result_shifted[15], result_in[16]);
    buf (result_shifted[14], result_in[15]);
    buf (result_shifted[13], result_in[14]);
    buf (result_shifted[12], result_in[13]);
    buf (result_shifted[11], result_in[12]);
    buf (result_shifted[10], result_in[11]);
    buf (result_shifted[9],  result_in[10]);
    buf (result_shifted[8],  result_in[9]);
    buf (result_shifted[7],  result_in[8]);
    buf (result_shifted[6],  result_in[7]);
    buf (result_shifted[5],  result_in[6]);
    buf (result_shifted[4],  result_in[5]);
    buf (result_shifted[3],  result_in[4]);
    buf (result_shifted[2],  result_in[3]);
    buf (result_shifted[1],  result_in[2]);
    buf (result_shifted[0],  result_in[1]);

    adder18 add2(result_shifted, B, result_candidato, cout2);

    // x_out = borrow ? x_in (sem alteracao) : dif (subtraiu)
    mux_2x1 mx0 (dif[0],  x_in[0],  borrow, x_out[0]);
    mux_2x1 mx1 (dif[1],  x_in[1],  borrow, x_out[1]);
    mux_2x1 mx2 (dif[2],  x_in[2],  borrow, x_out[2]);
    mux_2x1 mx3 (dif[3],  x_in[3],  borrow, x_out[3]);
    mux_2x1 mx4 (dif[4],  x_in[4],  borrow, x_out[4]);
    mux_2x1 mx5 (dif[5],  x_in[5],  borrow, x_out[5]);
    mux_2x1 mx6 (dif[6],  x_in[6],  borrow, x_out[6]);
    mux_2x1 mx7 (dif[7],  x_in[7],  borrow, x_out[7]);
    mux_2x1 mx8 (dif[8],  x_in[8],  borrow, x_out[8]);
    mux_2x1 mx9 (dif[9],  x_in[9],  borrow, x_out[9]);
    mux_2x1 mx10(dif[10], x_in[10], borrow, x_out[10]);
    mux_2x1 mx11(dif[11], x_in[11], borrow, x_out[11]);
    mux_2x1 mx12(dif[12], x_in[12], borrow, x_out[12]);
    mux_2x1 mx13(dif[13], x_in[13], borrow, x_out[13]);
    mux_2x1 mx14(dif[14], x_in[14], borrow, x_out[14]);
    mux_2x1 mx15(dif[15], x_in[15], borrow, x_out[15]);
    mux_2x1 mx16(dif[16], x_in[16], borrow, x_out[16]);
    mux_2x1 mx17(dif[17], x_in[17], borrow, x_out[17]);

    // result_out = borrow ? result_shifted : result_candidato
    mux_2x1 mr0 (result_candidato[0],  result_shifted[0],  borrow, result_out[0]);
    mux_2x1 mr1 (result_candidato[1],  result_shifted[1],  borrow, result_out[1]);
    mux_2x1 mr2 (result_candidato[2],  result_shifted[2],  borrow, result_out[2]);
    mux_2x1 mr3 (result_candidato[3],  result_shifted[3],  borrow, result_out[3]);
    mux_2x1 mr4 (result_candidato[4],  result_shifted[4],  borrow, result_out[4]);
    mux_2x1 mr5 (result_candidato[5],  result_shifted[5],  borrow, result_out[5]);
    mux_2x1 mr6 (result_candidato[6],  result_shifted[6],  borrow, result_out[6]);
    mux_2x1 mr7 (result_candidato[7],  result_shifted[7],  borrow, result_out[7]);
    mux_2x1 mr8 (result_candidato[8],  result_shifted[8],  borrow, result_out[8]);
    mux_2x1 mr9 (result_candidato[9],  result_shifted[9],  borrow, result_out[9]);
    mux_2x1 mr10(result_candidato[10], result_shifted[10], borrow, result_out[10]);
    mux_2x1 mr11(result_candidato[11], result_shifted[11], borrow, result_out[11]);
    mux_2x1 mr12(result_candidato[12], result_shifted[12], borrow, result_out[12]);
    mux_2x1 mr13(result_candidato[13], result_shifted[13], borrow, result_out[13]);
    mux_2x1 mr14(result_candidato[14], result_shifted[14], borrow, result_out[14]);
    mux_2x1 mr15(result_candidato[15], result_shifted[15], borrow, result_out[15]);
    mux_2x1 mr16(result_candidato[16], result_shifted[16], borrow, result_out[16]);
    mux_2x1 mr17(result_candidato[17], result_shifted[17], borrow, result_out[17]);
endmodule


// ---------------------------------------------------------------------
// Modulo topo: raiz quadrada de 18 bits, 9 estagios em cascata
// (constantes fixas 4^8 ... 4^0 -- nessa ordem)
// ---------------------------------------------------------------------
module raiz_Quadrada(X, root);
    input  [17:0] X;     // radicando (0 a 262143)
    output [8:0]  root;  // floor(sqrt(X)), de 0 a 511

    wire [17:0] r0, r1, r2, r3, r4, r5, r6, r7, r8, r9; // resultado apos cada estagio
    wire [17:0] x1, x2, x3, x4, x5, x6, x7, x8, x9;     // x apos cada estagio

    // resultado inicial = 0
    buf (r0[0],  1'b0);
    buf (r0[1],  1'b0);
    buf (r0[2],  1'b0);
    buf (r0[3],  1'b0);
    buf (r0[4],  1'b0);
    buf (r0[5],  1'b0);
    buf (r0[6],  1'b0);
    buf (r0[7],  1'b0);
    buf (r0[8],  1'b0);
    buf (r0[9],  1'b0);
    buf (r0[10], 1'b0);
    buf (r0[11], 1'b0);
    buf (r0[12], 1'b0);
    buf (r0[13], 1'b0);
    buf (r0[14], 1'b0);
    buf (r0[15], 1'b0);
    buf (r0[16], 1'b0);
    buf (r0[17], 1'b0);

    sqrt_stage stage1(X,  r0, 18'b010000000000000000, x1, r1); // B = 4^8 = 65536
    sqrt_stage stage2(x1, r1, 18'b000100000000000000, x2, r2); // B = 4^7 = 16384
    sqrt_stage stage3(x2, r2, 18'b000001000000000000, x3, r3); // B = 4^6 = 4096
    sqrt_stage stage4(x3, r3, 18'b000000010000000000, x4, r4); // B = 4^5 = 1024
    sqrt_stage stage5(x4, r4, 18'b000000000100000000, x5, r5); // B = 4^4 = 256
    sqrt_stage stage6(x5, r5, 18'b000000000001000000, x6, r6); // B = 4^3 = 64
    sqrt_stage stage7(x6, r6, 18'b000000000000010000, x7, r7); // B = 4^2 = 16
    sqrt_stage stage8(x7, r7, 18'b000000000000000100, x8, r8); // B = 4^1 = 4
    sqrt_stage stage9(x8, r8, 18'b000000000000000001, x9, r9); // B = 4^0 = 1

    // resposta final = 9 bits mais baixos do resultado do ultimo estagio
    buf (root[0], r9[0]);
    buf (root[1], r9[1]);
    buf (root[2], r9[2]);
    buf (root[3], r9[3]);
    buf (root[4], r9[4]);
    buf (root[5], r9[5]);
    buf (root[6], r9[6]);
    buf (root[7], r9[7]);
    buf (root[8], r9[8]);
endmodule
