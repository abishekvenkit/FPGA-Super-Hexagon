//-------------------------------------------------------------------------
//      lab8.sv                                                          --
//      Christine Chen                                                   --
//      Fall 2014                                                        --
//                                                                       --
//      Modified by Po-Han Huang                                         --
//      10/06/2017                                                       --
//                                                                       --
//      Fall 2017 Distribution                                           --
//                                                                       --
//      For use with ECE 385 Lab 8                                       --
//      UIUC ECE Department                                              --
//-------------------------------------------------------------------------


module final_project( input               CLOCK_50,
             input        [3:0]  KEY,          //bit 0 is set up as Reset
             output logic [6:0]  HEX0, HEX1, HEX2, HEX3,
             // VGA Interface 
             output logic [7:0]  VGA_R,        //VGA Red
                                 VGA_G,        //VGA Green
                                 VGA_B,        //VGA Blue
             output logic        VGA_CLK,      //VGA Clock
                                 VGA_SYNC_N,   //VGA Sync signal
                                 VGA_BLANK_N,  //VGA Blank signal
                                 VGA_VS,       //VGA virtical sync signal
                                 VGA_HS,       //VGA horizontal sync signal
             // CY7C67200 Interface
             inout  wire  [15:0] OTG_DATA,     //CY7C67200 Data bus 16 Bits
             output logic [1:0]  OTG_ADDR,     //CY7C67200 Address 2 Bits
             output logic        OTG_CS_N,     //CY7C67200 Chip Select
                                 OTG_RD_N,     //CY7C67200 Write
                                 OTG_WR_N,     //CY7C67200 Read
                                 OTG_RST_N,    //CY7C67200 Reset
             input               OTG_INT,      //CY7C67200 Interrupt
             // SDRAM Interface for Nios II Software
             output logic [12:0] DRAM_ADDR,    //SDRAM Address 13 Bits
             inout  wire  [31:0] DRAM_DQ,      //SDRAM Data 32 Bits
             output logic [1:0]  DRAM_BA,      //SDRAM Bank Address 2 Bits
             output logic [3:0]  DRAM_DQM,     //SDRAM Data Mast 4 Bits
             output logic        DRAM_RAS_N,   //SDRAM Row Address Strobe
                                 DRAM_CAS_N,   //SDRAM Column Address Strobe
                                 DRAM_CKE,     //SDRAM Clock Enable
                                 DRAM_WE_N,    //SDRAM Write Enable
                                 DRAM_CS_N,    //SDRAM Chip Select
                                 DRAM_CLK,      //SDRAM Clock

            // DAC interface
            output logic AUD_DACDAT,
            output logic I2C_SDAT,
            output logic I2C_SCLK,
            input  logic AUD_DACLRCK,
            input  logic AUD_ADCDAT,
            input  logic AUD_ADCLRCK,
            input  logic AUD_BCLK);
    
    logic Reset_h, Clk;
    logic [7:0] keycode;
    
    assign Clk = CLOCK_50;
    always_ff @ (posedge Clk) begin
        Reset_h <= ~(KEY[0]);        // The push buttons are active low
    end
    
    logic [1:0] hpi_addr;
    logic [15:0] hpi_data_in, hpi_data_out;
    logic hpi_r, hpi_w, hpi_cs, hpi_reset;
    
   //Interface between NIOS II and EZ-OTG chip
    hpi_io_intf hpi_io_inst(
                            .Clk(Clk),
                            .Reset(Reset_h),
                            // signals connected to NIOS II
                            .from_sw_address(hpi_addr),
                            .from_sw_data_in(hpi_data_in),
                            .from_sw_data_out(hpi_data_out),
                            .from_sw_r(hpi_r),
                            .from_sw_w(hpi_w),
                            .from_sw_cs(hpi_cs),
                            .from_sw_reset(hpi_reset),
                            // signals connected to EZ-OTG chip
                            .OTG_DATA(OTG_DATA),    
                            .OTG_ADDR(OTG_ADDR),    
                            .OTG_RD_N(OTG_RD_N),    
                            .OTG_WR_N(OTG_WR_N),    
                            .OTG_CS_N(OTG_CS_N),
                            .OTG_RST_N(OTG_RST_N)
    );
     
