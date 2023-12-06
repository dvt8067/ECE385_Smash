module Game_Logic
(

        input logic [9:0] Mario_size_X,
        input logic [9:0]Mario_size_Y,
        input logic Mario_Invert_Left,
        input logic Luigi_Invert_Left,
        input logic [9:0]MarioX,
        input logic [9:0]MarioY,
        input logic [9:0]LuigiX, 
        input logic [9:0]LuigiY, 
        input logic [9:0]Luigi_size_X, 
        input logic [9:0]Luigi_size_Y,
        input logic [4:0]Mario_State,
        input logic [4:0]Luigi_State,
        input logic Clk,
        input logic frame_clk,

        output logic Stop_Mario_Left, Stop_Mario_Right, Stop_Mario_Up, Stop_Mario_Down,
        output logic Stop_Luigi_Left, Stop_Luigi_Right, Stop_Luigi_Up, Stop_Luigi_Down,
        output logic Luigi_Movement_Lockout, Mario_Movement_Lockout,
        output logic [6:0] Mario_Percent, Luigi_Percent,
        output logic Mario_Punch_Sucessful, Luigi_Punch_Sucessful
);
// X line overalp section
logic [9:0] Mario_Rightmost_X, Mario_Leftmost_X, Mario_Bottommost_Y, Mario_Topmost_Y;
assign Mario_Rightmost_X = MarioX+Mario_size_X;
assign Mario_Leftmost_X = MarioX-Mario_size_X;
//assign Mario_Bottommost_Y = MarioY+Mario_size_Y;
//assign Mario_Topmost_Y = MarioY-Mario_size_Y;
assign Mario_Bottommost_Y = MarioY+40;
assign Mario_Topmost_Y = MarioY-40;

logic [9:0] Luigi_Rightmost_X, Luigi_Leftmost_X, Luigi_Bottommost_Y, Luigi_Topmost_Y;
assign Luigi_Rightmost_X = LuigiX+Luigi_size_X;
assign Luigi_Leftmost_X = LuigiX-Luigi_size_X;
assign Luigi_Bottommost_Y = LuigiY+40;
assign Luigi_Topmost_Y = LuigiY-40;

//assign Luigi_Bottommost_Y = LuigiY+Luigi_size_Y;
//assign Luigi_Topmost_Y = LuigiY-Luigi_size_Y;

logic Mario_Lockout_Tracker, Luigi_Lockout_Tracker;
logic [5:0] Luigi_Lockout_Counter, Mario_Lockout_Counter;
logic [5:0] Lockout_Delay;
logic Mario_Lockout_Counter_Reset, Luigi_Lockout_Counter_Reset;
assign Mario_Lockout_Counter_Reset = 1'b0;
assign Luigi_Lockout_Counter_Reset = 1'b0;
assign Luigi_Lockout_Tracker = 1'b0;
assign Mario_Lockout_Tracker = 1'b0;
assign Luigi_Movement_Lockout = 1'b0;
assign Mario_Movement_Lockout = 1'b0;
assign Lockout_Delay = 6'd30;

logic Luigi_Lockout_Count, Mario_Lockout_Count;



 always_ff @ (posedge frame_clk) begin
        if(Mario_Lockout_Counter_Reset)begin
            Mario_Lockout_Counter <= 0;
        end
        else if(Mario_Lockout_Count)begin
            Mario_Lockout_Counter <= Mario_Lockout_Counter + 1;
        end
        else begin 
                Mario_Lockout_Counter <= Mario_Lockout_Counter;
        end
 end

 
 always_ff @ (posedge frame_clk) begin
        if(Luigi_Lockout_Counter_Reset)begin
            Luigi_Lockout_Counter <= 0;
        end
        else if(Luigi_Lockout_Count)begin
            Luigi_Lockout_Counter <= Mario_Lockout_Counter + 1;
        end
        else begin 
                Mario_Lockout_Counter <= Mario_Lockout_Counter;
        end
 end
always_comb begin
Stop_Luigi_Down = 1'b0;
Stop_Luigi_Up = 1'b0;
Stop_Luigi_Left = 1'b0;
Stop_Luigi_Right = 1'b0;
Stop_Mario_Down = 1'b0;
Stop_Mario_Up = 1'b0;
Stop_Mario_Left = 1'b0;
Stop_Mario_Right = 1'b0;

if(((Mario_Rightmost_X  == Luigi_Leftmost_X - 4) || (Mario_Rightmost_X  == Luigi_Leftmost_X - 3) || (Mario_Rightmost_X  == Luigi_Leftmost_X - 2) || (Mario_Rightmost_X  == Luigi_Leftmost_X -1) || (Mario_Rightmost_X  == Luigi_Leftmost_X )
        || (Mario_Rightmost_X  == Luigi_Leftmost_X + 1) || (Mario_Rightmost_X  == Luigi_Leftmost_X + 2) || (Mario_Rightmost_X  == Luigi_Leftmost_X + 3)) 
        && ((Mario_Topmost_Y < Luigi_Bottommost_Y) && Mario_Bottommost_Y > Luigi_Topmost_Y)) begin
        Stop_Mario_Right = 1'b1;
        end
