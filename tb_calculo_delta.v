`timescale 1ns/1ps

module tb_calculo_delta;

    // Entradas
    reg [7:0] a;
    reg [7:0] b;
    reg [7:0] c;

    // Saídas
    wire [17:0] delta;
    wire overflow;

    // Instância do módulo que queremos testar
    calculo_delta dut (
        .a(a),
        .b(b),
        .c(c),
        .delta(delta),
        .overflow(overflow)
    );

    initial begin

        $display("==============================================");
        $display("       TESTE DO CALCULO DO DELTA");
        $display("       Delta = b^2 - 4ac");
        $display("==============================================");

        // -------------------------------------------------
        // TESTE 1
        // a = 1, b = 5, c = 6
        // Delta = 25 - 24 = 1
        // -------------------------------------------------
        a = 8'd1;
        b = 8'd5;
        c = 8'd6;

        #10;

        $display("Teste 1:");
        $display("a = %d | b = %d | c = %d | delta = %d | overflow = %b",
                 $signed(a), $signed(b), $signed(c), $signed(delta), overflow);


        // -------------------------------------------------
        // TESTE 2
        // a = 1, b = 4, c = 4
        // Delta = 16 - 16 = 0
        // -------------------------------------------------
        a = 8'd1;
        b = 8'd4;
        c = 8'd4;

        #10;

        $display("Teste 2:");
        $display("a = %d | b = %d | c = %d | delta = %d | overflow = %b",
                 $signed(a), $signed(b), $signed(c), $signed(delta), overflow);


        // -------------------------------------------------
        // TESTE 3
        // a = 1, b = 2, c = 3
        // Delta = 4 - 12 = -8
        // -------------------------------------------------
        a = 8'd1;
        b = 8'd2;
        c = 8'd3;

        #10;

        $display("Teste 3:");
        $display("a = %d | b = %d | c = %d | delta = %d | overflow = %b",
                 $signed(a), $signed(b), $signed(c), $signed(delta), overflow);


        // -------------------------------------------------
        // TESTE 4
        // a = 2, b = 10, c = 3
        // Delta = 100 - 24 = 76
        // -------------------------------------------------
        a = 8'd2;
        b = 8'd10;
        c = 8'd3;

        #10;

        $display("Teste 4:");
        $display("a = %d | b = %d | c = %d | delta = %d | overflow = %b",
                 $signed(a), $signed(b), $signed(c), $signed(delta), overflow);


        // -------------------------------------------------
        // TESTE 5 - valores negativos
        // a = -2, b = 5, c = 3
        // Delta = 25 - 4(-2)(3)
        // Delta = 25 + 24
        // Delta = 49
        // -------------------------------------------------
        a = -8'sd2;
        b =  8'sd5;
        c =  8'sd3;

        #10;

        $display("Teste 5:");
        $display("a = %d | b = %d | c = %d | delta = %d | overflow = %b",
                 $signed(a), $signed(b), $signed(c), $signed(delta), overflow);


        // -------------------------------------------------
        // TESTE 6 - b negativo
        // a = 1, b = -5, c = 6
        // Delta = (-5)^2 - 4(1)(6)
        // Delta = 25 - 24 = 1
        // -------------------------------------------------
        a =  8'sd1;
        b = -8'sd5;
        c =  8'sd6;

        #10;

        $display("Teste 6:");
        $display("a = %d | b = %d | c = %d | delta = %d | overflow = %b",
                 $signed(a), $signed(b), $signed(c), $signed(delta), overflow);


        // -------------------------------------------------
        // TESTE 7 - todos negativos
        // a = -2, b = -5, c = -3
        // Delta = (-5)^2 - 4(-2)(-3)
        // Delta = 25 - 24 = 1
        // -------------------------------------------------
        a = -8'sd2;
        b = -8'sd5;
        c = -8'sd3;

        #10;

        $display("Teste 7:");
        $display("a = %d | b = %d | c = %d | delta = %d | overflow = %b",
                 $signed(a), $signed(b), $signed(c), $signed(delta), overflow);


        // -------------------------------------------------
        // TESTE 8 - Delta grande positivo
        // a = 1, b = 100, c = 1
        // Delta = 10000 - 4 = 9996
        // -------------------------------------------------
        a = 8'd1;
        b = 8'd100;
        c = 8'd1;

        #10;

        $display("Teste 8:");
        $display("a = %d | b = %d | c = %d | delta = %d | overflow = %b",
                 $signed(a), $signed(b), $signed(c), $signed(delta), overflow);


        // -------------------------------------------------
        // TESTE 9 - Delta negativo
        // a = 10, b = 2, c = 10
        // Delta = 4 - 400 = -396
        // -------------------------------------------------
        a = 8'd10;
        b = 8'd2;
        c = 8'd10;

        #10;

        $display("Teste 9:");
        $display("a = %d | b = %d | c = %d | delta = %d | overflow = %b",
                 $signed(a), $signed(b), $signed(c), $signed(delta), overflow);


        // -------------------------------------------------
        // FIM
        // -------------------------------------------------
        $display("==============================================");
        $display("              FIM DOS TESTES");
        $display("==============================================");

        $stop;

    end

endmodule