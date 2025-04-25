//---------------------------------------------------------------
//
//Author          : Sumith Kumarage 
//Create Date     : 18th March 2025
//Design Name     : FSM
//File Name       : Moore_FSM.sv 
//Description     : Verilog Implementation of moore FSM
//
//---------------------------------------------------------------

module FSM ( 
    input logic clk, rstn, ser_valid, ser_data,
    output logic output_valid, out
);

    localparam IDLE      = 3'b001;
    localparam STATE1    = 3'b010;
    localparam STATE2    = 3'b011;
    localparam STATE3    = 3'b100;
    localparam STATE4    = 3'b101;
    localparam INCORRECT = 3'b110;
    localparam CORRECT   = 3'b111;
    
    logic [2:0] state, next_state;
	logic incr_pswd_detected;

    always_ff @(posedge clk or negedge rstn)begin
        if (!rstn) begin
           state <= IDLE;
		   incr_pswd_detected <= 1'b0;
        end else begin
           state <= next_state;
		   if (state != INCORRECT && next_state == INCORRECT)
		       incr_pswd_detected <= 1'b1;
		   if (!ser_valid)
		       incr_pswd_detected <= 1'b0;
        end 
    end 

    always_comb unique case(state)
     IDLE : begin 
        if (ser_valid && !incr_pswd_detected) begin
            if (ser_data) begin
              next_state = STATE1;
            end else begin 
              next_state = INCORRECT;
            end
        end else begin 
          next_state = IDLE;
        end     
     end 
    
     STATE1 : begin 
        if (ser_valid) begin
            if (ser_data) begin
              next_state = INCORRECT;
            end else begin 
              next_state = STATE2;
            end
        end else begin 
          next_state = STATE1;
        end     
     end 

     STATE2 : begin 
        if (ser_valid) begin
            if (ser_data) begin
              next_state = STATE3;
            end else begin 
              next_state = INCORRECT;
            end
        end else begin 
          next_state = STATE2;
        end     
     end

     STATE3 : begin 
        if (ser_valid) begin
            if (ser_data) begin
              next_state = CORRECT;
            end else begin 
              next_state = INCORRECT;
            end
        end else begin 
          next_state = STATE3;
        end     
     end

     INCORRECT : next_state = IDLE;
     CORRECT : next_state = IDLE;

    endcase

 always_ff @(posedge clk or negedge rstn)begin
        if (!rstn)begin
          output_valid <= 1'b0 ;
          out          <= 1'b0 ;
        end else unique case (state)
          IDLE: begin 
            output_valid <= 1'b0 ;
            out          <= 1'b0 ;
          end

          STATE1: begin 
            output_valid <= 1'b0 ;
            out          <= 1'b0 ;
          end

          STATE2: begin
            output_valid <= 1'b0 ;
            out          <= 1'b0 ;
          end

          STATE3: begin 
            output_valid <= 1'b0 ;
            out          <= 1'b0 ;
          end

          INCORRECT: begin 
            output_valid <= 1'b1 ;
            out          <= 1'b0 ;
          end

          CORRECT: begin 
            output_valid <= 1'b0 ;
            out          <= 1'b1 ;
          end
           
        endcase 
    end 

endmodule  


