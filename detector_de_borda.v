// ============================================================================
// Módulo: edge_detect
// Descrição: Detector de borda de descida (1 -> 0). Com base na convenção de 
//            botões ativos em nível baixo (como os botões KEY da DE10-Lite), 
//            este módulo compara o sinal atual com a versão atrasada em 1 ciclo 
//            para gerar um pulso único de duração exata de 1 ciclo de clock no 
//            momento em que o botão é pressionado.
// ============================================================================
module detector_de_borda (
    input  clk,
    input  rst,
    input  sinal,   // 1 = solto, 0 = pressionado (convenção KEY da DE10-Lite)
    output pulso
);

    wire sinal_anterior;
    wire not_anterior;

    ff_D FF_ATRASO (
        .D(sinal),
        .clk(clk),
        .reset(rst),
		  .Q(sinal_anterior)
    );

    // pulso na transição 1 -> 0 (solto -> pressionado)
    not (not_anterior, sinal_anterior);
    and (pulso, sinal_anterior, not_anterior);

endmodule
