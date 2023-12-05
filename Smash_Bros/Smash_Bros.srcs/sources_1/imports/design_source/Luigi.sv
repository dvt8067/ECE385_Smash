//-------------------------------------------------------------------------
//    Ball.sv                                                            --
//    Viral Mehta                                                        --
//    Spring 2005                                                        --
//                                                                       --
//    Modified by Stephen Kempf 03-01-2006                               --
//                              03-12-204f                               --
//    Translated by Joe Meng    4f-4f-2013                               --
//    Modified by Zuofu Cheng   08-19-2023                               --
//    Fall 2023 Distribution                                             --
//                                                                       --
//    For use with ECE 385 USB + HDMI Lab                                --
//    UIUC ECE Department                                                --
//-------------------------------------------------------------------------


module  Luigi ( input logic Reset, frame_clk,
			   input logic [7:0] keycode,
         input logic [9:0] Stage_X_Max, Stage_X_Min, Stage_Y_Max, Stage_Y_Min,
         input logic Stop_Luigi_Left, Stop_Luigi_Right, Stop_Luigi_Up, Stop_Luigi_Down,
               output logic [9:0] LuigiX, LuigiY, LuigiS_X, LuigiS_Y,
               output logic edge_below_luigi,
               output logic jump_on_luigi,
               output logic [25:0] Luigi_Fall_Counter); //CHANGE THESE TO Luigi EQUIVALENTS
    
    logic [9:0] Luigi_X_Motion, Luigi_Y_Motion, Luigi_Bottom_Edge_LX, Luigi_Bottom_Edge_RX, Luigi_Bottom_Edge_Y;
    logic [9:0] jumping_factor;
     int Luigi_Jump_Delay = 30;
    //logic jump_counter
    //logic edge;
    parameter [9:0] Luigi_X_Initial=420;  // Center position on the X axis
    parameter [9:0] Luigi_Y_Initial=100;  // Center position on the Y axis
    //parameter [9:0] Luigi_X_Min=0;       // Leftmost point on the X axis
    //parameter [9:0] Luigi_X_Max=639;     // Rightmost point on the X axis
    //parameter [9:0] Luigi_Y_Min=0;       // Topmost point on the Y axis
    //parameter [9:0] Luigi_Y_Max=479;     // Bottommost point on the Y axis
    //parameter [9:0] Luigi_X_Step=1;      // Step size on the X axis
    //parameter [9:0] Luigi_Y_Step=1;      // Step size on the Y axis
