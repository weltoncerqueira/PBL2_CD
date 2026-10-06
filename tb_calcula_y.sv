
`timescale 1ns / 1ps

module tb_calcula_y;

    // Entradas (reg no testbench)
    reg signed [7:0] x;
    reg signed [7:0] a;
    reg signed [7:0] b;
    reg signed [7:0] c;

    // Saídas (wire no testbench)
    wire        overflow;
    wire        cout;
    wire [23:0] y;

    // Instância do Módulo sob Teste (DUT)
    calcula_y dut (
        .x(x),
        .a(a),
        .b(b),
        .c(c),
        .overflow(overflow),
        .cout(cout),
        .y(y)
    );

    // Variável para calcular o valor esperado e comparar na simulação
    integer valor_esperado;

    initial begin
        // Configuração de exibição no console
        $monitor("Tempo=%0dt | a=%d b=%d c=%d x=%d | y_obtido=%d (0x%h) | cout=%b ovf=%b", 
                 $time, a, b, c, x, $signed(y), y, cout, overflow);

        $display("----------------------------------------------------------------------------------");
        $display("Iniciando Testbench para calcula_y (y = a*x^2 + b*x + c)");
        $display("----------------------------------------------------------------------------------");

        // Caso 1: Tudo positivo (Equação simples)
        // a=2, b=3, c=5, x=4  => y = 2*(16) + 3*(4) + 5 = 32 + 12 + 5 = 49
        a = 8'd2; b = 8'd3; c = 8'd5; x = 8'd4;
        #10;
        checar_resultado(49);

        // Caso 2: Entradas com x negativo
        // a=3, b=2, c=10, x=-5 => y = 3*(25) + 2*(-5) + 10 = 75 - 10 + 10 = 75
        a = 8'd3; b = 8'd2; c = 8'd10; x = -8'd5;
        #10;
        checar_resultado(75);

        // Caso 3: Coeficientes a e b negativos
        // a=-2, b=-4, c=20, x=3 => y = -2*(9) + (-4)*(3) + 20 = -18 - 12 + 20 = -10
        a = -8'd2; b = -8'd4; c = 8'd20; x = 8'd3;
        #10;
        checar_resultado(-10);

        // Caso 4: Todos os termos negativos
        // a=-1, b=-2, c=-5, x=-3 => y = -1*(9) + (-2)*(-3) + (-5) = -9 + 6 - 5 = -8
        a = -8'd1; b = -8'd2; c = -8'd5; x = -8'd3;
        #10;
        checar_resultado(-8);

        // Caso 5: Entrada Zero (Ponto de corte em c)
        // a=5, b=-7, c=-12, x=0 => y = 0 + 0 - 12 = -12
        a = 8'd5; b = -8'd7; c = -8'd12; x = 8'd0;
        #10;
        checar_resultado(-12);

        // Caso 6: Valores máximos positivos (8 bits sinalizado -> +127)
        // a=127, b=127, c=127, x=2 => y = 127*(4) + 127*(2) + 127 = 508 + 254 + 127 = 889
        a = 8'sd127; b = 8'sd127; c = 8'sd127; x = 8'sd2;
        #10;
        checar_resultado(889);

        // Caso 7: Valores mínimos negativos (8 bits sinalizado -> -128)
        // a=-128, b=-128, c=-128, x=2 => y = -128*(4) + (-128)*(2) + (-128) = -512 - 256 - 128 = -896
        a = -8'sd128; b = -8'sd128; c = -8'sd128; x = 8'sd2;
        #10;
        checar_resultado(-896);

        $display("----------------------------------------------------------------------------------");
        $display("Testes finalizados com sucesso!");
        $display("----------------------------------------------------------------------------------");
        $finish;
    end

    // Task para automatizar a verificação do resultado correto
    task checar_resultado(input integer esperado);
        begin
            if ($signed(y) === esperado) begin
                $display("  [OK] Resultado correto: %d", $signed(y));
            end else begin
                $display("  [ERRO] Esperado: %d | Obtido: %d", esperado, $signed(y));
            end
        end
    endtask

endmodule