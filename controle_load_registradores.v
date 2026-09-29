
module controle_load_registradores (
    input        clk,
    input        reset,
    input        botao,     
    input  [7:0] sw,      

    output [7:0] reg_a,
    output [7:0] reg_b,
    output [7:0] reg_c,
	 
	 output led0, led1, led2
	 
	);
	 
    wire [1:0] count;
    wire sel_a, sel_b, sel_c;
    wire botao_pulse; 
	 
	 wire rst_interno;
	 not (rst_interno, reset);
	 
	 // saida dos leds para teste
	 assign led0 = sel_a;
	 assign led1 = sel_b;
	 assign led2 = sel_c;
	 
	 // captura um pulso único do botão
    detector_de_borda borda_1 (
        .clk(clk),
        .rst(rst_interno),
        .sinal(botao),
        .pulso(botao_pulse)
    );

	 // Conta até 3, com base em cada pulso do botao
    contador_2b contComPausa (
        .pulso(botao_pulse),    
        .clk(clk),
        .rst(rst_interno),
        .Q1(count[0]),
		  .Q2(count[1])
    );
	 
	 // Decodifica o contador para escolher qual registrador receberá o valor das chaves
    decoder_abc abc (
        .key_pulse(botao_pulse),
        .count(count), 
        .sel_a(sel_a), 
        .sel_b(sel_b), 
        .sel_c(sel_c)
    );
	 
	 // registradores
    registrador_8b reg8_a (.D(sw), .enable(sel_a), .rst(rst_interno), .clk(clk), .S(reg_a));
    registrador_8b reg8_b (.D(sw), .enable(sel_b), .rst(rst_interno), .clk(clk), .S(reg_b));
    registrador_8b reg8_c (.D(sw), .enable(sel_c), .rst(rst_interno), .clk(clk), .S(reg_c));

endmodule


//registrador_8b.v
module registrador_8b (
    input        clk,
    input        rst,
    input        enable,
    input  [7:0] D,
    output [7:0] S
);

    wire [7:0] mux_out;
    wire [7:0] Q;

    mux_2x1 MUX0 (.A(Q[0]), .B(D[0]), .S(enable), .Y(mux_out[0]));
    ff_D     FF0  (.D(mux_out[0]), .clk(clk), .reset(rst), .Q(Q[0]));

    mux_2x1 MUX1 (.A(Q[1]), .B(D[1]), .S(enable), .Y(mux_out[1]));
    ff_D     FF1  (.D(mux_out[1]), .clk(clk), .reset(rst), .Q(Q[1]));

    mux_2x1 MUX2 (.A(Q[2]), .B(D[2]), .S(enable), .Y(mux_out[2]));
    ff_D     FF2  (.D(mux_out[2]), .clk(clk), .reset(rst), .Q(Q[2]));

    mux_2x1 MUX3 (.A(Q[3]), .B(D[3]), .S(enable), .Y(mux_out[3]));
    ff_D     FF3  (.D(mux_out[3]), .clk(clk), .reset(rst), .Q(Q[3]));

    mux_2x1 MUX4 (.A(Q[4]), .B(D[4]), .S(enable), .Y(mux_out[4]));
    ff_D     FF4  (.D(mux_out[4]), .clk(clk), .reset(rst), .Q(Q[4]));

    mux_2x1 MUX5 (.A(Q[5]), .B(D[5]), .S(enable), .Y(mux_out[5]));
    ff_D     FF5  (.D(mux_out[5]), .clk(clk), .reset(rst), .Q(Q[5]));

    mux_2x1 MUX6 (.A(Q[6]), .B(D[6]), .S(enable), .Y(mux_out[6]));
    ff_D     FF6  (.D(mux_out[6]), .clk(clk), .reset(rst), .Q(Q[6]));

    mux_2x1 MUX7 (.A(Q[7]), .B(D[7]), .S(enable), .Y(mux_out[7]));
    ff_D     FF7  (.D(mux_out[7]), .clk(clk), .reset(rst), .Q(Q[7]));

    buf (S[0], Q[0]);
	 buf (S[1], Q[1]);
	 buf (S[2], Q[2]);
	 buf (S[3], Q[3]);
	 buf (S[4], Q[4]);
	 buf (S[5], Q[5]);
	 buf (S[6], Q[6]);
	 buf (S[7], Q[7]);
	 
endmodule


//decoder_abc.v
module decoder_abc (
    input key_pulse,
    input [1:0] count,
    output sel_a, sel_b, sel_c
);
    wire countN0, countN1;

    not (countN0, count[0]);
    not (countN1, count[1]);

    // (count = 00)
    and (sel_a, key_pulse, countN1, countN0);

    // (count = 01)
    and (sel_b, key_pulse, countN1, count[0]);

    // (count = 10)
    and (sel_c, key_pulse, count[1], countN0);

    // count = 11 → nenhuma saída ativa (travado), implícito
endmodule


// Módulo: detector_de_borda
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


// FPGA projects using Verilog/ VHDL 
// fpga4student.com
// Verilog code for D Flip FLop
// Verilog code for Rising edge D flip flop with Asynchronous Reset high
module ff_D(D, clk, reset, Q);
input D; 
input clk;  
input reset; 
output reg Q; 

	always @(posedge clk) 
	  begin
        if (reset)
            Q <= 1'b0;
        else
            Q <= D;
     end
	  
endmodule 
