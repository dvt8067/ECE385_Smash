/*
 * ECE385-HelperTools/PNG-To-Txt
 * Author: Rishi Thakkar
 *
 */

module Mario_Jumping_RAM1
(

		input [12:0] read_address,
		input Clk,

		output logic [1:0] data_Out
);

// mem has width of 2 bits and a total of 4800 addresses
logic [1:0] mem [0:4799];

initial
begin
	 $readmemh("Mario_jumping.txt", mem);
end


always_ff @ (posedge Clk) begin
	data_Out<= mem[read_address];
end

endmodule
