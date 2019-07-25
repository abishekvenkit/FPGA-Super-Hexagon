module wall (input  logic  [9:0] radius,
             input  logic  [2:0] sextant,
				//  input  logic        Clk,     //debug
             input  logic        Reset_h, //debug
             input  logic        move_walls,
             input  logic        kb_reset,
             input  logic  [2:0] State,
            //  input  logic  [3:0] KEY,  //debug
            //  input  logic  [9:0] DrawY, //debug
             output logic [12:0] Score,
             output logic        is_wall);
     
    logic [400:0] wall_array           [1:6];
    logic  [10:0] pattern_counter           ;
    reg    [63:0] pattern_array_easy   [1:6];
    reg    [63:0] pattern_array_medium [1:6];
    reg    [63:0] pattern_array_hard   [1:6];
    logic  [17:0] score_counter             ;
    always_comb begin
        is_wall = wall_array[sextant][radius];
    end

    assign Score = score_counter[17:5];
    
    always_ff @ (posedge move_walls or posedge Reset_h or posedge kb_reset) begin
        if (Reset_h) begin
            wall_array[1][400:0]   <= 401'd0;
            wall_array[2][400:0]   <= 401'd0;
            wall_array[3][400:0]   <= 401'd0;
            wall_array[4][400:0]   <= 401'd0;
            wall_array[5][400:0]   <= 401'd0;
            wall_array[6][400:0]   <= 401'd0;
            pattern_counter <= 8'd0;
            score_counter   <= 18'd0;
        end
        else if (kb_reset) begin
            wall_array[1][400:0]   <= 401'd0;
            wall_array[2][400:0]   <= 401'd0;
            wall_array[3][400:0]   <= 401'd0;
            wall_array[4][400:0]   <= 401'd0;
            wall_array[5][400:0]   <= 401'd0;
            wall_array[6][400:0]   <= 401'd0;
            pattern_counter <= 8'd0;
            score_counter   <= 18'd0;
        end
        else begin
            if(State == 3'd1) begin
                wall_array[1] <= {pattern_array_easy[1][pattern_counter[10:5]], wall_array[1][399:1]};
                wall_array[2] <= {pattern_array_easy[2][pattern_counter[10:5]], wall_array[2][399:1]};
                wall_array[3] <= {pattern_array_easy[3][pattern_counter[10:5]], wall_array[3][399:1]};
                wall_array[4] <= {pattern_array_easy[4][pattern_counter[10:5]], wall_array[4][399:1]};
                wall_array[5] <= {pattern_array_easy[5][pattern_counter[10:5]], wall_array[5][399:1]};
                wall_array[6] <= {pattern_array_easy[6][pattern_counter[10:5]], wall_array[6][399:1]};
                pattern_counter <= pattern_counter + 8'd1;
                score_counter   <= score_counter + 18'd1;
            end
            else if(State == 3'd2) begin
                wall_array[1] <= {pattern_array_medium[1][pattern_counter[10:5]], wall_array[1][399:1]};
                wall_array[2] <= {pattern_array_medium[2][pattern_counter[10:5]], wall_array[2][399:1]};
                wall_array[3] <= {pattern_array_medium[3][pattern_counter[10:5]], wall_array[3][399:1]};
                wall_array[4] <= {pattern_array_medium[4][pattern_counter[10:5]], wall_array[4][399:1]};
                wall_array[5] <= {pattern_array_medium[5][pattern_counter[10:5]], wall_array[5][399:1]};
                wall_array[6] <= {pattern_array_medium[6][pattern_counter[10:5]], wall_array[6][399:1]};
                pattern_counter <= pattern_counter + 8'd1;
                score_counter   <= score_counter + 18'd1;
            end
            else if(State == 3'd3) begin
                wall_array[1] <= {pattern_array_hard[1][pattern_counter[10:5]], wall_array[1][399:1]};
                wall_array[2] <= {pattern_array_hard[2][pattern_counter[10:5]], wall_array[2][399:1]};
                wall_array[3] <= {pattern_array_hard[3][pattern_counter[10:5]], wall_array[3][399:1]};
                wall_array[4] <= {pattern_array_hard[4][pattern_counter[10:5]], wall_array[4][399:1]};
                wall_array[5] <= {pattern_array_hard[5][pattern_counter[10:5]], wall_array[5][399:1]};
                wall_array[6] <= {pattern_array_hard[6][pattern_counter[10:5]], wall_array[6][399:1]};
                pattern_counter <= pattern_counter + 8'd1;
                score_counter   <= score_counter + 18'd1;
            end
        end
    end
    
    initial begin
        pattern_array_easy[1]   <= 64'b1111111111111111111111111000100001000001000100010001000100000001 ;
        pattern_array_easy[2]   <= 64'b0000000010000000100000001000100001000001000000000000000000010000 ;
        pattern_array_easy[3]   <= 64'b0000100000001000000010000000000001000000000100010001000100000000 ;
        pattern_array_easy[4]   <= 64'b1111111111111111111111111000100001000001000000000000000000010001 ;
        pattern_array_easy[5]   <= 64'b0000000010000000100000001000100001000001000100010001000100000000 ;
        pattern_array_easy[6]   <= 64'b0000100000001000000010000000100000000001000100010000000000010000 ;
    end

    initial begin
        pattern_array_medium[1] <= 64'b0000010000000000001000110001000001000001000001001010110011110010 ;
        pattern_array_medium[2] <= 64'b0100011111111111111000000000001000001000001000000010110000010000 ;
        pattern_array_medium[3] <= 64'b0000000000001000001000000001000001000001000001001010110010000010 ;
        pattern_array_medium[4] <= 64'b0000010000001000000000110000001000001000001000000000000011110000 ;
        pattern_array_medium[5] <= 64'b0100010000001000001000000001000001000001000001000000110011110010 ;
        pattern_array_medium[6] <= 64'b0000010000001000001000000000001000001000001000000000110011110000 ;
    end

    initial begin
        pattern_array_hard[1]   <= 64'b0000000000111111000001000010000000000011111110001001001001001000 ; //C's, changing direction every 2.
        pattern_array_hard[2]   <= 64'b0011111100000000001000000000000111111000111110001001001001000001 ;
        pattern_array_hard[3]   <= 64'b0000000000111111000001001010001111111100000000001001001000001001 ;
        pattern_array_hard[4]   <= 64'b0011111100000000001000001000000111111000000010001001000001001001 ;
        pattern_array_hard[5]   <= 64'b0000000000111111000001000010001111110000000010001000001001001001 ;
        pattern_array_hard[6]   <= 64'b0011111100000000001000000000000111100000111110000001001001001001 ;
    end

endmodule