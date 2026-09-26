
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
