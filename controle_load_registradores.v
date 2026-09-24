
module controle_load_registradores (
    input        clk,
    input        reset,
    input        botao,     
    input  [7:0] sw,      

    output [7:0] reg_a,
    output [7:0] reg_b,
    output [7:0] reg_c,
	 
	 output led0, led1, led2, led3, led4, led5, led6, led7, led8
);

	 // saida dos leds para teste
	 assign led0 = sel_a;
	 assign led1 = sel_b;
	 assign led2 = sel_c;
	 assign led3 = 1'b0;
	 assign led4 = 1'b0;
	 assign led5 = 1'b0;
	 assign led6 = 1'b0;
	 assign led7 = 1'b0;
	 assign led8 = 1'b0;
	 
	 

    wire [1:0] count;
    wire sel_a, sel_b, sel_c;
    wire botao_pulse;       

	 
	 // captura um pulso único do botão
    detector_de_borda borda_1 (
        .clk(clk),
        .rst(reset),
        .sinal(botao),
        .pulso(botao_pulse)
    );

	 // Conta até 3, com base em cada pulso do botao
    contador_2b_ComPausa contComPausa (
        .pulso(botao_pulse),    
        .clk(clk),
        .rst(reset),
        .Q1(count[0]),
		  .Q2(count[1])
    );
	 
	 // Decodifica o contador para escolher qual registrador receberá o valor das chaves
    decoder_abc abc (
        .key_pulse(botao_pulse),
        .count(count), 
        .sel_a(sel_a), 
        .sel_b(sel_b), 
        .sel_c(sel_c)
    );
	 
	 // registrador a
    registrador_8b reg8_a (.D(sw), .enable(sel_a), .rst(reset), .clk(clk), .S(reg_a));
	 // registrador b
    registrador_8b reg8_b (.D(sw), .enable(sel_b), .rst(reset), .clk(clk), .S(reg_b));
	 // registrador c
    registrador_8b reg8_c (.D(sw), .enable(sel_c), .rst(reset), .clk(clk), .S(reg_c));

endmodule

