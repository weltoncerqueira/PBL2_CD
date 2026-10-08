
module complementoDe2_8bits (
    input  wire [7:0] A,
    input  wire       bs,
    output wire [7:0] out
);
    wire [7:0] notA, carry;
	 
    xor x0 (notA[0], A[0], bs);
    xor x1 (notA[1], A[1], bs);
    xor x2 (notA[2], A[2], bs);
    xor x3 (notA[3], A[3], bs);
    xor x4 (notA[4], A[4], bs);
    xor x5 (notA[5], A[5], bs);
    xor x6 (notA[6], A[6], bs);
    xor x7 (notA[7], A[7], bs);

    somador_completo fa1 (.A(notA[0]), .B(1'b0), .cin(bs),       .S(out[0]), .cout(carry[0]));
    somador_completo fa2 (.A(notA[1]), .B(1'b0), .cin(carry[0]), .S(out[1]), .cout(carry[1]));
    somador_completo fa3 (.A(notA[2]), .B(1'b0), .cin(carry[1]), .S(out[2]), .cout(carry[2]));
    somador_completo fa4 (.A(notA[3]), .B(1'b0), .cin(carry[2]), .S(out[3]), .cout(carry[3]));
    somador_completo fa5 (.A(notA[4]), .B(1'b0), .cin(carry[3]), .S(out[4]), .cout(carry[4]));
    somador_completo fa6 (.A(notA[5]), .B(1'b0), .cin(carry[4]), .S(out[5]), .cout(carry[5]));
    somador_completo fa7 (.A(notA[6]), .B(1'b0), .cin(carry[5]), .S(out[6]), .cout(carry[6]));
    somador_completo fa8 (.A(notA[7]), .B(1'b0), .cin(carry[6]), .S(out[7]), .cout(carry[7]));

endmodule


module complementoDe2_24bits (
    input  [23:0] A,
    input         bs, // Bit de sinal (1 = aplica C2, 0 = mantém)
    output [23:0] out
);

    wire [23:0] A_xor;
    wire cout_inutil, ovf_inutil;

    // Inversão condicional controlada por bs
    xor (A_xor[0],  A[0],  bs);
    xor (A_xor[1],  A[1],  bs);
    xor (A_xor[2],  A[2],  bs);
    xor (A_xor[3],  A[3],  bs);
    xor (A_xor[4],  A[4],  bs);
    xor (A_xor[5],  A[5],  bs);
    xor (A_xor[6],  A[6],  bs);
    xor (A_xor[7],  A[7],  bs);
    xor (A_xor[8],  A[8],  bs);
    xor (A_xor[9],  A[9],  bs);
    xor (A_xor[10], A[10], bs);
    xor (A_xor[11], A[11], bs);
    xor (A_xor[12], A[12], bs);
    xor (A_xor[13], A[13], bs);
    xor (A_xor[14], A[14], bs);
    xor (A_xor[15], A[15], bs);
    xor (A_xor[16], A[16], bs);
    xor (A_xor[17], A[17], bs);
    xor (A_xor[18], A[18], bs);
    xor (A_xor[19], A[19], bs);
    xor (A_xor[20], A[20], bs);
    xor (A_xor[21], A[21], bs);
    xor (A_xor[22], A[22], bs);
    xor (A_xor[23], A[23], bs);

    // Soma 'bs' para concluir o C2 (se bs=1 soma 1, se bs=0 soma 0)
    somador_24b add_c2 (
        .A(A_xor),
        .B(24'b0),
        .cin(bs),
        .S(out),
        .cout(cout_inutil),
        .overflow(ovf_inutil)
    );

endmodule
