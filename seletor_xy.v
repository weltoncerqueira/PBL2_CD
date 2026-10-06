
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
    
    mux_4x1 mux1 (.a(x[0]), .b(y[0]), .c(x1[0]), .d(x2[0]), .sel(sel), .S(s[0]));
    mux_4x1 mux2 (.a(x[1]), .b(y[1]), .c(x1[1]), .d(x2[1]), .sel(sel), .S(s[1]));
    mux_4x1 mux3 (.a(x[2]), .b(y[2]), .c(x1[2]), .d(x2[2]), .sel(sel), .S(s[2]));
    mux_4x1 mux4 (.a(x[3]), .b(y[3]), .c(x1[3]), .d(x2[3]), .sel(sel), .S(s[3]));
    mux_4x1 mux5 (.a(x[4]), .b(y[4]), .c(x1[4]), .d(x2[4]), .sel(sel), .S(s[4]));
    mux_4x1 mux6 (.a(x[5]), .b(y[5]), .c(x1[5]), .d(x2[5]), .sel(sel), .S(s[5]));
    mux_4x1 mux7 (.a(x[6]), .b(y[6]), .c(x1[6]), .d(x2[6]), .sel(sel), .S(s[6]));
    mux_4x1 mux8 (.a(x[7]), .b(y[7]), .c(x1[7]), .d(x2[7]), .sel(sel), .S(s[7]));

endmodule


module mux_4x1 (
    input  wire a,
    input  wire b,
    input  wire c,
    input  wire d,
    input  wire [1:0] sel,
    output wire S
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


