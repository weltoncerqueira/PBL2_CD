
module teste_reg (
    input        clk,
    input        reset,        // Entrada física de reset (ex: KEY0, ativo em 0)
    input        botao,        // Entrada física do botão de contagem
    output [1:0] count        // Conectado aos LEDs da placa
);

    wire botao_pulse;
    wire rst_interno;
	 
    not (rst_interno, reset);

    // Captura o pulso do botão
    detector_de_borda borda_2 (
        .clk(clk),
        .rst(rst_interno),
        .sinal(botao),
        .pulso(botao_pulse)
    );

    // Conta até 3 e trava no 3
    contador_2b contComPausa2 (
        .pulso(botao_pulse),    
        .clk(clk),
        .rst(rst_interno),
        .Q1(count[0]),
        .Q2(count[1])
    );

endmodule
