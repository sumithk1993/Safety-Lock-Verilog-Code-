//---------------------------------------------------------------
//
//Author          : Sumith Kumarage 
//Create Date     : 18th March 2025
//Design Name     : FSM_tb
//File Name       : FSM_tb.sv 
//Description     : Verilog testbench implementation of FSM module 
//
//---------------------------------------------------------------
module FSM_tb;

    // Testbench signals
    logic clk, rstn;
    logic ser_valid, ser_data;
    logic output_valid, out;

    // Instantiate the FSM module
    FSM dut (
        .clk(clk),
        .rstn(rstn),
        .ser_valid(ser_valid),
        .ser_data(ser_data),
        .output_valid(output_valid),
        .out(out)
    );

    // Clock generation
    always #5 clk = ~clk; // 10ns clock period (100MHz)

    // Task to send a serial input sequence
    task send_sequence(input logic [3:0] seq);
        integer i;
        for (i = 3; i >= 0; i--) begin
            ser_valid = 1;
            ser_data  = seq[i];
            #10; // Wait one clock cycle
        end
        ser_valid = 0;
        #20; // Wait for FSM to settle
    endtask

    // Testbench process
    initial begin
        $dumpfile("FSM_tb.vcd"); // Enable waveform dumping
        $dumpvars(0, FSM_tb);

        // Initialize signals
        clk = 0;
        rstn = 0;
        ser_valid = 0;
        ser_data = 0;

        // Apply reset
        #20 rstn = 1; // Deassert reset after 20ns

        // Test Invalid sequence: 1 -> 1 -> 0 -> 1 (Incorrect output expected)
        $display("Testing Invalid Sequence: 1101");
        send_sequence(4'b1101);
        #50;

        // Test valid sequence: 1 -> 0 -> 1 -> 1 (Correct output expected)
        $display("Testing valid Sequence: 1011");
        send_sequence(4'b1011);
        #50;

        // Test another invalid sequence: 0 -> 1 -> 1 -> 0 (Incorrect output expected)
        $display("Testing Invalid Sequence: 0110");
        send_sequence(4'b0110);
        #50;

        // End simulation
        $display("Testbench complete.");
        $finish;
    end

endmodule
