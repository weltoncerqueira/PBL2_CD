// ============================================================================
// Módulo: debounce
// Descrição: Módulo principal do filtro de debounce. Recebe o sinal bruto de 
//            um botão físico, sincroniza o sinal com o relógio do sistema para
//            evitar metaestabilidade, aguarda a estabilização da entrada por 
//            um determinado tempo (através de um contador de 19 bits) e atualiza 
//            a saída apenas quando o valor do botão permanece constante.
// ============================================================================
module debounce (
    input clk,
    input rst,
    input botao,
    output botao_debounced
);

    wire sync;
    wire estado;
    wire mudou;

    wire [18:0] cont;
    wire contador_cheio;


    // -------------------------
    // Sincronizador
    // -------------------------

    sincronizador_2ff sincronizador (
        .clk(clk),
        .rst(rst),
        .botao(botao),
        .sync(sync)
    );


    // -------------------------
    // Detecta mudança
    // -------------------------

    xor (mudou, sync, estado);


    // -------------------------
    // Contador
    // -------------------------

    contador_debounce_19b contador (
        .clk(clk),
        .rst(rst),
        .mudou(mudou),
        .cont(cont)
    );


    // -------------------------
    // Detecta contador cheio (todos os 19 bits em 1)
    // -------------------------

    and (contador_cheio, cont[0],  cont[1],  cont[2],  cont[3],  cont[4],
                         cont[5],  cont[6],  cont[7],  cont[8],  cont[9],
                         cont[10], cont[11], cont[12], cont[13], cont[14],
                         cont[15], cont[16], cont[17], cont[18]);


    // -------------------------
    // Atualiza estado estável
    // -------------------------

    estado_botao estado_ff (
        .clk(clk),
        .rst(rst),
        .D(sync),
        .load(contador_cheio),
        .Q(estado)
    );

	 // Atualiza a saida com o novo estado
	 buf (botao_debounced, estado);

endmodule


// ============================================================================
// Módulo: sincronizador_2ff
// Descrição: Sincronizador de 2 Flip-Flops tipo D em cascata. É usado para 
//            evitar o fenômeno da metaestabilidade ao ler sinais assíncronos 
//            externos (como botões físicos) para dentro do domínio de relógio 
//            da FPGA.
// ============================================================================
module sincronizador_2ff (
    input clk,
    input rst,
    input botao,
    output sync
);

    wire q1;

    ff_D FF1 (
        .D(botao),
        .clk(clk),
        .reset(rst),
        .Q(q1)
    );

    ff_D FF2 (
        .D(q1),
        .clk(clk),
        .reset(rst),
        .Q(sync)
    );

endmodule


// ============================================================================
// Módulo: estado_botao
// Descrição: Registrador com habilitação (load) para armazenar o estado estável
//            do botão. Utiliza um MUX 2:1 ligado a um Flip-Flop D para manter 
//            o valor anterior (Q) até que o sinal 'load' (contador cheio) seja 
//            acionado, atualizando a saída com o novo estado sincronizado.
// ============================================================================
module estado_botao (
    input clk,
    input rst,
    input D,
    input load,
    output Q
);

    wire D_mux;

    mux21_1b MUX (
        .A(Q),
        .B(D),
        .S(load),
        .Y(D_mux)
    );

    ff_D FF (
        .D(D_mux),
        .clk(clk),
        .reset(rst),
        .Q(Q)
    );

endmodule


// ============================================================================
// Módulo: contador_debounce_19b
// Descrição: Contador sequencial de 19 bits estruturado a partir de Flip-Flops 
//            tipo T e lógica de "carry chain". O contador incrementa a cada 
//            ciclo enquanto o sinal 'mudou' for verdadeiro. Caso ocorra qualquer 
//            ruído e 'mudou' vá a 0, o contador é resetado para garantir que a 
//            contagem só atinja o topo após um período contínuo e estável.
// ============================================================================
module contador_debounce_19b (
    input  clk,
    input  rst,
    input  mudou,
    output [18:0] cont
);

    wire [18:0] T;
    wire        reset_cont;

    assign reset_cont = rst | ~mudou;

    // T[0] = mudou  (igual ao T0 do contador_debounce_2b)
    buf (T[0], mudou);

    // T[i] = mudou & cont[0] & cont[1] & ... & cont[i-1]
    genvar i;
    generate
        for (i = 1; i < 19; i = i + 1) begin : carry_chain
            and (T[i], T[i-1], cont[i-1]);
        end
    endgenerate

    genvar j;
    generate
        for (j = 0; j < 19; j = j + 1) begin : ff_bank
            ff_T FFT (
                .t(T[j]),
                .clk(clk),
                .rst(reset_cont),
                .q(cont[j])
            );
        end
    endgenerate

endmodule


// ============================================================================
// Módulo: edge_detect
// Descrição: Detector de borda de descida (1 -> 0). Com base na convenção de 
//            botões ativos em nível baixo (como os botões KEY da DE10-Lite), 
//            este módulo compara o sinal atual com a versão atrasada em 1 ciclo 
//            para gerar um pulso único de duração exata de 1 ciclo de clock no 
//            momento em que o botão é pressionado.
// ============================================================================
module edge_detect (
    input  clk,
    input  rst,
    input  sinal_estavel,   // 1 = solto, 0 = pressionado (convenção KEY da DE10-Lite)
    output pulso
);

    wire sinal_atrasado;
    wire not_estavel;

    ff_D FF_ATRASO (
        .D(sinal_estavel),
        .clk(clk),
        .reset(rst),
        .Q(sinal_atrasado)
    );

    // pulso na transição 1 -> 0 (solto -> pressionado)
    not (not_estavel, sinal_estavel);
    and (pulso, sinal_atrasado, not_estavel);

endmodule
