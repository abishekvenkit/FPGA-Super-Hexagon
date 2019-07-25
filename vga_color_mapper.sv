//-------------------------------------------------------------------------
//    Color_Mapper.sv                                                    --
//    Stephen Kempf                                                      --
//    3-1-06                                                             --
//                                                                       --
//    Modified by David Kesler  07-16-2008                               --
//    Translated by Joe Meng    07-07-2013                               --
//    Modified by Po-Han Huang  10-06-2017                               --
//                                                                       --
//    Fall 2017 Distribution                                             --
//                                                                       --
//    For use with ECE 385 Lab 8                                         --
//    University of Illinois ECE Department                              --
//-------------------------------------------------------------------------

// color_mapper: Decide which color to be output to VGA for each pixel.
module  color_mapper ( input              is_wall,
                       input              is_player,
                       input              Clk,
                       input              invert_colors,
                       input        [4:0] Luminance_offset,        
                       input        [4:0] Saturation_offset,          
                       input        [5:0] Hue_offset,
                       input        [2:0] sextant,
                       input        [9:0] radius,
                       input        [2:0] State,
                       input        [9:0] DrawX,
                       input        [9:0] DrawY,
                       output logic [7:0] VGA_R, VGA_G, VGA_B // VGA RGB output
                     );

    logic [3:0] Saturation, Saturation_prime, Luminance, Luminance_prime;
    logic [4:0] Saturation_temp, Luminance_temp;
    logic [5:0] Hue, Hue_prime;

    assign Hue = Hue_prime + Hue_offset;
    assign Saturation_temp = Saturation_prime + Saturation_offset;
    assign Luminance_temp = Luminance_prime + Luminance_offset;
    
    always_comb begin
        // Saturation = (Saturation_temp[4])? 3'h0 : Saturation_temp[3:0];
        // Luminance = (Luminance_temp[4])? 3'h0 : Luminance_temp[3:0];
        Saturation = Saturation_temp;
        Luminance = (invert_colors)? 4'd15 - Luminance_temp : Luminance_temp;
    end
    
    hsl_to_rgb color_space_mapper(.*, .Red(VGA_R), .Green(VGA_G), .Blue(VGA_B));

    logic [159:0] ss_row, gos_row;
    start_screen start_screen_data(.Clk(Clk), .row_addr(DrawY[8:2]), .columns(ss_row));
    game_over_screen game_over_screen_data(.Clk(Clk), .row_addr(DrawY[8:2]), .columns(gos_row));

    
    always_comb begin
        //defaults
        Hue_prime        = 6'd0;
        Saturation_prime = 4'd15;
        Luminance_prime  = 4'd15;

        //Change to make actual start screen
        if (State == 3'd0) begin
            Luminance_prime  = (ss_row[DrawX/3'd4]) ? 4'd0 : 4'd8 - radius/8'd64;
            Hue_prime = radius/8'd16;
            // Saturation_prime = 4'd15 - radius/7'd32;
        end

        else if (State == 3'd1 || State == 3'd2 || State == 3'd3) begin 
            if (radius <= 10'd42 && radius >= 10'd38) begin // central hexagon boundary
                Saturation_prime = 4'd15;
                Luminance_prime  = 4'd9;
            end

            else if(radius < 10'd38) begin // inside central hexagon 
                Saturation_prime = 4'd5;
                Luminance_prime  = 4'd1;
            end

            else if (is_player) begin
                Hue_prime = 6'd0;
                Saturation_prime = 4'd15;
                Luminance_prime  = 4'd14;
            end

            else if (is_wall) begin
                Saturation_prime = 4'd15;
                case (sextant)
                    3'd1 : Luminance_prime  = 4'd11;
                    3'd2 : Luminance_prime  = 4'd12;
                    3'd3 : Luminance_prime  = 4'd11;
                    3'd4 : Luminance_prime  = 4'd12;
                    3'd5 : Luminance_prime  = 4'd11;
                    3'd6 : Luminance_prime  = 4'd12;
                endcase
            end

            else begin //background
                Saturation_prime = 4'd5;
                case (sextant)
                    3'd1 : Luminance_prime  = 4'd1;
                    3'd2 : Luminance_prime  = 4'd2;
                    3'd3 : Luminance_prime  = 4'd1;
                    3'd4 : Luminance_prime  = 4'd2;
                    3'd5 : Luminance_prime  = 4'd1;
                    3'd6 : Luminance_prime  = 4'd2;
                endcase
            end
        end

        else if (State == 3'd4) begin
            Luminance_prime  = ~(gos_row[DrawX/3'd4]) ? 4'd0 : 4'd8;
            Hue_prime = radius/8'd16;
        end    
    end 

endmodule
