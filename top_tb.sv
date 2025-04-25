//---------------------------------------------------------------
//
//Author          : Sumith Kumarage 
//Create Date     : 18th March 2025
//Design Name     : top_tb
//File Name       : top_tb.sv 
//Description     : Verilog testbench implementation of top module  
//
//---------------------------------------------------------------


`timescale 1ns/10ps

module top_tb;

    logic clk, rstn, par_valid;
    logic [3:0] par_data;
    logic output_valid, out, par_ready;

    // Instantiate the DUT (Device Under Test)
    top dut (
        .clk(clk),
        .rstn(rstn),
        .par_valid(par_valid),
        .par_data(par_data),
        .output_valid(output_valid),
        .out(out),
		.par_ready(par_ready)
    );

    // Clock Generation: 10ns period (100 MHz)
    always #5 clk = ~clk;

    // Stimulus
    initial begin
        // Initialize signals
        clk = 0;
        rstn = 0;
        par_valid = 0;
        par_data = 4'b0000;

        // Reset pulse
        #20 rstn = 1;  

        // Test Case 1: Send valid parallel data (binary 1010)
        #10 par_valid = 1;
        par_data = 4'b1010;
        #10 par_valid = 0;

        // Wait for FSM processing
        #100;

        // Test Case 2: Send another pattern (binary 1101)
        #10 par_valid = 1;
        par_data = 4'b1101;
        #10 par_valid = 0;
		
        // Wait for FSM processing
		#100;
        // Test Case 2: Send another pattern (binary 1011)
        #10 par_valid = 1;
        par_data = 4'b1011;
        #10 par_valid = 0;

        // Wait and end simulation
        #100;
        $finish;
    end

    // Monitor outputs
   initial begin
       $monitor("Time: %0t | par_data: %b  | output_valid: %b | out: %b", 
                $time, par_data, output_valid, out);
    end

    // Dump waveform for debugging
    initial begin
        $dumpfile("top_tb.vcd");
        $dumpvars(0, top_tb);
    end

endmodule
