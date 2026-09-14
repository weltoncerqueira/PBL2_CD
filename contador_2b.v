
module contador_2b_ComPausa (
    input  clk,
    input  rst,
    input  b,    //botão fisico
    output [1:0] cont
);

    wire not_q1, not_q0, q1_and_q0, not_q1_and_q0;
	 wire not_q1_and_q0_full;
    wire T0, T1;
	 
    not (not_q1, cont[1]);
    not (not_q0, cont[0]);

    // T0 = b & ~(q1 & q0)
    and (q1_and_q0, cont[1], cont[0]);
    not (not_q1_and_q0_full, q1_and_q0);
    and (T0, b, not_q1_and_q0_full);

    // T1 = b & ~q1 & q0
    and (not_q1_and_q0, not_q1, cont[0]);
    and (T1, b, not_q1_and_q0);
	 

	//flip flops do contador
    ff_T FFT0 (
        .t(T0),
        .clk(clk),
        .rst(rst),
        .q(cont[0])
    );

    ff_T FFT1 (
        .t(T1),
        .clk(clk),
        .rst(rst),
        .q(cont[1])
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




