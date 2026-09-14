
module mux21_1b (
	input  A, 
	input  B, 
	input  S,
	output Y
);

	wire S_and_A, S_and_B, Sn;
	
	not (Sn, S);
	
	// Y = (S & B) | (~S & A);

	and (S_and_A, Sn, A);
	and (S_and_B, S, B);
	
	or (Y, S_and_A, S_and_B);

endmodule
	