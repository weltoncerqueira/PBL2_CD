
module divisor_8x8_sinalizado (
	input  [7:0] A,
	input  [7:0] B,
	output [7:0] S,
	output [7:0] resto 
	
);
	
	wire [7:0] A_abs, B_abs, div_result, resto_sem_sinal;
	wire sinal;
	 
	// Sinais iguais = 0, Sinais diferentes = 1
	xor (sinal, A[7], B[7]);
	
	valor_absoluto va (.entrada(A), .valor_absoluto(A_abs));
   valor_absoluto vb (.entrada(B), .valor_absoluto(B_abs));
	
	divisor_8bits div1(
		.A(A_abs),
		.B(B_abs),
		.Q(div_result),
		.R(resto_sem_sinal)
	);
	
  complementoDe2_8bits complemento1 (
		 .A(div_result), 
		 .bs(sinal),
		 .out(S)
	 );
	 
	complementoDe2_8bits complemento2 (
       .A(resto_sem_sinal),
       .bs(A[7]),            // resto segue APENAS o sinal do dividendo
       .out(resto)
    );
	 
	 
endmodule



