//---------------------------------------------------------------
//
//Author          : Sumith Kumarage 
//Create Date     : 18th March 2025
//Design Name     : top
//File Name       : top.sv 
//Description     : Verilog Implementation of a top module 
//
//---------------------------------------------------------------

module top (
    input logic clk, rstn, par_valid,
    input logic [3:0] par_data,
    output logic out, output_valid, par_ready

);
    logic  ser_data, ser_valid ;


P2S_converter #(.N(4)) INST1 (
    .clk(clk),
    .rstn(rstn),
    .par_valid(par_valid),
    .par_data(par_data),
    .ser_ready(!out),
    .par_ready(par_ready),
    .ser_valid(ser_valid),
    .ser_data(ser_data)
);

FSM INST2 (
    .clk(clk),
    .rstn(rstn),
    .ser_valid(ser_valid),
    .ser_data(ser_data),
    .output_valid(output_valid),
    .out(out)
);

endmodule
