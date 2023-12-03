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


module Luigi_State (   input logic  Clk, 
									Reset,
                            input logic [7:0] keycode,
                            input logic edge_below_luigi,
                            input logic jump_on_luigi,
                            output logic [4:0] Luigi_State_Out,
                            output logic Luigi_Invert_Left
									
				);

	enum logic [4:0] {  Luigi_Stationary_Right, Luigi_Stationary_Left, 
                        Luigi_Walk_Right1, Luigi_Walk_Right2, Luigi_Walk_Right3, 
                        Luigi_Walk_Left1, Luigi_Walk_Left2, Luigi_Walk_Left3, Luigi_Fall_Left,
                         Luigi_Fall_Right, Luigi_Jump_Right, Luigi_Jump_Left, Luigi_Punch1_Right, 
                         Luigi_Punch2_Right, Luigi_Punch1_Left, Luigi_Punch2_Left}   State, Next_State;   // Internal state logic
    //logic edge_below_luigi_previous;
    always_comb begin
        Luigi_State_Out = State; 
    end
		
	always_ff @ (posedge Clk)
	begin
		if (Reset) begin
			State <= Luigi_Stationary_Right;
			//edge_below_luigi_previous <= 1;
			end
		else 
			State <= Next_State;
	end
   
	int Luigi_Walk_Delay = 4666667;
    logic Luigi_Walk_Counter_Tracker;
    logic Luigi_Walk_Counter_Reset;
    logic [22:0] Luigi_Walk_Counter;
    int Luigi_Punch_Delay = 25000000;
    logic Luigi_Punch_Counter_Tracker;
    logic Luigi_Punch_Counter_Reset;
    logic [25:0] Luigi_Punch_Counter;
    
    always_ff @ (posedge Clk) begin
            if(Luigi_Punch_Counter_Reset)begin
                Luigi_Punch_Counter <= 0;
            end
            else begin
                Luigi_Punch_Counter <= Luigi_Punch_Counter + Luigi_Punch_Counter_Tracker;
            end
                //update the register counter value
        end

    always_ff @ (posedge Clk) begin
        if(Luigi_Walk_Counter_Reset)begin
            Luigi_Walk_Counter <= 0;
        end
        else begin
            Luigi_Walk_Counter <= Luigi_Walk_Counter + Luigi_Walk_Counter_Tracker;
        end
            //update the register counter value
    end
    //always_ff @ (posedge Clk) begin
        //edge_below_luigi_previous <= edge_below_luigi;
    //end
    
    
    always_comb
	begin 
		Luigi_Walk_Counter_Tracker = 0;
        Luigi_Walk_Counter_Reset = 0; // This really should be 1, but I already went through the trouble of putting it to 1 everywhere else
        Luigi_Punch_Counter_Reset = 1;
