/*
 * ECE385-HelperTools/PNG-To-Txt
 * Author: Rishi Thakkar
 *
 */

module Smash_Background
(

		input [18:0] read_address,
		input Clk,

		output logic [3:0] data_Out
);

// mem has width of 2 bits and a total of 4800 addresses
logic [3:0] mem [0:307199];

initial
begin
	 $readmemh("Smash_bros_background_2_final.txt", mem);
end


always_ff @ (posedge Clk) begin
	data_Out<= mem[read_address];
end

endmodule
