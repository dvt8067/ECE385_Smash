module Key_Hierarchy_Mario
(

		input logic [47:0] Full_Keycodes,
		input logic edge_below_mario,
		input logic punch_on_mario,

		output logic [7:0] Mario_Priority_1
);
	logic [7:0] key1, key2, key3, key4, key5, key6;
	logic up, left, right, punch;
	assign key1 = Full_Keycodes[7:0];
	assign key2 = Full_Keycodes[15:8];
	assign key3 = Full_Keycodes[23:16];
	assign key4 = Full_Keycodes[31:24];
	assign key5 = Full_Keycodes[39:32];
	assign key6 = Full_Keycodes[47:40];

always_comb begin
	up = 0;
	punch = 0;
	left = 0;
	right = 0;
if((key1 == 8'h1A)|| (key2 == 8'h1A)|| (key3 == 8'h1A)|| (key4 == 8'h1A)|| (key5 == 8'h1A)|| (key6 == 8'h1A)) begin
	up = 1'b1;
end
if((key1 == 8'h04)|| (key2 == 8'h04)|| (key3 == 8'h04)|| (key4 == 8'h04)|| (key5 == 8'h04)|| (key6 == 8'h04)) begin
	left = 1'b1;
end
if((key1 == 8'h07)|| (key2 == 8'h07)|| (key3 == 8'h07)|| (key4 == 8'h07)|| (key5 == 8'h07)|| (key6 == 8'h07)) begin
	right = 1'b1;
end
if((key1 == 8'h0A)|| (key2 == 8'h0A)|| (key3 == 8'h0A)|| (key4 == 8'h0A)|| (key5 == 8'h0A)|| (key6 == 8'h0A)) begin
	punch = 1'b1;
end
	Mario_Priority_1 = 8'h00;
	//Mario_Priority_2 = 8'h00;
	if(up == 1 && edge_below_mario == 1) begin
		Mario_Priority_1 = 8'h1A;
	end

	else if((punch == 1)&& punch_on_mario == 0) begin
		Mario_Priority_1 = 8'h0A;
	end

	else if((right == 0 && left == 0) || (right == 1 && left == 1)) begin
		Mario_Priority_1 = 8'h00;
	end	

	else if(right == 1) begin
		Mario_Priority_1 = 8'h07;
	end
	else if(left ==1) begin
		Mario_Priority_1 = 8'h04;
	end
	else begin
		Mario_Priority_1 = 8'h00;
	end
	//Now for Mario_Priority_2
	// if(Mario_Priority_1 == 8'h1A) begin
	// 	if(punch == 1) begin
	// 		Mario_Priority_2 = 8'h0A;
	// 	end
	// 	else if((right == 0 && left == 0) || (right == 1 && left == 1)) begin
	// 	Mario_Priority_2 = 8'h00;
	// 	end
	// 	else if(right == 1) begin
	// 	Mario_Priority_2 = 8'h07;
	// 	end
	// 	else if(left ==1) begin
	// 		Mario_Priority_2 = 8'h04;
	// 	end
	// 	else begin
	// 		Mario_Priority_2 = 8'h00;
	// 	end
	// 	end	
	// else if(Mario_Priority_1 == 8'h0A) begin
	// 	if((right == 0 && left == 0) || (right == 1 && left == 1)) begin
	// 	Mario_Priority_2 = 8'h00;
	// 	end
	// 	else if(right == 1) begin
	// 	Mario_Priority_2 = 8'h07;
	// 	end
	// 	else if(left ==1) begin
	// 		Mario_Priority_2 = 8'h04;
	// 	end
	// 	else begin
	// 		Mario_Priority_2 = 8'h00;
	// 	end
	// end


end



// logic[7:0] first_dir;
// logic[7:0] newest_dir;
// logic[2:0] first_index, newest_index;
// assign first_dir = 8'h00;
// assign newest_dir = 8'h00;
// assign first_index = 3'b000;
// assign newest_index = 3'b000;
// int i = 0;
// while(1) begin
	
// 	if((Full_Keycodes[(((i+1)*8)-1):(i*8)] ==(8'h04)) || (Full_Keycodes[(((i+1)*8)-1):(i*8)] ==(8'h07)) ) begin // consider +: operator
// 		if(i > first_index )begin
			
// 		end
		
// 		if(i < first_index )begin
			
// 		end
		
// 		if(i = first_index )begin
			
// 		end
// 	end
// 	i = i + 1
// 	i = i % 6
	
// end


endmodule