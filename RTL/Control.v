module Control(
	input wire CLK, RESET,
	input wire IN_N_OUT,
	input wire Enable,
	input wire [12:0] Data_in,
	input wire [12:0]PM,  //Polar Magnitude
	input wire [12:0]AM, // Amplitude Magnitude
	input wire Cordic_Ready,

	output reg [12:0] Data_out,
	output reg Data_Ready,
	output reg Cordic_Enable,
	output reg [12:0] I,
	output reg [12:0] Q);

parameter [2:0] 
         S0 = 3'b000,
         S1 = 3'b001,
         S2 = 3'b010,
         S3 = 3'b011,
         S4 = 3'b100,
         S5 = 3'b101;

reg [2:0] state_reg, state_next;

always@(posedge CLK or posedge RESET) begin
	if(RESET) begin
        state_reg <= S0;
        state_next <= S0;
	end
	else state_reg <= state_next;
end

always@(*) begin
	case (state_reg)
	S0: begin
        I <= 0;
		Q <= 0;
		Data_out <= 0;
		Data_Ready <= 0;
        Cordic_Enable <= 0;	
        if (Enable == 1&&IN_N_OUT == 0) begin
            I <= Data_in;
            state_next <= S1;	
        end
	end		
	S1: begin
		Q <= Data_in;
		state_next <= S2;		
	end
	S2: begin
	    state_next <= S3;
	    Cordic_Enable <= 1;
	end
	S3: begin
		Cordic_Enable <= 0;
		if (Cordic_Ready == 1&&IN_N_OUT == 1) begin
			Data_Ready <= 1;
			state_next <= S4;
		end
	end
	S4: begin
		Data_out <= PM;
		state_next <= S5;		
	end
	S5: begin
		Data_out <= AM;
		state_next <= S0;
	end
    endcase
end

endmodule
