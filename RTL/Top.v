`include "Cordic.v"
`include "Control.v"

module Top(
	input wire CLK,
	input wire RESET, 
	input wire [12:0]Data_in,
	input wire Enable,
	input wire IN_N_OUT,

	output wire [12:0]Data_out,
	output wire Data_Ready
	);
  
	wire [12:0] I;
	wire [12:0] Q;
	wire [12:0] PM;
	wire [12:0] AM;
	wire Cordic_Enable,Cordic_Ready;
  
Control control1(.IN_N_OUT(IN_N_OUT),.Data_Ready(Data_Ready),.Enable(Enable),.Data_in(Data_in),.Data_out(Data_out),.CLK(CLK),.RESET(RESET),.PM(PM),.AM(AM),.Cordic_Ready(Cordic_Ready),.Cordic_Enable(Cordic_Enable),.I(I),.Q(Q));
Cordic cordic1(.I(I),.Q(Q),.Cordic_Enable(Cordic_Enable),.CLK(CLK),.RESET(RESET),.PM(PM),.AM(AM),.Cordic_Ready(Cordic_Ready));
  
endmodule
