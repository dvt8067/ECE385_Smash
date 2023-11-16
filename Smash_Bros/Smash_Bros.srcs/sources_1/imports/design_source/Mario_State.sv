//------------------------------------------------------------------------------
// Company:          UIUC ECE Dept.
// Engineer:         Stephen Kempf
//
// Create Date:    17:44:03 10/08/06
// Design Name:    ECE 385 Given Code - Incomplete ISDU for SLC-3
// Module Name:    ISDU - Behavioral
//
// Comments:
//    Revised 03-22-2007
//    Spring 2007 Distribution
//    Revised 07-26-2013
//    Spring 2015 Distribution
//    Revised 02-13-2017
//    Spring 2017 Distribution
//    Revised 07-25-2023
//    Xilinx Vivado
//------------------------------------------------------------------------------


module Mario_State (   input logic  Clk, 
									Reset,
                            input logic [7:0] keycode,
                            input logic edge_below,
                            output logic [4:0] Mario_State_Out,
                            output logic Mario_Invert_Left
									
				);

	enum logic [4:0] {  Mario_Stationary_Right, Mario_Stationary_Left, 
                        Mario_Walk_Right1, Mario_Walk_Right2, Mario_Walk_Right3, 
                        Mario_Walk_Left1, Mario_Walk_Left2, Mario_Walk_Left3, Mario_Fall_Left, Mario_Fall_Right}   State, Next_State;   // Internal state logic
    //logic edge_below_previous;
    always_comb begin
        Mario_State_Out = State; 
    end
		
	always_ff @ (posedge Clk)
	begin
		if (Reset) begin
			State <= Mario_Stationary_Right;
			//edge_below_previous <= 1;
			end
		else 
			State <= Next_State;
	end
   
	int Mario_Walk_Delay = 4666667;
    logic Mario_Walk_Counter_Tracker;
    logic Mario_Walk_Counter_Reset;
    logic [22:0] Mario_Walk_Counter;
    

    always_ff @ (posedge Clk) begin
        if(Mario_Walk_Counter_Reset)begin
            Mario_Walk_Counter <= 0;
        end
        else begin
            Mario_Walk_Counter <= Mario_Walk_Counter + Mario_Walk_Counter_Tracker;
        end
            //update the register counter value
    end
    //always_ff @ (posedge Clk) begin
        //edge_below_previous <= edge_below;
    //end
    
    
    always_comb
	begin 
		Mario_Walk_Counter_Tracker = 0;
        Mario_Walk_Counter_Reset = 0;
