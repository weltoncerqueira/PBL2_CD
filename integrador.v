module integrador (
    input [7:0] sw,
    input [1:0] sel,
    input botao,
    input clk,
    input reset,
 
   output [6:0] seg5_y, seg4_y, seg3_y, seg2_y, seg1_y, seg0_y
    
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
      //.ov_soma(ovf_x2), 
      //.delta_negativo(delta_negativo2)
     );
     
     
     //Verifica se delta é negativo. Caso seja, o valor de x1 e x2 é zerado
     wire delta_negativo;
     or (delta_negativo, delta_negativo1, delta_negativo2);
     // fzr modulo pra Aumentar o tamanho de (sw, x1, x2) para 24 bits
     
     calcula_y y1 (
        .x(sw),
        .a(reg_a),
        .b(reg_b),
        .c(reg_c),
        .overflow(ovf_y),
        .cout(cout_Y),
        .y(y)
    );
	 
	  
    
        wire [23:0] shift_x1, shift_x2, shift_x, y_saida;
        
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
		
		  complementoDe2_24bits_novo (
				 .A(y),
				 .bs(y[23]),
				.out(y_saida)
			);
        
        wire [3:0] cem_milhar_x, dez_milhar_x, milhar_x, centena_x, dezena_x, unidade_x;
        wire [3:0] cem_milhar_x1, dez_milhar_x1, milhar_x1, centena_x1, dezena_x1, unidade_x1;
        wire [3:0] cem_milhar_x2, dez_milhar_x2, milhar_x2, centena_x2, dezena_x2, unidade_x2;
        wire [3:0] cem_milhar_y, dez_milhar_y, milhar_y, centena_y, dezena_y, unidade_y;

        bin_pra_decimal bin_dec_1 (.valor_bin(shift_x), .dez_milhar(dez_milhar_x), .milhar(milhar_x), .centena(centena_x), .dezena(dezena_x), .unidade(unidade_x));
        bin_pra_decimal bin_dec_2 (.valor_bin(shift_x1), .dez_milhar(dez_milhar_x1), .milhar(milhar_x1), .centena(centena_x1), .dezena(dezena_x1), .unidade(unidade_x1));
        bin_pra_decimal bin_dec_3 (.valor_bin(y_saida), .dez_milhar(dez_milhar_y), .milhar(milhar_y), .centena(centena_y), .dezena(dezena_y), .unidade(unidade_y));
        bin_pra_decimal bin_dec_4 (.valor_bin(shift_x2), .dez_milhar(dez_milhar_x2), .milhar(milhar_x2), .centena(centena_x2), .dezena(dezena_x2), .unidade(unidade_x2));
        
      //wire [6:0] seg4_x, seg3_x, seg2_x, seg1_x, seg0_x;
     // wire [6:0] seg5_x1, seg4_x1, seg3_x1, seg2_x1, seg1_x1, seg0_x1;
       // wire [6:0] seg5_x2, seg4_x2, seg3_x2, seg2_x2, seg1_x2, seg0_x2;
        //wire [6:0] seg5_y, seg4_y, seg3_y, seg2_y, seg1_y, seg0_y;
        
    // --- Decodificação BCD para 7 Segmentos de REG_x ---
     /*
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
     */
     bcd_to_7seg bcd_y5 ( .bcd(cem_milhar_y), .seg(seg5_y) );
     bcd_to_7seg bcd_y4 ( .bcd(dez_milhar_y), .seg(seg4_y) );
     bcd_to_7seg bcd_y3 ( .bcd(milhar_y),     .seg(seg3_y) );
     bcd_to_7seg bcd_y2 ( .bcd(centena_y),    .seg(seg2_y) );
     bcd_to_7seg bcd_y1 ( .bcd(dezena_y),     .seg(seg1_y) );
     bcd_to_7seg bcd_y0 ( .bcd(unidade_y),    .seg(seg0_y) );
	  
	  
 
endmodule 

