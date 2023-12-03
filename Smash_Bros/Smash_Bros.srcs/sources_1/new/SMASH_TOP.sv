`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Zuofu Cheng
// 
// Create Date: 12/11/2022 10:48:49 AM
// Design Name: 
// Module Name: mb_usb_hdmi_top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// Top level for mb_lwusb test project, copy mb wrapper here from Verilog and modify
// to SV
// Dependencies: microblaze block design
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module SMASH_TOP(
    input logic Clk,
    input logic reset_rtl_0,
    
    //USB signals
    input logic [0:0] gpio_usb_int_tri_i,
    output logic gpio_usb_rst_tri_o,
    input logic usb_spi_miso,
    output logic usb_spi_mosi,
    output logic usb_spi_sclk,
    output logic usb_spi_ss,
    
    //UART
    input logic uart_rtl_0_rxd,
    output logic uart_rtl_0_txd,
    
    //HDMI
    output logic hdmi_tmds_clk_n,
    output logic hdmi_tmds_clk_p,
    output logic [2:0]hdmi_tmds_data_n,
    output logic [2:0]hdmi_tmds_data_p,
        
    //HEX displays
    output logic [7:0] hex_segA,
    output logic [3:0] hex_gridA,
    output logic [7:0] hex_segB,
    output logic [3:0] hex_gridB
    );

    logic[9:0] Stage_X_Max, Stage_X_Min, Stage_Y_Max, Stage_Y_Min;
    
    logic [31:0] keycode0_gpio, keycode1_gpio;
    logic clk_25MHz, clk_125MHz, clk, clk_100MHz;
    logic locked;
    logic [9:0] drawX, drawY, Marioxsig, Marioysig, Mariosizesig_X, Mariosizesig_Y;
    logic [9:0] Luigixsig, Luigiysig, Luigisizesig_X, Luigisizesig_Y;
    logic hsync, vsync, vde;
    logic [3:0] red, green, blue;
    logic reset_ah;
    logic Mario_Invert_Left;
    logic [4:0] Mario_State_Out;
    logic [4:0] Luigi_State_Out;
    logic edge_below_mario;
    logic jump_on_mario;
    logic edge_below_luigi;
    logic jump_on_luigi;
    logic [25:0]Mario_Fall_Counter;
    logic [25:0]Luigi_Fall_Counter;
    assign reset_ah = reset_rtl_0;
    
    
    //Keycode HEX drivers
    HexDriver HexA (
        .clk(Clk),
        .reset(reset_ah),
        .in({keycode1_gpio[31:28], keycode1_gpio[27:24], keycode1_gpio[23:20], keycode1_gpio[19:16]}),
        .hex_seg(hex_segA),
        .hex_grid(hex_gridA)
    );
    
    HexDriver HexB (
        .clk(Clk),
        .reset(reset_ah),
        .in({keycode0_gpio[15:12], keycode0_gpio[11:8], keycode0_gpio[7:4], keycode0_gpio[3:0]}),
        .hex_seg(hex_segB),
        .hex_grid(hex_gridB)
    );
    
    mb_ball mb_block_i(
        .clk_100MHz(Clk),
        .gpio_usb_int_i(gpio_usb_int_tri_i),
        .gpio_usb_keycode_0_tri_o(keycode0_gpio),
        .gpio_usb_keycode_1_tri_o(keycode1_gpio),
        .gpio_usb_rst_tri_o(gpio_usb_rst_tri_o),
        .reset_rtl_0(1'b1), //Block designs expect active low reset, all other modules are active high
        .uart_rtl_0_rxd(uart_rtl_0_rxd),
        .uart_rtl_0_txd(uart_rtl_0_txd),
        .usb_spi_miso(usb_spi_miso),
        .usb_spi_mosi(usb_spi_mosi),
        .usb_spi_sclk(usb_spi_sclk),
        .usb_spi_ss(usb_spi_ss)
    );
        
    //clock wizard configured with a 1x and 5x clock for HDMI
    clk_wiz_0 clk_wiz (
        .clk_out1(clk_25MHz),
        .clk_out2(clk_125MHz),
        .reset(reset_ah),
        .locked(locked),
        .clk_in1(Clk)
    );
    
    //VGA Sync signal generator
    vga_controller vga (
        .pixel_clk(clk_25MHz),
        .reset(reset_ah),
        .hs(hsync),
        .vs(vsync),
        .active_nblank(vde),
        .drawX(drawX),
        .drawY(drawY)
    );    

    //Real Digital VGA to HDMI converter
    hdmi_tx_0 vga_to_hdmi (
        //Clocking and Reset
        .pix_clk(clk_25MHz),
        .pix_clkx5(clk_125MHz),
        .pix_clk_locked(locked),
        //Reset is active LOW
        .rst(reset_ah),
        //Color and Sync Signals
        .red(red),
        .green(green),
        .blue(blue),
        .hsync(hsync),
        .vsync(vsync),
        .vde(vde),
        
        //aux Data (unused)
        .aux0_din(4'b0),
        .aux1_din(4'b0),
        .aux2_din(4'b0),
        .ade(1'b0),
        
        //Differential outputs
        .TMDS_CLK_P(hdmi_tmds_clk_p),          
        .TMDS_CLK_N(hdmi_tmds_clk_n),          
        .TMDS_DATA_P(hdmi_tmds_data_p),         
        .TMDS_DATA_N(hdmi_tmds_data_n)          
    );

    Mario_State Mario_State0(
        .Clk(Clk), 
		.Reset(reset_ah),
        .keycode(keycode0_gpio[7:0]),
        .edge_below_mario(edge_below_mario),
		.Mario_State_Out(Mario_State_Out),
        .Mario_Invert_Left(Mario_Invert_Left)
				);
    Luigi_State Luigi_State0 (
                .Clk(Clk), 
                .Reset(reset_ah),
                .keycode(keycode0_gpio[7:0]),
                .edge_below_luigi(edge_below_luigi),
                .jump_on_luigi(jump_on_luigi),
                .Luigi_State_Out(Luigi_State_Out),
                .Luigi_Invert_Left(Luigi_Invert_Left)
                        
    );
    //Mario Module
    Mario mario_instance(
        .Reset(reset_ah),
        .frame_clk(vsync),                    //Figure out what this should be so that the Mario will move
        .keycode(keycode0_gpio[7:0]),    //Notice: only one keycode connected to Mario by default
        .edge_below_mario(edge_below_mario),
        .MarioX(Marioxsig),
        .MarioY(Marioysig),
        .MarioS_X(Mariosizesig_X),
        .MarioS_Y(Mariosizesig_Y),
        .Stage_X_Max(Stage_X_Max),
        .Stage_X_Min(Stage_X_Min),
        .Stage_Y_Max(Stage_Y_Max),
        .Stage_Y_Min(Stage_Y_Min),
        .jump_on_mario(jump_on_mario),
        .Mario_Fall_Counter
    );
    Luigi  luigi_instance ( 
        .Reset(reset_ah), 
        .frame_clk(vsync),
		.keycode(keycode0_gpio[7:0]),
        .Stage_X_Max(Stage_X_Max), 
        .Stage_X_Min(Stage_X_Min), 
        .Stage_Y_Max(Stage_Y_Max), 
        .Stage_Y_Min(Stage_Y_Min),
        .LuigiX(Luigixsig), 
        .LuigiY(Luigiysig), 
        .LuigiS_X(Luigisizesig_X), 
        .LuigiS_Y(Luigisizesig_Y),
        .edge_below_luigi(edge_below_luigi),
        .jump_on_luigi(jump_on_luigi),
        .Luigi_Fall_Counter(Luigi_Fall_Counter));
    
    //Color Mapper Module   
    color_mapper color_instance(
        .Mario_State_Out(Mario_State_Out),
        .Luigi_State_Out(Luigi_State_Out),
        .Mario_Invert_Left(Mario_Invert_Left),
        .Luigi_Invert_Left(Luigi_Invert_Left),
        .MarioX(Marioxsig),
        .MarioY(Marioysig),
        .LuigiX(Luigixsig), 
        .LuigiY(Luigiysig), 
        .Luigi_size_X(Luigisizesig_X), 
        .Luigi_size_Y(Luigisizesig_Y),
        .DrawX(drawX),
        .DrawY(drawY),
        .Mario_size_X(Mariosizesig_X),
        .Mario_size_Y(Mariosizesig_Y),
        .Red(red),
        .Green(green),
        .Blue(blue),
        .Clk,
        .Stage_X_Max(Stage_X_Max), 
        .Stage_X_Min(Stage_X_Min), 
        .Stage_Y_Max(Stage_Y_Max), 
        .Stage_Y_Min(Stage_Y_Min),
        .Mario_Fall_Counter,
        .Luigi_Fall_Counter
    );
    
endmodule
