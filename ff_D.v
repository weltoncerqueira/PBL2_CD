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