//     You need to make sure that the port names here match the ports in Qsys-generated codes.
     final_project_soc_fix nios_system(
                             .clk_clk(Clk),         
                             .reset_reset_n(1'b1),    // Never reset NIOS
                             .sdram_wire_addr(DRAM_ADDR), 
                             .sdram_wire_ba(DRAM_BA),   
                             .sdram_wire_cas_n(DRAM_CAS_N),
                             .sdram_wire_cke(DRAM_CKE),  
                             .sdram_wire_cs_n(DRAM_CS_N), 
                             .sdram_wire_dq(DRAM_DQ),   
                             .sdram_wire_dqm(DRAM_DQM),  
                             .sdram_wire_ras_n(DRAM_RAS_N),
                             .sdram_wire_we_n(DRAM_WE_N), 
                             .sdram_clk_clk(DRAM_CLK),
                             .keycode_export(keycode),  
                             .otg_hpi_address_export(hpi_addr),
                             .otg_hpi_data_in_port(hpi_data_in),
                             .otg_hpi_data_out_port(hpi_data_out),
                             .otg_hpi_cs_export(hpi_cs),
                             .otg_hpi_r_export(hpi_r),
                             .otg_hpi_w_export(hpi_w),
                             .otg_hpi_reset_export(hpi_reset)
    );
    
    logic  [9:0] DrawX, DrawY;
	logic  [4:0] Saturation_offset,Luminance_offset;
	logic  [5:0] Hue_offset;
	logic  [9:0] rotation_offset, radius;
    logic  [2:0] sextant;
    logic        invert_colors;
    logic        is_wall;
    logic        move_walls;
    logic        is_player;
    logic  [2:0] State;
    logic        is_collision;
    logic        kb_reset;
    logic [15:0] LDATA, RDATA;
    logic        data_over, INIT, INIT_FINISH, adc_full, AUD_MCLK;
    logic        audio_operation;
    logic [31:0] ADCDATA;
    logic [12:0] Score;
    logic [12:0] Score_BCD;

    assign kb_reset = (keycode == 8'h28);
    assign is_collision = is_wall && is_player;

    audio_state_controller audio_state_controller_module(.*);

    audio_output audio_output_data(.*);

    audio_interface audio_interface_module(
        .LDATA(LDATA),
        .RDATA(RDATA),
        .clk(Clk), 
        .Reset(Reset_h),
        .INIT(INIT),
        .INIT_FINISH(INIT_FINISH),
        .adc_full(adc_full),
        .data_over(data_over),
        .AUD_MCLK(AUD_MCLK),
        .AUD_BCLK(AUD_BCLK),
        .AUD_ADCDAT(AUD_ADCDAT),
        .AUD_DACDAT(AUD_DACDAT),
        .AUD_DACLRCK(AUD_DACLRCK),
        .AUD_ADCLRCK(AUD_ADCLRCK),
        .I2C_SDAT(I2C_SDAT),
        .I2C_SCLK(I2C_SCLK),
        .ADCDATA(ADCDATA)
        );

    bin2bcd bin2bcd_instance(.bin(Score[11:0]), .bcd(Score_BCD));

    state_controller state_controller_instance(.*, .Current_State(State));

    sextant_mapper sextant_mapper_instance(.*);
        
    color_mapper color_instance(.*);

    vga_clk vga_clk_instance(.inclk0(Clk), .c0(VGA_CLK));

    VGA_controller vga_controller_instance(.Reset(Reset_h), .*);

    wall wall_module(.*);

    game_controller game_controller_module(.*);

    player player_module(.*);
    
    HexDriver hex_inst_0 (Score_BCD[3:0], HEX0);
    HexDriver hex_inst_1 (Score_BCD[7:4], HEX1);
    HexDriver hex_inst_2 (Score_BCD[11:8], HEX2);
    HexDriver hex_inst_3 (4'h0, HEX3);
    
    // HexDriver state_hex (State, HEX4);
endmodule
