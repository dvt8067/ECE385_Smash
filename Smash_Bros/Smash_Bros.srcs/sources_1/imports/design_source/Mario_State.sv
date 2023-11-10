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
                            output logic [4:0] Mario_State_Out,
                            output logic Mario_Invert_Left
									
				);

	enum logic [4:0] {  Mario_Stationary_Right, Mario_Stationary_Left, 
                        Mario_Walk_Right1, Mario_Walk_Right2, Mario_Walk_Right3, 
                        Mario_Walk_Left1, Mario_Walk_Left2, Mario_Walk_Left3}   State, Next_state;   // Internal state logic
    always_comb begin
        Mario_State_Out = State; 
    end
		
	always_ff @ (posedge Clk)
	begin
		if (Reset) 
			State <= Mario_Stationary_Right;
		else 
			State <= Next_state;
	end
   
	int Mario_Walk_Delay = 4166667
    int Mario_Walk_Counter;

    always_ff begin
        //IF (always_comb signal)
            //update the register counter value
    end
    
    
    
    always_comb
	begin 
		
//		Statetest = State;
		// Default next state is staying at current state
		Next_state = State;
		Mario_Invert_Left = 0;
		unique case (State)
			
            Mario_Stationary_Right : 
                if((keycode == 8'h04)) begin
                    Next_state = Mario_Walk_Left1;
                end
                if(keycode == 8'h07) begin
                    Next_state = Mario_Walk_Right1;
                end
                Mario_Walk_Counter = 0;

			Mario_Walk_Right1 : 
				if(keycode != 8'h07)  begin
                    if(keycode == 8'h04)begin
                        Next_state = Mario_Walk_Left1;
                    end
                    else begin
                        Next_State = Mario_Stationary_Right;
                    end
                    Mario_Walk_Counter = 0;
                end
                else if(Mario_Walk_Counter >= Mario_Walk_Delay) begin
                    Next_State = Mario_Walk_Right2;
                    Mario_Walk_Counter = 0;
                end
                else begin
                    Next_State = Mario_Walk_Right1;
                    Mario_Walk_Counter = Mario_Walk_Counter+1;
                end
            
			Mario_Walk_Right2 :                //e.g. S_33_2, etc. How many? As a hint, note that the BRAM is synchronous, in addition, 
				if(keycode != 8'h07)  begin
                    if(keycode == 8'h04)begin
                        Next_state = Mario_Walk_Left1;
                    end
                    else begin
                        Next_State = Mario_Stationary_Right;
                    end
                    Mario_Walk_Counter = 0;
                end
                else if(Mario_Walk_Counter >= Mario_Walk_Delay) begin
                    Next_State = Mario_Walk_Right3;
                    Mario_Walk_Counter = 0;
                end
                else begin
                    Next_State = Mario_Walk_Right2;
                    Mario_Walk_Counter = Mario_Walk_Counter+1;
                end 

			Mario_Walk_Right3 : 
				if(keycode != 8'h07)  begin
                    if(keycode == 8'h04)begin
                        Next_state = Mario_Walk_Left1;
                    end
                    else begin
                        Next_State = Mario_Stationary_Right;
                    end
                    Mario_Walk_Counter = 0;
                end
                else if(Mario_Walk_Counter >= Mario_Walk_Delay) begin
                    Next_State = Mario_Walk_Right1;
                    Mario_Walk_Counter = 0;
                end
                else begin
                    Next_State = Mario_Walk_Right2;
                    Mario_Walk_Counter = Mario_Walk_Counter+1;
                end 

			Mario_Stationary_Left :	
                Mario_Invert_Left = 1;			
				if((keycode == 8'h04)) begin
                    Next_state = Mario_Walk_Left1;
                end
                if(keycode == 8'h07) begin
                    Next_state = Mario_Walk_Right1;
                end
                Mario_Walk_Counter = 0;
                
			Mario_Walk_Left1 :
                Mario_Invert_Left = 1;
				if(keycode != 8'h04)  begin
                    if(keycode == 8'h07)begin
                        Next_state = Mario_Walk_Right1;
                    end
                    else begin
                        Next_State = Mario_Stationary_Left;
                    end
                    Mario_Walk_Counter = 0;
                end
                

                else if(Mario_Walk_Counter >= Mario_Walk_Delay) begin
                    Next_State = Mario_Walk_Left2;
                    Mario_Walk_Counter = 0;
                end
                else begin
                    Next_State = Mario_Walk_Left1;
                    Mario_Walk_Counter = Mario_Walk_Counter+1;
                end
            Mario_Walk_Left2 :
                Mario_Invert_Left = 1;
                if(keycode != 8'h04)  begin
                    if(keycode == 8'h07)begin
                        Next_state = Mario_Walk_Right1;
                    end
                    else begin
                        Next_State = Mario_Stationary_Left;
                    end
                    Mario_Walk_Counter = 0;
                end
                else if(Mario_Walk_Counter >= Mario_Walk_Delay) begin
                    Next_State = Mario_Walk_Left3;
                    Mario_Walk_Counter = 0;
                end
                else begin
                    Next_State = Mario_Walk_Left2;
                    Mario_Walk_Counter = Mario_Walk_Counter+1;
                end
                
            Mario_Walk_Left3 :
                Mario_Invert_Left = 1;
                if(keycode != 8'h04)  begin
                    if(keycode == 8'h07)begin
                        Next_state = Mario_Walk_Right1;
                    end
                    else begin
                        Next_State = Mario_Stationary_Left;
                    end
                    Mario_Walk_Counter = 0;
                end
                else if(Mario_Walk_Counter >= Mario_Walk_Delay) begin
                    Next_State = Mario_Walk_Left1;
                    Mario_Walk_Counter = 0;
                end
                else begin
                    Next_State = Mario_Walk_Left3;
                    Mario_Walk_Counter = Mario_Walk_Counter+1;
                end
                Mario_Invert_Left = 1;

		endcase
		
		// Assign control signals based on current state
		case (State)  // Tri state buffers controlled by specific state value, which then correpeond do the one hot encoding on the MUX
			Halted: ; 
			S_18 : 
				begin 
					

				end
			S_33_1 : //You may have to think about this as well to adapt to RAM with wait-states
				begin
    end					
				end
			S_33_2 :
				begin
					
				end
			S_33_3 :
				begin
					
				end
			S_35 : 
				begin 
					
				end
			
			S_32 : 
				begin

                end
			S_01 : 
				begin 
					
				end

			// You need to finish the rest of states..... 

			default : ;
		endcase
	end 

	
endmodule