always_comb begin
    LuigiS_X = 30;  // default Luigi sizes 
    LuigiS_Y = 40;
    
    Luigi_Bottom_Edge_LX = LuigiX - LuigiS_X;
    Luigi_Bottom_Edge_RX = LuigiX + LuigiS_X;
    Luigi_Bottom_Edge_Y = LuigiY + LuigiS_Y; // JUST DELETED A +1 here IF HE FALLS THROUGH STAGE, PUT IT BACK
    
    jumping_factor = Luigi_Jump_Delay/3 ;
   end
  always_comb begin
      Luigi_X_Motion = 0;
      Luigi_Y_Motion = 0;
      // 
      edge_below_luigi = 1'b0;
      if( (Luigi_Bottom_Edge_Y <= Stage_Y_Max) && (Luigi_Bottom_Edge_Y >= Stage_Y_Min))begin

        if(((Luigi_Bottom_Edge_LX> Stage_X_Min)&&(Luigi_Bottom_Edge_LX<Stage_X_Max))
        ||((Luigi_Bottom_Edge_RX>Stage_X_Min)&&(Luigi_Bottom_Edge_RX<Stage_X_Max)))begin
          edge_below_luigi = 1'b1;
          end
        else if(Stop_Luigi_Down == 1) begin
          edge_below_luigi = 1'b1;
        end
      
        // else begin
        //   edge_below_luigi = 0;
        // end
            end
            
  
  
  end
   
    logic Luigi_Jump_Counter_Tracker;
    logic Luigi_Jump_Counter_Reset;
    logic [6:0] Luigi_Jump_Counter; // CHANGED THIS TO AN INT, IF IT 
    int Luigi_Jump_Counter_ = Luigi_Jump_Counter;

    int Luigi_Fall_Delay = Luigi_Jump_Delay;
    logic Luigi_Fall_Counter_Tracker;
    logic Luigi_Fall_Counter_Reset;
     // CHANGED THIS TO AN INT, IF IT 
    int Luigi_Fall_Counter_ = Luigi_Fall_Counter;
    always_ff @ (posedge frame_clk) begin
        if(Luigi_Fall_Counter_Reset)begin
            Luigi_Fall_Counter <= 0;
        end
        else begin
            Luigi_Fall_Counter <= Luigi_Fall_Counter + Luigi_Fall_Counter_Tracker;
        end
            //update the register counter value
    end
    always_comb begin
      Luigi_Fall_Counter_Tracker = 0;
      Luigi_Fall_Counter_Reset = 0;
      if(edge_below_luigi == 0 && jump_on_luigi == 0) begin
        Luigi_Fall_Counter_Tracker = 1;
      end
      if(edge_below_luigi == 1)begin
        Luigi_Fall_Counter_Reset = 1;
      end
    end
    
    
  always_ff @ (posedge frame_clk) begin
        if(Luigi_Jump_Counter_Reset)begin
            Luigi_Jump_Counter <= 0;
        end
        else begin
            Luigi_Jump_Counter <= Luigi_Jump_Counter + Luigi_Jump_Counter_Tracker;
        end
            //update the register counter value
    end
      always_ff @ (posedge frame_clk) begin
        if(Luigi_Jump_Counter_Tracker == 0)begin
            Luigi_Jump_Counter_Reset <= 1;
        end
        else begin
            Luigi_Jump_Counter_Reset <= 0;
        end
      end
    always_comb begin
      jump_on_luigi = 0;
      //Luigi_Jump_Counter_Reset = 0;
      if((Luigi_Jump_Counter <= Luigi_Jump_Delay) && (Luigi_Jump_Counter >= 1) && Stop_Luigi_Up == 0) begin
        jump_on_luigi = 1;
      end
      // if(Luigi_Jump_Counter> Luigi_Jump_Delay) begin
      //   Luigi_Jump_Counter_Reset = 1;
      // end


    end

    always_ff @ (posedge frame_clk or posedge Reset) //make sure the frame clock is instantiated correctly
    begin: Move_Luigi
        if (Reset)  // asynchronous Reset
        begin 
            //Luigi_Y_Motion <= 10'd0; //Luigi_Y_Step;
			//Luigi_X_Motion <= 10'd0; //Luigi_X_Step;
			LuigiY <= Luigi_Y_Initial;
			LuigiX <= Luigi_X_Initial;
        end
           
        else 
        begin 
				
				//  else 
          // if(edge_below_luigi == 1'b0 || jump_on_luigi == 1'b1)begin
          //     if(jump_on_luigi == 1'b0) begin
          //    // LuigiY <= LuigiY + 10'd1;
          //        if((Luigi_Fall_Counter_/jumping_factor) <1)begin
          //           LuigiY <= LuigiY + 10'd2;
    
          //       end
          //       else if((Luigi_Fall_Counter_/jumping_factor) >=1  && (Luigi_Fall_Counter_/jumping_factor) <2)begin
          //           LuigiY <= LuigiY + 10'd3;
          //       end
          //       else if((Luigi_Fall_Counter_/jumping_factor) >=2 )begin
          //         LuigiY <= LuigiY + 10'd5;
          //       end
          //       else begin
          //         LuigiY <= LuigiY + 10'd15;
          //       end
          //     end 
          //     else begin
          //       if((Luigi_Jump_Counter_/jumping_factor) <1)begin
          //           LuigiY <= LuigiY - 10'd5;
    
          //       end
          //       else if((Luigi_Jump_Counter_/jumping_factor) >=1  && (Luigi_Jump_Counter_/jumping_factor) <2)begin
          //           LuigiY <= LuigiY - 10'd3;
          //       end
          //       else if((Luigi_Jump_Counter_/jumping_factor) >=2 && (Luigi_Jump_Counter_/jumping_factor) <=3)begin
          //         LuigiY <= LuigiY - 10'd2;
          //       end
          //       else begin
          //         LuigiY <= LuigiY + 10'd15;
          //       end
  
                
          //     end
          if(edge_below_luigi == 1'b0 || jump_on_luigi == 1'b1)begin
              if(jump_on_luigi == 1'b0) begin
             // LuigiY <= LuigiY + 10'd1;
                 if(Luigi_Fall_Counter_  < 6)begin
                    LuigiY <= LuigiY + 10'd1;
    
                end
                else if(((Luigi_Fall_Counter_  >= 6) && (Luigi_Fall_Counter_  < 12)))  begin
                    LuigiY <= LuigiY + 10'd2;
                end
                else if(((Luigi_Fall_Counter_  >= 12) && (Luigi_Fall_Counter_  < 18)))  begin
                    LuigiY <= LuigiY + 10'd3;
                end
                else if(((Luigi_Fall_Counter_  >= 18) && (Luigi_Fall_Counter_  < 24)))  begin
                    LuigiY <= LuigiY + 10'd5;
                end
                else if(((Luigi_Fall_Counter_  >= 24) ))begin
                  LuigiY <= LuigiY + 10'd5;
                end
                
                else begin
                  LuigiY <= LuigiY;
                end
              end 
              else begin
                if(Luigi_Jump_Counter_  < 6)begin
                    LuigiY <= LuigiY - 10'd7;
                end
                else if(((Luigi_Jump_Counter_  >= 6) && (Luigi_Jump_Counter_  < 12)))begin
                    LuigiY <= LuigiY - 10'd5;
                end
                else if(((Luigi_Jump_Counter_  >= 12) && (Luigi_Jump_Counter_  < 18)))begin
                  LuigiY <= LuigiY - 10'd3;
                end
                else if(((Luigi_Jump_Counter_  >= 18) && (Luigi_Jump_Counter_  < 24)))begin
                    LuigiY <= LuigiY - 10'd2;
                end
                else if(((Luigi_Jump_Counter_  >= 24) && (Luigi_Jump_Counter_  <= 30)))begin
                  LuigiY <= LuigiY - 10'd1;
                end
                else begin
                  LuigiY <= LuigiY;
                end
  
                
              end

          end
          else begin
          LuigiY <= LuigiY;
          end
        
				//Luigi_Y_Motion <= Luigi_Y_Motion;  // Ball is somewhere in the middle, don't bounce, just keep moving
					  
				 //modify to control ball motion with the keycode
				 if (keycode == 8'h52) begin
				    // if(BallY - BallS > Ball_Y_Min) begin
              if(edge_below_luigi == 1) begin
                Luigi_Jump_Counter_Tracker <=1;
                // Luigi_Jump_Counter_Reset <= 0
              end
              else if(jump_on_luigi == 0) begin
                  Luigi_Jump_Counter_Tracker <= 0;
              end
              else begin
                  Luigi_Jump_Counter_Tracker <= Luigi_Jump_Counter_Tracker;
              end
              // else if(jump_on_luigi) begin
              //     LuigiY <= LuigiY - 10'd1;
              //     Luigi_Jump_Counter_Tracker <= 1;
              // end
              // else if(jump_on_luigi == 0 ) begin
              //   Luigi_Jump_Counter_Tracker <= 0;
              //   // Luigi_Jump_Counter_Reset <= 1


              
              LuigiX <= LuigiX; // Continue to Reset LuigiX
                    //     Ball_Y_Motion <= -10'd1;
                    //     Ball_X_Motion <= 10'd0;
                    //     end
                    // Ball_X_Motion <= 10'd0;
                    end
          else if(jump_on_luigi == 0) begin
                Luigi_Jump_Counter_Tracker <= 0;
          end
          else begin
                Luigi_Jump_Counter_Tracker <= Luigi_Jump_Counter_Tracker;
          end
        //if(edge_below_luigi == 0 )
				 if (keycode == 8'h16) begin
				    // if(BallY + BallS <=Ball_Y_Max) begin
                  LuigiX <= LuigiX; // continue to reset LuigiX
                    //     Ball_Y_Motion <= 10'd1;
                    //     Ball_X_Motion <= 10'd0;
                    //     end
                    // Ball_X_Motion <= 10'd0;
                    end             
				 if (keycode == 8'h50) begin
          if(Luigi_Bottom_Edge_Y<Stage_Y_Min+1) begin
            if(Stop_Luigi_Left == 0) begin
				   LuigiX <= LuigiX - 10'd4;
            end
            else begin
              LuigiX <= LuigiX;
            end
          end
          else if(Luigi_Bottom_Edge_LX == Stage_X_Max || Luigi_Bottom_Edge_LX == Stage_X_Max+1
          || Luigi_Bottom_Edge_LX == Stage_X_Max+2 || Luigi_Bottom_Edge_LX == Stage_X_Max-1 || Luigi_Bottom_Edge_LX == Stage_X_Max-2)begin
            LuigiX <= LuigiX;
          end
          else begin
            if(Stop_Luigi_Left == 0) begin
            LuigiX <= LuigiX - 10'd4;
            end
            else begin
              LuigiX <= LuigiX;
            end
          end
                    // if(BallX - BallS > Ball_X_Min) begin
				 
                    //     Ball_X_Motion <= -10'd1;
                    //     Ball_Y_Motion <= 10'd0;
                    //     end
                    // Ball_Y_Motion <= 10'd0;
                    end 
				 if (keycode == 8'h4f) begin
          if(Luigi_Bottom_Edge_Y<Stage_Y_Min+1) begin
            if(Stop_Luigi_Right == 0) begin
				   LuigiX <= LuigiX + 10'd4;
            end
            else begin
              LuigiX <= LuigiX;
            end
          end
          else if(Luigi_Bottom_Edge_RX == Stage_X_Min || Luigi_Bottom_Edge_RX == Stage_X_Min+1
          || Luigi_Bottom_Edge_RX == Stage_X_Min+2 || Luigi_Bottom_Edge_RX == Stage_X_Min-1 || Luigi_Bottom_Edge_RX == Stage_X_Min-2)begin
            LuigiX <= LuigiX;
          end
          else begin
            if(Stop_Luigi_Right == 0) begin
            LuigiX <= LuigiX + 10'd4;
            end
            else begin
              LuigiX <= LuigiX;
            end
          end
                    end                   
				 
				//  BallY <= (BallY + Ball_Y_Motion);  // Update ball position
				//  BallX <= (BallX + Ball_X_Motion);
        if(keycode !=8'h4f &&keycode !=8'h50) begin
        
        //&& keycode != 8'h16 && keycode != 8'h52) begin
            LuigiX<=LuigiX; ///  continue to reset LuigiX
            //LuigiY<=LuigiY;
         end
        //  if(jump_on_luigi)begin
        //   LuigiY <= LuigiY - 10'd1;
        //  end
         end
         
      end
      
endmodule
