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
         input logic [6:0] Mario_Percent,
         input logic [9:0] Stage_X_Max, Stage_X_Min, Stage_Y_Max, Stage_Y_Min,
         input logic Stop_Mario_Left, Stop_Mario_Right, Stop_Mario_Up, Stop_Mario_Down, Luigi_Right_Punch_Sucessful, Luigi_Left_Punch_Sucessful,
               output logic [9:0] MarioX, MarioY, MarioS_X, MarioS_Y,
               output logic edge_below_mario,
               output logic jump_on_mario,
               output logic [25:0] Mario_Fall_Counter); //CHANGE THESE TO MARIO EQUIVALENTS
    
    logic [9:0] Mario_X_Motion, Mario_Y_Motion, Mario_Bottom_Edge_LX, Mario_Bottom_Edge_RX, Mario_Bottom_Edge_Y;
    logic [9:0] jumping_factor;
    logic Mario_Yeet_Right;
    logic Mario_Yeet_Left;
     int Mario_Jump_Delay = 30;
    //logic jump_counter
    //logic edge;
    parameter [9:0] Mario_X_Initial=213;  // Center position on the X axis
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
    assign Mario_Bottom_Edge_Y = MarioY + MarioS_Y; // JUST DELETED A +1 here IF HE FALLS THROUGH STAGE, PUT IT BACK
    
    assign jumping_factor = Mario_Jump_Delay/3 ;
   
  always_comb begin
      Mario_X_Motion = 0;
      Mario_Y_Motion = 0;
      // 
      edge_below_mario = 1'b0;
      if( (Mario_Bottom_Edge_Y <= Stage_Y_Max) && (Mario_Bottom_Edge_Y >= Stage_Y_Min))begin

        if(((Mario_Bottom_Edge_LX> Stage_X_Min)&&(Mario_Bottom_Edge_LX<Stage_X_Max))
        ||((Mario_Bottom_Edge_RX>Stage_X_Min)&&(Mario_Bottom_Edge_RX<Stage_X_Max)))begin
          edge_below_mario = 1'b1;
          end
      end
        if (Stop_Mario_Down == 1) begin
          edge_below_mario = 1'b1;
        end
      
        // else begin
        //   edge_below_mario = 0;
        // end
          
          
      
  
  end
   
    logic Mario_Jump_Counter_Tracker;
    logic Mario_Jump_Counter_Reset;
    logic [6:0] Mario_Jump_Counter; // CHANGED THIS TO AN INT, IF IT 
    int Mario_Jump_Counter_ = Mario_Jump_Counter;

    int Mario_Fall_Delay = Mario_Jump_Delay;
    logic Mario_Fall_Counter_Tracker;
    logic Mario_Fall_Counter_Reset;
     // CHANGED THIS TO AN INT, IF IT 
    int Mario_Fall_Counter_ = Mario_Fall_Counter;
    always_ff @ (posedge frame_clk) begin
        if(Mario_Fall_Counter_Reset)begin
            Mario_Fall_Counter <= 0;
        end
        else begin
            Mario_Fall_Counter <= Mario_Fall_Counter + Mario_Fall_Counter_Tracker;
        end
            //update the register counter value
    end
    always_comb begin
      Mario_Fall_Counter_Tracker = 0;
      Mario_Fall_Counter_Reset = 0;
      if(edge_below_mario == 0 && jump_on_mario == 0) begin
        Mario_Fall_Counter_Tracker = 1;
      end
      if(edge_below_mario == 1)begin
        Mario_Fall_Counter_Reset = 1;
      end
    end
    
    
  always_ff @ (posedge frame_clk) begin
        if(Mario_Jump_Counter_Reset)begin
            Mario_Jump_Counter <= 0;
        end
        else begin
            Mario_Jump_Counter <= Mario_Jump_Counter + Mario_Jump_Counter_Tracker;
        end
            //update the register counter value
    end
      always_ff @ (posedge frame_clk) begin
        if(Mario_Jump_Counter_Tracker == 0)begin
            Mario_Jump_Counter_Reset <= 1;
        end
        else begin
            Mario_Jump_Counter_Reset <= 0;
        end
      end
    always_comb begin
      jump_on_mario = 0;
      //Mario_Jump_Counter_Reset = 0;
      if((Mario_Jump_Counter <= Mario_Jump_Delay) && (Mario_Jump_Counter >= 1) && Stop_Mario_Up == 0) begin
        jump_on_mario = 1;
      end
      // if(Mario_Jump_Counter> Mario_Jump_Delay) begin
      //   Mario_Jump_Counter_Reset = 1;
      // end


    end

    always_ff @ (posedge frame_clk or posedge Reset) //make sure the frame clock is instantiated correctly
    begin: Move_Mario
        if (Reset)  // asynchronous Reset
        begin 
            //Mario_Y_Motion <= 10'd0; //Mario_Y_Step;
			//Mario_X_Motion <= 10'd0; //Mario_X_Step;
			MarioY <= Mario_Y_Initial;
			MarioX <= Mario_X_Initial;
      Mario_Yeet_Left <=0;
      Mario_Yeet_Right<=0;
        end
           
        else 
        begin 
          if(MarioX > 672 || MarioY > 522) begin
            MarioX <= MarioX;
            MarioY <= MarioY;
          end
          else begin
				
			

        if(Mario_Percent >= 99) begin
            if(Luigi_Left_Punch_Sucessful ==1 || Mario_Yeet_Left==1) begin
              MarioX <= MarioX - 50;
              MarioY <= MarioY - 50;
              Mario_Yeet_Left <=1;
            end
            //else if begin
             else if(Luigi_Right_Punch_Sucessful==1 || Mario_Yeet_Right==1) begin
                  MarioX <= MarioX + 50;
                  MarioY <= MarioY - 50;
                  Mario_Yeet_Right <=1;
                  
                end
                
            //end
            else begin
              MarioX <= MarioX;
              MarioY <= MarioY;
            end
        end
        else begin

          if(edge_below_mario == 1'b0 || jump_on_mario == 1'b1)begin
              if(jump_on_mario == 1'b0) begin
             // MarioY <= MarioY + 10'd1;
                 if(Mario_Fall_Counter_  < 6)begin
                    MarioY <= MarioY + 10'd1;
    
                end
                else if(((Mario_Fall_Counter_  >= 6) && (Mario_Fall_Counter_  < 12)))  begin
                    MarioY <= MarioY + 10'd2;
                end
                else if(((Mario_Fall_Counter_  >= 12) && (Mario_Fall_Counter_  < 18)))  begin
                    MarioY <= MarioY + 10'd3;
                end
                else if(((Mario_Fall_Counter_  >= 18) && (Mario_Fall_Counter_  < 24)))  begin
                    MarioY <= MarioY + 10'd5;
                end
                else if(((Mario_Fall_Counter_  >= 24) ))begin
                  MarioY <= MarioY + 10'd5;
                end
                
                else begin
                  MarioY <= MarioY;
                end
              end 
              else begin
                if(Mario_Jump_Counter_  < 6)begin
                    MarioY <= MarioY - 10'd7;
                end
                else if(((Mario_Jump_Counter_  >= 6) && (Mario_Jump_Counter_  < 12)))begin
                    MarioY <= MarioY - 10'd5;
                end
                else if(((Mario_Jump_Counter_  >= 12) && (Mario_Jump_Counter_  < 18)))begin
                  MarioY <= MarioY - 10'd3;
                end
                else if(((Mario_Jump_Counter_  >= 18) && (Mario_Jump_Counter_  < 24)))begin
                    MarioY <= MarioY - 10'd2;
                end
                else if(((Mario_Jump_Counter_  >= 24) && (Mario_Jump_Counter_  <= 30)))begin
                  MarioY <= MarioY - 10'd1;
                end
                else begin
                  MarioY <= MarioY;
                end
  
                
              end

          end
          else begin
          MarioY <= MarioY;
          end
        
				//Mario_Y_Motion <= Mario_Y_Motion;  // Ball is somewhere in the middle, don't bounce, just keep moving
					  
				 //modify to control ball motion with the keycode
        //  if(Luigi_Punch_Sucessful == 1) begin
        //   MarioX <= MarioX+2;
        //  end
				 if (keycode == 8'h1A) begin
				    // if(BallY - BallS > Ball_Y_Min) begin
              if(edge_below_mario == 1) begin
                Mario_Jump_Counter_Tracker <=1;
                // Mario_Jump_Counter_Reset <= 0
              end
              else if(jump_on_mario == 0) begin
                  Mario_Jump_Counter_Tracker <= 0;
              end
              else begin
                  Mario_Jump_Counter_Tracker <= Mario_Jump_Counter_Tracker;
              end
              // else if(jump_on_mario) begin
              //     MarioY <= MarioY - 10'd1;
              //     Mario_Jump_Counter_Tracker <= 1;
              // end
              // else if(jump_on_mario == 0 ) begin
              //   Mario_Jump_Counter_Tracker <= 0;
              //   // Mario_Jump_Counter_Reset <= 1


              if(Luigi_Right_Punch_Sucessful != 1 && Luigi_Left_Punch_Sucessful != 1) begin
                MarioX <= MarioX;
              end
               // Continue to Reset MarioX
                    //     Ball_Y_Motion <= -10'd1;
                    //     Ball_X_Motion <= 10'd0;
                    //     end
                    // Ball_X_Motion <= 10'd0;
                    end
          else if(jump_on_mario == 0) begin
                Mario_Jump_Counter_Tracker <= 0;
          end
          else begin
                Mario_Jump_Counter_Tracker <= Mario_Jump_Counter_Tracker;
          end
        //if(edge_below_mario == 0 )
				 if (keycode == 8'h16) begin
				    // if(BallY + BallS <=Ball_Y_Max) begin
              if(Luigi_Right_Punch_Sucessful != 1 && Luigi_Left_Punch_Sucessful != 1) begin
                  MarioX <= MarioX; // continue to reset marioX
              end
                    //     Ball_Y_Motion <= 10'd1;
                    //     Ball_X_Motion <= 10'd0;
                    //     end
                    // Ball_X_Motion <= 10'd0;
                    end             
        if(Luigi_Right_Punch_Sucessful == 1) begin
          MarioX <= MarioX + 10'd20;
        end 
        else if(Luigi_Left_Punch_Sucessful == 1) begin
          MarioX <= MarioX - 10'd20;
        end
        else begin
				 if (keycode == 8'h04) begin
          if(Mario_Bottom_Edge_Y<Stage_Y_Min+1) begin
            if(Stop_Mario_Left == 0)begin
				   MarioX <= MarioX - 10'd4;
            end
            else begin
              MarioX <= MarioX;
            end
          end
          else if(Mario_Bottom_Edge_LX == Stage_X_Max || Mario_Bottom_Edge_LX == Stage_X_Max+1
          || Mario_Bottom_Edge_LX == Stage_X_Max+2 || Mario_Bottom_Edge_LX == Stage_X_Max-1 || Mario_Bottom_Edge_LX == Stage_X_Max-2)begin
            MarioX <= MarioX;
          end
          else begin
            if(Stop_Mario_Left == 0)begin
            MarioX <= MarioX - 10'd4;
            end
            else begin
              MarioX<= MarioX;
            end
          end
                    // if(BallX - BallS > Ball_X_Min) begin
				 
                    //     Ball_X_Motion <= -10'd1;
                    //     Ball_Y_Motion <= 10'd0;
                    //     end
                    // Ball_Y_Motion <= 10'd0;
                    end 
				 if (keycode == 8'h07) begin
          if(Mario_Bottom_Edge_Y<Stage_Y_Min+1) begin
            if(Stop_Mario_Right == 0) begin
				   MarioX <= MarioX + 10'd4;
            end
            else begin
              MarioX <= MarioX;
            end
          end
          else if(Mario_Bottom_Edge_RX == Stage_X_Min || Mario_Bottom_Edge_RX == Stage_X_Min+1
          || Mario_Bottom_Edge_RX == Stage_X_Min+2 || Mario_Bottom_Edge_RX == Stage_X_Min-1 || Mario_Bottom_Edge_RX == Stage_X_Min-2)begin
            MarioX <= MarioX;
          end
          else begin
            if(Stop_Mario_Right == 0) begin
            MarioX <= MarioX + 10'd4;
            end
            else begin
              MarioX <= MarioX;
            end
          end
                    end                   
				 
				//  BallY <= (BallY + Ball_Y_Motion);  // Update ball position
				//  BallX <= (BallX + Ball_X_Motion);
        if(keycode !=8'h07 &&keycode !=8'h04 && Luigi_Right_Punch_Sucessful != 1 && Luigi_Left_Punch_Sucessful != 1) begin
        
        //&& keycode != 8'h16 && keycode != 8'h1A) begin
            MarioX<=MarioX; ///  continue to reset MarioX
            //MarioY<=MarioY;
         end
        //  if(jump_on_mario)begin
        //   MarioY <= MarioY - 10'd1;
        //  end
        end
         end
          end
         
      end
    end
      
endmodule
