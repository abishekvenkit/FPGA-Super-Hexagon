module sextant_mapper(input  logic        Clk,
                      input  logic  [9:0] rotation_offset,
                      input  logic  [9:0] DrawX,
                      input  logic  [9:0] DrawY,
                      output logic  [2:0] sextant,
                      output logic  [9:0] radius);

    //cartesian coordinates, assuming centre of the screen as origin
    logic signed [9:0] X, Y; 
    assign X = 10'sd320 - DrawX;
    assign Y = 10'sd240 - DrawY;

    // slopes of the three lines separating the sextants
    logic signed [19:0] slope1_20, slope2_20, slope3_20;
    logic signed [29:0] slope1, slope2, slope3;

    tan tan_slope1(.*, .angle(rotation_offset          ), .answer(slope1_20));
    tan tan_slope2(.*, .angle(rotation_offset + 10'd171), .answer(slope2_20));
    tan tan_slope3(.*, .angle(rotation_offset + 10'd341), .answer(slope3_20));

    assign slope1 = {{10{slope1_20[19]}}, slope1_20};
    assign slope2 = {{10{slope2_20[19]}}, slope2_20};
    assign slope3 = {{10{slope3_20[19]}}, slope3_20};
    
    // calculating sextant
    always_comb begin
        sextant = 3'd1; //default case
        if(rotation_offset <= 10'd85 || rotation_offset >= 10'd939) begin // 330 < theta < 30
            if      (((Y*30'sd1024 <= slope2*X) && (Y*30'sd1024 >= slope1*X)))  sextant = 3'd1;
            else if (((Y*30'sd1024 >= slope2*X) && (Y*30'sd1024 >= slope3*X)))  sextant = 3'd2;
            else if (((Y*30'sd1024 <= slope3*X) && (Y*30'sd1024 >= slope1*X)))  sextant = 3'd3;
            else if (((Y*30'sd1024 <= slope1*X) && (Y*30'sd1024 >= slope2*X)))  sextant = 3'd4;
            else if (((Y*30'sd1024 <= slope2*X) && (Y*30'sd1024 <= slope3*X)))  sextant = 3'd5;
            else if (((Y*30'sd1024 <= slope1*X) && (Y*30'sd1024 >= slope3*X)))  sextant = 3'd6;
        end
        else if (rotation_offset >= 10'd85 && rotation_offset <= 10'd256) begin // 30 < theta < 90
            if      (((Y*30'sd1024 >= slope1*X) && (Y*30'sd1024 >= slope2*X)))  sextant = 3'd1;
            else if (((Y*30'sd1024 <= slope2*X) && (Y*30'sd1024 >= slope3*X)))  sextant = 3'd2;
            else if (((Y*30'sd1024 <= slope3*X) && (Y*30'sd1024 >= slope1*X)))  sextant = 3'd3;
            else if (((Y*30'sd1024 <= slope1*X) && (Y*30'sd1024 <= slope2*X)))  sextant = 3'd4;
            else if (((Y*30'sd1024 <= slope3*X) && (Y*30'sd1024 >= slope2*X)))  sextant = 3'd5;
            else if (((Y*30'sd1024 <= slope1*X) && (Y*30'sd1024 >= slope3*X)))  sextant = 3'd6;
        end
        else if (rotation_offset >= 10'd256 && rotation_offset <= 10'd427) begin // 90 < theta < 150
            if      (((Y*30'sd1024 <= slope1*X) && (Y*30'sd1024 >= slope2*X)))  sextant = 3'd1;
            else if (((Y*30'sd1024 <= slope2*X) && (Y*30'sd1024 >= slope3*X)))  sextant = 3'd2;
            else if (((Y*30'sd1024 <= slope1*X) && (Y*30'sd1024 <= slope3*X)))  sextant = 3'd3;
            else if (((Y*30'sd1024 <= slope2*X) && (Y*30'sd1024 >= slope1*X)))  sextant = 3'd4;
            else if (((Y*30'sd1024 >= slope2*X) && (Y*30'sd1024 <= slope3*X)))  sextant = 3'd5;
            else if (((Y*30'sd1024 >= slope1*X) && (Y*30'sd1024 >= slope3*X)))  sextant = 3'd6;
        end
        else if (rotation_offset >= 10'd427 && rotation_offset <= 10'd597) begin // 150 < theta < 210
            if      (((Y*30'sd1024 <= slope1*X) && (Y*30'sd1024 >= slope2*X)))  sextant = 3'd1;
            else if (((Y*30'sd1024 <= slope2*X) && (Y*30'sd1024 <= slope3*X)))  sextant = 3'd2;
            else if (((Y*30'sd1024 <= slope1*X) && (Y*30'sd1024 >= slope3*X)))  sextant = 3'd3;
            else if (((Y*30'sd1024 <= slope2*X) && (Y*30'sd1024 >= slope1*X)))  sextant = 3'd4;
            else if (((Y*30'sd1024 >= slope2*X) && (Y*30'sd1024 >= slope3*X)))  sextant = 3'd5;
            else if (((Y*30'sd1024 >= slope1*X) && (Y*30'sd1024 <= slope3*X)))  sextant = 3'd6;
        end
        else if (rotation_offset >= 10'd597 && rotation_offset <= 10'd768) begin // 210 < theta < 270
            if      (((Y*30'sd1024 <= slope1*X) && (Y*30'sd1024 <= slope2*X)))  sextant = 3'd1;
            else if (((Y*30'sd1024 >= slope2*X) && (Y*30'sd1024 <= slope3*X)))  sextant = 3'd2;
            else if (((Y*30'sd1024 <= slope1*X) && (Y*30'sd1024 >= slope3*X)))  sextant = 3'd3;
            else if (((Y*30'sd1024 >= slope2*X) && (Y*30'sd1024 >= slope1*X)))  sextant = 3'd4;
            else if (((Y*30'sd1024 <= slope2*X) && (Y*30'sd1024 >= slope3*X)))  sextant = 3'd5;
            else if (((Y*30'sd1024 >= slope1*X) && (Y*30'sd1024 <= slope3*X)))  sextant = 3'd6;
        end
        else if (rotation_offset >= 10'd768 && rotation_offset <= 10'd939) begin // 270 < theta < 330
            if      (((Y*30'sd1024 >= slope1*X) && (Y*30'sd1024 <= slope2*X)))  sextant = 3'd1;
            else if (((Y*30'sd1024 >= slope2*X) && (Y*30'sd1024 <= slope3*X)))  sextant = 3'd2;
            else if (((Y*30'sd1024 >= slope1*X) && (Y*30'sd1024 >= slope3*X)))  sextant = 3'd3;
            else if (((Y*30'sd1024 >= slope2*X) && (Y*30'sd1024 <= slope1*X)))  sextant = 3'd4;
            else if (((Y*30'sd1024 <= slope2*X) && (Y*30'sd1024 >= slope3*X)))  sextant = 3'd5;
            else if (((Y*30'sd1024 <= slope1*X) && (Y*30'sd1024 <= slope3*X)))  sextant = 3'd6;
        end
    end 

    // sines and cosines of the unit vectors in the direction of sextants
    logic signed [20:0] u1_sin, u1_cos, u2_sin, u2_cos, u3_sin, u3_cos, u4_sin, u4_cos, u5_sin, u5_cos, u6_sin, u6_cos;
    sin u1_sin_module(.*, .angle(rotation_offset + 10'd085), .answer(u1_sin));
    cos u1_cos_module(.*, .angle(rotation_offset + 10'd085), .answer(u1_cos));
    sin u2_sin_module(.*, .angle(rotation_offset + 10'd255), .answer(u2_sin));
    cos u2_cos_module(.*, .angle(rotation_offset + 10'd255), .answer(u2_cos));
    sin u3_sin_module(.*, .angle(rotation_offset + 10'd426), .answer(u3_sin));
    cos u3_cos_module(.*, .angle(rotation_offset + 10'd426), .answer(u3_cos));
    sin u4_sin_module(.*, .angle(rotation_offset + 10'd597), .answer(u4_sin));
    cos u4_cos_module(.*, .angle(rotation_offset + 10'd597), .answer(u4_cos));
    sin u5_sin_module(.*, .angle(rotation_offset + 10'd767), .answer(u5_sin));
    cos u5_cos_module(.*, .angle(rotation_offset + 10'd767), .answer(u5_cos));
    sin u6_sin_module(.*, .angle(rotation_offset + 10'd938), .answer(u6_sin));
    cos u6_cos_module(.*, .angle(rotation_offset + 10'd938), .answer(u6_cos));

    // calculate radius
    logic signed [20:0] radius_temp, radius_abs, dot_product_x, dot_product_y, dot_product_x_abs, dot_product_y_abs;
    // assign dot_product_x_abs = (dot_product_x[20])? -dot_product_x : dot_product_x;
    // assign dot_product_y_abs = (dot_product_y[20])? -dot_product_y : dot_product_y;
    assign radius_temp = dot_product_x + dot_product_y;
    // assign radius_abs = (radius_temp[20])? -radius_temp : radius_temp;
    assign radius = radius_temp[19:10]; 

    always_comb begin
        case(sextant)
            3'd1 : begin
                dot_product_x = X*u1_cos;
                dot_product_y = Y*u1_sin;
            end
            3'd2 : begin
                dot_product_x = X*u2_cos;
                dot_product_y = Y*u2_sin;
            end
            3'd3 : begin
                dot_product_x = X*u3_cos;
                dot_product_y = Y*u3_sin;
            end
            3'd4 : begin
                dot_product_x = X*u4_cos;
                dot_product_y = Y*u4_sin;
            end
            3'd5 : begin
                dot_product_x = X*u5_cos;
                dot_product_y = Y*u5_sin;
            end
            3'd6 : begin
                dot_product_x = X*u6_cos;
                dot_product_y = Y*u6_sin;
            end
            default : begin
                dot_product_x = X*u1_cos;
                dot_product_y = Y*u1_sin;
            end
        endcase
    end            

endmodule