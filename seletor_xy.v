

module seletor_xy (
    input  [7:0] x1, 
	 input  [7:0] x2, 
	 input  [7:0] x, 
	 input  [7:0] y,
	 input  [1:0] sel,
    output [7:0] s
	 
    );
	 
    // seletor 00 = x
    // seletor 01 = y
    // seletor 10 = x1		
    // seletor 11 = x2
    
    mux_4x1_antigo_1bit mux1 (.a(x[0]), .b(y[0]), .c(x1[0]), .d(x2[0]), .sel(sel), .S(s[0]));
    mux_4x1_antigo_1bit mux2 (.a(x[1]), .b(y[1]), .c(x1[1]), .d(x2[1]), .sel(sel), .S(s[1]));
    mux_4x1_antigo_1bit mux3 (.a(x[2]), .b(y[2]), .c(x1[2]), .d(x2[2]), .sel(sel), .S(s[2]));
    mux_4x1_antigo_1bit mux4 (.a(x[3]), .b(y[3]), .c(x1[3]), .d(x2[3]), .sel(sel), .S(s[3]));
    mux_4x1_antigo_1bit mux5 (.a(x[4]), .b(y[4]), .c(x1[4]), .d(x2[4]), .sel(sel), .S(s[4]));
    mux_4x1_antigo_1bit mux6 (.a(x[5]), .b(y[5]), .c(x1[5]), .d(x2[5]), .sel(sel), .S(s[5]));
    mux_4x1_antigo_1bit mux7 (.a(x[6]), .b(y[6]), .c(x1[6]), .d(x2[6]), .sel(sel), .S(s[6]));
    mux_4x1_antigo_1bit mux8 (.a(x[7]), .b(y[7]), .c(x1[7]), .d(x2[7]), .sel(sel), .S(s[7]));

endmodule


module mux_4x1 (
    input  [6:0] a,
    input  [6:0] b,
    input  [6:0] c,
    input  [6:0] d,
    input  [1:0] sel,
    output reg [6:0] S
);

    always @(*) begin
        case (sel)
            2'b00:   S = a; // Seleciona X
            2'b01:   S = b; // Seleciona Y
            2'b10:   S = c; // Seleciona X1
            2'b11:   S = d; // Seleciona X2
            default: S = 7'b111_1111; // Display apagado (Anodo comum)
        endcase
    end

endmodule



/*

module mux_4x1 (
    input  [6:0] a,
    input  [6:0] b,
    input  [6:0] c,
    input  [6:0] d,
    input  [1:0] sel,
    output [6:0] S
);

    wire nsel0, nsel1;
    wire sel_a_1b, sel_b_1b, sel_c_1b, sel_d_1b;
    wire [6:0] var_a, var_b, var_c, var_d;

    not (nsel0, sel[0]);
    not (nsel1, sel[1]);

    // Decodificação de 1 bit
    and (sel_a_1b, nsel1, nsel0);
    and (sel_b_1b, nsel1, sel[0]);
    and (sel_c_1b, sel[1], nsel0);
    and (sel_d_1b, sel[1], sel[0]);

    // Mapeamento AND bit-a-bit aplicando a réplica do bit de seleção
    assign var_a = a & {7{sel_a_1b}};
    assign var_b = b & {7{sel_b_1b}};
    assign var_c = c & {7{sel_c_1b}};
    assign var_d = d & {7{sel_d_1b}};

    // Junção OR bit-a-bit
    assign S = var_a | var_b | var_c | var_d;

endmodule

*/


module mux_4x1_antigo_1bit (
    input  a,
    input  b,
    input  c,
    input  d,
    input  [1:0] sel,
    output S
);

    wire nsel0, nsel1;
    wire sel_a, sel_b, sel_c, sel_d;
    wire var_a, var_b, var_c, var_d;

    not (nsel0, sel[0]);
    not (nsel1, sel[1]);

    and (sel_a, nsel1, nsel0);      // sel = 00
    and (sel_b, nsel1, sel[0]);     // sel = 01
    and (sel_c, sel[1], nsel0);     // sel = 10
    and (sel_d, sel[1], sel[0]);    // sel = 11

    and (var_a, a, sel_a);
    and (var_b, b, sel_b);
    and (var_c, c, sel_c);
    and (var_d, d, sel_d);

    or (S, var_a, var_b, var_c, var_d);

endmodule


