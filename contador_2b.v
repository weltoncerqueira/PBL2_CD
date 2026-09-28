
module contador_2b (
    input  clk,
    input  rst,
    input  pulso,
    output Q1,
    output Q2
);

    wire parar, Nparar;   
    wire habilita;
    wire T1;
	 
	 not (Nparar, parar);
	 
    and (parar, Q1, Q2);
	 and (habilita, pulso, Nparar);
	

    ff_T FFT0 (
        .t(habilita),
        .clk(clk),
        .rst(rst),
        .q(Q1)
    );

    and (T1, habilita, Q1);

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