if(( (Mario_Leftmost_X  == Luigi_Rightmost_X - 3) || (Mario_Leftmost_X  == Luigi_Rightmost_X - 2) || (Mario_Leftmost_X  == Luigi_Rightmost_X -1) || (Mario_Leftmost_X  == Luigi_Rightmost_X )
        || (Mario_Leftmost_X  == Luigi_Rightmost_X + 1) || (Mario_Leftmost_X  == Luigi_Rightmost_X + 2) || (Mario_Leftmost_X  == Luigi_Rightmost_X + 3)
        || (Mario_Leftmost_X  == Luigi_Rightmost_X + 4)) 
        && ((Mario_Topmost_Y < Luigi_Bottommost_Y) && Mario_Bottommost_Y > Luigi_Topmost_Y)) begin
        Stop_Mario_Left = 1'b1; 
        end

if(((Luigi_Rightmost_X  == Mario_Leftmost_X - 4) ||(Luigi_Rightmost_X  == Mario_Leftmost_X - 3) || (Luigi_Rightmost_X  == Mario_Leftmost_X - 2) || (Luigi_Rightmost_X  == Mario_Leftmost_X -1) || (Luigi_Rightmost_X  == Mario_Leftmost_X )
        || (Luigi_Rightmost_X  == Mario_Leftmost_X + 1) || (Luigi_Rightmost_X  == Mario_Leftmost_X + 2)|| (Luigi_Rightmost_X  == Mario_Leftmost_X + 3)) 
        && ((Luigi_Topmost_Y < Mario_Bottommost_Y) && Luigi_Bottommost_Y > Mario_Topmost_Y)) begin
        Stop_Luigi_Right = 1'b1;
        end 
if((( Luigi_Leftmost_X  == Mario_Rightmost_X - 3) ||(Luigi_Leftmost_X  == Mario_Rightmost_X - 2) || (Luigi_Leftmost_X  == Mario_Rightmost_X -1) || (Luigi_Leftmost_X  == Mario_Rightmost_X )
        || (Luigi_Leftmost_X  == Mario_Rightmost_X + 1) || (Luigi_Leftmost_X  == Mario_Rightmost_X + 2) || (Luigi_Leftmost_X  == Mario_Rightmost_X + 3)
        || (Luigi_Leftmost_X  == Mario_Rightmost_X + 4)) 
        && ((Luigi_Topmost_Y < Mario_Bottommost_Y) && Luigi_Bottommost_Y > Mario_Topmost_Y))begin
        Stop_Luigi_Left = 1'b1; 
        end   



if((Mario_Topmost_Y == Luigi_Bottommost_Y - 4) ||(Mario_Topmost_Y == Luigi_Bottommost_Y - 3) || (Mario_Topmost_Y == Luigi_Bottommost_Y - 2) || (Mario_Topmost_Y == Luigi_Bottommost_Y- 1) || (Mario_Topmost_Y == Luigi_Bottommost_Y )
        || (Mario_Topmost_Y == Luigi_Bottommost_Y + 1) || (Mario_Topmost_Y == Luigi_Bottommost_Y + 2) || (Mario_Topmost_Y == Luigi_Bottommost_Y + 3)
        || (Mario_Topmost_Y == Luigi_Bottommost_Y + 4))  begin
                //Stop_Mario_Up = 1'b1;
                if((Mario_Rightmost_X >= Luigi_Leftmost_X) && (Mario_Rightmost_X <= Luigi_Rightmost_X))begin
                        Stop_Mario_Up = 1'b1;
                end
                else if(((Mario_Leftmost_X >= Luigi_Leftmost_X) && (Mario_Leftmost_X <= Luigi_Rightmost_X)))begin
                       Stop_Mario_Up = 1'b1; 
                end
        end
if( (Mario_Bottommost_Y == Luigi_Topmost_Y - 4) || (Mario_Bottommost_Y == Luigi_Topmost_Y - 3) || (Mario_Bottommost_Y == Luigi_Topmost_Y - 2) || (Mario_Bottommost_Y == Luigi_Topmost_Y- 1) || (Mario_Bottommost_Y == Luigi_Topmost_Y )
        || (Mario_Bottommost_Y == Luigi_Topmost_Y + 1) || (Mario_Bottommost_Y == Luigi_Topmost_Y + 2) || (Mario_Bottommost_Y == Luigi_Topmost_Y +3)
        || (Mario_Bottommost_Y == Luigi_Topmost_Y +4)) 
                //Stop_Mario_Down = 1'b1;
        begin
                if((Mario_Rightmost_X >= Luigi_Leftmost_X) && (Mario_Rightmost_X <= Luigi_Rightmost_X)) begin
                        Stop_Mario_Down = 1'b1;
                end
                else if ((Mario_Leftmost_X >= Luigi_Leftmost_X) && (Mario_Leftmost_X <= Luigi_Rightmost_X)) begin
                        Stop_Mario_Down = 1'b1;
                end
        end


