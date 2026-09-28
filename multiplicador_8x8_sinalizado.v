
module multiplicador_8x8_sinalizado (
    input  wire [7:0] A,
    input  wire [7:0] B,
    output wire [15:0] S
);

    wire [7:0] A_abs, B_abs;
    wire [15:0] P_mag;
    wire sinal;
	 

    // Sinais iguais = 0, Sinais diferentes = 1
    xor (sinal, A[7], B[7]);

    valor_absoluto va (.entrada(A), .valor_absoluto(A_abs));
    valor_absoluto vb (.entrada(B), .valor_absoluto(B_abs));

    multiplicador_8x8 mul_u (
        .A(A_abs),
        .B(B_abs),
        .S(P_mag)
    );

    complementoDe2_16bits comp16 (
        .A(P_mag),
        .bs(sinal),
        .out(S)
    );

endmodule


// complementoDe2_16bits.v
module complementoDe2_16bits (
    input  wire [15:0] A,
    input  wire        bs,
    output wire [15:0] out
);

    wire [15:0] xA;
    wire [15:0] c;

    // Inverte condicionalmente cada bit (XOR com bs)
    xor (xA[0],  A[0],  bs);
    xor (xA[1],  A[1],  bs);
    xor (xA[2],  A[2],  bs);
    xor (xA[3],  A[3],  bs);
    xor (xA[4],  A[4],  bs);
    xor (xA[5],  A[5],  bs);
    xor (xA[6],  A[6],  bs);
    xor (xA[7],  A[7],  bs);
    xor (xA[8],  A[8],  bs);
    xor (xA[9],  A[9],  bs);
    xor (xA[10], A[10], bs);
    xor (xA[11], A[11], bs);
    xor (xA[12], A[12], bs);
    xor (xA[13], A[13], bs);
    xor (xA[14], A[14], bs);
    xor (xA[15], A[15], bs);

    // Soma +1 quando bs=1 (ripple carry com somador_completo)
    somador_completo fa0  (.A(xA[0]),  .B(1'b0), .cin(bs),    .S(out[0]),  .cout(c[0]));
    somador_completo fa1  (.A(xA[1]),  .B(1'b0), .cin(c[0]),  .S(out[1]),  .cout(c[1]));
    somador_completo fa2  (.A(xA[2]),  .B(1'b0), .cin(c[1]),  .S(out[2]),  .cout(c[2]));
    somador_completo fa3  (.A(xA[3]),  .B(1'b0), .cin(c[2]),  .S(out[3]),  .cout(c[3]));
    somador_completo fa4  (.A(xA[4]),  .B(1'b0), .cin(c[3]),  .S(out[4]),  .cout(c[4]));
    somador_completo fa5  (.A(xA[5]),  .B(1'b0), .cin(c[4]),  .S(out[5]),  .cout(c[5]));
    somador_completo fa6  (.A(xA[6]),  .B(1'b0), .cin(c[5]),  .S(out[6]),  .cout(c[6]));
    somador_completo fa7  (.A(xA[7]),  .B(1'b0), .cin(c[6]),  .S(out[7]),  .cout(c[7]));
    somador_completo fa8  (.A(xA[8]),  .B(1'b0), .cin(c[7]),  .S(out[8]),  .cout(c[8]));
    somador_completo fa9  (.A(xA[9]),  .B(1'b0), .cin(c[8]),  .S(out[9]),  .cout(c[9]));
    somador_completo fa10 (.A(xA[10]), .B(1'b0), .cin(c[9]),  .S(out[10]), .cout(c[10]));
    somador_completo fa11 (.A(xA[11]), .B(1'b0), .cin(c[10]), .S(out[11]), .cout(c[11]));
    somador_completo fa12 (.A(xA[12]), .B(1'b0), .cin(c[11]), .S(out[12]), .cout(c[12]));
    somador_completo fa13 (.A(xA[13]), .B(1'b0), .cin(c[12]), .S(out[13]), .cout(c[13]));
    somador_completo fa14 (.A(xA[14]), .B(1'b0), .cin(c[13]), .S(out[14]), .cout(c[14]));
    somador_completo fa15 (.A(xA[15]), .B(1'b0), .cin(c[14]), .S(out[15]), .cout(c[15]));

endmodule
