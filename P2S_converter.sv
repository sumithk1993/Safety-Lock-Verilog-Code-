//---------------------------------------------------------------
//
//Author          : Sumith Kumarage 
//Create Date     : 17th March 2025
//Design Name     : P2S_converter
//File Name       : P2S_converter.sv 
//Description     : Verilog Implementation of a parallel to serial converter 
//
//---------------------------------------------------------------

module P2S_converter #(N = 4) (
  input logic clk, rstn, par_valid, ser_ready,
  input logic [N-1:0] par_data,
  output logic par_ready, ser_data, ser_valid
  
); //module parallel to serial converter 

  
  localparam N_BITS = $clog2(N);
  enum logic {RX=0 , TX=1} next_state, state;
  logic [N_BITS-1:0] count; //count_signal
  logic [N-1:0] shift_reg;  //shift register 
  
  always_comb unique case(state)
    RX: next_state = (par_valid) ? TX: RX ;
    TX: next_state = (count == N -1) && (ser_ready) ? RX: TX ;
  endcase
  
  always_ff @(posedge clk or negedge rstn)
    state <= !rstn ? RX : next_state;
  
  assign ser_data  = shift_reg[N-1];
  assign par_ready = (state == RX);
  assign ser_valid = (state == TX);
  
  always_ff @(posedge clk or negedge rstn)
    if (!rstn) count <= 1'b0;
    else unique case(state)
        RX: begin
    			shift_reg <= par_data;
                count     <= 1'b0;         
             end
        TX: if (ser_ready) begin
                shift_reg <= shift_reg << 1;
                count     <= count + 1'd1;
            end 
      endcase
endmodule 
