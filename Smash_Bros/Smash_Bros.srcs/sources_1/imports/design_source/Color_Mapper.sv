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
                       output logic [3:0]  Red, Green, Blue );
    
    logic Mario_on;
    logic [12:0] Mario_address, ADDR0X_Mario, ADDR0Y_Mario, ADDR_X_OFFSET_Mario, ADDR_Y_OFFSET_Mario;
    logic [1:0] Palette_Index_Stationary;
    logic [1:0] Palette_Index_Walking1, Palette_Index_Walking2, Palette_Index_Walking3;
    logic [1:0] Palette_Index;
    logic [11:0] Palette_Output;
	 
 
	  
    int Size_X, Size_Y;
    assign Size_X = Mario_size_X;
    assign Size_Y = Mario_size_Y;

    int DistX_Mario, DistY_Mario, Mario_Rowsize;
    assign DistX_Mario = 30;
    assign DistY_Mario = 40;
    assign Mario_Rowsize = 60;
    assign ADDR0X_Mario = MarioX - DistX_Mario;
    assign ADDR0Y_Mario = MarioY - DistY_Mario;
    always_comb begin
        ADDR_X_OFFSET_Mario = DrawX - ADDR0X_Mario;
        ADDR_Y_OFFSET_Mario = DrawY - ADDR0Y_Mario;
        if(Mario_Invert_Left == 0) begin
            Mario_address = ADDR_X_OFFSET_Mario + ADDR_Y_OFFSET_Mario*Mario_Rowsize; // mario is right 
        end
        else begin
            Mario_address = (59-ADDR_X_OFFSET_Mario) + ADDR_Y_OFFSET_Mario*Mario_Rowsize;
        end
    end
    
    
    
    Mario_Stationary_RAM Mario_Stationary_ROM (
		.read_address(Mario_address),
		.Clk(Clk),
		.data_Out(Palette_Index_Stationary)
    );

    Mario_Walking_RAM1 Mario_Walking1_ROM ( 
		.read_address(Mario_address),
		.Clk(Clk),
		.data_Out(Palette_Index_Walking1)
    );
    Mario_Walking_RAM2 Mario_Walking2_ROM ( 
		.read_address(Mario_address),
		.Clk(Clk),
		.data_Out(Palette_Index_Walking2)
    );
    Mario_Walking_RAM3 Mario_Walking3_ROM ( 
		.read_address(Mario_address),
		.Clk(Clk),
		.data_Out(Palette_Index_Walking3)
    );
    
    always_comb begin
        if(Mario_State_Out == 0 || Mario_State_Out == 1)begin
            Palette_Index = Palette_Index_Stationary;
        end
        else if(Mario_State_Out == 2 ||Mario_State_Out == 5) begin
            Palette_Index = Palette_Index_Walking1;
        end
        else if(Mario_State_Out == 3 ||Mario_State_Out == 6) begin
            Palette_Index = Palette_Index_Walking2;
        end
        else if(Mario_State_Out == 4 ||Mario_State_Out == 7) begin
            Palette_Index = Palette_Index_Walking3;
        end
        else begin
            Palette_Index = 2'b01;
        end
    end
    Palette(.addr(Palette_Index), .data(Palette_Output));
  
    always_comb
    begin:Mario_on_proc
        if ((DrawX >= MarioX - Mario_size_X) &&
            (DrawX <= MarioX + Mario_size_X) &&
            (DrawY >= MarioY - Mario_size_Y) &&
            (DrawY <= MarioY + Mario_size_Y)) begin
       
            Mario_on = 1'b1;
       end
        else 
            Mario_on = 1'b0;
     end 
       
    always_comb
    begin:RGB_Display
        if(Mario_on && (Palette_Output != 12'h808)) begin
             Red = Palette_Output[11:8];
             Green = Palette_Output[7:4];
             Blue = Palette_Output[3:0];
        end  
        else if ((DrawY>400) && (DrawY<430)&& (DrawX<600) && (DrawX>40)) begin 
            Red = 4'hf;
            Green = 4'h7;
            Blue = 4'h0;
        end
   
        else begin 
            Red = 4'hf; 
            Green = 4'hf;
            Blue = 4'hf;
        end      
    end 

      
   
    
endmodule
