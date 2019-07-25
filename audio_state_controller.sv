module audio_state_controller(input  logic       Clk,
						input  logic       Reset_h,
                        input  logic       INIT_FINISH,
                        output logic       INIT,
                        output logic       audio_operation);


enum logic  {init, regular} State, Next_State;

assign audio_operation = State;

always_ff @ (posedge Clk or posedge Reset_h)
	begin
		if (Reset_h) 
			State <= init;
		else 
			State <= Next_State;
	end

always_comb
	begin 
		// Default next state is staying at current state
		Next_State = State;
        INIT = 1'b0;

        //Assign next state
        unique case (State)
            init : if (INIT_FINISH) Next_State = regular;            
        endcase

        case (State)
            init : INIT = 1'b1;
			endcase
    end

endmodule