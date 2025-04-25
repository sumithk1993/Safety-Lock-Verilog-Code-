//---------------------------------------------------------------
//
//Author          : Sumith Kumarage 
//Create Date     : 17th March 2025
//Design Name     : P2S_converter_tb
//File Name       : P2S_converter_tb.sv 
//Description     : Verilog Implementation of a parallel to serial converter 
//
//---------------------------------------------------------------

`timescale 1ns/10ps
module p2s_tb;
	logic clk = 0, rstn = 0;
	localparam CLK_PERIOD = 10;

	initial forever
	#(CLK_PERIOD/2)
	clk <= ~clk;

	parameter N = 4;
	logic [N-1:0] par_data;
	logic par_valid=0, par_ready, ser_data, ser_valid, ser_ready;

	P2S_converter #(.N(N)) dut (.*);

	initial begin
	$dumpfile("dump.vcd");
	$dumpvars;

	@(posedge clk); #1 rstn <= 0;
	@(posedge clk); #1 rstn <= 1;
	@(posedge clk) #1 par_data <= 4'd7 ; par_valid <= 0; ser_ready <= 1;

	#(CLK_PERIOD*3)
	@(posedge clk) #1 par_data <= 4'd11; par_valid <= 1;
	@(posedge clk) #1 par_valid <= 0;

	#(CLK_PERIOD*10)
	@(posedge clk) #1 par_data <= 4'd14; par_valid <= 1;
	@(posedge clk) #1 par_valid <= 0;
	@(posedge clk) #1 ser_ready <= 0;

	#(CLK_PERIOD*3)
	@(posedge clk) #1 ser_ready <= 1;
	#(CLK_PERIOD*10)

	@(posedge clk) #1 ser_ready <= 0;

	$finish();
	end
endmodule