//		Statetest = State;
		// Default next state is staying at current state
		Next_State = State;
		Luigi_Invert_Left = 0;
		unique case (State)
			
            Luigi_Stationary_Right : begin
                if((keycode == 8'h04)) begin
                    Next_State = Luigi_Walk_Left1;
                end
                if(keycode == 8'h07) begin
                    Next_State = Luigi_Walk_Right1;
                end
                if(edge_below_luigi == 0 && jump_on_luigi == 1) begin
                    Next_State = Luigi_Jump_Right;
                end
                if(edge_below_luigi == 0 && jump_on_luigi == 0) begin
                    Next_State = Luigi_Fall_Right;
                end
                if(keycode == 8'h0A)begin
                    Next_State = Luigi_Punch1_Right;
                end
                Luigi_Walk_Counter_Reset = 1;
            end
			Luigi_Walk_Right1 :  begin
				if(keycode != 8'h07)  begin
                    if(keycode == 8'h04)begin
                        Next_State = Luigi_Walk_Left1;
                    end
                    else begin
                        Next_State = Luigi_Stationary_Right;
                    end
                    Luigi_Walk_Counter_Reset = 1;
                end
                else if(Luigi_Walk_Counter >= Luigi_Walk_Delay) begin
                    Next_State = Luigi_Walk_Right2;
                    Luigi_Walk_Counter_Reset = 1;
                end
                else begin
                    Next_State = Luigi_Walk_Right1;
                    Luigi_Walk_Counter_Tracker = 1;
                end
                if(edge_below_luigi == 0 && jump_on_luigi == 1) begin
                    Next_State = Luigi_Jump_Right;
                end
                if(edge_below_luigi == 0 && jump_on_luigi == 0) begin
                    Next_State = Luigi_Fall_Right;
                end
                if(keycode == 8'h0A)begin
                    Next_State = Luigi_Punch1_Right;
                end
            end
			Luigi_Walk_Right2 : begin               //e.g. S_33_2, etc. How many? As a hint, note that the BRAM is synchronous, in addition, 
				if(keycode != 8'h07)  begin
                    if(keycode == 8'h04)begin
                        Next_State = Luigi_Walk_Left1;
                    end
                    else begin
                        Next_State = Luigi_Stationary_Right;
                    end
                    Luigi_Walk_Counter_Reset = 1;
                end
                else if(Luigi_Walk_Counter >= Luigi_Walk_Delay) begin
                    Next_State = Luigi_Walk_Right3;
                    Luigi_Walk_Counter_Reset = 1;
                end
                else begin
                    Next_State = Luigi_Walk_Right2;
                    Luigi_Walk_Counter_Tracker = 1;
                end 
                if(edge_below_luigi == 0 && jump_on_luigi == 1) begin
                    Next_State = Luigi_Jump_Right;
                end
                if(edge_below_luigi == 0 && jump_on_luigi == 0) begin
                    Next_State = Luigi_Fall_Right;
                end
                if(keycode == 8'h0A)begin
                    Next_State = Luigi_Punch1_Right;
                end
            end
			Luigi_Walk_Right3 : begin
				if(keycode != 8'h07)  begin
                    if(keycode == 8'h04)begin
                        Next_State = Luigi_Walk_Left1;
                    end
                    else begin
                        Next_State = Luigi_Stationary_Right;
                    end
                    Luigi_Walk_Counter_Reset = 1;
                end
                else if(Luigi_Walk_Counter >= Luigi_Walk_Delay) begin
                    Next_State = Luigi_Walk_Right1;
                    Luigi_Walk_Counter_Reset = 1;
                end
                else begin
                    Next_State = Luigi_Walk_Right3;
                    Luigi_Walk_Counter_Tracker = 1;
                end 
                if(edge_below_luigi == 0 && jump_on_luigi == 1) begin
                    Next_State = Luigi_Jump_Right;
                end
                if(edge_below_luigi == 0 && jump_on_luigi == 0) begin
                    Next_State = Luigi_Fall_Right;
                end
                if(keycode == 8'h0A)begin
                    Next_State = Luigi_Punch1_Right;
                end
            end
			Luigi_Stationary_Left :	begin
                Luigi_Invert_Left = 1;			
				if((keycode == 8'h04)) begin
                    Next_State = Luigi_Walk_Left1;
                end
                if(keycode == 8'h07) begin
                    Next_State = Luigi_Walk_Right1;
                end
                if(edge_below_luigi == 0 && jump_on_luigi == 1) begin
                    Next_State = Luigi_Jump_Left;
                end
                if(edge_below_luigi == 0 && jump_on_luigi == 0) begin
                    Next_State = Luigi_Fall_Left;
                end
                if(keycode == 8'h0A)begin
                    Next_State = Luigi_Punch1_Left;
                end
                Luigi_Walk_Counter_Reset = 1;
            end
			Luigi_Walk_Left1 : begin
                Luigi_Invert_Left = 1;
				if(keycode != 8'h04)  begin
                    if(keycode == 8'h07)begin
                        Next_State = Luigi_Walk_Right1;
                    end
                    else begin
                        Next_State = Luigi_Stationary_Left;
                    end
                    Luigi_Walk_Counter_Reset = 1;
                end
                

                else if(Luigi_Walk_Counter >= Luigi_Walk_Delay) begin
                    Next_State = Luigi_Walk_Left2;
                    Luigi_Walk_Counter_Reset = 1;
                end
                else begin
                    Next_State = Luigi_Walk_Left1;
                    Luigi_Walk_Counter_Tracker = 1;
                end
                if(edge_below_luigi == 0 && jump_on_luigi == 1) begin
                    Next_State = Luigi_Jump_Left;
                end
                if(edge_below_luigi == 0 && jump_on_luigi == 0) begin
                    Next_State = Luigi_Fall_Left;
                end
                if(keycode == 8'h0A)begin
                    Next_State = Luigi_Punch1_Left;
                end
            end
            Luigi_Walk_Left2 : begin
                Luigi_Invert_Left = 1;
                if(keycode != 8'h04)  begin
                    if(keycode == 8'h07)begin
                        Next_State = Luigi_Walk_Right1;
                    end
                    else begin
                        Next_State = Luigi_Stationary_Left;
                    end
                    Luigi_Walk_Counter_Reset = 1;
                end
                else if(Luigi_Walk_Counter >= Luigi_Walk_Delay) begin
                    Next_State = Luigi_Walk_Left3;
                    Luigi_Walk_Counter_Reset = 1;
                end
                else begin
                    Next_State = Luigi_Walk_Left2;
                    Luigi_Walk_Counter_Tracker = 1;
                end
                if(edge_below_luigi == 0 && jump_on_luigi == 1) begin
                    Next_State = Luigi_Jump_Left;
                end
                if(edge_below_luigi == 0 && jump_on_luigi == 0) begin
                    Next_State = Luigi_Fall_Left;
                end
                if(keycode == 8'h0A)begin
                    Next_State = Luigi_Punch1_Left;
                end
            end
            Luigi_Walk_Left3 : begin
                Luigi_Invert_Left = 1;
                if(keycode != 8'h04)  begin
                    if(keycode == 8'h07)begin
                        Next_State = Luigi_Walk_Right1;
                    end
                    else begin
                        Next_State = Luigi_Stationary_Left;
                    end
                    Luigi_Walk_Counter_Reset = 1;
                end
                else if(Luigi_Walk_Counter >= Luigi_Walk_Delay) begin
                    Next_State = Luigi_Walk_Left1;
                    Luigi_Walk_Counter_Reset = 1;
                end
                else begin
                    Next_State = Luigi_Walk_Left3;
                    Luigi_Walk_Counter_Tracker = 1;
                end
                if(edge_below_luigi == 0 && jump_on_luigi == 1) begin
                    Next_State = Luigi_Jump_Left;
                end
                if(edge_below_luigi == 0 && jump_on_luigi == 0) begin
                    Next_State = Luigi_Fall_Left;
                end
                if(keycode == 8'h0A)begin
                    Next_State = Luigi_Punch1_Left;
                end
                Luigi_Invert_Left = 1;
            end
            Luigi_Fall_Left: begin /// CAN ADD FRAME HERE LATER FOR FALLING ANIMATION
                Luigi_Invert_Left = 1;
                Luigi_Walk_Counter_Reset = 1;
                if(edge_below_luigi == 0) begin
                    if(keycode == 8'h07) begin
                        Next_State = Luigi_Fall_Right;
                    end
                end
                else
                begin
                    Next_State = Luigi_Stationary_Left;
                end
                if(keycode == 8'h0A)begin
                    Next_State = Luigi_Punch1_Left;
                end
                //Luigi_Walk_Counter_Reset = 1;
            end
            Luigi_Fall_Right: begin /// CAN ADD FRAME HERE FOR FALLING ANIMATION
                Luigi_Walk_Counter_Reset = 1;
                if(edge_below_luigi == 0) begin
                    if(keycode == 8'h04) begin
                        Next_State = Luigi_Fall_Left;
                    end
                    else begin
                        Next_State = Luigi_Fall_Right;
                    end
                end
                else
                begin
                    Next_State = Luigi_Stationary_Right;
                end
                if(keycode == 8'h0A)begin
                    Next_State = Luigi_Punch1_Right;
                end
                //Luigi_Walk_Counter_Reset = 0;
            end
            Luigi_Jump_Right: begin
                Luigi_Walk_Counter_Reset = 1;
                if(jump_on_luigi == 1) begin
                    if(keycode == 8'h04) begin
                        Next_State = Luigi_Jump_Left;
                    end
                    else begin
                        Next_State = Luigi_Jump_Right;
                    end
                end
                else if(edge_below_luigi == 0 && jump_on_luigi == 0)
                begin
                    Next_State = Luigi_Fall_Right;
                end
                else begin
                    Next_State = Luigi_Stationary_Right;
                end
                if(keycode == 8'h0A)begin
                    Next_State = Luigi_Punch1_Right;
                end
            end
            Luigi_Jump_Left: begin
                 Luigi_Invert_Left = 1;
                Luigi_Walk_Counter_Reset = 1;
                if(jump_on_luigi == 1) begin
                    if(keycode == 8'h07) begin
                        Next_State = Luigi_Jump_Right;
                    end
                    else begin
                        Next_State = Luigi_Jump_Left;
                    end
                end
                else if(edge_below_luigi == 0 && jump_on_luigi == 0)
                begin
                    Next_State = Luigi_Fall_Left;
                end
                else begin
                    Next_State = Luigi_Stationary_Left;
                end
                if(keycode == 8'h0A)begin
                    Next_State = Luigi_Punch1_Left;
                end
            end
            Luigi_Punch1_Right: begin
                Luigi_Punch_Counter_Reset = 0;
                if(keycode != 8'h04)begin
                    if(Luigi_Punch_Counter > Luigi_Punch_Delay)begin
                        Next_State = Luigi_Punch2_Right;
                        Luigi_Punch_Counter_Reset = 1;
                    end
                    else begin
                        Luigi_Punch_Counter_Tracker = 1;
                        Next_State = Luigi_Punch1_Right;
                    end
                end
                else begin
                    if(Luigi_Punch_Counter > Luigi_Punch_Delay)begin
                        Next_State = Luigi_Punch2_Left;
                        Luigi_Punch_Counter_Reset = 1;
                    end
                    else begin
                        Luigi_Punch_Counter_Tracker = 1;
                        Next_State = Luigi_Punch1_Left;
                    end
                end
            end
            Luigi_Punch2_Right: begin
                Luigi_Punch_Counter_Reset = 0;
                if(Luigi_Punch_Counter > Luigi_Punch_Delay) begin
                    //Next State Logic
                    if(keycode != 8'h04) begin
                        if(jump_on_luigi) begin
                            Next_State = Luigi_Jump_Right;
                        end
                        else if(edge_below_luigi == 0) begin
                                Next_State = Luigi_Fall_Right;
                            end
                        else if(keycode == 8'h07) begin
                            Next_State = Luigi_Walk_Right1;
                        end
                        else begin
                            Next_State = Luigi_Stationary_Right;
                    end
                    end
                    else begin
                        if(jump_on_luigi) begin
                            Next_State = Luigi_Jump_Left;
                        end
                        else if(edge_below_luigi == 0) begin
                                Next_State = Luigi_Fall_Left;
                         
                        end
                        else  begin
                            Next_State = Luigi_Walk_Left1;
                        end
                        // else begin
                        //     Next_State = Luigi_Stationary_Left;
                    end
                end
                else begin
                    if(keycode == 8'h04) begin
                        Next_State = Luigi_Punch2_Left;
                    end
                    else begin
                        Next_State = Luigi_Punch2_Right;
                    end

                end
            end
            Luigi_Punch1_Left: begin
                Luigi_Punch_Counter_Reset = 0;
                Luigi_Invert_Left = 1;
                if(keycode != 8'h07)begin
                    if(Luigi_Punch_Counter > Luigi_Punch_Delay)begin
                        Next_State = Luigi_Punch2_Left;
                        Luigi_Punch_Counter_Reset = 1;
                    end
                    else begin
                        Luigi_Punch_Counter_Tracker = 1;
                        Next_State = Luigi_Punch1_Left;
                    end
                end
                else begin
                    if(Luigi_Punch_Counter > Luigi_Punch_Delay)begin
                        Next_State = Luigi_Punch2_Right;
                        Luigi_Punch_Counter_Reset = 1;
                    end
                    else begin
                        Luigi_Punch_Counter_Tracker = 1;
                        Next_State = Luigi_Punch1_Right;
                    end
                end
            end
            Luigi_Punch2_Left: begin
                Luigi_Punch_Counter_Reset = 0;
                Luigi_Invert_Left = 1;
                if(Luigi_Punch_Counter > Luigi_Punch_Delay) begin
                    //Next State Logic
                    if(keycode != 8'h07) begin
                        if(jump_on_luigi) begin
                            Next_State = Luigi_Jump_Left;
                        end
                        else if (edge_below_luigi == 0) begin
                                Next_State = Luigi_Fall_Left;
                        end
                        else if(keycode == 8'h04) begin
                            Next_State = Luigi_Walk_Left1;
                        end
                        else begin
                            Next_State = Luigi_Stationary_Left;
                    end
                    end
                    else begin
                        if(jump_on_luigi) begin
                            Next_State = Luigi_Jump_Right;
                        end
                        else if(edge_below_luigi == 0) begin
                                Next_State = Luigi_Fall_Right;
                            end
                        
                        else  begin
                            Next_State = Luigi_Walk_Right1;
                        end
                        // else begin
                        //     Next_State = Luigi_Stationary_Left;
                    end
                end
                else begin
                    if(keycode == 8'h07) begin
                        Next_State = Luigi_Punch2_Right;
                    end
                    else begin
                        Next_State = Luigi_Punch2_Left;
                    end

                end
            end

		endcase
        //edge_below_luigi_previous == 1 && 
        // if(edge_below_luigi == 0) begin
        //     if((State == Luigi_Stationary_Right) || (State == Luigi_Walk_Right1)
        //     || (State == Luigi_Walk_Right2) || (State == Luigi_Walk_Right3)) begin
        //         Next_State = Luigi_Fall_Right;
        //     end
        //     else begin
        //     Next_State = Luigi_Fall_Left;
        //     end
        // end
        
    end
		// Assign control signals based on current state
		
	
endmodule
