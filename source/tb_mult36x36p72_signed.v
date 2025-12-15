
`timescale 1ns/1ps

module tb;

GSRA GSR_INST  (.GSR_N(1'b1));

  //============================================================
  // パラメータ
  //============================================================
  parameter RAND_TESTS  = 1000;
  parameter CLK_HALF    = 5;   

  //============================================================
  // クロック・リセット
  //============================================================
  reg clk = 1'b0;
  reg rst_n = 1'b0;
  always #(CLK_HALF) clk = ~clk;
initial begin
    rst_n = 1'b0;
    repeat (5) @(posedge clk);
    rst_n = 1'b1;
    repeat (2) @(posedge clk);
end

  //============================================================
  // DUT I/O
  //============================================================
  reg  signed [35:0] A;
  reg  signed [35:0] B;
  reg  signed [71:0] C;
  wire signed [72:0] result;     // 73-bit signed 出力

  //============================================================
  // DUT インスタンス（あなたの実装に合わせて調整）
  //============================================================
  mult36x36p72_signed dut (
    .A     (A),
    .B     (B),
    .C     (C),
    .result(result)
  );

  //============================================================
  // golden result
  //============================================================
  function [72:0] golden_mac;
    input signed [35:0] a;
    input signed [35:0] b;
    input signed [71:0] c;
    reg   signed [71:0] prod72;
    reg   signed [72:0] sum73;
  begin
    prod72 = a * b;                               // 72b signed
    sum73  = {prod72[71], prod72} + {c[71], c};
    golden_mac = sum73;
  end
  endfunction
  wire signed [72:0] g = golden_mac(A,B,C);

reg [15:0] test_cnt;
always @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		A	<=	36'sd0;
		B	<=	36'sd0;
		C	<=	72'sd0;
		test_cnt<=	0;
	end
	else if(test_cnt==0) begin
		A <= -36'sd1;
		B <= -36'sd1;
		C <= 72'sd0;
		test_cnt <= test_cnt + 1;
	end
	else if(test_cnt==1) begin
		A <= 36'sh7FFFFFFFF;
		B <= 36'sh7FFFFFFFF;
		C <= 72'sd0;
		test_cnt <= test_cnt + 1;
	end
	else if(test_cnt==2) begin
		A <= 36'sh800000000;
		B <= 36'sh800000000;
		C <= 72'sd0;
		test_cnt <= test_cnt + 1;
	end
	else if(test_cnt==3) begin
		A <= 36'sh7FFFFFFFF;
		B <= 36'sh7FFFFFFFF;
		C <= 72'shFFFFFFFFFFFFFFFFFFFF;
		test_cnt <= test_cnt + 1;
	end
	else if(test_cnt<RAND_TESTS) begin
		A[31: 0] = $random;
		A[35:32] = $random;
		B[31: 0] = $random;
		B[35:32] = $random;
		C[31: 0] = $random;
		C[63:32] = $random;
		C[72:64] = $random;
		test_cnt <= test_cnt + 1;
	end
	else begin
		$stop;
	end
end
always @(posedge clk) begin
	if(result != g) begin
		$display("ERROR: A=%h B=%h C=%h", A, B, C);
		$display("       result from dut = %h", result);
		$display("       result golden   = %h", g);
		$stop;
	end
	else begin
		// $display("OK   : A=%h B=%h C=%h", A, B, C);
		// $display("       result from dut = %h", result);
		// $display("       result golden   = %h", g);
	end
end


endmodule

