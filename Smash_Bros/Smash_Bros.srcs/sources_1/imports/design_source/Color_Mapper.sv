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
                       input  logic [9:0] LuigiX, LuigiY, Luigi_size_X, Luigi_size_Y,
                       input logic Clk,
                       input logic [4:0] Mario_State_Out,
                       input logic [4:0] Luigi_State_Out,
                       input logic Mario_Invert_Left,
                       input logic Luigi_Invert_Left, Mario_Movement_Lockout,
                       input logic [25:0] Mario_Fall_Counter,
                       input logic [25:0] Luigi_Fall_Counter,
                       input logic [6:0] Luigi_Percent, Mario_Percent,
                       input logic [3:0] Mario_Percent_Plus, Luigi_Percent_Plus,
                       output logic [3:0]  Red, Green, Blue,
                       output logic[9:0] Stage_X_Max, Stage_X_Min, Stage_Y_Max, Stage_Y_Min);

    logic Mario_on;
    logic [12:0] Mario_address, ADDR0X_Mario, ADDR0Y_Mario, ADDR_X_OFFSET_Mario, ADDR_Y_OFFSET_Mario;
    logic [12:0] Character_address;
    logic Luigi_on;
    logic [12:0] Luigi_address, ADDR0X_Luigi, ADDR0Y_Luigi, ADDR_X_OFFSET_Luigi, ADDR_Y_OFFSET_Luigi;
    logic [1:0] Palette_Index_Stationary_Mario;
    logic [1:0] Palette_Index_Walking1_Mario, Palette_Index_Walking2_Mario, Palette_Index_Walking3_Mario, Palette_Index_Jumping_Mario,
     Palette_Index_Punching1_Mario, Palette_Index_Punching2_Mario;
    logic [1:0] Palette_Index_Mario;
    logic [1:0] Palette_Index_Luigi;
    logic [2:0] Palette_Index_Background;
    logic [11:0] Palette_Output_Score_Luigi, Palette_Output_Mario,Palette_Output_Score, Palette_Output_Score20, Palette_Output_Score40, Palette_Output_Score60, Palette_Output_Score80, Palette_Output_Score100;
    logic [11:0] Palette_Output_Luigi;
    logic [11:0] Palette_Output_Background;
    logic [18:0] Background_address;
    logic [11:0] Mario_Score_Adress, Luigi_Score_Adress;
    logic Background_on;
    logic [7:0] lowest_number_data, second_number_data, highest_number_data;
    logic Palette_Index_Score, Palette_Index_Score0, Palette_Index_Score20, Palette_Index_Score40, Palette_Index_Score60, Palette_Index_Score80, Palette_Index_Score100;
     logic LPalette_Index_Score, LPalette_Index_Score0, LPalette_Index_Score20, LPalette_Index_Score40, LPalette_Index_Score60, LPalette_Index_Score80, LPalette_Index_Score100;
    int    Lowest_Number; 
    int Second_Number;
    int Highest_Number; 
    //logic [9:0] Stage_X_Max, Stage_X_Min, Stage_Y_Max, Stage_Y_Min;



    // int Size_X_Mario, Size_Y_Mario;
    // assign Size_X_Mario = Mario_size_X;
    // assign Size_Y_Mario = Mario_size_Y;
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

    int DistX_Luigi, DistY_Luigi, Luigi_Rowsize;
    assign DistX_Luigi = 30;
    assign DistY_Luigi = 40;
    assign Luigi_Rowsize = 60;
    assign ADDR0X_Luigi = LuigiX - DistX_Luigi;
    assign ADDR0Y_Luigi = LuigiY - DistY_Luigi;
    //assign Background_address = (DrawY*640) + DrawX;

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

    always_comb begin
        ADDR_X_OFFSET_Luigi = DrawX - ADDR0X_Luigi;
        ADDR_Y_OFFSET_Luigi = DrawY - ADDR0Y_Luigi;
        if(Luigi_Invert_Left == 0) begin
            Luigi_address = ADDR_X_OFFSET_Luigi + ADDR_Y_OFFSET_Luigi*Luigi_Rowsize; // mario is right
        end
        else begin
            Luigi_address = (60-ADDR_X_OFFSET_Luigi) + ADDR_Y_OFFSET_Luigi*Luigi_Rowsize;
        end
    
    if(Luigi_on) begin
        Character_address = Luigi_address;
    end
    else begin
        Character_address = Mario_address;
    end
    end

    always_comb begin
        Mario_Score_Adress = ( DrawX-200) +(DrawY*75);
        Luigi_Score_Adress = (DrawX- 365) +(DrawY*75);

    end

    Mario_Stationary_RAM Mario_Stationary_ROM (
		.read_address(Character_address),
		.Clk(Clk),
		.data_Out(Palette_Index_Stationary_Mario)
    );

    Mario_Walking_RAM1 Mario_Walking1_ROM (
		.read_address(Character_address),
		.Clk(Clk),
		.data_Out(Palette_Index_Walking1_Mario)
    );
    Mario_Walking_RAM2 Mario_Walking2_ROM (
		.read_address(Character_address),
		.Clk(Clk),
		.data_Out(Palette_Index_Walking2_Mario)
    );
    Mario_Walking_RAM3 Mario_Walking3_ROM (
		.read_address(Character_address),
		.Clk(Clk),
		.data_Out(Palette_Index_Walking3_Mario)
    );
    Smash_Background Smash_Background0(.read_address(Background_address), .Clk, .data_Out(Palette_Index_Background));
   
    zero_health_ROM zero_health_ROM(.read_address(Mario_Score_Adress),.Clk, .data_Out(Palette_Index_Score0));
   twenty_health_ROM twenty_health_ROM(.read_address(Mario_Score_Adress),.Clk, .data_Out(Palette_Index_Score20));
   forty_health_ROM forty_health_ROM(.read_address(Mario_Score_Adress),.Clk, .data_Out(Palette_Index_Score40));
  sixty_health_ROM sixty_health_ROM(.read_address(Mario_Score_Adress),.Clk, .data_Out(Palette_Index_Score60));
   eighty_health_ROM eighty_health_ROM(.read_address(Mario_Score_Adress),.Clk, .data_Out(Palette_Index_Score80));
    one_hundred_health_ROM one_hundred_health_ROM(.read_address(Mario_Score_Adress),.Clk, .data_Out(Palette_Index_Score100));

    zero_health_ROM Lzero_health_ROM(.read_address(Luigi_Score_Adress),.Clk, .data_Out(LPalette_Index_Score0));
   twenty_health_ROM Ltwenty_health_ROM(.read_address(Luigi_Score_Adress),.Clk, .data_Out(LPalette_Index_Score20));
   forty_health_ROM Lforty_health_ROM(.read_address(Luigi_Score_Adress),.Clk, .data_Out(LPalette_Index_Score40));
  sixty_health_ROM Lsixty_health_ROM(.read_address(Luigi_Score_Adress),.Clk, .data_Out(LPalette_Index_Score60));
  eighty_health_ROM Leighty_health_ROM(.read_address(Luigi_Score_Adress),.Clk, .data_Out(LPalette_Index_Score80));
    one_hundred_health_ROM Lone_hundred_health_ROM(.read_address(Luigi_Score_Adress),.Clk, .data_Out(LPalette_Index_Score100));


    Mario_Jumping_RAM1 Mario_Jumping_ROM (
		.read_address(Character_address),
		.Clk(Clk),
		.data_Out(Palette_Index_Jumping_Mario)
    );

    Mario_Punching_1_RAM1 Mario_Punching1_ROM (
		.read_address(Character_address),
		.Clk(Clk),
		.data_Out(Palette_Index_Punching1_Mario)
    );

    Mario_Punching_2_RAM1 Mario_Punching2_ROM (
		.read_address(Character_address),
		.Clk(Clk),
		.data_Out(Palette_Index_Punching2_Mario)
    );