//		Statetest = State;
		// Default next state is staying at current state
		Next_State = State;
		Mario_Invert_Left = 0;
		unique case (State)
			
            Mario_Stationary_Right : begin
                if((keycode == 8'h04)) begin
                    Next_State = Mario_Walk_Left1;
                end
                if(keycode == 8'h07) begin
                    Next_State = Mario_Walk_Right1;
                end
                Mario_Walk_Counter_Reset = 1;
            end
			Mario_Walk_Right1 :  begin
				if(keycode != 8'h07)  begin
                    if(keycode == 8'h04)begin
                        Next_State = Mario_Walk_Left1;
                    end
                    else begin
                        Next_State = Mario_Stationary_Right;
                    end
                    Mario_Walk_Counter_Reset = 1;
                end
                else if(Mario_Walk_Counter >= Mario_Walk_Delay) begin
                    Next_State = Mario_Walk_Right2;
                    Mario_Walk_Counter_Reset = 1;
                end
                else begin
                    Next_State = Mario_Walk_Right1;
                    Mario_Walk_Counter_Tracker = 1;
                end
            end
			Mario_Walk_Right2 : begin               //e.g. S_33_2, etc. How many? As a hint, note that the BRAM is synchronous, in addition, 
				if(keycode != 8'h07)  begin
                    if(keycode == 8'h04)begin
                        Next_State = Mario_Walk_Left1;
                    end
                    else begin
                        Next_State = Mario_Stationary_Right;
                    end
                    Mario_Walk_Counter_Reset = 1;
                end
                else if(Mario_Walk_Counter >= Mario_Walk_Delay) begin
                    Next_State = Mario_Walk_Right3;
                    Mario_Walk_Counter_Reset = 1;
                end
                else begin
                    Next_State = Mario_Walk_Right2;
                    Mario_Walk_Counter_Tracker = 1;
                end 
            end
			Mario_Walk_Right3 : begin
				if(keycode != 8'h07)  begin
                    if(keycode == 8'h04)begin
                        Next_State = Mario_Walk_Left1;
                    end
                    else begin
                        Next_State = Mario_Stationary_Right;
                    end
                    Mario_Walk_Counter_Reset = 1;
                end
                else if(Mario_Walk_Counter >= Mario_Walk_Delay) begin
                    Next_State = Mario_Walk_Right1;
                    Mario_Walk_Counter_Reset = 1;
                end
                else begin
                    Next_State = Mario_Walk_Right3;
                    Mario_Walk_Counter_Tracker = 1;
                end 
            end
			Mario_Stationary_Left :	begin
                Mario_Invert_Left = 1;			
				if((keycode == 8'h04)) begin
                    Next_State = Mario_Walk_Left1;
                end
                if(keycode == 8'h07) begin
                    Next_State = Mario_Walk_Right1;
                end
                Mario_Walk_Counter_Reset = 1;
            end
			Mario_Walk_Left1 : begin
                Mario_Invert_Left = 1;
				if(keycode != 8'h04)  begin
                    if(keycode == 8'h07)begin
                        Next_State = Mario_Walk_Right1;
                    end
                    else begin
                        Next_State = Mario_Stationary_Left;
                    end
                    Mario_Walk_Counter_Reset = 1;
                end
                

                else if(Mario_Walk_Counter >= Mario_Walk_Delay) begin
                    Next_State = Mario_Walk_Left2;
                    Mario_Walk_Counter_Reset = 1;
                end
                else begin
                    Next_State = Mario_Walk_Left1;
                    Mario_Walk_Counter_Tracker = 1;
                end
            end
            Mario_Walk_Left2 : begin
                Mario_Invert_Left = 1;
                if(keycode != 8'h04)  begin
                    if(keycode == 8'h07)begin
                        Next_State = Mario_Walk_Right1;
                    end
                    else begin
                        Next_State = Mario_Stationary_Left;
                    end
                    Mario_Walk_Counter_Reset = 1;
                end
                else if(Mario_Walk_Counter >= Mario_Walk_Delay) begin
                    Next_State = Mario_Walk_Left3;
                    Mario_Walk_Counter_Reset = 1;
                end
                else begin
                    Next_State = Mario_Walk_Left2;
                    Mario_Walk_Counter_Tracker = 1;
                end
            end
            Mario_Walk_Left3 : begin
                Mario_Invert_Left = 1;
                if(keycode != 8'h04)  begin
                    if(keycode == 8'h07)begin
                        Next_State = Mario_Walk_Right1;
                    end
                    else begin
                        Next_State = Mario_Stationary_Left;
                    end
                    Mario_Walk_Counter_Reset = 1;
                end
                else if(Mario_Walk_Counter >= Mario_Walk_Delay) begin
                    Next_State = Mario_Walk_Left1;
                    Mario_Walk_Counter_Reset = 1;
                end
                else begin
                    Next_State = Mario_Walk_Left3;
                    Mario_Walk_Counter_Tracker = 1;
                end
                Mario_Invert_Left = 1;
            end
            Mario_Fall_Left: begin /// CAN ADD FRAME HERE LATER FOR FALLING ANIMATION
                Mario_Invert_Left = 1;
                Mario_Walk_Counter_Reset = 1;
                if(edge_below == 0) begin
                    if(keycode == 8'h07) begin
                        Next_State = Mario_Fall_Right;
                    end
                end
                else
                begin
                    Next_State = Mario_Stationary_Left;
                end
            end
            Mario_Fall_Right: begin /// CAN ADD FRAME HERE FOR FALLING ANIMATION
                Mario_Walk_Counter_Reset = 1;
                if(edge_below == 0) begin
                    if(keycode == 8'h04) begin
                        Next_State = Mario_Fall_Left;
                    end
                    else begin
                        Next_State = Mario_Fall_Right;
                    end
                end
                else
                begin
                    Next_State = Mario_Stationary_Right;
                end
            end

		endcase
        //edge_below_previous == 1 && 
        if(edge_below == 0) begin
            if((State == Mario_Stationary_Right) || (State == Mario_Walk_Right1)
            || (State == Mario_Walk_Right2) || (State == Mario_Walk_Right3)) begin
                Next_State = Mario_Fall_Right;
            end
        end
        else begin
            Next_State = Mario_Fall_Left;
        end
    end
		// Assign control signals based on current state
		
	
endmodule
