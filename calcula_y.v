
// y = ax² + bx + c
module calcula_y (
    input  [7:0]  x,
    input  [7:0]  a,
    input  [7:0]  b,
    input  [7:0]  c,
    output        overflow,
    output        cout,
    output [23:0] y
);
    
    wire [15:0] produto1; // x^2
    wire [23:0] produto2; // a * x^2
    wire [15:0] produto3; // b * x
    wire [23:0] soma1;    // ax^2 + bx
    
    wire ovf1, ovf2;

    // x² (8x8 -> 16 bits)
    multiplicador_8x8_sinalizado multp_1 (
        .A(x),
        .B(x),
        .S(produto1)
    );
     
    // a * x² (8x16 -> 24 bits)
    multiplicador_16x8_sinalizado multp_2 (
        .A(produto1),
        .B(a),
        .P(produto2)
    );
     
    // b * x (8x8 -> 16 bits)
    multiplicador_8x8_sinalizado multp_3 (
        .A(b),
        .B(x),
        .S(produto3)
    );
     
    //  ax² + bx
    // Preenchimento com zero para expandir produto3 de 16b para 24b 
    somador_24b soma24_1 (
        .A(produto2),
        .B({ {8{produto3[15]}}, produto3 }),
        .cin(1'b0),
        .S(soma1),
        .cout(),
        .overflow(ovf1)
    );
     
    // 5. y = (ax² + bx) + c
    // Extensão do sinal c para 24 bits
    somador_24b soma24_2 (
        .A(soma1),
        .B({ {16{c[7]}}, c }),
        .cin(1'b0),
        .S(y),
        .cout(cout),
        .overflow(ovf2)
    );
	 
	 or (overflow, ovf1, ovf2);

endmodule


module somador_24b (
    input  [23:0] A,
    input  [23:0] B,
    input         cin,
    output [23:0] S,
    output        cout,
    output        overflow
);
    
    wire [22:0] c;

    somador_completo fa0  (.A(A[0]),  .B(B[0]),  .cin(cin),  .S(S[0]),  .cout(c[0]));
    somador_completo fa1  (.A(A[1]),  .B(B[1]),  .cin(c[0]), .S(S[1]),  .cout(c[1]));
    somador_completo fa2  (.A(A[2]),  .B(B[2]),  .cin(c[1]), .S(S[2]),  .cout(c[2]));
    somador_completo fa3  (.A(A[3]),  .B(B[3]),  .cin(c[2]), .S(S[3]),  .cout(c[3]));
    somador_completo fa4  (.A(A[4]),  .B(B[4]),  .cin(c[3]), .S(S[4]),  .cout(c[4]));
    somador_completo fa5  (.A(A[5]),  .B(B[5]),  .cin(c[4]), .S(S[5]),  .cout(c[5]));
    somador_completo fa6  (.A(A[6]),  .B(B[6]),  .cin(c[5]), .S(S[6]),  .cout(c[6]));
    somador_completo fa7  (.A(A[7]),  .B(B[7]),  .cin(c[6]), .S(S[7]),  .cout(c[7]));
    somador_completo fa8  (.A(A[8]),  .B(B[8]),  .cin(c[7]), .S(S[8]),  .cout(c[8]));
    somador_completo fa9  (.A(A[9]),  .B(B[9]),  .cin(c[8]), .S(S[9]),  .cout(c[9]));
    somador_completo fa10 (.A(A[10]), .B(B[10]), .cin(c[9]), .S(S[10]), .cout(c[10]));
    somador_completo fa11 (.A(A[11]), .B(B[11]), .cin(c[10]),.S(S[11]), .cout(c[11]));
    somador_completo fa12 (.A(A[12]), .B(B[12]), .cin(c[11]),.S(S[12]), .cout(c[12]));
    somador_completo fa13 (.A(A[13]), .B(B[13]), .cin(c[12]),.S(S[13]), .cout(c[13]));
    somador_completo fa14 (.A(A[14]), .B(B[14]), .cin(c[13]),.S(S[14]), .cout(c[14]));
    somador_completo fa15 (.A(A[15]), .B(B[15]), .cin(c[14]),.S(S[15]), .cout(c[15]));
    somador_completo fa16 (.A(A[16]), .B(B[16]), .cin(c[15]),.S(S[16]), .cout(c[16]));
    somador_completo fa17 (.A(A[17]), .B(B[17]), .cin(c[16]),.S(S[17]), .cout(c[17]));
    somador_completo fa18 (.A(A[18]), .B(B[18]), .cin(c[17]),.S(S[18]), .cout(c[18]));
    somador_completo fa19 (.A(A[19]), .B(B[19]), .cin(c[18]),.S(S[19]), .cout(c[19]));
    somador_completo fa20 (.A(A[20]), .B(B[20]), .cin(c[19]),.S(S[20]), .cout(c[20]));
    somador_completo fa21 (.A(A[21]), .B(B[21]), .cin(c[20]),.S(S[21]), .cout(c[21]));
    somador_completo fa22 (.A(A[22]), .B(B[22]), .cin(c[21]),.S(S[22]), .cout(c[22]));
    somador_completo fa23 (.A(A[23]), .B(B[23]), .cin(c[22]),.S(S[23]), .cout(cout));
    
    xor (overflow, c[22], cout);
     
endmodule
