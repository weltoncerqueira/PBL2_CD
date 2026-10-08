module integrador (
    input [7:0] sw,
    input [1:0] sel,
    input botao,
    input clk,
    input reset,
 
    output [6:0] s0, s1, s2, s3, s4, s5,
	 output sinal_x1, sinal_x2, sinal_y
    
);

    wire [7:0] reg_a, reg_b, reg_c;
    wire [1:0] count1, count2;
    
    wire sel_a, sel_b, sel_c;
    wire botao_pulse; 
     
    wire rst_interno;
    not (rst_interno, reset);
    
     
    // captura um pulso único do botão
   detector_de_borda borda_1 (
       .clk(clk),
       .rst(rst_interno),
       .sinal(botao),
       .pulso(botao_pulse)
    );

    // Conta até 3, com base em cada pulso do botao
   contador_2b contComPausa (
        .pulso(botao_pulse),    
        .clk(clk),
        .rst(rst_interno),
        .Q(count1),
          .S(count2)
    );
     
     // Decodifica o contador para escolher qual registrador receberá o valor das chaves
    decoder_abc abc (
        .count(count1), 
        .sel_a(sel_a), 
        .sel_b(sel_b), 
        .sel_c(sel_c)
    );
     
     // registradores
    registrador_8b reg8_a (.D(sw), .enable(sel_a), .rst(rst_interno), .clk(clk), .S(reg_a));
    registrador_8b reg8_b (.D(sw), .enable(sel_b), .rst(rst_interno), .clk(clk), .S(reg_b));
    registrador_8b reg8_c (.D(sw), .enable(sel_c), .rst(rst_interno), .clk(clk), .S(reg_c));
    
     wire [8:0] x1, x2;
     wire [17:0] delta;
     wire [23:0] y;
     
     wire ovf_x1, ovf_x2;
     wire ovf_delta, ovf_y, cout_Y;
     wire delta_negativo1, delta_negativo2;
	  wire [23:0] shift_x1, shift_x2, shift_x;
	  wire [23:0] x_saida, x1_saida, x2_saida, y_saida;
	 
	 
	  //captura os sinais para a flag de número negativo
	  and (sinal_x1, x1[8], 1'b1);
	  and (sinal_x2, x2[8], 1'b1);
	  and (sinal_y, y[23], 1'b1);
	  and (sinal_x, x[7], 1'b1);
	 
     calculo_delta delta1 (
        .a(reg_a),
        .b(reg_b),
        .c(reg_c),
        .delta(delta),
        .overflow(ovf_delta)
     );
    
     calcula_x1 x01 (
      .a(reg_a), 
      .b(reg_b),
      .delta(delta),
      .x1(x1),
      .ov_soma(ovf_x1), 
      .delta_negativo(delta_negativo1)
     );
    
     calcula_x2  x02 (
      .a(reg_a), 
      .b(reg_b),
      .delta(delta),
      .x2(x2),
      .overflow(ovf_x2), 
      .delta_negativo(delta_negativo2)
     );
     
     calcula_y y1 (
       .x(sw),
       .a(reg_a),
       .b(reg_b),
       .c(reg_c),
       .overflow(ovf_y),
       .cout(cout_Y),
       .y(y)
    );
	 
     //Verifica se delta é negativo. Caso seja, o valor de x1 e x2 é zerado
	  //Dá pra fazer usando mux que seleciona entre o x1 e x2 normal ou zerado
	  //a depender do valor de delta_negativo
     wire delta_negativo;
     or (delta_negativo, delta_negativo1, delta_negativo2);
		
	
	  //Extensão das variaveis x1, x2 e x para 24 bits
	  extensao_pra_24bits extende(
		  .sw(sw), 
		  .x1(x1), 
		  .x2(x2),
		  .shift_x(shift_x),
		  .shift_x1(shift_x1), 
		  .shift_x2(shift_x2)
	  );
		
		
	  //complemento de dois do y
	  complementoDe2_24bits comple24b_y(
			 .A(y),
			 .bs(sinal_y),
			.out(y_saida)
		);
		
	  //complemento de dois do x1
	  complementoDe2_24bits comple24b_x1(
			 .A(shift_x1),
			 .bs(sinal_x1),
			.out(x1_saida)
		);
		
	  //complemento de dois do x2
	  complementoDe2_24bits comple24b_x2(
			 .A(shift_x2),
			 .bs(sinal_x2),
			.out(x2_saida)
		);
		
	  //complemento de dois do x2
	  complementoDe2_24bits comple24b_x(
			 .A(shift_x),
			 .bs(sinal_x),
			.out(x_saida)
		);		
		
	  
	  wire [3:0] cem_milhar_x, dez_milhar_x, milhar_x, centena_x, dezena_x, unidade_x;
	  wire [3:0] cem_milhar_x1, dez_milhar_x1, milhar_x1, centena_x1, dezena_x1, unidade_x1;
	  wire [3:0] cem_milhar_x2, dez_milhar_x2, milhar_x2, centena_x2, dezena_x2, unidade_x2;
	  wire [3:0] cem_milhar_y, dez_milhar_y, milhar_y, centena_y, dezena_y, unidade_y;

	  bin_pra_decimal bin_dec_1 (
		  .valor_bin(x_saida), 
		  .centena_milhar(cem_milhar_x),
		  .dez_milhar(dez_milhar_x), 
		  .milhar(milhar_x), 
		  .centena(centena_x), 
		  .dezena(dezena_x), 
		  .unidade(unidade_x)
	  );
	  
	  bin_pra_decimal bin_dec_2 (
		  .valor_bin(x1_saida), 
		  .centena_milhar(cem_milhar_x1),
		  .dez_milhar(dez_milhar_x1), 
		  .milhar(milhar_x1), 
		  .centena(centena_x1), 
		  .dezena(dezena_x1), 
		  .unidade(unidade_x1)
	  );
	  
	  bin_pra_decimal bin_dec_4 (
		  .valor_bin(x2_saida),
		  .centena_milhar(cem_milhar_x2), 
		  .dez_milhar(dez_milhar_x2), 
		  .milhar(milhar_x2), 
		  .centena(centena_x2), 
		  .dezena(dezena_x2), 
		  .unidade(unidade_x2)
	  );
	  
	  bin_pra_decimal bin_dec_3 (
		  .valor_bin(y_saida),
	     .centena_milhar(cem_milhar_y), 
		  .dez_milhar(dez_milhar_y), 
		  .milhar(milhar_y), 
		  .centena(centena_y), 
		  .dezena(dezena_y), 
		  .unidade(unidade_y)
	  );
	  
	  
	  wire [6:0] seg5_x, seg4_x, seg3_x, seg2_x, seg1_x, seg0_x;
	  wire [6:0] seg5_x1, seg4_x1, seg3_x1, seg2_x1, seg1_x1, seg0_x1;
	  wire [6:0] seg5_x2, seg4_x2, seg3_x2, seg2_x2, seg1_x2, seg0_x2;
	  wire [6:0] seg5_y, seg4_y, seg3_y, seg2_y, seg1_y, seg0_y;
	  
		  
    // --- Decodificação BCD para 7 Segmentos de REG_x ---
	  bcd_to_7seg bcd_x5 ( .bcd(cem_milhar_x), .seg(seg5_x) );
     bcd_to_7seg bcd_x4 ( .bcd(dez_milhar_x), .seg(seg4_x) );
     bcd_to_7seg bcd_x3 ( .bcd(milhar_x),     .seg(seg3_x) );
     bcd_to_7seg bcd_x2 ( .bcd(centena_x),    .seg(seg2_x) );
     bcd_to_7seg bcd_x1 ( .bcd(dezena_x),     .seg(seg1_x) );
     bcd_to_7seg bcd_x0 ( .bcd(unidade_x),    .seg(seg0_x) );
      
     bcd_to_7seg bcd_x15 ( .bcd(cem_milhar_x1), .seg(seg5_x1) );
     bcd_to_7seg bcd_x14 ( .bcd(dez_milhar_x1), .seg(seg4_x1) );
     bcd_to_7seg bcd_x13 ( .bcd(milhar_x1),     .seg(seg3_x1) );
     bcd_to_7seg bcd_x12 ( .bcd(centena_x1),    .seg(seg2_x1) );
     bcd_to_7seg bcd_x11 ( .bcd(dezena_x1),     .seg(seg1_x1) );
     bcd_to_7seg bcd_x10 ( .bcd(unidade_x1),    .seg(seg0_x1) );

     bcd_to_7seg bcd_x25 ( .bcd(cem_milhar_x2), .seg(seg5_x2) );
     bcd_to_7seg bcd_x24 ( .bcd(dez_milhar_x2), .seg(seg4_x2) );
     bcd_to_7seg bcd_x23 ( .bcd(milhar_x2),     .seg(seg3_x2) );
     bcd_to_7seg bcd_x22 ( .bcd(centena_x2),    .seg(seg2_x2) );
     bcd_to_7seg bcd_x21 ( .bcd(dezena_x2),     .seg(seg1_x2) );
     bcd_to_7seg bcd_x20 ( .bcd(unidade_x2),    .seg(seg0_x2) );
  
     bcd_to_7seg bcd_y5 ( .bcd(cem_milhar_y), .seg(seg5_y) );
     bcd_to_7seg bcd_y4 ( .bcd(dez_milhar_y), .seg(seg4_y) );
     bcd_to_7seg bcd_y3 ( .bcd(milhar_y),     .seg(seg3_y) );
     bcd_to_7seg bcd_y2 ( .bcd(centena_y),    .seg(seg2_y) );
     bcd_to_7seg bcd_y1 ( .bcd(dezena_y),     .seg(seg1_y) );
     bcd_to_7seg bcd_y0 ( .bcd(unidade_y),    .seg(seg0_y) );
	  
	  
	 // seletor 00 = x
    // seletor 01 = y
    // seletor 10 = x1		
    // seletor 11 = x2

	 mux_4x1 mux00(.a(seg0_x), .b(seg0_y), .c(seg0_x1), .d(seg0_x2), .sel(sel), .S(s0)); 
	 mux_4x1 mux01(.a(seg1_x), .b(seg1_y), .c(seg1_x1), .d(seg1_x2), .sel(sel), .S(s1));
	 mux_4x1 mux02(.a(seg2_x), .b(seg2_y), .c(seg2_x1), .d(seg2_x2), .sel(sel), .S(s2));
	 mux_4x1 mux03(.a(seg3_x), .b(seg3_y), .c(seg3_x1), .d(seg3_x2), .sel(sel), .S(s3));
	 mux_4x1 mux04(.a(seg4_x), .b(seg4_y), .c(seg4_x1), .d(seg4_x2), .sel(sel), .S(s4));
	 mux_4x1 mux05(.a(seg5_x), .b(seg5_y), .c(seg5_x1), .d(seg5_x2), .sel(sel), .S(s5)); 
	  
	 
endmodule




module extensao_pra_24bits (
    input  [7:0]  sw,
    input  [8:0]  x1, x2,
    output [23:0] shift_x, shift_x1, shift_x2
);

	  buf (shift_x1[0], x1[0]);
	  buf (shift_x1[1], x1[1]);
	  buf (shift_x1[2], x1[2]);
	  buf (shift_x1[3], x1[3]);
	  buf (shift_x1[4], x1[4]);
	  buf (shift_x1[5], x1[5]);
	  buf (shift_x1[6], x1[6]);
	  buf (shift_x1[7], x1[7]);
	  buf (shift_x1[8], x1[8]);
	  buf (shift_x1[9], x1[8]);
	  buf (shift_x1[10], x1[8]);
	  buf (shift_x1[11], x1[8]);
	  buf (shift_x1[12], x1[8]);
	  buf (shift_x1[13], x1[8]);
	  buf (shift_x1[14], x1[8]);
	  buf (shift_x1[15], x1[8]);
	  buf (shift_x1[16], x1[8]);
	  buf (shift_x1[17], x1[8]);
	  buf (shift_x1[18], x1[8]);
	  buf (shift_x1[19], x1[8]);
	  buf (shift_x1[20], x1[8]);
	  buf (shift_x1[21], x1[8]);
	  buf (shift_x1[22], x1[8]);
	  buf (shift_x1[23], x1[8]);
	  
	  buf (shift_x2[0], x2[0]);
	  buf (shift_x2[1], x2[1]);
	  buf (shift_x2[2], x2[2]);
	  buf (shift_x2[3], x2[3]);
	  buf (shift_x2[4], x2[4]);
	  buf (shift_x2[5], x2[5]);
	  buf (shift_x2[6], x2[6]);
	  buf (shift_x2[7], x2[7]);
	  buf (shift_x2[8], x2[8]);
	  buf (shift_x2[9], x2[8]);
	  buf (shift_x2[10], x2[8]);
	  buf (shift_x2[11], x2[8]);
	  buf (shift_x2[12], x2[8]);
	  buf (shift_x2[13], x2[8]);
	  buf (shift_x2[14], x2[8]);
	  buf (shift_x2[15], x2[8]);
	  buf (shift_x2[16], x2[8]);
	  buf (shift_x2[17], x2[8]);
	  buf (shift_x2[18], x2[8]);
	  buf (shift_x2[19], x2[8]);
	  buf (shift_x2[20], x2[8]);
	  buf (shift_x2[21], x2[8]);
	  buf (shift_x2[22], x2[8]);
	  buf (shift_x2[23], x2[8]);
	  
	  buf (shift_x[0], sw[0]);
	  buf (shift_x[1], sw[1]);
	  buf (shift_x[2], sw[2]);
	  buf (shift_x[3], sw[3]);
	  buf (shift_x[4], sw[4]);
	  buf (shift_x[5], sw[5]);
	  buf (shift_x[6], sw[6]);
	  buf (shift_x[7], sw[7]);
	  buf (shift_x[8], sw[7]);
	  buf (shift_x[9], sw[7]);
	  buf (shift_x[10], sw[7]);
	  buf (shift_x[11], sw[7]);
	  buf (shift_x[12], sw[7]);
	  buf (shift_x[13], sw[7]);
	  buf (shift_x[14], sw[7]);
	  buf (shift_x[15], sw[7]);
	  buf (shift_x[16], sw[7]);
	  buf (shift_x[17], sw[7]);
	  buf (shift_x[18], sw[7]);
	  buf (shift_x[19], sw[7]);
	  buf (shift_x[20], sw[7]);
	  buf (shift_x[21], sw[7]);
	  buf (shift_x[22], sw[7]);
	  buf (shift_x[23], sw[7]);
endmodule








//registrador_8b.v
module registrador_8b (
    input        clk,
    input        rst,
    input        enable,
    input  [7:0] D,
    output [7:0] S
);

    wire [7:0] mux_out;
    wire [7:0] Q;

    mux_2x1 MUX0 (.A(Q[0]), .B(D[0]), .S(enable), .Y(mux_out[0]));
    ff_D     FF0  (.D(mux_out[0]), .clk(clk), .reset(rst), .Q(Q[0]));

    mux_2x1 MUX1 (.A(Q[1]), .B(D[1]), .S(enable), .Y(mux_out[1]));
    ff_D     FF1  (.D(mux_out[1]), .clk(clk), .reset(rst), .Q(Q[1]));

    mux_2x1 MUX2 (.A(Q[2]), .B(D[2]), .S(enable), .Y(mux_out[2]));
    ff_D     FF2  (.D(mux_out[2]), .clk(clk), .reset(rst), .Q(Q[2]));

    mux_2x1 MUX3 (.A(Q[3]), .B(D[3]), .S(enable), .Y(mux_out[3]));
    ff_D     FF3  (.D(mux_out[3]), .clk(clk), .reset(rst), .Q(Q[3]));

    mux_2x1 MUX4 (.A(Q[4]), .B(D[4]), .S(enable), .Y(mux_out[4]));
    ff_D     FF4  (.D(mux_out[4]), .clk(clk), .reset(rst), .Q(Q[4]));

    mux_2x1 MUX5 (.A(Q[5]), .B(D[5]), .S(enable), .Y(mux_out[5]));
    ff_D     FF5  (.D(mux_out[5]), .clk(clk), .reset(rst), .Q(Q[5]));

    mux_2x1 MUX6 (.A(Q[6]), .B(D[6]), .S(enable), .Y(mux_out[6]));
    ff_D     FF6  (.D(mux_out[6]), .clk(clk), .reset(rst), .Q(Q[6]));

    mux_2x1 MUX7 (.A(Q[7]), .B(D[7]), .S(enable), .Y(mux_out[7]));
    ff_D     FF7  (.D(mux_out[7]), .clk(clk), .reset(rst), .Q(Q[7]));

    buf (S[0], Q[0]);
     buf (S[1], Q[1]);
     buf (S[2], Q[2]);
     buf (S[3], Q[3]);
     buf (S[4], Q[4]);
     buf (S[5], Q[5]);
     buf (S[6], Q[6]);
     buf (S[7], Q[7]);
     
endmodule


//decoder_abc.v
module decoder_abc (
    input [1:0] count,
    output sel_a, sel_b, sel_c
);
    wire countN0, countN1;

    not (countN0, count[0]);
    not (countN1, count[1]);

    // (count = 00)
    and (sel_a, countN1, countN0);

    // (count = 01)
    and (sel_b, countN1, count[0]);

    // (count = 10)
    and (sel_c, count[1], countN0);

    // count = 11 → nenhuma saída ativa (travado), implícito
endmodule


// Módulo: detector_de_borda
module detector_de_borda (
    input  clk,
    input  rst,
    input  sinal,   // 1 = solto, 0 = pressionado (convenção KEY da DE10-Lite)
    output pulso
);

    wire Q1, Q2, Q1N;

    ff_D FF_Detector1 (
        .D(sinal),
        .clk(clk),
        .reset(rst),
          .Q(Q1)
    );

    ff_D FF_Detector2 (
        .D(Q1),
        .clk(clk),
        .reset(rst),
          .Q(Q2)
    );
     
     not (Q1N, Q1);
     and (pulso, Q1N, Q2);
    
     
endmodule


// FPGA projects using Verilog/ VHDL 
// fpga4student.com
// Verilog code for D Flip FLop
// Verilog code for Rising edge D flip flop with Asynchronous Reset high
module ff_D(D, clk, reset, Q);
input D; 
input clk;  
input reset; 
output reg Q; 

    always @(posedge clk) 
      begin
        if (reset)
            Q <= 1'b0;
        else
            Q <= D;
     end
      
endmodule