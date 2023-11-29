//-------------------------------------------------------------------------
//    Ball.sv                                                            --
//    Viral Mehta                                                        --
//    Spring 2005                                                        --
//                                                                       --
//    Modified by Stephen Kempf 03-01-2006                               --
//                              03-12-2007                               --
//    Translated by Joe Meng    07-07-2013                               --
//    Modified by Zuofu Cheng   08-19-2023                               --
//    Fall 2023 Distribution                                             --
//                                                                       --
//    For use with ECE 385 USB + HDMI Lab                                --
//    UIUC ECE Department                                                --
//-------------------------------------------------------------------------


module  Mario ( input logic Reset, frame_clk,
			   input logic [7:0] keycode,
         input logic [9:0] Stage_X_Max, Stage_X_Min, Stage_Y_Max, Stage_Y_Min,
               output logic [9:0] MarioX, MarioY, MarioS_X, MarioS_Y,
               output logic edge_below,
               output logic jump_on); //CHANGE THESE TO MARIO EQUIVALENTS
    
    logic [9:0] Mario_X_Motion, Mario_Y_Motion, Mario_Bottom_Edge_LX, Mario_Bottom_Edge_RX, Mario_Bottom_Edge_Y;
    //logic jump_counter
    //logic edge;
    parameter [9:0] Mario_X_Initial=320;  // Center position on the X axis
    parameter [9:0] Mario_Y_Initial=100;  // Center position on the Y axis
    //parameter [9:0] Mario_X_Min=0;       // Leftmost point on the X axis
    //parameter [9:0] Mario_X_Max=639;     // Rightmost point on the X axis
    //parameter [9:0] Mario_Y_Min=0;       // Topmost point on the Y axis
    //parameter [9:0] Mario_Y_Max=479;     // Bottommost point on the Y axis
    //parameter [9:0] Mario_X_Step=1;      // Step size on the X axis
    //parameter [9:0] Mario_Y_Step=1;      // Step size on the Y axis

    assign MarioS_X = 30;  // default Mario sizes 
    assign MarioS_Y = 40;
    assign Mario_Bottom_Edge_LX = MarioX - MarioS_X;
    assign Mario_Bottom_Edge_RX = MarioX + MarioS_X;
    assign Mario_Bottom_Edge_Y = MarioY + MarioS_Y + 1;
   
  always_comb begin
      Mario_X_Motion = 0;
      Mario_Y_Motion = 0;
      // 
      edge_below = 1'b0;
      if( (Mario_Bottom_Edge_Y <= Stage_Y_Max) && (Mario_Bottom_Edge_Y >= Stage_Y_Min))begin

        if(((Mario_Bottom_Edge_LX> Stage_X_Min)&&(Mario_Bottom_Edge_LX<Stage_X_Max))
        ||((Mario_Bottom_Edge_RX>Stage_X_Min)&&(Mario_Bottom_Edge_RX<Stage_X_Max)))begin
          edge_below = 1'b1;
          end
      
        // else begin
        //   edge_below = 0;
        // end
      end
  
  
  
  end
    int Mario_Jump_Delay = 60;
    logic Mario_Jump_Counter_Tracker;
    logic Mario_Jump_Counter_Reset;
    logic [25:0] Mario_Jump_Counter;
  always_ff @ (posedge frame_clk) begin
        if(Mario_Jump_Counter_Reset)begin
            Mario_Jump_Counter <= 0;
        end
        else begin
            Mario_Jump_Counter <= Mario_Jump_Counter + Mario_Jump_Counter_Tracker;
        end
            //update the register counter value
    end
    always_comb begin
      jump_on = 0;
      Mario_Jump_Counter_Reset = 0;
      if((Mario_Jump_Counter <= Mario_Jump_Delay) && (Mario_Jump_Counter >= 1)) begin
        jump_on = 1;
      end
      if(Mario_Jump_Counter> Mario_Jump_Delay) begin
        Mario_Jump_Counter_Reset = 1;
      end
      //if(keycode != 8'h1A)begin
        //Mario_Jump_Counter_Reset = 1;
      //end
    end

    always_ff @ (posedge frame_clk or posedge Reset) //make sure the frame clock is instantiated correctly
    begin: Move_Mario
        if (Reset)  // asynchronous Reset
        begin 
            //Mario_Y_Motion <= 10'd0; //Mario_Y_Step;
			//Mario_X_Motion <= 10'd0; //Mario_X_Step;
			MarioY <= Mario_Y_Initial;
			MarioX <= Mario_X_Initial;
        end
           
        else 
        begin 
				//  if ( (BallY + BallS) >= Ball_Y_Max )  // Ball is at the bottom edge, BOUNCE!
				// 	  Ball_Y_Motion <= (~ (Ball_Y_Step) + 1'b1);  // 2's complement.
					  
				//  else if ( (BallY - BallS) <= Ball_Y_Min )  // Ball is at the top edge, BOUNCE!
				// 	  Ball_Y_Motion <= Ball_Y_Step;
					  
				//   else if ( (BallX + BallS) >= Ball_X_Max )  // Ball is at the Right edge, BOUNCE!
				// 	  Ball_X_Motion <= (~ (Ball_X_Step) + 1'b1);  // 2's complement.
					  
				//  else if ( (BallX - BallS) <= Ball_X_Min )  // Ball is at the Left edge, BOUNCE!
				// 	  Ball_X_Motion <= Ball_X_Step;
					  
				//  else 
          if(edge_below == 1'b0 || jump_on == 1'b1)begin
              if(jump_on == 1'b0) begin
              MarioY <= MarioY + 10'd1;
              end 
              else begin
                MarioY <= MarioY - 10'd2;
              end
          
          end
          else begin
          MarioY <= MarioY;
          end
        
				//Mario_Y_Motion <= Mario_Y_Motion;  // Ball is somewhere in the middle, don't bounce, just keep moving
					  
				 //modify to control ball motion with the keycode
				 if (keycode == 8'h1A) begin
				    // if(BallY - BallS > Ball_Y_Min) begin
              if(edge_below == 1) begin
                Mario_Jump_Counter_Tracker <=1;
              end
              // else if(jump_on) begin
              //     MarioY <= MarioY - 10'd1;
              //     Mario_Jump_Counter_Tracker <= 1;
              // end
              else if(jump_on == 0 || Mario_Jump_Counter_Reset == 1) begin
                Mario_Jump_Counter_Tracker <= 0;

              end
              MarioX <= MarioX; // Continue to Reset MarioX
                    //     Ball_Y_Motion <= -10'd1;
                    //     Ball_X_Motion <= 10'd0;
                    //     end
                    // Ball_X_Motion <= 10'd0;
                    end
        //if(edge_below == 0 )
				 if (keycode == 8'h16) begin
				    // if(BallY + BallS <=Ball_Y_Max) begin
                  MarioX <= MarioX; // continue to reset marioX
                    //     Ball_Y_Motion <= 10'd1;
                    //     Ball_X_Motion <= 10'd0;
                    //     end
                    // Ball_X_Motion <= 10'd0;
                    end             
				 if (keycode == 8'h04) begin
          if(Mario_Bottom_Edge_Y<Stage_Y_Min+2) begin
				   MarioX <= MarioX - 10'd3;
          end
          else if(Mario_Bottom_Edge_LX == Stage_X_Max || Mario_Bottom_Edge_LX == Stage_X_Max+1
          || Mario_Bottom_Edge_LX == Stage_X_Max+2 || Mario_Bottom_Edge_LX == Stage_X_Max-1 || Mario_Bottom_Edge_LX == Stage_X_Max-2)begin
            MarioX <= MarioX;
          end
          else begin
            MarioX <= MarioX - 10'd3;
          end
                    // if(BallX - BallS > Ball_X_Min) begin
				 
                    //     Ball_X_Motion <= -10'd1;
                    //     Ball_Y_Motion <= 10'd0;
                    //     end
                    // Ball_Y_Motion <= 10'd0;
                    end 
				 if (keycode == 8'h07) begin
          if(Mario_Bottom_Edge_Y<Stage_Y_Min+2) begin
				   MarioX <= MarioX + 10'd3;
          end
          else if(Mario_Bottom_Edge_RX == Stage_X_Min || Mario_Bottom_Edge_RX == Stage_X_Min+1
          || Mario_Bottom_Edge_RX == Stage_X_Min+2 || Mario_Bottom_Edge_RX == Stage_X_Min-1 || Mario_Bottom_Edge_RX == Stage_X_Min-2)begin
            MarioX <= MarioX;
          end
          else begin
            MarioX <= MarioX + 10'd3;
          end
                    end                   
				 
				//  BallY <= (BallY + Ball_Y_Motion);  // Update ball position
				//  BallX <= (BallX + Ball_X_Motion);
        if(keycode !=8'h07 &&keycode !=8'h04 && keycode != 8'h16 && keycode != 8'h1A) begin
            MarioX<=MarioX; ///  continue to reset MarioX
            //MarioY<=MarioY;
         end
        //  if(jump_on)begin
        //   MarioY <= MarioY - 10'd1;
        //  end
         end
         
      end
      
endmodule
