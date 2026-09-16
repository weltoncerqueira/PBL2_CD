
`timescale 1ns/1ps

module registrador_8b_tb;

    // Sinais de teste (entradas do módulo -> reg, saídas -> wire)
    reg        clk;
    reg        rst;
    reg        enable;
    reg  [7:0] D;
    wire [7:0] S;

    // Instanciação da Unit Under Test (UUT)
    registrador_8b uut (
        .clk(clk),
        .rst(rst),
        .enable(enable),
        .D(D),
        .S(S)
    );

    // Geração do relógio (período de 10ns -> frequência de 100 MHz)
    always #5 clk = ~clk;

    // Sequência de estímulos
    initial begin
        // 1. Inicialização dos sinais
        clk    = 0;
        rst    = 0;
        enable = 0;
        D      = 8'h00;

        // Visualização no console durante a simulação
        $monitor("Tempo=%0t | rst=%b | enable=%b | D=0x%h (%b) | S=0x%h (%b)", 
                 $time, rst, enable, D, D, S, S);

        // 2. Aplica o Reset inicial
        #2;
        rst = 1;
        #10;
        rst = 0;
        #8;

        // 3. Tenta escrever com enable = 0 (O valor de S deve continuar 0x00)
        D = 8'hAA; // 10101010
        enable = 0;
        #20;

        // 4. Ativa o enable (O valor de S deve atualizar para 0xAA no próximo ciclo)
        enable = 1;
        #20;

        // 5. Desativa o enable e altera D (S deve manter o valor 0xAA)
        enable = 0;
        D = 8'h55; // 01010101
        #20;

        // 6. Ativa o enable novamente (S deve atualizar para 0x55)
        enable = 1;
        #20;

        // 7. Aplica o Reset durante uma operação (S deve voltar para 0x00 imediatamente)
        rst = 1;
        #10;
        rst = 0;
        #10;

        // Finaliza a simulação
        $display("Simulação concluída com sucesso.");
        $finish;
    end

endmodule