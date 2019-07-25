module player(input  logic  [9:0] DrawY,
              input  logic  [9:0] DrawX,
              input  logic        Reset_h,
              input  logic        Clk,
              input  logic  [9:0] rotation_offset,
              input  logic        VGA_VS,
              input  logic  [7:0] keycode,
              input  logic  [2:0] State,
              output logic  is_player);

    parameter signed [9:0] radius = 9'd60;
    logic [5:0] player_angle_step;
    parameter [5:0] player_size = 6'd3;

    always_comb begin
        player_angle_step = 6'd8;
        if (State == 3'd1) player_angle_step = 6'd8;
        else if (State == 3'd2) player_angle_step = 6'd11;
        else if (State == 3'd3) player_angle_step = 6'd11;
    end

    int X, Y; 
    assign X = 10'sd320 - DrawX;
    assign Y = 10'sd240 - DrawY;
    
    logic [9:0] player_angle;
    int player_X;
    int player_Y;
    logic signed [20:0] player_X_temp;
    logic signed [20:0] player_Y_temp;
    logic signed [20:0] player_X_prime;
    logic signed [20:0] player_Y_prime;

    int signed DistX, DistX_abs, DistY, DistY_abs, Size;
    assign DistX = DrawX - (player_X + 10'd320);
    assign DistX_abs = (DistX >= 10'd0) ? DistX : (-DistX);
    assign DistY = DrawY - (player_Y + 10'd240);
    assign DistY_abs = (DistY >= 10'd0) ? DistY : (-DistY);
    assign Size = player_size;
    always_comb begin
        if ( ( DistX_abs*DistX_abs + DistY_abs*DistY_abs) <= (Size*Size) ) 
            is_player = 1'b1;
        else
            is_player = 1'b0;
    end
    
    always_ff @ (posedge VGA_VS) begin
        if (Reset_h) player_angle <= 10'b0;
        else if (keycode == 8'h50) player_angle <= player_angle - player_angle_step;
        else if (keycode == 8'h4f) player_angle <= player_angle + player_angle_step;
    end


    sin player_Y_calc(.*, .angle(player_angle + rotation_offset), .answer(player_Y_temp));
    cos player_X_calc(.*, .angle(player_angle + rotation_offset), .answer(player_X_temp));

    assign player_X_prime = player_X_temp * radius;
    assign player_Y_prime = player_Y_temp * radius;
    assign player_X = player_X_prime/12'sd1024;
    assign player_Y = player_Y_prime/12'sd1024;

endmodule