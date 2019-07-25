module state_controller(input  logic [7:0] keycode,
                        input  logic       Clk,
						input  logic       Reset_h,
                        input  logic       is_collision,
                        output logic [2:0] Current_State);


enum logic [2:0] {Start_Screen,
                  Play_Game_Easy,
                  Play_Game_Medium,
                  Play_Game_Hard,
                  Game_Over} State, Next_State;

assign Current_State = State;

always_ff @ (posedge Clk or posedge Reset_h)
	begin
		if (Reset_h) 
			State <= Start_Screen;
		else 
			State <= Next_State;
	end

always_comb
	begin 
		// Default next state is staying at current state
		Next_State = State;

        //Assign next state
        unique case (State)
            Start_Screen : begin
                    if (keycode == 8'd30) //Easy Game Mode
                        Next_State = Play_Game_Easy;
                    if (keycode == 8'd31)
                        Next_State = Play_Game_Medium;
                    if (keycode == 8'd32)
                        Next_State = Play_Game_Hard;
                end
            
            Play_Game_Easy   : if (is_collision) Next_State = Game_Over;
            Play_Game_Medium : if (is_collision) Next_State = Game_Over;
            Play_Game_Hard   : if (is_collision) Next_State = Game_Over;

            Game_Over        : if (keycode == 8'h28) Next_State = Start_Screen;
            
        endcase
    end

endmodule