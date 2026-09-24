
module contador_2b_ComPausa (
    input  clk,
    input  rst,
    input  pulso,    //botão fisico
    output Q1, 
	 output Q2
);

	wire T1;
	 
	//flip flops do contador
    ff_T FFT0 (
        .t(pulso),
        .clk(clk),
        .rst(rst),
        .q(Q1)
    );
	 
	 and (T1, pulso, Q1);

    ff_T FFT1 (
        .t(T1),
        .clk(clk),
        .rst(rst),
        .q(Q2)
    );

endmodule


module ff_T (
    input clk, rst,
    input t,
    output reg q
);
    always @(posedge clk) begin  // reset síncrono
        if (rst)                 // ativo-alto, igual ao resto do projeto
            q <= 1'b0;
        else if (t)
            q <= ~q;
    end
endmodule




