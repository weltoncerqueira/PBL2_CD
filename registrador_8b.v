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
