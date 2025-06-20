//---------------------------------------------------------------
//
//Author          : Sumith Kumarage 
//Create Date     : 18th March 2025
//Design Name     : FSM
//File Name       : Mealy_FSM.sv 
//Description     : Verilog Implementation of mealy FSM
//
//---------------------------------------------------------------

module FSM ( 
    input logic clk, rstn, ser_valid, ser_data,
    output logic output_valid, out
);

   typedef enum logic [1:0] {
      IDLE   = 2'b00,
      STATEA = 2'b01,
      STATEB = 2'b10,
      STATEC = 2'b11
   } state_t;

   state_t current_state, next_state;
   logic incr_pswd_detected;

    // State transition logic
    always_ff @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            current_state <= IDLE;
			incr_pswd_detected <= 1'b0;
        end else begin
            current_state <= next_state;
            if (output_valid ==  1'b1 && out != 1'b1)
		       incr_pswd_detected <= 1'b1;
		    if (!ser_valid)
		       incr_pswd_detected <= 1'b0;
        end 
       // end
    end

    // Next state logic and output
    always_comb begin
        next_state = current_state;
        output_valid = 1'b0;    
        out = 1'b0;

        case (current_state)
            IDLE: begin
                if (ser_valid && ser_data && !incr_pswd_detected) begin
                    next_state = STATEA;
                    output_valid = 1'b0;
                    out = 1'b0;
				
                end
                else if (ser_valid && !ser_data && !incr_pswd_detected) begin
                    next_state = IDLE;
                    output_valid = 1'b1;
                    out = 1'b0;
				
                end
                else begin 
                    next_state = IDLE;
                    output_valid = 1'b0;
                    out = 1'b0;
				
                end 
            end
            STATEA: begin
                if (ser_valid && ser_data) begin
                    next_state = IDLE;
                    output_valid = 1'b1;
                    out = 1'b0;
				
                 end
                else if (ser_valid && !ser_data) begin
                    next_state = STATEB;
                    output_valid = 1'b0;
                    out = 1'b0;
				
                end
                else begin 
                    next_state = STATEA;
                    output_valid = 1'b0;
                    out = 1'b0;
				
                end 
            end

            STATEB : begin
                if (ser_valid && ser_data) begin
                    next_state = STATEC;
                    output_valid = 1'b0;
                    out = 1'b0;
				
                end
                else if (ser_valid && !ser_data) begin
                    next_state = IDLE;
                    output_valid = 1'b1;
                    out = 1'b0;
				
                    end
                else begin 
                    next_state = STATEB;
                    output_valid = 1'b0;
                    out = 1'b0;
				
                    end 
            end

            STATEC: begin
                if (ser_valid && ser_data) begin
                    next_state = IDLE;
                    output_valid = 1'b0;
                    out = 1'b1;
			
                end
                else if (ser_valid && !ser_data) begin
                    next_state = IDLE;
                    output_valid = 1'b1;
                    out = 1'b0;
				
                end
                else begin 
                    next_state = STATEC;
                    output_valid = 1'b0;
                    out = 1'b0;
				
                end 
            end
        endcase
    end 

endmodule