module complementoDe2_24bits_novo (
    input  wire [23:0] A,
    input  wire       bs,
    output wire [23:0] out
);
    wire [23:0] notA, carry;
	 
    xor x0 (notA[0], A[0], bs);
    xor x1 (notA[1], A[1], bs);
    xor x2 (notA[2], A[2], bs);
    xor x3 (notA[3], A[3], bs);
    xor x4 (notA[4], A[4], bs);
    xor x5 (notA[5], A[5], bs);
    xor x6 (notA[6], A[6], bs);
    xor x8 (notA[7], A[7], bs);
	 xor x9 (notA[8], A[8], bs);
	 xor x10 (notA[9], A[9], bs);
	 xor x11(notA[10], A[10], bs);
	 xor x12(notA[11], A[11], bs);
	 xor x13(notA[12], A[12], bs);
	 xor x14(notA[13], A[13], bs);
	 xor x15 (notA[14], A[14], bs);
	 xor x16(notA[15], A[15], bs);
	 xor x17(notA[16], A[16], bs);
	 xor x18 (notA[17], A[17], bs);
	 xor x19(notA[18], A[18], bs);
	 xor x20(notA[19], A[19], bs);
	 xor x21(notA[20], A[20], bs);
	 xor x22(notA[21], A[21], bs);
	 xor x23(notA[22], A[22], bs);
	 xor x24(notA[23], A[23], bs);
	 

    somador_completo fa1 (.A(notA[0]), .B(1'b0), .cin(bs),       .S(out[0]), .cout(carry[0]));
    somador_completo fa2 (.A(notA[1]), .B(1'b0), .cin(carry[0]), .S(out[1]), .cout(carry[1]));
    somador_completo fa3 (.A(notA[2]), .B(1'b0), .cin(carry[1]), .S(out[2]), .cout(carry[2]));
    somador_completo fa4 (.A(notA[3]), .B(1'b0), .cin(carry[2]), .S(out[3]), .cout(carry[3]));
    somador_completo fa5 (.A(notA[4]), .B(1'b0), .cin(carry[3]), .S(out[4]), .cout(carry[4]));
    somador_completo fa6 (.A(notA[5]), .B(1'b0), .cin(carry[4]), .S(out[5]), .cout(carry[5]));
    somador_completo fa7 (.A(notA[6]), .B(1'b0), .cin(carry[5]), .S(out[6]), .cout(carry[6]));
    somador_completo fa8 (.A(notA[7]), .B(1'b0), .cin(carry[6]), .S(out[7]), .cout(carry[7]));
	 
	 somador_completo (.A(notA[8]), .B(1'b0), .cin(carry[7]), .S(out[8]), .cout(carry[8]));
	 somador_completo (.A(notA[9]), .B(1'b0), .cin(carry[8]), .S(out[9]), .cout(carry[9]));
	 somador_completo (.A(notA[10]), .B(1'b0), .cin(carry[9]), .S(out[10]), .cout(carry[10]));
	 somador_completo (.A(notA[11]), .B(1'b0), .cin(carry[10]), .S(out[11]), .cout(carry[11]));
	 somador_completo (.A(notA[12]), .B(1'b0), .cin(carry[11]), .S(out[12]), .cout(carry[12]));
	 somador_completo (.A(notA[13]), .B(1'b0), .cin(carry[12]), .S(out[13]), .cout(carry[13]));
	 somador_completo (.A(notA[14]), .B(1'b0), .cin(carry[13]), .S(out[14]), .cout(carry[14]));
	 somador_completo (.A(notA[15]), .B(1'b0), .cin(carry[14]), .S(out[15]), .cout(carry[15]));
	 somador_completo (.A(notA[16]), .B(1'b0), .cin(carry[15]), .S(out[16]), .cout(carry[16]));
	 somador_completo (.A(notA[17]), .B(1'b0), .cin(carry[16]), .S(out[17]), .cout(carry[17]));
	 somador_completo (.A(notA[18]), .B(1'b0), .cin(carry[17]), .S(out[18]), .cout(carry[18]));
	 somador_completo (.A(notA[19]), .B(1'b0), .cin(carry[18]), .S(out[19]), .cout(carry[19]));
	 somador_completo (.A(notA[20]), .B(1'b0), .cin(carry[19]), .S(out[20]), .cout(carry[20]));
	 somador_completo (.A(notA[21]), .B(1'b0), .cin(carry[20]), .S(out[21]), .cout(carry[21]));
	 somador_completo (.A(notA[22]), .B(1'b0), .cin(carry[21]), .S(out[22]), .cout(carry[22]));
	 somador_completo (.A(notA[23]), .B(1'b0), .cin(carry[22]), .S(out[23]), .cout(carry[23]));

endmodule
     

// Mux 4:1 estrutural genérico de 7 bits
module mux4to1_7bit (
    input  [6:0] in_a,
    input  [6:0] in_b,
    input  [6:0] in_c,
    input  [1:0] sel,
    output [6:0] out
);
    // Para cada um dos 7 segmentos, faz a combinação lógica estrutural do MUX 4:1:
    // sel = 00 -> in_a
    // sel = 01 -> in_b
    // sel = 10 ou 11 -> in_c
    
    genvar i;
    generate
        for (i = 0; i < 7; i = i + 1) begin : gen_mux
            wire not_sel1, not_sel0;
            wire term_a, term_b, term_c1, term_c2;

            not (not_sel1, sel[1]);
            not (not_sel0, sel[0]);

            // mintermos para seleção:
            // sel == 00 -> in_a
            and (term_a, in_a[i], not_sel1, not_sel0);
            
            // sel == 01 -> in_b
            and (term_b, in_b[i], not_sel1, sel[0]);
            
            // sel == 10 -> in_c
            and (term_c1, in_c[i], sel[1], not_sel0);
            
            // sel == 11 -> in_c
            and (term_c2, in_c[i], sel[1], sel[0]);

            // Saída = OU dos mintermos
            or (out[i], term_a, term_b, term_c1, term_c2);
        end
    endgenerate
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
