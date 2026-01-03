
`timescale 1ns/1ps

module tb_mult36x36p72;

GSRA GSR_INST  (.GSR_N(1'b1));

  reg clk = 0;
  reg [3:0] rst_cnt = 1;
  wire resetn = rst_cnt[3];
  always #5 clk = ~clk;   // 100 MHz
  always @(posedge clk) if(!resetn) rst_cnt<=rst_cnt <<< 1;

  // Inputs
  reg signed [35:0] A;
  reg signed [35:0] B;
  reg signed [71:0] C;

  // Output
  wire [72:0] result;
  wire [71:0] result_m;

  mult36x36p72 uut (
    .A(A), 
    .B(B), 
    .C(C),
    .result(result)
  );

assign result_m = A * B;
wire [72:0] ref_result = {result_m[71],result_m[71:0]} + {C[71],C[71:0]};

reg [23:0] idx;
reg [31:0] randA;
reg [31:0] randB;
reg [31:0] randC;
always @(posedge clk or negedge resetn) begin
	if(!resetn) begin
		idx <= 0;
		randA <= 0;
		randB <= 0;
		randC <= 0;
	end
	else if(&idx) begin
		$stop;
	end
	else begin
		idx <= idx + 1;
		randA <= $random;
		randB <= $random;
		randC <= $random;
	end
end
always @(posedge clk or negedge resetn) begin
	if(!resetn) begin
		A <= 0;
		B <= 0;
		C <= 0;
	end
	else if(idx==0) begin
        // Test case 1: Positive * Positive
		A <= 36'hF_FFFF_FFFF;
		B <= 36'hF_FFFF_FFFF;
		C <= 72'h0;
	end
	else if(idx==1) begin
        // Test case 2: Negative * Positive
		A <= 36'h8_0000_0000;
		B <= 36'h8_0000_0000;
		C <= 72'h0;
	end
	else if(idx==2) begin
        // Test case 3: Positive * Negative
		A <= 36'h7_FFFF_FFFF;
		B <= 36'h7_FFFF_FFFF;
                C <= 72'hFF_FFFF_FFFF_FFFF_FFFF;
	end
	else if(idx==3) begin
        // Test case 4: Negative * Negative
                A <= -36'sd123456;
                B <= -36'sd654321;
                C <= 72'h0;
	end
	else if(idx==4) begin
        // Test case 5: Zero * Any
                A <= 36'sd0;
                B <= 36'sd654321;
                C <= 72'h0;
	end
	else if(idx==5) begin
        // Test case 6: Max * Max
                A <= 36'h7_FFFF_FFFF;
                B <= 36'h7_FFFF_FFFF;
                // A <= 36'hF_FFFF_FFFF; // 36'sd68719476735; // 2^35 - 1
                // B <= 36'hF_FFFF_FFFF; // 36'sd68719476735;
                //C <= 72'hFF_FFFF_FFFF_FFFF_FFFF;
                C <= 72'h0;
	end
	else if(idx==6) begin
        // Test case 7: Min * Min
                //A <= 36'h1;
                A <= 36'hF_FFFF_FFFF;
                B <= 36'h1;
                C <= 72'h0;
                //C <= 72'hFF_FFFF_FFFF_FFFF_FFFF;
	end
	else begin
		A <= {randA[31:0],randC[31:28]};
		B <= {randB[31:0],randA[31:28]};
		C <= {randC[31:0],randB[31: 0],randA[7:0]};
	end
end
always @(posedge clk ) begin
	if(ref_result != result) begin
            $display("%0t	%09x	%09x	%18x	%03x_%04x_%04x_%04x_%04x,	%02x_%04x_%04x_%04x_%04x", $time, A, B, C, result[72:64],result[63:48],result[47:32],result[31:16],result[15:0],
    	result_m[71:64],result_m[63:48],result_m[47:32],result_m[31:16],result_m[15:0]);
		$stop;
	end
end

  initial begin
    // Display header
    $display("Time		A	B		C	Result			Result_m");
  end

endmodule
