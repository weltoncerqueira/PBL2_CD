
module controle_load_registradores (
    input        clk,
    input        reset,
    input        botao,     
    input  [7:0] sw,      

    output [7:0] reg_a,
    output [7:0] reg_b,
    output [7:0] reg_c
);

    wire [1:0] count;
    wire sel_a, sel_b, sel_c;
    wire botao_debounced;   // nível estável (renomeado, sem "pulse" no nome)
    wire botao_pulse;       // pulso de 1 ciclo — este é o que os demais blocos precisam

    debounce debounce_1 (
        .botao(botao),
        .clk(clk),
        .rst(reset),
        .botao_debounced(botao_debounced)
    );

    edge_detect edge_1 (
        .clk(clk),
        .rst(reset),
        .sinal_estavel(botao_debounced),
        .pulso(botao_pulse)
    );

    contador_2b_ComPausa contComPausa (
        .b(botao_pulse),      // <-- corrigido: pulso limpo, não o botão bruto
        .clk(clk),
        .rst(reset),
        .cont(count)
    );

    decoder_abc abc (
        .key_pulse(botao_pulse),  // <-- corrigido: pulso limpo, não o nível debounced
        .count(count), 
        .sel_a(sel_a), 
        .sel_b(sel_b), 
        .sel_c(sel_c)
    );

    registrador_8b reg8_a (
        .D(sw), .enable(sel_a), .rst(reset), .clk(clk), .S(reg_a)
    );

    registrador_8b reg8_b (
        .D(sw), .enable(sel_b), .rst(reset), .clk(clk), .S(reg_b)
    );

    registrador_8b reg8_c (
        .D(sw), .enable(sel_c), .rst(reset), .clk(clk), .S(reg_c)
    );

endmodule