logic Index_Second, Index_Highest;
logic Percent_Reset;

always_comb begin
if(Mario_Percent > 100)begin
    Percent_Reset = 1'b1;
end
else begin
    Percent_Reset = 1'b0;
end
end
always_ff @( posedge Clk)begin
    if(~Percent_Reset)begin
        if((Mario_Percent_Plus != 0) && ((Lowest_Number/10) < 1)) begin
            Lowest_Number <= Lowest_Number + Mario_Percent_Plus;
            Index_Second <= 0;
        end 
    else if((((Lowest_Number/10) >= 1) && ((Lowest_Number/10) < 2) ))begin
        Lowest_Number <= 0;
        Index_Second <= 1;
    end
    else begin
        Lowest_Number <= Lowest_Number;
        Index_Second <= 0;

    end 
    end
    else begin
        Lowest_Number <= 0;
        Index_Second <= 0;
    end
end
always_ff @ ( posedge Clk)begin
    if(~Percent_Reset) begin
    if(Index_Second && ((Second_Number/10)<1)) begin
    Second_Number <= Second_Number +1;
    Index_Highest <= 0;
    end
    else if(((Lowest_Number/10) >= 1) && ((Lowest_Number/10) < 2) ) begin
        Second_Number <= 0;
        Index_Highest <= 1;
    end
    else begin
        Second_Number <= Second_Number;
        Index_Highest <= 0;
    end
    end
    else begin
        Second_Number <= 0;
        Index_Highest <= 0;
    end
