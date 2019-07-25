// module hsl_to_rgb (input logic [7:0] Hue,
//                    input logic [7:0] Saturation,
//                    input logic [7:0] Luminance,
//                    output logic [7:0] Red,
//                    output logic [7:0] Green,
//                    output logic [7:0] Blue, );
//     logic [20:0] C;
//     logic [10:0] H, L, S, temp, temp2, C_prime, X, R_1, G_1, B_1;
//     logic [2:0] H_prime;

//     assign S = Saturation * 4;
//     assign L = Luminance * 4;
//     assign temp = (2*L - 11'sd1023);
    
//     assign C = (11'sd1023 - temp2) * S;
//     assign C_prime = C[20:10];

//     always_comb begin
//         if (Hue < 8'd43) H_prime = 3'd0;
//         else if (Hue >= 8'd43 && Hue < 8'd86) H_prime = 3'd1;
//         else if (Hue >= 8'd86 && Hue < 8'd128) H_prime = 3'd2;
//         else if (Hue >= 8'd128 && Hue < 8'd170) H_prime = 3'd3;
//         else if (Hue >= 8'd170 && Hue < 8'd213) H_prime = 3'd4;
//         else H_prime = 3'd5;

//         if (temp < 11'sd0) temp2 = ~temp + 11'sd1;
//         else temp2 = temp;

//         if (H_prime[0]) X = C_prime;
//         else X = 11'sd0;

//         case(H_prime)
//             3'd0 : begin
//                     R_1 = C_prime;
//                     G_1 = X;
//                     B_1 = 11'sd0;
//                    end

//             3'd1 : begin
//                     R_1 = X;
//                     G_1 = C_prime;
//                     B_1 = 11'sd0;
//                    end

//             3'd2 : begin
//                     R_1 = 11'sd0;
//                     G_1 = C_prime;
//                     B_1 = X;
//                    end
                   
//             3'd3 : begin
//                     R_1 = 11'sd0;
//                     G_1 = X;
//                     B_1 = C_prime;
//                    end
                   
//             3'd4 : begin
//                     R_1 = X;
//                     G_1 = 11'sd0;
//                     B_1 = C_prime;
//                    end
                   
//             3'd5 : begin
//                     R_1 = C_prime;
//                     G_1 = 11'sd0;
//                     B_1 = X;
//                    end

//             default : begin
//                         R_1 = 11'sd0;
//                         G_1 = 11'sd0;
//                         B_1 = 11'sd0;
//                       end
                   
            


//     end
    
    
// endmodule