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

    wire Q1, Q2, Q1N;

    ff_D FF_Detector1 (
        .D(sinal),
        .clk(clk),
        .reset(rst),
		  .Q(Q1)
    );

    ff_D FF_Detector2 (
        .D(Q1),
        .clk(clk),
        .reset(rst),
		  .Q(Q2)
    );
	 
	 not (Q1N, Q1);
	 and (pulso, Q1N, Q2);
	
	 
endmodule
