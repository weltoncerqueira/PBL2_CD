`timescale 1ns / 1ps

module tb_integrador;

    // Sinais de Entrada (Regs)
    reg [7:0] sw;
    reg [1:0] sel;
    reg botao;
    reg clk;
    reg reset;

    // Sinais de Saída (Wires)
    wire [6:0] s0, s1, s2, s3, s4, s5;

    // Instância do Módulo Top-Level
    integrador uut (
        .sw(sw),
        .sel(sel),
        .botao(botao),
        .clk(clk),
        .reset(reset),
        .s0(s0), .s1(s1), .s2(s2), .s3(s3), .s4(s4), .s5(s5)
    );

    // Geração do Clock (Período = 10ns -> 100MHz)
    always #5 clk = ~clk;

    // Task para simular o clique do botão (Sincronizada com o Clock)
    task pulsar_botao;
        begin
            @(posedge clk);
            #1;
            botao = 1'b0; // Pressiona botão (Ativo em LOW)
            repeat (5) @(posedge clk);
            #1;
            botao = 1'b1; // Solta botão
            repeat (5) @(posedge clk);
        end
    endtask

    // Task para exibir os valores brutos diretamente da hierarquia 'uut'
    task exibir_valores_brutos;
        begin
            #1;
            $display("\n==================================================");
            $display("       VALORES BRUTOS DOS SINAIS INTERNOS");
            $display("==================================================");
            $display("  [REGISTRADORES DE ENTRADA]");
            $display("    a  = %d (HEX: 0x%h)", $signed(uut.reg_a), uut.reg_a);
            $display("    b  = %d (HEX: 0x%h)", $signed(uut.reg_b), uut.reg_b);
            $display("    c  = %d (HEX: 0x%h)", $signed(uut.reg_c), uut.reg_c);
            $display("    x  = %d (HEX: 0x%h)", $signed(sw), sw);
            $display("--------------------------------------------------");
            $display("  [SAIDAS CALCULADAS]");
            $display("    Delta = %d (HEX: 0x%h)", $signed(uut.delta), uut.delta);
            $display("    Y     = %d (HEX: 0x%h)", $signed(uut.y), uut.y);
            $display("    X1    = %d (HEX: 0x%h)", $signed(uut.x1), uut.x1);
            $display("    X2    = %d (HEX: 0x%h)", $signed(uut.x2), uut.x2);
            $display("==================================================\n");
        end
    endtask

    // Processo Estímulo Principal
    initial begin
        // 1. Inicialização dos Sinais
        clk   = 0;
        reset = 0; // Active-Low: 0 = reseta na FPGA (início)
        botao = 1; // Botão Solto
        sw    = 8'h00;
        sel   = 2'b00;

        // Mantém reset mantido por 10 ciclos de clock
        repeat (10) @(posedge clk);
        reset = 1; // Libera o Reset na FPGA (1 = ativo/operação normal)
        repeat (5)  @(posedge clk);

        $display("\n==================================================");
        $display("   INICIANDO GRAVACAO DOS REGS (a, b, c)");
        $display("==================================================");

        // 2. Grava 'a' = -1 (8'hFF em Compl. de 2)
        sw = 8'd255;
        $display("[%0t ns] Configurando SW para 'a' = -1 (0xFF)", $time);
        pulsar_botao();

        // 3. Grava 'b' = -10 (8'hF6 em Compl. de 2)
        sw = 8'd246;
        $display("[%0t ns] Configurando SW para 'b' = -10 (0xF6)", $time);
        pulsar_botao();

        // 4. Grava 'c' = -3 (8'hFD em Compl. de 2)
        sw = 8'd253;
        $display("[%0t ns] Configurando SW para 'c' = -3 (0xFD)", $time);
        pulsar_botao();

        $display("\n==================================================");
        $display("   LEITURA DOS RESULTADOS BRUTOS");
        $display("==================================================");

        // Define x = -2 (8'hFE em Compl. de 2)
        sw = 8'd254;
        $display("[%0t ns] Ajustando entrada SW (x) = -2 (0xFE)", $time);
        
        // Aguarda a propagação da lógica combinacional interna (10 ciclos de clock)
        repeat (10) @(posedge clk);

        // Exibe os valores computados
        exibir_valores_brutos();

        #50;
        $finish;
    end

endmodule