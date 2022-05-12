module Cordic(input wire [12:0] I,
	          input wire [12:0] Q,
	          input wire        Cordic_Enable,
	          input wire        CLK,
	          input wire        RESET,

	          output reg [12:0] PM,
	          output reg [12:0] AM,
	          output reg        Cordic_Ready);

parameter theta1 = 18'b000110010010000111;  //45/180*pi
parameter theta2 = 18'b000011101101011000;  //26.565052/180*pi
parameter theta3 = 18'b000001111101011011;
parameter theta4 = 18'b000000111111101010;
parameter theta5 = 18'b000000011111111101;
parameter theta6 = 18'b000000001111111111;
parameter theta7 = 18'b000000000111111111;
parameter theta8 = 18'b000000000011111111;
parameter theta9 = 18'b000000000001111111;
parameter theta10 = 18'b000000000001000000;
parameter theta11 = 18'b000000000000100000;
parameter theta12 = 18'b000000000000001111;
parameter theta13 = 18'b000000000000000111; 

reg signed [17:0] x;
reg signed [17:0] y;
reg [3:0]  i;
reg [17:0] theta;

always @(posedge CLK or posedge RESET) begin
	if (RESET) begin
		x <= 0;
		y <= 0;
		theta <= 0;		
	end
	else begin
		if (Cordic_Enable == 1) begin
			x <= {I[12:0],5'b0};
			y <= {Q[12:0],5'b0};
			theta <= 0;
		end
		else begin
		if (i>12) begin
			x <= x;
			y <= y;
			theta <= theta;
		end
		else begin
			if (y<0) begin
				x <= x - (y>>>i);
				y <= y + (x>>>i);
				case (i)
				0:theta <= theta-theta1;
                1:theta <= theta-theta2;
                2:theta <= theta-theta3;
                3:theta <= theta-theta4;
                4:theta <= theta-theta5;
                5:theta <= theta-theta6;
                6:theta <= theta-theta7;
                7:theta <= theta-theta8;
                8:theta <= theta-theta9;
                9:theta <= theta-theta10;
                10:theta <= theta-theta11;
                11:theta <= theta-theta12;
                12:theta <= theta-theta13;
                default: theta <= theta;
                endcase
			end
			else begin
				x <= x + (y>>>i);
				y <= y - (x>>>i);
				case (i)
				0:theta <= theta+theta1;
                1:theta <= theta+theta2;
                2:theta <= theta+theta3;
                3:theta <= theta+theta4;
                4:theta <= theta+theta5;
                5:theta <= theta+theta6;
                6:theta <= theta+theta7;
                7:theta <= theta+theta8;
                8:theta <= theta+theta9;
                9:theta <= theta+theta10;
                10:theta <= theta+theta11;
                11:theta <= theta+theta12;
                12:theta <= theta+theta13;
                default: theta <= theta;
                endcase
			end
		end
		end
	end
end

always @(posedge CLK or posedge RESET) begin
	if (RESET) begin
		i  <= 0;
		PM <= 0;
		AM <= 0;
		Cordic_Ready <= 0;
	end
	else begin
		if (Cordic_Enable ==1) begin
			i  <= 0;
		    PM <= 0;
		    AM <= 0;
		    Cordic_Ready <= 0;
		end
		else begin
			if (i == 4'd13) begin
			i <= i;
            PM <= theta[17:5];
            AM <= ((x[17:5]>>1)+(x[17:5]>>4)+(x[17:5]>>5)+(x[17:5]>>7)+(x[17:5]>>8)+(x[17:5]>>10)+(x[17:5]>>11)+(x[17:5]>>12))>>1; 
            Cordic_Ready <= 1;
            end
            else i <= i + 1;
		end
	end
end

endmodule
