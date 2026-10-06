
module contador_2b (
    input  clk,
    input  rst,
    input  pulso,
    output [1:0] Q,
	 output [1:0] S
	 
);

    wire parar, Nparar;   
    wire habilita;
    wire T1;
	 
	 not (Nparar, parar);
	 
    and (parar, Q[0], Q[1]);
	 and (habilita, pulso, Nparar);
	

    ff_T FFT0 (
        .t(habilita),
        .clk(clk),
        .rst(rst),
        .q(Q[0])
    );

    and (T1, habilita, Q[0]);

    ff_T FFT1 (
        .t(T1),
        .clk(clk),
        .rst(rst),
        .q(Q[1])
    );
	 

	wire habilita_sel, TS1;
	
	// só conta depois de carregar a,b,c
	and (habilita_sel, pulso, parar);   

	ff_T FFS0 (
		.t(habilita_sel), 
		.clk(clk), 
		.rst(rst), 
		.q(S[0])
	);

	and (TS1, habilita_sel, S[0]);
	
	ff_T FFS1 (
		.t(TS1), 
		.clk(clk), 
		.rst(rst), 
		.q(S[1])
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




