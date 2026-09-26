
// Módulo multiplicador 8x8

module multiplicador_8x8 (
    input  wire [7:0] A,
    input  wire [7:0] B,
    output wire [15:0] S
);
    // Produtos Parciais (Portas AND)
    wire p[63:0];

    // ---  Matriz de Produtos Parciais ---

    and (p[0], A[0], B[0]); and (p[1], A[1], B[0]); and (p[2], A[2], B[0]); and (p[3], A[3], B[0]);
	 and (p[4], A[4], B[0]); and (p[5], A[5], B[0]); and (p[6], A[6], B[0]); and (p[7], A[7], B[0]);

    and (p[8], A[0], B[1]);and (p[9], A[1], B[1]);and (p[10], A[2], B[1]);   and (p[11], A[3], B[1]);
    and (p[12], A[4], B[1]);and (p[13], A[5], B[1]);and (p[14], A[6], B[1]); and (p[15], A[7], B[1]);

    and (p[16], A[0], B[2]); 
	 and (p[17], A[1], B[2]);
    and (p[18], A[2], B[2]);
    and (p[19], A[3], B[2]);
    and (p[20], A[4], B[2]);
    and (p[21], A[5], B[2]);
    and (p[22], A[6], B[2]);
    and (p[23], A[7], B[2]);
    
    and (p[24], A[0], B[3]);
    and (p[25], A[1], B[3]);
    and (p[26], A[2], B[3]);
    and (p[27], A[3], B[3]);
    and (p[28], A[4], B[3]);
    and (p[29], A[5], B[3]);
    and (p[30], A[6], B[3]);
    and (p[31], A[7], B[3]);
    
    and (p[32], A[0], B[4]);
    and (p[33], A[1], B[4]);
    and (p[34], A[2], B[4]);
    and (p[35], A[3], B[4]);
    and (p[36], A[4], B[4]);
    and (p[37], A[5], B[4]);
    and (p[38], A[6], B[4]);
    and (p[39], A[7], B[4]);
    
    and (p[40], A[0], B[5]);
    and (p[41], A[1], B[5]);
    and (p[42], A[2], B[5]);
    and (p[43], A[3], B[5]);
    and (p[44], A[4], B[5]);
    and (p[45], A[5], B[5]);
    and (p[46], A[6], B[5]);
    and (p[47], A[7], B[5]);
    
    and (p[48], A[0], B[6]);
    and (p[49], A[1], B[6]);
    and (p[50], A[2], B[6]);
    and (p[51], A[3], B[6]);
    and (p[52], A[4], B[6]);
    and (p[53], A[5], B[6]);
    and (p[54], A[6], B[6]);
    and (p[55], A[7], B[6]);
    
    and (p[56], A[0], B[7]);
    and (p[57], A[1], B[7]);
    and (p[58], A[2], B[7]);
    and (p[59], A[3], B[7]);
    and (p[60], A[4], B[7]);
    and (p[61], A[5], B[7]);
    and (p[62], A[6], B[7]);
    and (p[63], A[7], B[7]);
	
	//fios intermediários para somas entre bits das colunas
	wire [127:0] s_int;
	
	// Fios de Carry intermediários entre os somadores
    wire [127:0] c;

    // Coluna 0: Não precisa de somador
    //buf b0 (S[0], p[0]);
	 assign S[0] = p[0];
    
    // --- Coluna 1 
    meio_somador h10 ( .A(p[1]), .B(p[8]), .sum(S[1]), .cout(c[0]) );   

    // --- Coluna 2 
   somador_completo f20 (.A(p[2]), .B(p[9]), .cin(c[0]), .S(s_int[0]), .cout(c[1]));
   somador_completo f21 ( .A(s_int[0]), .B(p[16]), .cin(1'b0), .S(S[2]), .cout(c[2]) );
    
    //Coluna 3
   somador_completo f31 (.A(p[3]),     .B(p[10]),  .cin(c[1]), .S(s_int[1]), .cout(c[3]));
   somador_completo f32 (.A(s_int[1]), .B(p[17]),  .cin(c[2]), .S(s_int[2]), .cout(c[4]));
   somador_completo f33 (.A(s_int[2]), .B(p[24]),  .cin(1'b0), .S(S[3]),     .cout(c[5]));
    
    //Coluna 4
   somador_completo f41 ( .A(p[4]), .B(p[11]),     .cin(c[3]), .S(s_int[3]), .cout(c[6]) );
   somador_completo f42 ( .A(s_int[3]), .B(p[18]), .cin(c[4]), .S(s_int[4]), .cout(c[7]) );
   somador_completo f43 ( .A(s_int[4]), .B(p[25]), .cin(c[5]), .S(s_int[5]), .cout(c[8]) );
   somador_completo f44 ( .A(s_int[5]), .B(p[32]), .cin(1'b0), .S(S[4]),     .cout(c[9]) );
    
    // Coluna 5
   somador_completo f51 ( .A(p[5]), 	 .B(p[12]), .cin(c[6]), .S(s_int[6]), .cout(c[10]) );
   somador_completo f52 ( .A(s_int[6]), .B(p[19]), .cin(c[7]), .S(s_int[7]), .cout(c[11]) );
   somador_completo f53 ( .A(s_int[7]), .B(p[26]), .cin(c[8]), .S(s_int[8]), .cout(c[12]) );
   somador_completo f54 ( .A(s_int[8]), .B(p[33]), .cin(c[9]), .S(s_int[9]), .cout(c[13]) );
   somador_completo f55 ( .A(s_int[9]), .B(p[40]), .cin(1'b0), .S(S[5]),     .cout(c[14]) );
 
    // Coluna 6
   somador_completo f61 ( .A(p[6]), 	  .B(p[13]), .cin(c[10]), .S(s_int[10]), .cout(c[15]) );
   somador_completo f62 ( .A(s_int[10]), .B(p[20]), .cin(c[11]), .S(s_int[11]), .cout(c[16]) );
   somador_completo f63 ( .A(s_int[11]), .B(p[27]), .cin(c[12]), .S(s_int[12]), .cout(c[17]) );
   somador_completo f64 ( .A(s_int[12]), .B(p[34]), .cin(c[13]), .S(s_int[13]), .cout(c[18]) );
   somador_completo f65 ( .A(s_int[13]), .B(p[41]), .cin(c[14]), .S(s_int[14]), .cout(c[19]) );
   somador_completo f66 ( .A(s_int[14]), .B(p[48]), .cin(1'b0), .S(S[6]),       .cout(c[20]) );
    
    // Coluna 7
   somador_completo f71 ( .A(p[7]),      .B(p[14]), .cin(c[15]), .S(s_int[15]), .cout(c[21]) );
   somador_completo f72 ( .A(s_int[15]), .B(p[21]), .cin(c[16]), .S(s_int[16]), .cout(c[22]) );
   somador_completo f73 ( .A(s_int[16]), .B(p[28]), .cin(c[17]), .S(s_int[17]), .cout(c[23]) );
   somador_completo f74 ( .A(s_int[17]), .B(p[35]), .cin(c[18]), .S(s_int[18]), .cout(c[24]) );
   somador_completo f75 ( .A(s_int[18]), .B(p[42]), .cin(c[19]), .S(s_int[19]), .cout(c[25]) );
   somador_completo f76 ( .A(s_int[19]), .B(p[49]), .cin(c[20]), .S(s_int[20]), .cout(c[26]) );
   somador_completo f77 ( .A(s_int[20]), .B(p[56]), .cin(1'b0), .S(S[7]), 		  .cout(c[27]) );
    
    // Coluna 8
   somador_completo fa8_0 ( .A(1'b0),     .B(p[15]), .cin(c[21]), .S(s_int[21]), .cout(c[28]) );
   somador_completo fa8_1 ( .A(s_int[21]),.B(p[22]), .cin(c[22]), .S(s_int[22]), .cout(c[29]) );
   somador_completo fa8_2 ( .A(s_int[22]),.B(p[29]), .cin(c[23]), .S(s_int[23]), .cout(c[30]) );
   somador_completo fa8_3 ( .A(s_int[23]),.B(p[36]), .cin(c[24]), .S(s_int[24]), .cout(c[31]) );
   somador_completo fa8_4 ( .A(s_int[24]),.B(p[43]), .cin(c[25]), .S(s_int[25]), .cout(c[32]) );
   somador_completo fa8_5 ( .A(s_int[25]),.B(p[50]), .cin(c[26]), .S(s_int[26]), .cout(c[33]) );
   somador_completo fa8_6 ( .A(s_int[26]),.B(p[57]), .cin(c[27]), .S(S[8]),      .cout(c[34]) );
    
    // Coluna 9
   somador_completo fa9_0 ( .A(1'b0),      .B(p[23]),  .cin(c[28]), .S(s_int[27]), .cout(c[35]) );
   somador_completo fa9_1 ( .A(s_int[27]), .B(p[30]),  .cin(c[29]), .S(s_int[28]), .cout(c[36]) );
   somador_completo fa9_2 ( .A(s_int[28]), .B(p[37]),  .cin(c[30]), .S(s_int[29]), .cout(c[37]) );
   somador_completo fa9_3 ( .A(s_int[29]), .B(p[44]),  .cin(c[31]), .S(s_int[30]), .cout(c[38]) );
   somador_completo fa9_4 ( .A(s_int[30]), .B(p[51]),  .cin(c[32]), .S(s_int[31]), .cout(c[39]) );
   somador_completo fa9_5 ( .A(s_int[31]), .B(p[58]),  .cin(c[33]), .S(s_int[32]), .cout(c[40]) );
   somador_completo fa9_6 ( .A(s_int[32]), .B(1'b0),   .cin(c[34]), .S(S[9]),      .cout(c[41]) );

    // Coluna 10
   somador_completo fa10_0 ( .A(1'b0),      .B(p[31]), .cin(c[35]), .S(s_int[33]), .cout(c[42]) );
   somador_completo fa10_1 ( .A(s_int[33]), .B(p[38]), .cin(c[36]), .S(s_int[34]), .cout(c[43]) );
   somador_completo fa10_2 ( .A(s_int[34]), .B(p[45]), .cin(c[37]), .S(s_int[35]), .cout(c[44]) );
   somador_completo fa10_3 ( .A(s_int[35]), .B(p[52]), .cin(c[38]), .S(s_int[36]), .cout(c[45]) );
   somador_completo fa10_4 ( .A(s_int[36]), .B(p[59]), .cin(c[39]), .S(s_int[37]), .cout(c[46]) );
   somador_completo fa10_5 ( .A(s_int[37]), .B(1'b0),  .cin(c[40]), .S(s_int[38]), .cout(c[47]) );
   somador_completo fa10_6 ( .A(s_int[38]), .B(1'b0),  .cin(c[41]), .S(S[10]),     .cout(c[48]) );
    
    // Coluna 11
   somador_completo fa11_0 ( .A(1'b0),      .B(p[39]), .cin(c[42]), .S(s_int[39]), .cout(c[49]) );
   somador_completo fa11_1 ( .A(s_int[39]), .B(p[46]), .cin(c[43]), .S(s_int[40]), .cout(c[50]) );
   somador_completo fa11_2 ( .A(s_int[40]), .B(p[53]), .cin(c[44]), .S(s_int[41]), .cout(c[51]) );
   somador_completo fa11_3 ( .A(s_int[41]), .B(p[60]), .cin(c[45]), .S(s_int[42]), .cout(c[52]) );
   somador_completo fa11_4 ( .A(s_int[42]), .B(1'b0),  .cin(c[46]), .S(s_int[43]), .cout(c[53]) );
   somador_completo fa11_5 ( .A(s_int[43]), .B(1'b0),  .cin(c[47]), .S(s_int[44]), .cout(c[54]) );
   somador_completo fa11_6 ( .A(s_int[44]), .B(1'b0),  .cin(c[48]), .S(S[11]),     .cout(c[55]) );
    
    // Coluna 12:
   somador_completo fa12_0 ( .A(1'b0),      .B(p[47]), .cin(c[49]), .S(s_int[45]), .cout(c[56]) );
   somador_completo fa12_1 ( .A(s_int[45]), .B(p[54]), .cin(c[50]), .S(s_int[46]), .cout(c[57]) );
   somador_completo fa12_2 ( .A(s_int[46]), .B(p[61]), .cin(c[51]), .S(s_int[47]), .cout(c[58]) );
   somador_completo fa12_3 ( .A(s_int[47]), .B(1'b0),  .cin(c[52]), .S(s_int[48]), .cout(c[59]) );
   somador_completo fa12_4 ( .A(s_int[48]), .B(1'b0),  .cin(c[53]), .S(s_int[49]), .cout(c[60]) );
   somador_completo fa12_5 ( .A(s_int[49]), .B(1'b0),  .cin(c[54]), .S(s_int[50]), .cout(c[61]) );
   somador_completo fa12_6 ( .A(s_int[50]), .B(1'b0),  .cin(c[55]), .S(S[12]),     .cout(c[62]) );
    
    // Coluna 13:
   somador_completo fa13_0 ( .A(1'b0),      .B(p[55]), .cin(c[56]), .S(s_int[51]), .cout(c[63]) );
   somador_completo fa13_1 ( .A(s_int[51]), .B(p[62]), .cin(c[57]), .S(s_int[52]), .cout(c[64]) );
   somador_completo fa13_2 ( .A(s_int[52]), .B(1'b0),  .cin(c[58]), .S(s_int[53]), .cout(c[65]) );
   somador_completo fa13_3 ( .A(s_int[53]), .B(1'b0),  .cin(c[59]), .S(s_int[54]), .cout(c[66]) );
   somador_completo fa13_4 ( .A(s_int[54]), .B(1'b0),  .cin(c[60]), .S(s_int[55]), .cout(c[67]) );
   somador_completo fa13_5 ( .A(s_int[55]), .B(1'b0),  .cin(c[61]), .S(s_int[56]), .cout(c[68]) );
   somador_completo fa13_6 ( .A(s_int[56]), .B(1'b0),  .cin(c[62]), .S(S[13]),     .cout(c[69]) );
    
    // Coluna 14:
   somador_completo fa14_0 ( .A(1'b0),      .B(p[63]), .cin(c[63]), .S(s_int[57]), .cout(c[70]) );
   somador_completo fa14_1 ( .A(s_int[57]), .B(1'b0),  .cin(c[64]), .S(s_int[58]), .cout(c[71]) );
   somador_completo fa14_2 ( .A(s_int[58]), .B(1'b0),  .cin(c[65]), .S(s_int[59]), .cout(c[72]) );
   somador_completo fa14_3 ( .A(s_int[59]), .B(1'b0),  .cin(c[66]), .S(s_int[60]), .cout(c[73]) );
   somador_completo fa14_4 ( .A(s_int[60]), .B(1'b0),  .cin(c[67]), .S(s_int[61]), .cout(c[74]) );
   somador_completo fa14_5 ( .A(s_int[61]), .B(1'b0),  .cin(c[68]), .S(s_int[62]), .cout(c[75]) );
   somador_completo fa14_6 ( .A(s_int[62]), .B(1'b0),  .cin(c[69]), .S(S[14]),     .cout(c[76]) );
    
   // Coluna 15:
	wire [127:0] s_int_final;
	wire [127:0] c_final;
   somador_completo fa15_0 ( .A(c[70]), 				.B(c[71]), 	.cin(1'b0), 		 .S(s_int_final[0]), .cout(c_final[0]) );
	somador_completo fa15_1 ( .A(s_int_final[0]), 	.B(c[72]),  .cin(c_final[0]),  .S(s_int_final[1]), .cout(c_final[1]) );
	somador_completo fa15_2 ( .A(s_int_final[1]), 	.B(c[73]), 	.cin(c_final[1]),  .S(s_int_final[2]), .cout(c_final[2]) );
	somador_completo fa15_3 ( .A(s_int_final[2]), 	.B(c[74]), 	.cin(c_final[2]),  .S(s_int_final[3]), .cout(c_final[3]) );
	somador_completo fa15_4 ( .A(s_int_final[3]), 	.B(c[75]), 	.cin(c_final[3]),  .S(s_int_final[4]), .cout(c_final[4]) );
	somador_completo fa15_5 ( .A(s_int_final[4]), 	.B(c[76]), 	.cin(c_final[4]),  .S(S[15]), 			 .cout(c_final[5]) );

endmodule