if((Luigi_Topmost_Y == Mario_Bottommost_Y - 4) || (Luigi_Topmost_Y == Mario_Bottommost_Y - 3) || 
(Luigi_Topmost_Y == Mario_Bottommost_Y - 2) || (Luigi_Topmost_Y == Mario_Bottommost_Y - 1) || (Luigi_Topmost_Y == Mario_Bottommost_Y)
        || (Luigi_Topmost_Y == Mario_Bottommost_Y + 1) || (Luigi_Topmost_Y == Mario_Bottommost_Y + 2) ||
        (Luigi_Topmost_Y == Mario_Bottommost_Y + 3)|| (Luigi_Topmost_Y == Mario_Bottommost_Y + 4))begin
                //Stop_Luigi_Up = 1'b1;
                if((Luigi_Rightmost_X >= Mario_Leftmost_X) && (Luigi_Rightmost_X <= Mario_Rightmost_X)) begin
                        Stop_Luigi_Up = 1'b1;
                end
                else if((Luigi_Leftmost_X >= Mario_Leftmost_X) && (Luigi_Leftmost_X <= Mario_Rightmost_X)) begin
                        Stop_Luigi_Up = 1'b1;
                end
        end
if((Luigi_Bottommost_Y == Mario_Topmost_Y - 4)||(Luigi_Bottommost_Y == Mario_Topmost_Y - 3)||(Luigi_Bottommost_Y == Mario_Topmost_Y - 2) || (Luigi_Bottommost_Y == Mario_Topmost_Y- 1) || (Luigi_Bottommost_Y == Mario_Topmost_Y )
        || (Mario_Bottommost_Y == Luigi_Topmost_Y + 1) || (Luigi_Bottommost_Y == Mario_Topmost_Y + 2)|| 
        (Luigi_Bottommost_Y == Mario_Topmost_Y + 3) || (Luigi_Bottommost_Y == Mario_Topmost_Y + 4)) begin
                //Stop_Luigi_Down = 1'b1;    
                if((Luigi_Rightmost_X >= Mario_Leftmost_X) && (Luigi_Rightmost_X <= Mario_Rightmost_X)) begin
                    Stop_Luigi_Down = 1'b1;     
                end
                else if((Luigi_Leftmost_X >= Mario_Leftmost_X) && (Luigi_Leftmost_X <= Mario_Rightmost_X)) begin
                        Stop_Luigi_Down = 1'b1;
                end
        end
end 
// Hit Reg Logic

always_comb begin
  if(Mario_Lockout_Counter > Lockout_Delay)begin
        Mario_Lockout_Counter_Reset = 1'b1;

end

else if (Mario_Lockout_Counter <= Lockout_Delay) begin
        Mario_Lockout_Counter_Reset = 1'b0;
end
end

always_comb begin
if(Luigi_Lockout_Counter > Lockout_Delay)begin
        Luigi_Lockout_Counter_Reset = 1'b1;
    
end

else if (Luigi_Lockout_Counter <= Lockout_Delay) begin
        Luigi_Lockout_Counter_Reset = 1'b0;
        
end
end

always_ff @ (posedge Clk)begin
        if (Mario_Lockout_Counter_Reset)begin
                Mario_Lockout_Count <= 1'b0;
        end
        else if (Mario_Punch_Sucessful) begin
                Mario_Lockout_Count <= 1'b1;
        end
        else begin 
                Mario_Lockout_Count <= 1'b0;
        end

end

always_ff @ (posedge Clk)begin
        if (Luigi_Lockout_Counter_Reset)begin
                Luigi_Lockout_Count <= 1'b0;
        end
        else if (Luigi_Punch_Sucessful) begin
                Luigi_Lockout_Count <= 1'b1;
        end
        else begin 
                Luigi_Lockout_Count <= 1'b0;
        end

end


always_comb begin
// Mario_Punch_Sucessful = 1'b0;
// Luigi_Punch_Sucessful = 1'b0;

// if(Mario_Punch_Sucessful) begin
// Luigi_Lockout_Count = 1'b1;
// end

// if(Luigi_Punch_Sucessful) begin
// Luigi_Lockout_Count = 1'b1;
// end


if(Mario_State == 13 || Mario_State == 15)begin
        if(Stop_Mario_Right || Stop_Mario_Left)begin
        Mario_Punch_Sucessful = 1'b1;
        end
end


if(Luigi_State == 13 || Luigi_State == 15)begin
             if(Stop_Luigi_Right || Stop_Luigi_Left)begin
        Luigi_Punch_Sucessful = 1'b1;
        //Luigi_Movement_Lockout = 1'b1;
        end
end

end
 always_ff @ (posedge Clk) begin
        if(Mario_Percent > 100)begin
            Mario_Percent <= 0;
        end
        else if(Luigi_Punch_Sucessful)begin
           Mario_Percent <= Mario_Percent + 5;
        end
        else begin 
                Mario_Percent <= Mario_Percent;
        end

 end
 
 always_ff @ (posedge Clk) begin
        if(Luigi_Percent > 100)begin
            Luigi_Percent <= 0;
        end
        else if(Mario_Punch_Sucessful)begin
           Luigi_Percent <= Luigi_Percent + 5;
        end
        else begin 
                Luigi_Percent <= Luigi_Percent;
        end
 end


    
 //end
endmodule