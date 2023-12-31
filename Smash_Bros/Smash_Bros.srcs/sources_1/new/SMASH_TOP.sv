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
    logic clk_25MHz, clk_125MHz, clk, clk_100MHz, clk_50MHz;
    logic locked, locked1;
    logic [9:0] drawX, drawY, Marioxsig, Marioysig, Mariosizesig_X, Mariosizesig_Y;
    logic [9:0] Luigixsig, Luigiysig, Luigisizesig_X, Luigisizesig_Y;
    logic hsync, vsync, vde;
    logic [3:0] red, green, blue;
    logic reset_ah;
    logic Mario_Invert_Left;
    logic Luigi_Invert_Left;
    logic [4:0] Mario_State_Out;
    logic [4:0] Luigi_State_Out;
    logic edge_below_mario;
    logic jump_on_mario;
    logic edge_below_luigi;
    logic jump_on_luigi;
    logic [25:0]Mario_Fall_Counter;
    logic [25:0]Luigi_Fall_Counter;
    logic [7:0] Mario_Priority_1, Luigi_Priority_1;
    logic punch_on_mario, punch_on_luigi;
    logic Stop_Mario_Left, Stop_Mario_Right, Stop_Mario_Up, Stop_Mario_Down;
    logic Stop_Luigi_Left, Stop_Luigi_Right, Stop_Luigi_Up, Stop_Luigi_Down;
    logic Luigi_Movement_Lockout, Mario_Movement_Lockout;
    logic Mario_Right_Punch_Sucessful, Mario_Left_Punch_Sucessful, Luigi_Right_Punch_Sucessful, Luigi_Left_Punch_Sucessful;
    logic [6:0] Mario_Percent, Luigi_Percent;
    logic [3:0] Mario_Percent_Plus, Luigi_Percent_Plus;
    logic Top_Bottom_Test;

    //logic [7:0] Mario_Priority_2;
    assign reset_ah = reset_rtl_0;
    logic reset_mario;
    logic reset_luigi;
always_comb begin
    reset_mario = 0;
    reset_luigi = 0;
    if (keycode0_gpio[7:0] == 8'h3c) begin 
        reset_mario = 1;
        reset_luigi = 1;
    end
    else begin
    reset_mario = 0;
    reset_luigi = 0;
    end   
    
end
// always_comb begin
//     reset_luigi = 0;
//     if (keycode0_gpio[7:0] == 8'h0f) begin 
//         reset_luigi = 1;
//     end
//     else begin
//     reset_luigi = 0;
//     end   
// end
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

    
        clk_wiz_1 clk_wiz1 (
        .clk_out1(clk_50MHz),
        .reset(reset_ah),
        .locked(locked1),
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
        .Clk(clk_50MHz), 
		.Reset(reset_ah),
        .keycode(Mario_Priority_1),
        .edge_below_mario(edge_below_mario),
		.Mario_State_Out(Mario_State_Out),
        .Mario_Invert_Left(Mario_Invert_Left),
        .punch_on_mario(punch_on_mario)
				);
    Luigi_State Luigi_State0 (
                .Clk(clk_50MHz), 
                .Reset(reset_ah),
                .keycode(Luigi_Priority_1),
                .edge_below_luigi(edge_below_luigi),
                .jump_on_luigi(jump_on_luigi),
                .Luigi_State_Out(Luigi_State_Out),
                .Luigi_Invert_Left(Luigi_Invert_Left),
                .punch_on_luigi(punch_on_luigi)
                        
    );
    //Mario Module
    Mario mario_instance(
        .Reset(reset_mario),
        .frame_clk(vsync),                    //Figure out what this should be so that the Mario will move
        .keycode(Mario_Priority_1),    //Notice: only one keycode connected to Mario by default
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
        .Mario_Fall_Counter,
        .Stop_Mario_Left, .Stop_Mario_Right, .Stop_Mario_Up, .Stop_Mario_Down,
        .Mario_Percent,
        .Luigi_Right_Punch_Sucessful,
        .Luigi_Left_Punch_Sucessful
    );
    Luigi  luigi_instance ( 
        .Reset(reset_luigi), 
        .frame_clk(vsync),
		.keycode(Luigi_Priority_1),
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
        .Luigi_Fall_Counter(Luigi_Fall_Counter),
        .Stop_Luigi_Left, .Stop_Luigi_Right, .Stop_Luigi_Up, .Stop_Luigi_Down,
        .Luigi_Percent,
        .Mario_Right_Punch_Sucessful,
        .Mario_Left_Punch_Sucessful
        );
    
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
        .Clk(clk_50MHz),
        .Stage_X_Max(Stage_X_Max), 
        .Stage_X_Min(Stage_X_Min), 
        .Stage_Y_Max(Stage_Y_Max), 
        .Stage_Y_Min(Stage_Y_Min),
        .Mario_Fall_Counter,
        .Luigi_Fall_Counter,
        .Mario_Movement_Lockout(Top_Bottom_Test),
        .Mario_Percent,
        .Mario_Percent_Plus,
        .Luigi_Percent,
        .Luigi_Percent_Plus
    );
    Key_Hierarchy_Mario KHM0(
        .Full_Keycodes({keycode1_gpio[15:0], keycode0_gpio}),
        .edge_below_mario(edge_below_mario),
        .Mario_Priority_1(Mario_Priority_1),
        .punch_on_mario(punch_on_mario),
        .Mario_Movement_Lockout
    );

     Key_Hierarchy_Luigi KHL0(
        .Full_Keycodes({keycode1_gpio[15:0], keycode0_gpio}),
        .edge_below_luigi(edge_below_luigi),
        .Luigi_Priority_1(Luigi_Priority_1),
        .punch_on_luigi(punch_on_luigi),
        .Luigi_Movement_Lockout
    );
    Game_Logic Game_Logic0(
        .Mario_size_X(Mariosizesig_X),
        .Mario_size_Y(Mariosizesig_Y),
        .Mario_Invert_Left(Mario_Invert_Left),
        .Luigi_Invert_Left(Luigi_Invert_Left),
        .MarioX(Marioxsig),
        .MarioY(Marioysig),
        .LuigiX(Luigixsig), 
        .LuigiY(Luigiysig), 
        .Luigi_size_X(Luigisizesig_X), 
        .Luigi_size_Y(Luigisizesig_Y),
        .Stop_Mario_Left, .Stop_Mario_Right, .Stop_Mario_Up, .Stop_Mario_Down,
        .Stop_Luigi_Left, .Stop_Luigi_Right, .Stop_Luigi_Up, .Stop_Luigi_Down,
        .Mario_State(Mario_State_Out),
        .Luigi_State(Luigi_State_Out),
        .Clk(clk_50MHz),
        .frame_clk(vsync),
        .Luigi_Movement_Lockout, 
        .Mario_Movement_Lockout,
        .Mario_Percent,
        .Mario_Right_Punch_Sucessful,
        .Mario_Left_Punch_Sucessful,
        .Luigi_Percent,
        .Luigi_Right_Punch_Sucessful,
        .Luigi_Left_Punch_Sucessful,
        .Top_Bottom_Test,
        .Luigi_Percent_Plus,
        .Mario_Percent_Plus,
        .Reset_Percent(reset_mario)
);

    
endmodule
