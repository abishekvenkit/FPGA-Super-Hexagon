module game_controller(input  logic         Clk,
                       input  logic         Reset_h,
                       input  logic  [9:0]  DrawY,
                       input  logic         VGA_VS,
					   input  logic  [2:0]  State,
                       output logic  [9:0]  rotation_offset,
                       output logic  [4:0]  Saturation_offset,
                       output logic  [4:0]  Luminance_offset,
                       output logic  [5:0]  Hue_offset, 
                       output logic         move_walls,
                       output logic         invert_colors
                       );
    
    //FIXED COUNTER SHIT
    logic [29:0] Clk_counter;
    logic [10:0] frame_counter_fix; 
    assign frame_counter_fix = Clk_counter[29:19];
    logic [9:0] frame_counter;
    
    assign Hue_offset        = frame_counter_fix[9:3]; //every 8 frames / 7.5 Hz / full spectrum in 8.53 seconds
    assign Luminance_offset  = 5'd0;
    assign Saturation_offset = 5'd0;
    // assign Luminance_offset  = (frame_counter[7])? 5'sd0 : -5'sd1; 
    // assign Saturation_offset = (frame_counter[6])? 5'sd0 : -5'sd1; 


    always_ff @ (posedge Clk or posedge Reset_h) begin
        if(Reset_h) Clk_counter <= 30'd0;
        else Clk_counter <= Clk_counter + 30'd1;
    end 
    //FIXED COUNTER SHIT

    always_ff @ (posedge VGA_VS) begin //at every frame / 60Hz
        frame_counter <= frame_counter + 10'd1;
    end

    logic [6:0] move_walls_counter;
    logic [6:0] move_walls_counter_reset;
    
    always_comb begin
	     move_walls = 1'b0;
        if (State == 3'd1) move_walls = Clk_counter[19];
        else if (State == 3'd2) move_walls = Clk_counter[18];
        else if (State == 3'd3) move_walls = Clk_counter[18];
    end
    //controls whether we move walls in or not based on the current move_walls_counter_reset
    // always_ff @ (posedge Clk_counter[18]) begin  //speed of walls
    //     if (Reset_h) begin //CHANGE THIS 
    //         move_walls_counter <= 7'd0;
    //         move_walls <= 1'b0;
    //     end
    //     if(State == 3'd1 || State == 3'd2 || State == 3'd3)  begin
    //         if (move_walls_counter >= move_walls_counter_reset) begin //whether we move walls
    //             move_walls_counter <= 7'd0;
    //             move_walls <= ~move_walls;
    //         end

    //         else begin
    //             move_walls_counter <= move_walls_counter + 7'd1;
    //         end
    //     end
    // end

    // //WALL RESET COUNTER (COULD CAUSE ISSUE)
    // always_ff @ (posedge frame_counter_fix[6]) begin // controls acceleration of move_walls
    //     if (Reset_h) move_walls_counter_reset <= 7'd50; //initial speed
    //     else if (move_walls_counter_reset > 7'd3) //max speed
    //         move_walls_counter_reset <= move_walls_counter_reset - 7'd1;
    // end

    logic rotation_direction;

    always_ff @ (posedge Clk_counter[18]) begin  //test
        if (Reset_h) rotation_offset <= 10'd0;

        else if (State == 3'd1) rotation_offset <= (rotation_direction)? rotation_offset + 10'd2 : rotation_offset - 10'd2 ;
        else if (State == 3'd2) rotation_offset <= (rotation_direction)? rotation_offset + 10'd3 : rotation_offset - 10'd3 ;
        else if (State == 3'd3) rotation_offset <= (rotation_direction)? rotation_offset + 10'd4 : rotation_offset - 10'd4 ;
        else rotation_offset <= (rotation_direction)? rotation_offset + 10'd2 : rotation_offset - 10'd2 ;
    end

    assign rotation_direction = frame_counter_fix[10];
    
    always_comb begin
        invert_colors = 1'b0;
        if (State == 3'd1 || State == 3'd2 || State == 3'd3) invert_colors = frame_counter_fix[9];
    end

endmodule
            
