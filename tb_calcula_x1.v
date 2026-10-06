`timescale 1ns / 1ps

module tb_calcula_x1;

    // Sinais de entrada (reg)
    reg  [7:0]  a;
    reg  [7:0]  b;
    reg  [17:0] delta;

    // Sinais de saída (wire)
    wire [8:0]  x1;
    wire        ov_soma;
    wire        delta_negativo;

    // Instância do Módulo sob Teste (DUT)
    calcula_x1 dut (
        .a(a),
        .b(b),
        .delta(delta),
        .x1(x1),
        .ov_soma(ov_soma),
        .delta_negativo(delta_negativo)
    );

    // Bloco de Estímulos
    initial begin
        // Configuração de formato de exibição
        $display("-----------------------------------------------------------------------");
        $display(" Tempo |    a |    b |      delta | x1 (hex/dec) | ov_soma | delta_neg ");
        $display("-----------------------------------------------------------------------");

        // Caso 1: Equação com raízes reais simples
        // Exemplo: a = 1, b = -5, delta = 9 (sqrt(delta) = 3)
        // x1 = (-(-5) + 3) / (2*1) = (5 + 3) / 2 = 4
        a = 8'd1;
        b = -8'sd5;               // Complemento de 2 para -5
        delta = 18'd9;
        #10;
        $display("%5t ns | %4d | %4d | %10d | %3h (%2d)   |    %b    |     %b", 
                 $time, $signed(a), $signed(b), delta, x1, $signed(x1), ov_soma, delta_negativo);

        // Caso 2: Delta negativo
        // Bit 17 de delta deve ser 1 para indicar número negativo em complemento de 2
        a = 8'd2;
        b = 8'd4;
        delta = 18'b10_0000_0000_0000_0000; // Bit 17 setado
        #10;
        $display("%5t ns | %4d | %4d | %10d | %3h (%2d)   |    %b    |     %b", 
                 $time, $signed(a), $signed(b), delta, x1, $signed(x1), ov_soma, delta_negativo);

        // Caso 3: Resultado x1 negativo
        // Exemplo: a = 1, b = 7, delta = 25 (sqrt(delta) = 5)
        // x1 = (-7 + 5) / (2*1) = -2 / 2 = -1
        a = 8'd1;
        b = 8'd7;
        delta = 18'd25;
        #10;
        $display("%5t ns | %4d | %4d | %10d | %3h (%2d)   |    %b    |     %b", 
                 $time, $signed(a), $signed(b), delta, x1, $signed(x1), ov_soma, delta_negativo);

        // Caso 4: a = 2, b = -10, delta = 16 (sqrt(delta) = 4)
        // x1 = (10 + 4) / 4 = 14 / 4 = 3 (divisão inteira)
        a = 8'd2;
        b = -8'sd10;
        delta = 18'd16;
        #10;
        $display("%5t ns | %4d | %4d | %10d | %3h (%2d)   |    %b    |     %b", 
                 $time, $signed(a), $signed(b), delta, x1, $signed(x1), ov_soma, delta_negativo);

        // Caso 5: Teste com b = 0
        // Exemplo: a = 1, b = 0, delta = 16 (sqrt(delta) = 4)
        // x1 = (0 + 4) / 2 = 2
        a = 8'd1;
        b = 8'd0;
        delta = 18'd16;
        #10;
        $display("%5t ns | %4d | %4d | %10d | %3h (%2d)   |    %b    |     %b", 
                 $time, $signed(a), $signed(b), delta, x1, $signed(x1), ov_soma, delta_negativo);

        $display("-----------------------------------------------------------------------");
        $finish;
    end

endmodule