end
always_ff @ ( posedge Clk)begin
       if(~Percent_Reset) begin
    if(Index_Highest) begin
    Highest_Number <= Highest_Number +1;
    end
    else begin
        Highest_Number <= Highest_Number;
    end
    end
    else begin
        Highest_Number <= 0;
    end
end

    number_font_rom lowest_number_font_rom(.addr({0,DrawY[3:0]}), .data(lowest_number_data)); // Lowest_Number[3:0]// Mario Percent May be able to be changed to lowest number
    number_font_rom second_number_font_rom(.addr({0,DrawY[3:0]}), .data(second_number_data));// Second_Number[3:0]
   number_font_rom  highest_number_font_rom(.addr({0,DrawY[3:0]}), .data(highest_number_data)); //Highest_Number[3:0]

    
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
        //// LUIGI STATES

        if(Luigi_State_Out == 0 || Luigi_State_Out == 1)begin
            Palette_Index_Luigi = Palette_Index_Stationary_Mario;
        end
        else if(Luigi_State_Out == 2 ||Luigi_State_Out == 5) begin
            Palette_Index_Luigi = Palette_Index_Walking1_Mario;
        end
        else if(Luigi_State_Out == 3 ||Luigi_State_Out == 6) begin
            Palette_Index_Luigi = Palette_Index_Walking2_Mario;
        end
        else if(Luigi_State_Out == 4 ||Luigi_State_Out == 7) begin
            Palette_Index_Luigi = Palette_Index_Walking3_Mario;
        end
        else if(Luigi_State_Out == 8 || Luigi_State_Out == 9 || Luigi_State_Out == 10 || Luigi_State_Out == 11)begin
            Palette_Index_Luigi = Palette_Index_Jumping_Mario;
        end
        else if(Luigi_State_Out == 12 || Luigi_State_Out == 14)begin
            Palette_Index_Luigi = Palette_Index_Punching1_Mario;
        end
        else if(Luigi_State_Out == 13 || Luigi_State_Out == 15)begin
            Palette_Index_Luigi = Palette_Index_Punching2_Mario;
        end
        else begin
            Palette_Index_Luigi = 2'b01; // if for some reason we are not in one of the defined states, print red
        end
    end
    //end

    always_comb begin
        Palette_Index_Score = 0; 
        if(Mario_Percent<20)begin
        Palette_Index_Score  = Palette_Index_Score0;
        end

        if(Mario_Percent>=20 && Mario_Percent<40)begin
        Palette_Index_Score  = Palette_Index_Score20;
        end

        if(Mario_Percent>=40 && Mario_Percent<60)begin
        Palette_Index_Score  = Palette_Index_Score40;
        end

        if(Mario_Percent>=60 && Mario_Percent<80)begin
        Palette_Index_Score  = Palette_Index_Score60;
        end

        if(Mario_Percent>=80 && Mario_Percent<100)begin
        Palette_Index_Score  = Palette_Index_Score80;
        end

        if(Mario_Percent>100)begin
        Palette_Index_Score  = Palette_Index_Score100;
        end
        else begin
            Palette_Index_Score = Palette_Index_Score;
        end
    end

        always_comb begin 
        LPalette_Index_Score = 0; 
        if(Luigi_Percent<20)begin
        LPalette_Index_Score  = LPalette_Index_Score0;
        end

        if(Luigi_Percent>=20 && Luigi_Percent<40)begin
        LPalette_Index_Score  = LPalette_Index_Score20;
        end

        if(Luigi_Percent>=40 && Luigi_Percent<60)begin
        LPalette_Index_Score  = LPalette_Index_Score40;
        end

        if(Luigi_Percent>=60 && Luigi_Percent<80)begin
        LPalette_Index_Score  = LPalette_Index_Score60;
        end

        if(Luigi_Percent>=80 && Luigi_Percent<100)begin
        LPalette_Index_Score  = LPalette_Index_Score80;
        end

        if(Luigi_Percent>100)begin
        LPalette_Index_Score  = Palette_Index_Score100;
        end
        else begin
            LPalette_Index_Score = LPalette_Index_Score;
        end
    end
    Palette_Mario Palette_Mario0(.addr(Palette_Index_Mario), .data(Palette_Output_Mario));

    Palette_Luigi Palette_Luigi0(.addr(Palette_Index_Luigi), .data(Palette_Output_Luigi)); // NEED TO CHANGE THIS MODULE TO LUIGI COLORS AFTER
    // NEED TO CREATE A NEW PALETTE FOR ONLY BACKGROUND AND PUT IT HERE
    Palette_Background(.addr(Palette_Index_Background), .data(Palette_Output_Background));

    Palette_Score Palette_Score0(.addr(Palette_Index_Score), .data(Palette_Output_Score));
    Palette_Score Palette_Score1(.addr( LPalette_Index_Score), .data(Palette_Output_Score_Luigi));


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

        if ((DrawX >= LuigiX - Luigi_size_X) &&
            (DrawX <= LuigiX + Luigi_size_X) &&
            (DrawY >= LuigiY - Luigi_size_Y) &&
            (DrawY <= LuigiY + Luigi_size_Y)) begin

            Luigi_on = 1'b1;
       end
        else
            Luigi_on = 1'b0;
     end

    always_comb
    begin:RGB_Display
    if(DrawX < 200 && DrawY < 30) begin
        if(DrawX<50) begin
            if(Mario_Percent >20) begin
                Red <= 4'hf;
                Green <= 4'h0;
                Blue <= 4'h0;
            end

            
            else begin
                Red <= 4'hf;
                Green <= 4'hf;
                Blue <= 4'hf;
            end
        end
        else if(DrawX >= 50 && DrawX <100) begin
            if(Mario_Percent >40) begin
                Red <= 4'hf;
                Green <= 4'h0;
                Blue <= 4'h0;
            end

            
            else begin
                Red <= 4'hf;
                Green <= 4'hf;
                Blue <= 4'hf;
            end            
        end
        else if(DrawX >=100 && DrawX<150)begin
            if(Mario_Percent >60) begin
                Red <= 4'hf;
                Green <= 4'h0;
                Blue <= 4'h0;
            end

            
            else begin
                Red <= 4'hf;
                Green <= 4'hf;
                Blue <= 4'hf;
            end 
        end
        else if (DrawX >= 150 && DrawX < 200)begin
            if(Mario_Percent >80) begin
                Red <= 4'hf;
                Green <= 4'h0;
                Blue <= 4'h0;
            end
            else begin
                Red <= 4'hf;
                Green <= 4'hf;
                Blue <= 4'hf;
            end 
        end
        else begin
            Red <= 4'h0;
                Green <= 4'h0;
                Blue <= 4'hf;
        end
    end
    //end 
    else if(DrawX > 440 && DrawY <30) begin
          if(DrawX<490) begin
            if(Luigi_Percent >20) begin
                Red <= 4'hf;
                Green <= 4'h0;
                Blue <= 4'h0;
            end

            
            else begin
                Red <= 4'hf;
                Green <= 4'hf;
                Blue <= 4'hf;
            end
        end
        else if(DrawX >= 490 && DrawX <540) begin
            if(Luigi_Percent >40) begin
                Red <= 4'hf;
                Green <= 4'h0;
                Blue <= 4'h0;
            end

            
            else begin
                Red <= 4'hf;
                Green <= 4'hf;
                Blue <= 4'hf;
            end            
        end
        else if(DrawX >=540 && DrawX<590)begin
            if(Luigi_Percent >60) begin
                Red <= 4'hf;
                Green <= 4'h0;
                Blue <= 4'h0;
            end

            
            else begin
                Red <= 4'hf;
                Green <= 4'hf;
                Blue <= 4'hf;
            end 
        end
        else if (DrawX >= 590 && DrawX < 640)begin
            if(Luigi_Percent >80) begin
                Red <= 4'hf;
                Green <= 4'h0;
                Blue <= 4'h0;
            end
            else begin
                Red <= 4'hf;
                Green <= 4'hf;
                Blue <= 4'hf;
            end 
        end
        else begin
            Red <= 4'h0;
                Green <= 4'h0;
                Blue <= 4'hf;
        end
      

      
    end
    else if((DrawX>=200 && DrawX<275) && DrawY <30) begin
             Red <= Palette_Output_Score[11:8]; 
            Green <= Palette_Output_Score[7:4];
            Blue <= Palette_Output_Score[3:0];
    end

    else if((DrawX>=365 && DrawX<440) && DrawY <30) begin
             Red <= Palette_Output_Score_Luigi[11:8]; 
            Green <= Palette_Output_Score_Luigi[7:4];
            Blue <= Palette_Output_Score_Luigi[3:0];
    end

    else begin
        
    //end
    //else begin /// need to comment this out when not testing
        if(Mario_on && (Palette_Output_Mario != 12'h808)) begin
             Red <= Palette_Output_Mario[11:8];
             Green <= Palette_Output_Mario[7:4];
             Blue <= Palette_Output_Mario[3:0];
             //on_background = 0;
        end
        else if(Luigi_on && (Palette_Output_Luigi != 12'h808)) begin
             Red <= Palette_Output_Luigi[11:8];
             Green <= Palette_Output_Luigi[7:4];
             Blue <= Palette_Output_Luigi[3:0];
        end
        else if ((DrawY>Stage_Y_Min) && (DrawY<Stage_Y_Max)&& (DrawX<Stage_X_Max) && (DrawX>Stage_X_Min)) begin
            Red <= 4'hf;
            Green <= 4'h7;
            Blue <= 4'h0;
            //on_background = 0;
        end

        // else if(DrawY<16 && DrawX>=64 && DrawX <88)begin
        //     if(DrawX>=64 && DrawX<72)begin
        //        if (highest_number_data[DrawX[2:0]] == 1)begin
        //             Red <= 4'hf;
        //             Green <= 4'hf;
        //             Blue <= 4'hf;
        //        end
        //        else begin
                
        //         Red <= Palette_Output_Background[11:8]; 
        //         Green <= Palette_Output_Background[7:4];
        //         Blue <= Palette_Output_Background[3:0];
        //        end
        //      end

        //     if(DrawX>=72 && DrawX<80)begin
        //             if (second_number_data[DrawX[2:0]] == 1)begin
        //             Red <= 4'hf;
        //             Green <= 4'hf;
        //             Blue <= 4'hf;
        //        end
        //        else begin
                
        //         Red <= Palette_Output_Background[11:8]; 
        //         Green <= Palette_Output_Background[7:4];
        //         Blue <= Palette_Output_Background[3:0];
        //        end
               
        //     end

        //     if(DrawX>=80 && DrawX<88)begin
        //                        if (lowest_number_data[DrawX[2:0]] == 1)begin
        //             Red <= 4'hf;
        //             Green <= 4'hf;
        //             Blue <= 4'hf;
        //        end
        //        else begin
                
        //         Red <= Palette_Output_Background[11:8]; 
        //         Green <= Palette_Output_Background[7:4];
        //         Blue <= Palette_Output_Background[3:0];
        //        end
        //     end
        // end

        else begin
            //on_background = 1;
            // Red = 4'hf; /// FIX FIX FIX FIX FIX
            // Green = 4'hf; // PUT THE BACKGROUND COLOR OUTPUT HERE
            // Blue = 4'hf; // SWITCH TO THE COMMENTED VERSION BELOW ONCE NEW PALETTE IS MADE

            Red <= Palette_Output_Background[11:8]; 
            Green <= Palette_Output_Background[7:4];
            Blue <= Palette_Output_Background[3:0];
        end
    end
    end // need to comment this out when not testing
    //end
endmodule
