//-------------------------------------------------------------------------
//    Color_Mapper.sv                                                    --
//    Stephen Kempf                                                      --
//    3-1-06                                                             --
//                                                                       --
//    Modified by David Kesler  07-16-2008                               --
//    Translated by Joe Meng    07-07-2013                               --
//    Modified by Zuofu Cheng   08-19-2023                               --
//                                                                       --
//    Fall 2023 Distribution                                             --
//                                                                       --
//    For use with ECE 385 USB + HDMI                                    --
//    University of Illinois ECE Department                              --
//-------------------------------------------------------------------------


module  color_mapper ( input  logic [9:0] MarioX, MarioY, DrawX, DrawY, Mario_size_X, Mario_size_Y,
                       input logic Clk,
                       input logic [4:0] Mario_State_Out,
                       input logic Mario_Invert_Left,
                       input logic [25:0] Mario_Fall_Counter,
                       output logic [3:0]  Red, Green, Blue,
                       output logic[9:0] Stage_X_Max, Stage_X_Min, Stage_Y_Max, Stage_Y_Min);

    logic Mario_on;
    logic [12:0] Mario_address, ADDR0X_Mario, ADDR0Y_Mario, ADDR_X_OFFSET_Mario, ADDR_Y_OFFSET_Mario;
    logic [1:0] Palette_Index_Stationary_Mario;
    logic [1:0] Palette_Index_Walking1_Mario, Palette_Index_Walking2_Mario, Palette_Index_Walking3_Mario, Palette_Index_Jumping_Mario,
     Palette_Index_Punching1_Mario, Palette_Index_Punching2_Mario;
    logic [1:0] Palette_Index_Mario;
    logic [2:0] Palette_Index_Background;
    logic [11:0] Palette_Output_Mario;
    logic [11:0] Palette_Output_Background;
    logic [18:0] Background_address;
    logic Background_on;
    //logic [9:0] Stage_X_Max, Stage_X_Min, Stage_Y_Max, Stage_Y_Min;



    int Size_X, Size_Y;
    assign Size_X = Mario_size_X;
    assign Size_Y = Mario_size_Y;
    assign Stage_X_Max = 540;
    assign Stage_X_Min = 100;
    assign Stage_Y_Max = 430;
    assign Stage_Y_Min = 400;

    int DistX_Mario, DistY_Mario, Mario_Rowsize;
    assign DistX_Mario = 30;
    assign DistY_Mario = 40;
    assign Mario_Rowsize = 60;
    assign ADDR0X_Mario = MarioX - DistX_Mario;
    assign ADDR0Y_Mario = MarioY - DistY_Mario;
    assign Background_address = (DrawY*640) + DrawX;
    //assign on_background = 0;
    always_comb begin
        ADDR_X_OFFSET_Mario = DrawX - ADDR0X_Mario;
        ADDR_Y_OFFSET_Mario = DrawY - ADDR0Y_Mario;
        if(Mario_Invert_Left == 0) begin
            Mario_address = ADDR_X_OFFSET_Mario + ADDR_Y_OFFSET_Mario*Mario_Rowsize; // mario is right
        end
        else begin
            Mario_address = (60-ADDR_X_OFFSET_Mario) + ADDR_Y_OFFSET_Mario*Mario_Rowsize;
        end
    end



    Mario_Stationary_RAM Mario_Stationary_ROM (
		.read_address(Mario_address),
		.Clk(Clk),
		.data_Out(Palette_Index_Stationary_Mario)
    );

    Mario_Walking_RAM1 Mario_Walking1_ROM (
		.read_address(Mario_address),
		.Clk(Clk),
		.data_Out(Palette_Index_Walking1_Mario)
    );
    Mario_Walking_RAM2 Mario_Walking2_ROM (
		.read_address(Mario_address),
		.Clk(Clk),
		.data_Out(Palette_Index_Walking2_Mario)
    );
    Mario_Walking_RAM3 Mario_Walking3_ROM (
		.read_address(Mario_address),
		.Clk(Clk),
		.data_Out(Palette_Index_Walking3_Mario)
    );
    Smash_Background Smash_Background0(.read_address(Background_address), .Clk, .data_Out(Palette_Index_Background));

    Mario_Jumping_RAM1 Mario_Jumping_ROM (
		.read_address(Mario_address),
		.Clk(Clk),
		.data_Out(Palette_Index_Jumping_Mario)
    );

    Mario_Punching_1_RAM1 Mario_Punching1_ROM (
		.read_address(Mario_address),
		.Clk(Clk),
		.data_Out(Palette_Index_Punching1_Mario)
    );

    Mario_Punching_2_RAM1 Mario_Punching2_ROM (
		.read_address(Mario_address),
		.Clk(Clk),
		.data_Out(Palette_Index_Punching2_Mario)
    );
    //REDOINK THIS KUD TI HAVE 0-7 PALETTE INDEXES

    always_comb begin
    // if(Background_on) begin // check background first
    // Palette_Index = Palette_Index_Background; //// FIX FIX FIX FIX
    // end
    // else begin // else do mario
    
        if(Mario_State_Out == 0 || Mario_State_Out == 1)begin
            Palette_Index_Mario = Palette_Index_Stationary_Mario;
        end
        else if(Mario_State_Out == 2 ||Mario_State_Out == 5) begin
            Palette_Index_Mario = Palette_Index_Walking1_Mario;
        end
        else if(Mario_State_Out == 3 ||Mario_State_Out == 6) begin
            Palette_Index_Mario = Palette_Index_Walking2_Mario;
        end
        else if(Mario_State_Out == 4 ||Mario_State_Out == 7) begin
            Palette_Index_Mario = Palette_Index_Walking3_Mario;
        end
        else if(Mario_State_Out == 8 || Mario_State_Out == 9 || Mario_State_Out == 10 || Mario_State_Out == 11)begin
            Palette_Index_Mario = Palette_Index_Jumping_Mario;
        end
        else if(Mario_State_Out == 12 || Mario_State_Out == 14)begin
            Palette_Index_Mario = Palette_Index_Punching1_Mario;
        end
        else if(Mario_State_Out == 13 || Mario_State_Out == 15)begin
            Palette_Index_Mario = Palette_Index_Punching2_Mario;
        end
        else begin
            Palette_Index_Mario = 2'b01; // if for some reason we are not in one of the defined states, print red
        end
    end
    //end
    
    Palette_Mario(.addr(Palette_Index_Mario), .data(Palette_Output_Mario));
    // NEED TO CREATE A NEW PALETTE FOR ONLY BACKGROUND AND PUT IT HERE
    Palette_Background(.addr(Palette_Index_Background), .data(Palette_Output_Background));

    always_comb
    begin:Mario_on_proc
        if ((DrawX >= MarioX - Mario_size_X) &&
            (DrawX <= MarioX + Mario_size_X) &&
            (DrawY >= MarioY - Mario_size_Y) &&
            (DrawY <= MarioY + Mario_size_Y)) begin

            Mario_on = 1'b1;
            //Background_on = 1'b0;
       end
        else
            Mario_on = 1'b0;
            //Background_on = 1'b1;
     end

    always_comb
    begin:RGB_Display
    // if(DrawX < 50 && DrawY < 50) begin
    //     if(Mario_Fall_Counter < 10) begin
    //         Red = 4'hf;
    //          Green = 4'hf;
    //          Blue = 4'hf;
    //     end
    //     else if(Mario_Fall_Counter < 20 && Mario_Fall_Counter >= 10) begin
    //         Red = 4'hB;
    //          Green = 4'hB;
    //          Blue = 4'hB;
    //     end
    //     else if(Mario_Fall_Counter < 30 && Mario_Fall_Counter >=20) begin
    //         Red = 4'h7;
    //          Green = 4'h7;
    //          Blue = 4'h7;
    //     end
        
    //      else if(Mario_Fall_Counter > 30 ) begin
    //         Red = 4'h0;
    //          Green = 4'h0;
    //          Blue = 4'h0;
    //     end
    // end
    // else begin /// need to comment this out when not testing
        if(Mario_on && (Palette_Output_Mario != 12'h808)) begin
             Red = Palette_Output_Mario[11:8];
             Green = Palette_Output_Mario[7:4];
             Blue = Palette_Output_Mario[3:0];
             //on_background = 0;
        end
        else if ((DrawY>Stage_Y_Min) && (DrawY<Stage_Y_Max)&& (DrawX<Stage_X_Max) && (DrawX>Stage_X_Min)) begin
            Red = 4'hf;
            Green = 4'h7;
            Blue = 4'h0;
            //on_background = 0;
        end

        else begin
            //on_background = 1;
            // Red = 4'hf; /// FIX FIX FIX FIX FIX
            // Green = 4'hf; // PUT THE BACKGROUND COLOR OUTPUT HERE
            // Blue = 4'hf; // SWITCH TO THE COMMENTED VERSION BELOW ONCE NEW PALETTE IS MADE

            Red = Palette_Output_Background[11:8]; 
            Green = Palette_Output_Background[7:4];
            Blue = Palette_Output_Background[3:0];
        end
    end
    //end // need to comment this out when not testing
endmodule
