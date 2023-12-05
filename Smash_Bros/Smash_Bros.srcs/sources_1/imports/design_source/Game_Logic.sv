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
        output logic Stop_Mario_Left, Stop_Mario_Right, Stop_Mario_Up, Stop_Mario_Down,
        output logic Stop_Luigi_Left, Stop_Luigi_Right, Stop_Luigi_Up, Stop_Luigi_Down
);
// X line overalp section
logic [9:0] Mario_Rightmost_X, Mario_Leftmost_X, Mario_Bottommost_Y, Mario_Topmost_Y;
assign Mario_Rightmost_X = MarioX+Mario_size_X;
assign Mario_Leftmost_X = MarioX-Mario_size_X;
assign Mario_Bottommost_Y = MarioY+Mario_size_Y;
assign Mario_Topmost_Y = MarioY-Mario_size_Y;

logic [9:0] Luigi_Rightmost_X, Luigi_Leftmost_X, Luigi_Bottommost_Y, Luigi_Topmost_Y;
assign Luigi_Rightmost_X = LuigiX+Luigi_size_X;
assign Luigi_Leftmost_X = LuigiX-Luigi_size_X;
assign Luigi_Bottommost_Y = LuigiY+Luigi_size_Y;
assign Luigi_Topmost_Y = LuigiY-Luigi_size_Y;

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



if(((Mario_Topmost_Y == Luigi_Bottommost_Y - 2) || (Mario_Topmost_Y == Luigi_Bottommost_Y- 1) || (Mario_Topmost_Y == Luigi_Bottommost_Y )
        || (Mario_Topmost_Y == Luigi_Bottommost_Y + 1) || Mario_Topmost_Y == Luigi_Bottommost_Y + 2) 
        && ((Mario_Rightmost_X > Luigi_Leftmost_X) && (Mario_Leftmost_X < Luigi_Rightmost_X))) begin
        Stop_Mario_Up = 1'b1;
        end
if(( (Mario_Bottommost_Y == Luigi_Topmost_Y - 2) || (Mario_Bottommost_Y == Luigi_Topmost_Y- 1) || (Mario_Bottommost_Y == Luigi_Topmost_Y )
        || (Mario_Bottommost_Y == Luigi_Topmost_Y + 1) || (Mario_Bottommost_Y == Luigi_Topmost_Y + 2)) 
        && ((Mario_Rightmost_X > Luigi_Leftmost_X) && (Mario_Leftmost_X < Luigi_Rightmost_X))) begin
        Stop_Mario_Down = 1'b1; 
        end


if(((Luigi_Topmost_Y == Mario_Bottommost_Y - 2) || (Luigi_Topmost_Y == Mario_Bottommost_Y - 1) || (Luigi_Topmost_Y == Mario_Bottommost_Y)
        || (Luigi_Topmost_Y == Mario_Bottommost_Y + 1) || Luigi_Topmost_Y == Mario_Bottommost_Y + 2) 
        && ((Luigi_Rightmost_X > Mario_Leftmost_X) || (Luigi_Leftmost_X < Mario_Rightmost_X))) begin
        Stop_Luigi_Up = 1'b1;
        end
if(( (Luigi_Bottommost_Y == Mario_Topmost_Y - 2) || (Luigi_Bottommost_Y == Mario_Topmost_Y- 1) || (Luigi_Bottommost_Y == Mario_Topmost_Y )
        || (Mario_Bottommost_Y == Luigi_Topmost_Y + 1) || (Luigi_Bottommost_Y == Mario_Topmost_Y + 2)) 
        && ((Luigi_Rightmost_X > Mario_Leftmost_X) || (Luigi_Leftmost_X < Mario_Rightmost_X))) begin
        Stop_Luigi_Down = 1'b1; 
        end

    
end
endmodule