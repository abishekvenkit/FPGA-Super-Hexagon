module testbench();
    
    timeunit 10ns;  // how long one unit of time is

    timeprecision 1ns;

    // inputs
    // logic CLOCK_50;
    // logic [3:0]  KEY;        
    // logic [6:0]  HEX0, HEX1, HEX4;
 
    // logic [7:0]  VGA_R,       
    //              VGA_G,       
    //              VGA_B;       
    // logic   VGA_CLK,     
    //         VGA_SYNC_N,  
    //         VGA_BLANK_N, 
    //         VGA_VS,      
    //         VGA_HS; 
    // wire  [15:0] OTG_DATA;   
    // logic [1:0]  OTG_ADDR;  
    // logic        OTG_CS_N,   
    //             OTG_RD_N,   
    //             OTG_WR_N,   
    //             OTG_RST_N,  
    //             OTG_INT;    
    // logic [12:0] DRAM_ADDR;  
    // wire  [31:0] DRAM_DQ;    
    // logic [1:0]  DRAM_BA;    
    // logic [3:0]  DRAM_DQM;   
    // logic        DRAM_RAS_N, 
    //             DRAM_CAS_N, 
    //             DRAM_CKE,   
    //             DRAM_WE_N,  
    //             DRAM_CS_N,  
    //             DRAM_CLK;          

    // final_project test(.*);

    logic        Clk;
    logic        Reset_h;
    logic  [9:0] DrawY;
    logic        VGA_VS;
    logic  [2:0] State;
    logic  [9:0] rotation_offset;
    logic  [4:0] Saturation_offset;
    logic  [4:0] Luminance_offset;
    logic  [5:0] Hue_offset;
    logic        move_walls;
	 logic 		  invert_colors;
        
    game_controller game_controller_test(.*);
	 
    always begin 
        #1 Clk = ~Clk;
    end

    initial begin
        Clk = 0;
    end 
        
    //set test vectors
    initial begin
        // KEY = 4'b1111;
        // #10 KEY = 4'b1110; 
        // #10 KEY = 4'b1111;
	    // #100 KEY = 4'b0111;
		// #100 KEY = 4'b1111;
        #2 Reset_h = 1'b1;
        #2 Reset_h = 1'b0;
           State = 3'd1;

    end
endmodule
        