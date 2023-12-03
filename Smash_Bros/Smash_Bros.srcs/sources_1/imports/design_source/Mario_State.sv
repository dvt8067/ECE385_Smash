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
                            input logic edge_below_mario,
                            input logic jump_on_mario,
                            output logic [4:0] Mario_State_Out,
                            output logic Mario_Invert_Left
									
				);

	enum logic [4:0] {  Mario_Stationary_Right, Mario_Stationary_Left, 
                        Mario_Walk_Right1, Mario_Walk_Right2, Mario_Walk_Right3, 
                        Mario_Walk_Left1, Mario_Walk_Left2, Mario_Walk_Left3, Mario_Fall_Left,
                         Mario_Fall_Right, Mario_Jump_Right, Mario_Jump_Left, Mario_Punch1_Right, 
                         Mario_Punch2_Right, Mario_Punch1_Left, Mario_Punch2_Left}   State, Next_State;   // Internal state logic
    //logic edge_below_mario_previous;
    always_comb begin
        Mario_State_Out = State; 
    end
		
	always_ff @ (posedge Clk)
	begin
		if (Reset) begin
			State <= Mario_Stationary_Right;
			//edge_below_mario_previous <= 1;
			end
		else 
			State <= Next_State;
	end
   
	int Mario_Walk_Delay = 4666667;
    logic Mario_Walk_Counter_Tracker;
    logic Mario_Walk_Counter_Reset;
    logic [22:0] Mario_Walk_Counter;
    int Mario_Punch_Delay = 25000000;
    logic Mario_Punch_Counter_Tracker;
    logic Mario_Punch_Counter_Reset;
    logic [25:0] Mario_Punch_Counter;
    
    always_ff @ (posedge Clk) begin
            if(Mario_Punch_Counter_Reset)begin
                Mario_Punch_Counter <= 0;
            end
            else begin
                Mario_Punch_Counter <= Mario_Punch_Counter + Mario_Punch_Counter_Tracker;
            end
                //update the register counter value
        end

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
        //edge_below_mario_previous <= edge_below_mario;
    //end
    
    
    always_comb
	begin 
		Mario_Walk_Counter_Tracker = 0;
        Mario_Walk_Counter_Reset = 0; // This really should be 1, but I already went through the trouble of putting it to 1 everywhere else
        Mario_Punch_Counter_Reset = 1;
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
                if(edge_below_mario == 0 && jump_on_mario == 1) begin
                    Next_State = Mario_Jump_Right;
                end
                if(edge_below_mario == 0 && jump_on_mario == 0) begin
                    Next_State = Mario_Fall_Right;
                end
                if(keycode == 8'h0A)begin
                    Next_State = Mario_Punch1_Right;
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
                if(edge_below_mario == 0 && jump_on_mario == 1) begin
                    Next_State = Mario_Jump_Right;
                end
                if(edge_below_mario == 0 && jump_on_mario == 0) begin
                    Next_State = Mario_Fall_Right;
                end
                if(keycode == 8'h0A)begin
                    Next_State = Mario_Punch1_Right;
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
                if(edge_below_mario == 0 && jump_on_mario == 1) begin
                    Next_State = Mario_Jump_Right;
                end
                if(edge_below_mario == 0 && jump_on_mario == 0) begin
                    Next_State = Mario_Fall_Right;
                end
                if(keycode == 8'h0A)begin
                    Next_State = Mario_Punch1_Right;
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
                if(edge_below_mario == 0 && jump_on_mario == 1) begin
                    Next_State = Mario_Jump_Right;
                end
                if(edge_below_mario == 0 && jump_on_mario == 0) begin
                    Next_State = Mario_Fall_Right;
                end
                if(keycode == 8'h0A)begin
                    Next_State = Mario_Punch1_Right;
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
                if(edge_below_mario == 0 && jump_on_mario == 1) begin
                    Next_State = Mario_Jump_Left;
                end
                if(edge_below_mario == 0 && jump_on_mario == 0) begin
                    Next_State = Mario_Fall_Left;
                end
                if(keycode == 8'h0A)begin
                    Next_State = Mario_Punch1_Left;
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
                if(edge_below_mario == 0 && jump_on_mario == 1) begin
                    Next_State = Mario_Jump_Left;
                end
                if(edge_below_mario == 0 && jump_on_mario == 0) begin
                    Next_State = Mario_Fall_Left;
                end
                if(keycode == 8'h0A)begin
                    Next_State = Mario_Punch1_Left;
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
                if(edge_below_mario == 0 && jump_on_mario == 1) begin
                    Next_State = Mario_Jump_Left;
                end
                if(edge_below_mario == 0 && jump_on_mario == 0) begin
                    Next_State = Mario_Fall_Left;
                end
                if(keycode == 8'h0A)begin
                    Next_State = Mario_Punch1_Left;
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
                if(edge_below_mario == 0 && jump_on_mario == 1) begin
                    Next_State = Mario_Jump_Left;
                end
                if(edge_below_mario == 0 && jump_on_mario == 0) begin
                    Next_State = Mario_Fall_Left;
                end
                if(keycode == 8'h0A)begin
                    Next_State = Mario_Punch1_Left;
                end
                Mario_Invert_Left = 1;
            end
            Mario_Fall_Left: begin /// CAN ADD FRAME HERE LATER FOR FALLING ANIMATION
                Mario_Invert_Left = 1;
                Mario_Walk_Counter_Reset = 1;
                if(edge_below_mario == 0) begin
                    if(keycode == 8'h07) begin
                        Next_State = Mario_Fall_Right;
                    end
                end
                else
                begin
                    Next_State = Mario_Stationary_Left;
                end
                if(keycode == 8'h0A)begin
                    Next_State = Mario_Punch1_Left;
                end
                //Mario_Walk_Counter_Reset = 1;
            end
            Mario_Fall_Right: begin /// CAN ADD FRAME HERE FOR FALLING ANIMATION
                Mario_Walk_Counter_Reset = 1;
                if(edge_below_mario == 0) begin
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
                if(keycode == 8'h0A)begin
                    Next_State = Mario_Punch1_Right;
                end
                //Mario_Walk_Counter_Reset = 0;
            end
            Mario_Jump_Right: begin
                Mario_Walk_Counter_Reset = 1;
                if(jump_on_mario == 1) begin
                    if(keycode == 8'h04) begin
                        Next_State = Mario_Jump_Left;
                    end
                    else begin
                        Next_State = Mario_Jump_Right;
                    end
                end
                else if(edge_below_mario == 0 && jump_on_mario == 0)
                begin
                    Next_State = Mario_Fall_Right;
                end
                else begin
                    Next_State = Mario_Stationary_Right;
                end
                if(keycode == 8'h0A)begin
                    Next_State = Mario_Punch1_Right;
                end
            end
            Mario_Jump_Left: begin
                 Mario_Invert_Left = 1;
                Mario_Walk_Counter_Reset = 1;
                if(jump_on_mario == 1) begin
                    if(keycode == 8'h07) begin
                        Next_State = Mario_Jump_Right;
                    end
                    else begin
                        Next_State = Mario_Jump_Left;
                    end
                end
                else if(edge_below_mario == 0 && jump_on_mario == 0)
                begin
                    Next_State = Mario_Fall_Left;
                end
                else begin
                    Next_State = Mario_Stationary_Left;
                end
                if(keycode == 8'h0A)begin
                    Next_State = Mario_Punch1_Left;
                end
            end
            Mario_Punch1_Right: begin
                Mario_Punch_Counter_Reset = 0;
                if(keycode != 8'h04)begin
                    if(Mario_Punch_Counter > Mario_Punch_Delay)begin
                        Next_State = Mario_Punch2_Right;
                        Mario_Punch_Counter_Reset = 1;
                    end
                    else begin
                        Mario_Punch_Counter_Tracker = 1;
                        Next_State = Mario_Punch1_Right;
                    end
                end
                else begin
                    if(Mario_Punch_Counter > Mario_Punch_Delay)begin
                        Next_State = Mario_Punch2_Left;
                        Mario_Punch_Counter_Reset = 1;
                    end
                    else begin
                        Mario_Punch_Counter_Tracker = 1;
                        Next_State = Mario_Punch1_Left;
                    end
                end
            end
            Mario_Punch2_Right: begin
                Mario_Punch_Counter_Reset = 0;
                if(Mario_Punch_Counter > Mario_Punch_Delay) begin
                    //Next State Logic
                    if(keycode != 8'h04) begin
                        if(jump_on_mario) begin
                            Next_State = Mario_Jump_Right;
                        end
                        else if(edge_below_mario == 0) begin
                                Next_State = Mario_Fall_Right;
                            end
                        else if(keycode == 8'h07) begin
                            Next_State = Mario_Walk_Right1;
                        end
                        else begin
                            Next_State = Mario_Stationary_Right;
                    end
                    end
                    else begin
                        if(jump_on_mario) begin
                            Next_State = Mario_Jump_Left;
                        end
                        else if(edge_below_mario == 0) begin
                                Next_State = Mario_Fall_Left;
                         
                        end
                        else  begin
                            Next_State = Mario_Walk_Left1;
                        end
                        // else begin
                        //     Next_State = Mario_Stationary_Left;
                    end
                end
                else begin
                    if(keycode == 8'h04) begin
                        Next_State = Mario_Punch2_Left;
                    end
                    else begin
                        Next_State = Mario_Punch2_Right;
                    end

                end
            end
            Mario_Punch1_Left: begin
                Mario_Punch_Counter_Reset = 0;
                Mario_Invert_Left = 1;
                if(keycode != 8'h07)begin
                    if(Mario_Punch_Counter > Mario_Punch_Delay)begin
                        Next_State = Mario_Punch2_Left;
                        Mario_Punch_Counter_Reset = 1;
                    end
                    else begin
                        Mario_Punch_Counter_Tracker = 1;
                        Next_State = Mario_Punch1_Left;
                    end
                end
                else begin
                    if(Mario_Punch_Counter > Mario_Punch_Delay)begin
                        Next_State = Mario_Punch2_Right;
                        Mario_Punch_Counter_Reset = 1;
                    end
                    else begin
                        Mario_Punch_Counter_Tracker = 1;
                        Next_State = Mario_Punch1_Right;
                    end
                end
            end
            Mario_Punch2_Left: begin
                Mario_Punch_Counter_Reset = 0;
                Mario_Invert_Left = 1;
                if(Mario_Punch_Counter > Mario_Punch_Delay) begin
                    //Next State Logic
                    if(keycode != 8'h07) begin
                        if(jump_on_mario) begin
                            Next_State = Mario_Jump_Left;
                        end
                        else if (edge_below_mario == 0) begin
                                Next_State = Mario_Fall_Left;
                        end
                        else if(keycode == 8'h04) begin
                            Next_State = Mario_Walk_Left1;
                        end
                        else begin
                            Next_State = Mario_Stationary_Left;
                    end
                    end
                    else begin
                        if(jump_on_mario) begin
                            Next_State = Mario_Jump_Right;
                        end
                        else if(edge_below_mario == 0) begin
                                Next_State = Mario_Fall_Right;
                            end
                        
                        else  begin
                            Next_State = Mario_Walk_Right1;
                        end
                        // else begin
                        //     Next_State = Mario_Stationary_Left;
                    end
                end
                else begin
                    if(keycode == 8'h07) begin
                        Next_State = Mario_Punch2_Right;
                    end
                    else begin
                        Next_State = Mario_Punch2_Left;
                    end

                end
            end

		endcase
        //edge_below_mario_previous == 1 && 
        // if(edge_below_mario == 0) begin
        //     if((State == Mario_Stationary_Right) || (State == Mario_Walk_Right1)
        //     || (State == Mario_Walk_Right2) || (State == Mario_Walk_Right3)) begin
        //         Next_State = Mario_Fall_Right;
        //     end
        //     else begin
        //     Next_State = Mario_Fall_Left;
        //     end
        // end
        
    end
		// Assign control signals based on current state
		
	
endmodule
