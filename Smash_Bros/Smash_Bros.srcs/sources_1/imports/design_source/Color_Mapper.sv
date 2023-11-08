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


module  color_mapper ( input  logic [9:0] BallX, BallY, DrawX, DrawY, Ball_size_X, Ball_size_Y,
                       output logic [3:0]  Red, Green, Blue );
    
    logic ball_on;
	 
 /* Old Ball: Generated square box by checking if the current pixel is within a square of length
    2*BallS, centered at (BallX, BallY).  Note that this requires unsigned comparisons.
	 
    if ((DrawX >= BallX - Ball_size) &&
       (DrawX <= BallX + Ball_size) &&
       (DrawY >= BallY - Ball_size) &&
       (DrawY <= BallY + Ball_size))
       )

     New Ball: Generates (pixelated) circle by using the standard circle formula.  Note that while 
     this single line is quite powerful descriptively, it causes the synthesis tool to use up three
     of the 120 available multipliers on the chip!  Since the multiplicants are required to be signed,
	  we have to first cast them from logic to int (signed by default) before they are multiplied). */
	  
    int DistX, DistY, Size_X, Size_Y;
    assign DistX = DrawX - BallX;
    assign DistY = DrawY - BallY;
    assign Size_X = Ball_size_X;
    assign Size_Y = Ball_size_Y;
  
    always_comb
    begin:Ball_on_proc
        if ((DrawX >= BallX - Ball_size_X) &&
            (DrawX <= BallX + Ball_size_X) &&
            (DrawY >= BallY - Ball_size_Y) &&
            (DrawY <= BallY + Ball_size_Y)) begin
       
            ball_on = 1'b1;
       end
        else 
            ball_on = 1'b0;
     end 
       
    always_comb
    begin:RGB_Display
        if ((DrawY>400) && (DrawY<430)&& (DrawX<600) && (DrawX>40)) begin 
            Red = 4'hf;
            Green = 4'h7;
            Blue = 4'h0;
        end
        else if(ball_on) begin
            Red = 4'hf;
            Green = 4'h0;
            Blue = 4'h0;
        end     
        else begin 
            Red = 4'hf; 
            Green = 4'hf;
            Blue = 4'hf;
        end      
    end 
    
endmodule
