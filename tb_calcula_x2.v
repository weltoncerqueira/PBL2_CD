`timescale 1ns / 1ps

module tb_calcula_x2;

    // Sinais de entrada (reg)
    reg  [7:0]  a;
    reg  [7:0]  b;
    reg  [17:0] delta;

    // Sinais de saída (wire)
    wire [8:0]  x2;
    wire        overflow;

    // Instância do Módulo sob Teste (DUT)
    calcula_x2 dut (
        .a(a),
        .b(b),
        .delta(delta),
        .x2(x2),
        .overflow(overflow)
    );

    // Bloco de Estímulos
    initial begin
        // Cabeçalho para o log de simulação
        $display("-------------------------------------------------------------------");
        $display(" Tempo |    a |    b |      delta | x2 (hex/dec) | overflow | Obs");
        $display("-------------------------------------------------------------------");

        // Caso 1: Raízes simples (ex: x^2 - 5x + 6 = 0)
        // a = 1, b = -5, delta = 1 (sqrt(1) = 1)
        // x2 = (-(-5) - 1) / (2*1) = (5 - 1) / 2 = 2
        a = 8'd1;
        b = -8'sd5;               // Complemento de 2 para -5
        delta = 18'd1;
        #10;
        $display("%5t ns | %4d | %4d | %10d | %3h (%3d)  |    %b     | x2 = 2", 
                 $time, $signed(a), $signed(b), delta, x2, $signed(x2), overflow);

        // Caso 2: Raíz x2 fortemente negativa (ex: x^2 + 7x + 6 = 0)
        // a = 1, b = 7, delta = 25 (sqrt(25) = 5)
        // x2 = (-7 - 5) / (2*1) = -12 / 2 = -6
        a = 8'd1;
        b = 8'd7;
        delta = 18'd25;
        #10;
        $display("%5t ns | %4d | %4d | %10d | %3h (%3d)  |    %b     | x2 = -6", 
                 $time, $signed(a), $signed(b), delta, x2, $signed(x2), overflow);

        // Caso 3: Delta Negativo (Sinalizador de erro via Bit 17)
        // Deve ativar a saída de 'overflow' via porta OR interna do módulo
        a = 8'd2;
        b = 8'd4;
        delta = 18'b10_0000_0000_0000_0000; // Bit 17 = 1
        #10;
        $display("%5t ns | %4d | %4d | %10d | %3h (%3d)  |    %b     | Delta Negativo (Ovf=1)", 
                 $time, $signed(a), $signed(b), delta, x2, $signed(x2), overflow);

        // Caso 4: Divisão com a > 1 e truncamento de inteiros
        // a = 2, b = -10, delta = 16 (sqrt(16) = 4)
        // x2 = (10 - 4) / (2*2) = 6 / 4 = 1 (truncamento da divisão inteira)
        a = 8'd2;
        b = -8'sd10;
        delta = 18'd16;
        #10;
        $display("%5t ns | %4d | %4d | %10d | %3h (%3d)  |    %b     | x2 = 1 (1.5 truncado)", 
                 $time, $signed(a), $signed(b), delta, x2, $signed(x2), overflow);

        // Caso 5: Teste com b = 0
        // a = 1, b = 0, delta = 36 (sqrt(36) = 6)
        // x2 = (0 - 6) / 2 = -3
        a = 8'd1;
        b = 8'd0;
        delta = 18'd36;
        #10;
        $display("%5t ns | %4d | %4d | %10d | %3h (%3d)  |    %b     | x2 = -3", 
                 $time, $signed(a), $signed(b), delta, x2, $signed(x2), overflow);

        // Caso 6: Ambas as parcelas zeradas no numerador
        // a = 1, b = 0, delta = 0
        // x2 = (0 - 0) / 2 = 0
        a = 8'd1;
        b = 8'd0;
        delta = 18'd0;
        #10;
        $display("%5t ns | %4d | %4d | %10d | %3h (%3d)  |    %b     | x2 = 0", 
                 $time, $signed(a), $signed(b), delta, x2, $signed(x2), overflow);

        $display("-------------------------------------------------------------------");
        $finish;
    end

endmodule